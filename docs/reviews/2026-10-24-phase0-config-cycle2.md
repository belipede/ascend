
# Engineering Manager Review: Phase 0 configuration, cycle 2
Date: 2026-10-24   Cycle: 2/3   Base..Head: 95e7c03..08224be

> **Note on HEAD:** HEAD moved twice while I was reviewing (`0549a95` → `bed2ae8` → `08224be`). I reviewed all three commits. `bed2ae8` only touches `docs/jury/`. `08224be` adds ADR 0002 and edits ENVIRONMENT.md, and both are reviewed below. Please don't commit to the branch while a review is in progress.

## Scope reviewed
- Every non-jury change in `95e7c03..08224be`: the hook, `test_hooks.sh`, `verify.sh`, `check_config.py`, `settings.json`, `.gitignore`, CLAUDE.md, the product-planner agent, the test-and-verify skill, ARCHITECTURE.md, ENVIRONMENT.md, ADR 0001, the new ADR 0002, the proposed CI file, and the recorded cycle-1 report.
- `docs/jury/`: only checked as recorded content (secret and contact-data grep, nothing found). Not judged on its merits.

## Files and changes inspected
- I read the full diff, the whole of `verify.sh` and `check_config.py`, and the new commits.
- **Cycle-1 report fidelity:** the only visible edits are the header note and the redactions on lines 26 and 47, as described. Findings F1–F13 and the verdict match what I'm re-checking now. I have no independent copy of my original output, so a byte-for-byte comparison is NOT VERIFIED.
- **Bypass testing:** done in a scratch clone (`/tmp/claude-0/-home-claude-ascend/ec0a6fad-5627-5139-a060-0d4dda8b1380/scratchpad/c2b`), using `git -C` commits with the hook active. The reviewed repo was not modified.

## Previous findings
| ID | Status | Evidence |
|---|---|---|
| F1 | **FIXED** | The hook now reads the staged blob (`git show ":$f"`), uses `--diff-filter=ACMR`, and loops NUL-safely. In `test_hooks.sh`, (a) the overwritten worktree case and (c) the space-in-filename case are blocked. For (b) I made a real rename myself (`R098 docs/ROADMAP.md → ROADMAP2.md` plus an EC key header): blocked, exit 1. The tests are wired into `verify.sh config`. Remaining gaps are new, separate findings (F15, F16). |
| F2 | FIXED | Read-only agents and all jurors now need an explicit `tools` list with no Write/Edit/NotebookEdit. EM and code-reviewer must list all three in `disallowedTools`. YAML-list frontmatter is now flagged. Lint result: 0 errors. |
| F3 | FIXED | Added `git clean:*`, `rm -rf`/`-fr`, `git restore .`, `git checkout -- .`, `--force-with-lease`, and Read-deny for `.pem`, `.key`, `.cer` and `.provisionprofile`. ENVIRONMENT.md now says these are "Best-effort prefix matches". One of my own compound commands containing `rm -rf` was refused this session. That fits the rule being active, but I can't conclusively attribute it. See F18. |
| F4 | FIXED | `verify.sh --ci config` → exit 0. `verify.sh --ci all` on Linux → exit 1, because non-device NOT VERIFIED lines now fail. The CI file now carries a "pin to a commit SHA when activating" note. |
| F5 | FIXED | Now points to `docs/PRODUCT-BRIEF.md`. |
| F6 | FIXED | CLAUDE.md now uses `-cycle<N>.md`, matching the skill. |
| F7 | FIXED (doc level) | One measure per goal, explicitly chosen feeding items, undo deletes the source's entry, and duplicate checks done in the repository. Tests are deferred to Phase 2. |
| F8 | FIXED (doc level) | ADR 0001 records the CloudKit/`#Unique` trade-off as NOT VERIFIED, for the platform specialist to check in Phase 1. |
| F9 | FIXED | Single write path through repositories, refresh on foreground and after an intent write, tests in Phase 4. |
| F10 | FIXED | Export is now called "data portability". Import/restore is a proposed Phase 5 item. |
| F11 | FIXED | The DayKey is fixed at logging time and never recomputed. |
| F12 | FIXED | Uses `$ARGUMENTS`. |
| F13 | FIXED | `.gitignore` now lists `*.pem` and `*.key`. |

