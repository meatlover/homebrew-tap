#!/usr/bin/env bash
# Tests for scripts/update-formula.sh, run against file:// fixtures in a
# scratch copy of the tap so the real Formula/ is never touched. Prints only
# failures; exits 1 if any.
set -uo pipefail

here=$(cd "$(dirname "$0")" && pwd)
fails=0
fail() { echo "FAIL $1: $2"; fails=$((fails + 1)); }

# run <fixture> <tag>: a fresh scratch tap, the script run in it; sets
# $scratch, $status and $output.
run() {
  scratch=$(mktemp -d)
  mkdir -p "$scratch/scripts" "$scratch/Formula"
  cp "$here/../scripts/update-formula.sh" "$scratch/scripts/"
  echo "previous" >"$scratch/Formula/modelpick.rb"
  output=$(MODELPICK_RELEASE_BASE="file://$here/fixtures/$1" "$scratch/scripts/update-formula.sh" "$2" 2>&1)
  status=$?
}

# Each archive's checksum sits right under its own URL.
run complete v9.8.7
[ "$status" -eq 0 ] || fail complete "exit $status: $output"
f=$scratch/Formula/modelpick.rb
for p in darwin_arm64 darwin_amd64 linux_arm64 linux_amd64; do
  want=$(awk -v f="modelpick_9.8.7_$p.tar.gz" '$2 == f { print $1 }' "$here/fixtures/complete/SHA256SUMS")
  got=$(grep -A1 "/v9.8.7/modelpick_9.8.7_$p.tar.gz\"" "$f" | sed -n 's/.*sha256 "\(.*\)"/\1/p')
  [ "$got" = "$want" ] || fail "complete $p" "sha256 after its url is '$got', want '$want'"
done
grep -q '^  version "9.8.7"$' "$f" || fail complete "no version line 9.8.7"
grep -q 'file://' "$f" && fail complete "fixture base leaked into the formula"
ruby -c "$f" >/dev/null 2>&1 || fail complete "formula is not valid Ruby"

# A release missing one archive is refused and the formula is left alone.
run missing-linux-arm64 v9.8.7
[ "$status" -eq 1 ] || fail missing "exit $status, want 1"
[[ $output == *"no checksum for modelpick_9.8.7_linux_arm64.tar.gz"* ]] || fail missing "output: $output"
[ "$(cat "$scratch/Formula/modelpick.rb")" = previous ] || fail missing "formula was changed"

# Prereleases and junk tags are refused before any fetch.
for t in v9.8.7-rc.1 9.8.7 vX; do
  run complete "$t"
  [ "$status" -eq 1 ] || fail "tag $t" "exit $status, want 1"
  [[ $output == *"is not vX.Y.Z"* ]] || fail "tag $t" "output: $output"
done

# A release with no SHA256SUMS is refused.
run does-not-exist v9.8.7
[ "$status" -eq 1 ] || fail "no sums" "exit $status, want 1"
[[ $output == *"cannot fetch"* ]] || fail "no sums" "output: $output"

[ "$fails" -eq 0 ] || exit 1
