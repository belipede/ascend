# Engineering Manager Review: Phase 0 configuration, cycle 3
Date: 2026-10-24   Cycle: 3/3   Base..Head: 08224be..87923f5

## Scope reviewed
- The single commit `87923f5`. It changes `scripts/test_hooks.sh`, `scripts/git-hooks/pre-commit` and `docs/ENVIRONMENT.md`, and adds the recorded cycle-2 report.
- `.claude/settings.json` for F18. It has not changed in this range.
- I re-checked F14–F19 by ID and looked for regressions.
- HEAD was `87923f5` at the start and at the end. The branch stayed frozen.

## Files and changes inspected
- **Diff and current files:** I read the full `git diff 08224be..87923f5` and all of the current `test_hooks.sh`, `pre-commit` and `settings.json`. I also checked how `verify.sh` calls the hook (lines 21–22).
- **Recorded cycle-2 report:** it matches the findings and verdict I'm re-checking now. I have no independent copy, so a byte-for-byte comparison is NOT VERIFIED.
- **Main agent's clone `/tmp/claude-0/f14`:**
  - `git status --short --ignored` shows ` M README.md` and `!! .env`.
  - HEAD is `87923f5`.
  - The reflog has exactly one entry (`HEAD@{0}: clone`). If `git reset --hard` or a commit had run, it would have added entries. None are there.
  - I could not read the `.env` content: the `Read(./**/.env)` deny rule blocked it. "Content intact" is therefore NOT VERIFIED by me. That the file exists and is still ignored is VERIFIED.
- **My own scratch clone** (`/tmp/claude-0/-home-claude-ascend/ec0a6fad-5627-5139-a060-0d4dda8b1380/scratchpad/c3`): I made bypass attempts there with git commits, with the hook active through `-c core.hooksPath=scripts/git-hooks`.

## Previous findings
| ID | Status | Evidence |
|---|---|---|
| F14 | **FIXED** | **Guard checks:** `T=$(mktemp -d) \|\| exit 1`. Then `[[ -n "$T" && -d "$T" ]]`, then `cd "$T" \|\| exit 1`. After `git init`, `git rev-parse --show-toplevel` must equal `pwd -P`, otherwise the script exits. `unset GIT_DIR GIT_WORK_TREE GIT_INDEX_FILE` runs first. The cleanup trap is set only after `T` is validated. No destructive command runs before all of these guards pass.<br>**Failure path:** `mktemp -d -p /nonexistent` exits 1 and leaves `X=''`, and the `\|\|` branch is taken.<br>**Clone evidence:** the f14 clone has no reset or commit in its reflog, and the local edit and ignored file are still there.<br>**Not done by me:** running `TMPDIR=/nonexistent scripts/test_hooks.sh` end-to-end in my own clone needed sandbox approval. I would not run it from the real repo. That end-to-end run rests on the main agent's output, the clone state and my code reading. |
| F15 | **FIXED** | **(1) Binary file:** `grep -aqE`. Covered by the test "key inside binary file" (ok).<br>**(2) Upper-case extension:** `shopt -s nocasematch`. Covered by the test "upper-case .P12 file" (ok).<br>**(3) Hook's own file:** the self-exemption is removed and the pattern is split. I appended an EC key header to `pre-commit` in the clone and committed: **blocked**, exit 1. `pre-commit --all` on the real repo exits 0, so the hook does not flag itself.<br>**(4) Type change:** `--diff-filter=d`. In the clone I committed a symlink `tlink`, then staged it as a regular file holding a key (`T tlink`): **blocked**, exit 1. |
| F16 | FIXED | The fixture is now `seq 1 40`. The test asserts `^R` in `--name-status` before calling `expect_block`, and fails explicitly otherwise. Result: "rename plus key" ok. The F15 self-file and type-change cases are not in `test_hooks.sh` (see F21). |
| F17 | FIXED | §4 now says "Not currently available (Ben has no Mac)". Items 1 and 2 now refer to GitHub Actions and TestFlight. |
| F18 | **NOT VERIFIED (accepted as SUGGESTION)** | `settings.json` only has `Edit(./**/*.entitlements)` and `Edit(./**/*.pbxproj)` as ask rules. ENVIRONMENT.md now records the reason, citing the Claude Code 2.1.310 message. I could not reproduce that message: `claude --version` needed approval. It is plausible and documented. `rm -r -f` and `git checkout .` are still not covered, which the existing "best-effort" caveat accepts. |
| F19 | FIXED | HEAD stayed at `87923f5` through the whole review. The request named the exact range. |