## Acceptance criteria
| # | Criterion | Status | Evidence |
|---|---|---|---|
| 1 | CLAUDE.md concise and correct | MET | Only change is the F6 fix. |
| 2 | Agents exist, with distinct remits and suitable tools | MET | Lint: "18 agents, 5 skills checked, 0 errors". The lint is now stricter (F2). |
| 3 | Five skills exist and are usable | PARTIALLY MET | The files are valid. Interactive discovery is still NOT VERIFIED. |
| 4 | Quality controls exist and actually work | **NOT MET** | The hook works for the cycle-1 cases. But the new regression script can run destructive git commands against the real repo (F14). Minor bypasses remain (F15). |
| 5 | Docs honest about limits | MET with gap | The settings caveats are good. ENVIRONMENT.md contradicts itself after ADR 0002 (F17). |
| 6 | Architecture sound | MET | F7–F11 are addressed at the doc level. |
| 7 | Nothing builds the app yet | MET | No Swift or Xcode files in the tree. |

## Findings
| ID | Severity | Location | Issue | Remediation |
|---|---|---|---|---|
| F14 | **MAJOR (blocking; regression)** | `scripts/test_hooks.sh:5-6,9-10` | `T=$(mktemp -d)` and `cd "$T" && git init …` are unchecked, and there is no `set -e`.<br>If `mktemp` fails (TMPDIR unwritable or missing, disk full, sandbox), `T` is empty. Only the rest of line 6 is skipped. Every later line then runs in the caller's working directory, and `verify.sh` has already moved that to the **repo root**.<br>The script would then:<br>• commit `base.txt` to the real branch with `--no-verify`<br>• run `git reset --hard` and `git clean -qfdx` **five times**, wiping uncommitted work and every ignored file. By design those include local-only `.env` and signing files, which can't be recovered.<br>• finally commit a private-key header file (`sp ace.txt`) into real history.<br>This also gets around the settings deny rules, because the commands run inside a script. It is triggered by an environment failure, not misuse. I found it by reading the code. I did not reproduce it, because that would mean running destructive commands. | `T=$(mktemp -d) \|\| exit 1`, then `cd "$T" \|\| exit 1`. Before any destructive command, assert that `git rev-parse --show-toplevel` is the temp directory (compare with `pwd -P`). Run `unset GIT_DIR GIT_WORK_TREE GIT_INDEX_FILE` first, so the script stays safe if it's ever called from a hook. Consider `set -e` for the setup lines. |
| F15 | MINOR | `scripts/git-hooks/pre-commit` | Four bypasses not covered in cycle 1, all with the hook active:<br>**(1)** A key in a file that contains a NUL byte was committed (`e0994f7`). `grep -I` skips binary input, and `--all` uses the same grep, so it misses it too (by code reading; running the clone's script needed approval).<br>**(2)** `CERT.P12` was committed: the extension check is case-sensitive.<br>**(3)** A key appended to `scripts/git-hooks/pre-commit` itself was committed, because the hook skips its own file.<br>**(4)** A symlink→file type change (`T`) isn't in `ACMR`. NOT EXERCISED: making a symlink needed approval. `--all` would catch it later.<br>The common real cases (PEM text keys, lowercase `.p12`/`.p8`, `AuthKey_*`) are blocked. | Use `grep -aqE` instead of `-I`. Match extensions case-insensitively (`shopt -s nocasematch`). Split the pattern string inside the hook (as `test_hooks.sh` does) and remove the self-exemption. Use `--diff-filter=d` (everything except deletions). |
| F16 | MINOR | `test_hooks.sh:13` | The "rename plus key" case doesn't produce a rename. I reproduced it: the staging shows `D base9.txt` / `A moved9.txt`, because a one-line file plus a key line is under 50% similar. So the test passes without ever exercising the `R` filter, and a regression to `ACM` would go unnoticed. | Use a file of 20+ lines so git stages it as `R`, and assert that in the test. Add test cases for F15. |
| F17 | MINOR | `docs/ENVIRONMENT.md` §4 (commit `08224be`) | The new line says the decision is GitHub Actions, but the bullet right below still says "**Recommended:** Claude Code Remote Control session on the Mac". Ben has no Mac. | Mark the Mac options as alternatives that aren't currently available, or move them under ADR 0002 "Alternatives". |
| F18 | SUGGESTION | `.claude/settings.json` | The `Write(./**/*.entitlements)` ask rule was removed. That relies on `Edit(...)` rules also covering Write, which I have NOT VERIFIED. `rm -r -f` and `git checkout .` are still uncovered. That's acceptable given the documented "best-effort" caveat. | Restore the `Write` rule or confirm that Edit rules cover it, then add the obvious variants. |
| F19 | SUGGESTION | Process | Two commits landed while the review was running. | Freeze the branch during EM review. Name the exact head SHA in the review request. |

## Builds executed (command → result)
- No app exists, and none should at Phase 0. iOS build: NOT VERIFIED (Linux, no `xcodebuild`).

## Tests executed (command → result)
- `scripts/verify.sh` (at `0549a95`) → exit 2:
  - PASS: definitions; PASS: secret scan; PASS: hook regression tests, 7/7 ok
  - NOT VERIFIED ×3: package missing, `xcodebuild` missing, device checks
- `scripts/test_hooks.sh` → 7/7 ok, exit 0.
- `scripts/verify.sh --ci config` → exit 0. `scripts/verify.sh --ci all` → exit 1 (correct on Linux).
- `scripts/verify.sh config` (at `08224be`) → PASS ×3, exit 0.
- `git config --get core.hooksPath` → `scripts/git-hooks`.
- My bypass attempts in the scratch clone:
  - real rename plus key → **blocked**
  - key in a NUL-containing file → **committed**
  - `CERT.P12` → **committed**
  - key in the hook file → **committed**
  - typechange → NOT EXERCISED (symlink creation needed approval)
- Running the clone's scripts directly (`pre-commit --all`, a bypass script) needed approval I don't have, so those parts are based on reading the code.
- Settings rules in effect and skill/agent discovery: NOT VERIFIED (not exercised live).

## Remaining risks
- Merge gating and EM read-only status are still process-only. There is no remote, branch protection or CI yet. ADR 0002 activates CI in Phase 1.
- F14 is the kind of failure that will become more likely once `verify.sh` runs in varied environments (CI runners, sandboxes).
- No Swift toolchain anywhere, so the AscendCore date logic stays untested until CI exists.

## Required manual testing
- After the F14 fix: run `TMPDIR=/nonexistent scripts/test_hooks.sh` **in a throwaway clone only**. Confirm it exits non-zero and that the clone's `git status`, `git log` and ignored files are unchanged.
- Interactively: `/agents` lists 18 agents and the 5 skills appear. A denied command (`git reset --hard`) is refused, and `git push` asks first.

## Decision: REJECTED
- **What's done:** F1 through F13 are all fixed with evidence. The secret scan now checks the staged content and handles renames and awkward filenames. The `--ci` mode closes the false-green CI hole. The documentation fixes are accurate.
- **Why I'm rejecting:** the F1 fix added a regression (F14). The regression-test script has no guard on its temp directory. A single `mktemp` failure would make the project's own routine gate run `git reset --hard` and `git clean -fdx` on Ben's real repo, deleting uncommitted work and local-only signing and env files, and commit a fake key into history. The chance is low, but data integrity is priority #1 and the fix is two lines, so I can't approve it as non-blocking.
- **Only F14 blocks.** F15–F17 are MINOR and F18–F19 are suggestions. They can be fixed now or tracked.
- **Cycle 3 is the last** before escalating to Ben. If F14 is fixed with the guard above, the manual test above passes in a throwaway clone, and no other regressions appear, I expect to give APPROVED WITH NON-BLOCKING FINDINGS.

*I couldn't record this outcome in team memory: this role has no Write tool, and writing outside the repo needs approval.*
