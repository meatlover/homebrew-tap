# meatlover/homebrew-tap

Homebrew formulae for Meatlover LLC tools.

```
brew install meatlover/tap/modelpick
```

| Formula | What it is |
|---|---|
| `modelpick` | [modelpick](https://github.com/meatlover/modelpick): picks an LLM subscription, account, model and thinking level from live usage. macOS and Linux, Intel and ARM. |

## How the formula is kept current

`Formula/modelpick.rb` is generated, never edited by hand. It installs the
archives of a modelpick GitHub Release, checked against that release's
`SHA256SUMS`.

- `scripts/update-formula.sh vX.Y.Z` writes the formula for a release.
  Prereleases are refused.
- The `update` workflow runs hourly (or from **Run workflow**). It writes the
  formula for modelpick's latest release; if that changed anything, it
  installs and tests it with `scripts/brew-check.sh`, then commits and pushes.
  When there has been no commit for 50 days it pushes an empty one, because
  GitHub disables a public repository's schedules after 60 days without
  activity.
- The `test` workflow, on every push: `tests/test.sh` (the generator against
  fixtures), a check that the committed formula is exactly what the script
  writes for its release, and `scripts/brew-check.sh` (tap, install,
  `brew test`, `brew audit --strict`, `brew style`) on Ubuntu and macOS.

## License

MIT, Meatlover LLC.
