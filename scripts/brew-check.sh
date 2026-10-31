#!/usr/bin/env bash
# brew-check.sh taps this checkout as meatlover/tap, then installs, tests and
# audits the modelpick formula exactly as a user's `brew install` would. CI
# runs it on every push and before the update job commits a new formula.
set -euo pipefail

root=$(cd "$(dirname "$0")/.." && pwd)
if ! command -v brew >/dev/null && [ -x /home/linuxbrew/.linuxbrew/bin/brew ]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi
export HOMEBREW_NO_AUTO_UPDATE=1 HOMEBREW_NO_INSTALL_CLEANUP=1 HOMEBREW_NO_ENV_HINTS=1

# The tap is a clone, so it sees the committed formula, not the working tree.
git -C "$root" diff --quiet HEAD -- Formula || {
  echo "brew-check: commit Formula/ first; the tap clones HEAD" >&2
  exit 1
}

brew untap --force meatlover/tap >/dev/null 2>&1 || true
brew tap meatlover/tap "$root"
brew install meatlover/tap/modelpick
brew test meatlover/tap/modelpick
brew audit --strict meatlover/tap/modelpick
brew style meatlover/tap/modelpick
