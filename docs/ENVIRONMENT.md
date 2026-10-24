# Environment audit (Phase 0, 2026-10-24)

## Where Claude Code runs today
| Item | Finding | How checked |
|---|---|---|
| OS | Linux x86_64 cloud container (4 CPU, 15 GB RAM), ephemeral | `uname -a`, `free` |
| Claude Code | 2.1.310 | `claude --version` |
| Xcode / xcodebuild / simulator | **Not available** (Linux) | `which xcodebuild` → not found |
| Swift toolchain | **Not installed**; download.swift.org blocked by network policy (HTTP 403 at proxy) | `which swift`, `curl -I` |
| Physical iPhone | **Not reachable** from the cloud | n/a |
| Git | 2.43.0 | `git --version` |
| GitHub | **No GitHub account linked** to Claude; no repo attached | `list_repos` error |
| Project agents in nested dirs | Supported: `.claude/agents/jury/*.md` discovered | headless `claude -p` init listed `probe-nested` |
| Apple docs (developer.apple.com) | Reachable | `curl -I` → 200 |

## Consequences
- **No iOS build, simulator run, UI test or device install can happen in the cloud.** Any such claim from a cloud session is false by construction; `scripts/verify.sh` prints `NOT VERIFIED` for them.
- Pure-Swift business logic (`AscendCore`) could be tested on Linux **if** a Swift toolchain were installed. That needs either the environment's network policy to allow `download.swift.org`, or running core tests on the Mac. Linux Foundation can differ from Apple's, so macOS remains the source of truth.

## What Ben needs for building and installing
1. macOS with a current Xcode: GitHub Actions macOS runners per ADR 0002 (or a Mac later). App Store uploads require the current SDK; see Apple's "Upcoming requirements" page.
2. For installs without a Mac: TestFlight (needs the paid program below). With a Mac: USB cable and Developer Mode (Settings → Privacy & Security → Developer Mode).
3. An Apple ID signed into Xcode.
   - **Free Personal Team**: installs expire after **7 days** and must be reinstalled; capability limits apply (App Groups needed for widgets are reported as restricted on free teams: source mybyways.com 2016, **NOT VERIFIED for current Xcode**).
   - **Apple Developer Program**: USD 99/year (published price; confirm in your region). 1-year installs, TestFlight, App Store. **Paid; needs Ben's decision. Not required until widgets or longer-lived installs are needed.**
4. **Decision (ADR 0002): Ben is on Windows; builds run on GitHub Actions macOS runners.** Options considered for running on a Mac:
   - Not currently available (Ben has no Mac). If a Mac is added later: a Claude Code Remote Control session on it, Claude Code in a terminal there, or Ben running `scripts/verify.sh all` and pasting the output.

## Manual device checklist (used by /release-check)
Install, launch, kill and relaunch (data persists), log a habit, undo it, complete and reopen a task, goal progress updates once (no double count), notification fires, editing/deleting cancels it, permission-denied path, widget shows current data after an app change, interactive widget action updates the app, Dynamic Type at largest accessibility size, VoiceOver on Today, dark mode, time-zone change.

## Enforcement that exists vs. does not
| Control | Status |
|---|---|
| `scripts/verify.sh` (config lint, secret scan, core/app tests where possible) | Configured, ran on Linux |
| Git pre-commit secret scan (`scripts/install-hooks.sh`) | Configured in this clone; must be installed per clone |
| `.claude/settings.json` deny/ask rules (force push, hard reset, git clean, rm -rf, signing files, entitlements, project file, uploads) | Configured. **Best-effort prefix matches**: variants (e.g. `cat` of a key via Bash) can slip past. The real safeguards are the CLAUDE.md rules plus Ben's approval. `Edit(...)` rules cover all file-editing tools including Write (Claude Code 2.1.310 printed this when a `Write(...)` rule was present, so that rule was removed) |
| EM / code-reviewer read-only | Write/Edit tools removed. **Bash is still available to them** for git and tests, so read-only is by instruction, not by sandbox |
| Merge only after EM approval | **Process only. Not technically enforced.** Needs GitHub branch protection + CI once a repo exists |
| CI on macOS | **Not configured.** Proposed in docs/ci/ios-ci.yml.proposed (`verify.sh --ci` fails on anything NOT VERIFIED except the device check); uses GitHub Actions macOS minutes (decision for Ben) |
| Secret-scan hook regression tests (`scripts/test_hooks.sh`, run by verify.sh) | Configured, ran on Linux |