## Acceptance criteria
| # | Criterion | Status | Evidence |
|---|---|---|---|
| 1 | CLAUDE.md concise and correct | MET | Not changed in this range. Already MET in cycle 2. |
| 2 | Agents exist, with distinct remits and suitable tools | MET | Lint: "18 agents, 5 skills checked, 0 errors". |
| 3 | Five skills exist and are usable | PARTIALLY MET | The files are valid. Interactive `/agents` and skill discovery are NOT VERIFIED. |
| 4 | Quality controls exist and actually work | MET | Hook tests 9/9 ok. All four F15 bypasses are now blocked (two of them by my own attempts). F14 is guarded. |
| 5 | Docs honest about limits | MET | F17 is fixed. The F18 rationale is documented. Settings are still described as "best-effort". |
| 6 | Architecture sound | MET | Not changed. Already MET in cycle 2. |
| 7 | Nothing builds the app yet | MET | No Swift or Xcode files. |

## Findings
| ID | Severity | Location | Issue | Remediation |
|---|---|---|---|---|
| F18 | SUGGESTION (carried) | `.claude/settings.json` | My statement that Edit rules also cover Write is NOT VERIFIED. `rm -r -f` and `git checkout .` are not covered. | Confirm once in an interactive session on Ben's side. Optionally add those variants to the deny list. |
| F20 | MINOR (process) | Repo | All Phase 0 work, including the fix commits, was committed straight to `main`. There are no other branches and no remote. So "merge only after EM approval" was not a gate here: review happened after the commits. Nothing has been published, so nothing has leaked. | From Phase 1 on, use `feature/<name>` branches per CLAUDE.md. Once the GitHub repo exists, enable branch protection and CI (ADR 0002). |
| F21 | MINOR | `scripts/test_hooks.sh` | The self-file and type-change protections (F15 parts 3 and 4) work, but there are no regression tests for them. A future edit could quietly re-add the self-exemption or go back to `ACMR`. | Add two cases: a key appended to the hook path, and a symlink-to-file type change. The symlink can be built with `git update-index --cacheinfo 120000,…`, so no `ln` is needed. |

No regressions found. `nocasematch` only affects `case` and `[[ == ]]` matching (the `--all` flag check still works). It does not affect `grep`.

## Builds executed (command → result)
- No app exists, and none should at Phase 0. iOS build: NOT VERIFIED (Linux, no `xcodebuild`).

## Tests executed (command → result)
- `scripts/verify.sh config` → exit 0:
  - PASS: definitions; PASS: secret scan of tracked files
  - PASS: hook regression tests, 9/9 ok: staged key, key staged with worktree overwritten, rename plus key, space in filename, .p12 file, upper-case .P12 file, key inside binary file, clean file allowed, `--all` finds committed key
- `scripts/verify.sh` → "RESULT: PASSED (PARTIAL)", with NOT VERIFIED ×3: AscendCore missing, `xcodebuild` missing, device checks.
- `scripts/verify.sh --ci all` → exit 1. That is correct on Linux.
- `scripts/git-hooks/pre-commit --all` → exit 0.
- `git status --short` on the real repo after all runs → clean, HEAD `87923f5`.
- Bypass attempts in my clone:
  - key appended to the hook file → **blocked**
  - symlink→file type change with a key → **blocked**
- Not run by me (needed approval): `TMPDIR=/nonexistent scripts/test_hooks.sh` end-to-end in a clone, `claude --version`, and live checks of the settings rules.

## Remaining risks
- Merge gating and EM read-only status are still process-only until a GitHub remote with branch protection and CI exists (ADR 0002).
- The settings deny/ask rules are best-effort prefix matches. My `wc` on `.env` was refused, which fits the Read-deny rule being active, but the rules are bypassable by design.
- No Swift toolchain anywhere yet, so the AscendCore date logic stays untested until Phase 1 CI.

## Required manual testing
- Interactively: `/agents` lists 18 agents and the 5 skills appear. `git reset --hard` is refused, and `git push` asks first. An attempt to Write a `*.entitlements` file prompts for approval (this settles F18).
- Optional: on a machine without the sandbox limits, run `TMPDIR=/nonexistent scripts/test_hooks.sh` in a throwaway clone to independently repeat F14 end-to-end.

## Decision: APPROVED WITH NON-BLOCKING FINDINGS
The only blocker from cycle 2, F14, is fixed. The temp-repo guard is layered (mktemp result, directory check, cd, toplevel equals temp dir, git environment unset), and nothing destructive can run before it passes. My own `mktemp` failure check and the clean reflog and state of the main agent's throwaway clone back this up. I did not run the end-to-end failure case myself, and I could not read the `.env` content, because of sandbox limits. F15–F17 and F19 are fixed, and I reproduced two of the F15 fixes with my own bypass attempts. No regressions were found, and the config gate passes (exit 0, hook tests 9/9). What remains is non-blocking: F18 (an unverified suggestion), F20 (work committed directly to `main` with no feature branch) and F21 (missing regression tests for two protections that do work). They can be fixed now or tracked into Phase 1. This approval covers Phase 0 configuration only. Moving to Phase 1 still needs Ben's explicit approval.

*I couldn't record this outcome in team memory: this role has no Write tool.*
