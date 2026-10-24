> Recorded verbatim except that quoted private-key header test strings were replaced with `[... PRIVATE KEY header]` by the main agent so the secret scan accepts the file. No findings or verdict text changed.

# Engineering Manager Review: Phase 0 configuration (whole tree)
Date: 2026-10-24   Cycle: 1/3   Base..Head: (no base; root commit) .. 95e7c03

## Scope reviewed
All 37 tracked files in commit `95e7c03` (the only commit; the working tree is clean). That covers CLAUDE.md, README, the docs (ENVIRONMENT, ARCHITECTURE, ROADMAP, PRODUCT-BRIEF, ADR 0001, the proposed CI file), the 7 core agents, the 11 jury agents, the 5 skills, `.claude/settings.json`, `.gitignore` and the scripts (`verify.sh`, `check_config.py`, `pre-commit`, `install-hooks.sh`). I read every file myself.

## Files and changes inspected
`git log --stat` shows one commit with 37 files and +1103 lines. I read every agent's frontmatter (tools, disallowedTools, model) and its prompt, and every skill's frontmatter and steps. I traced the logic of the scripts line by line. I tested the pre-commit hook in a throwaway clone in the scratchpad. The reviewed repo was not modified.

## Acceptance criteria
| # | Criterion | Status | Evidence |
|---|---|---|---|
| 1 | CLAUDE.md concise and correct | MET | 51 lines. Agent names, workflow, hard rules and environment facts match the files. One filename mismatch with a skill (F6). |
| 2 | 6 specialists, the EM and 11 jurors exist, with distinct remits and suitable tools | MET | `check_config.py`: "18 agents, 5 skills checked, 0 errors". The EM and code-reviewer have no Write/Edit. Jurors are read-only. Remits don't overlap. Small linter gap (F2) and one stale path (F5). |
| 3 | Five skills exist and are usable | PARTIALLY MET (files exist; discovery NOT VERIFIED) | All 5 `SKILL.md` files have valid frontmatter and their names match their folders. I could not re-run the headless `claude -p` discovery check (see Tests). |
| 4 | Quality controls exist and actually work | NOT MET | `verify.sh` works and exits 2 correctly. The secret scan blocks the basic case but can be bypassed 3 ways, and `verify.sh` then prints **PASS** while a tracked file contains a private key (F1). The settings rules are configured but not verified in effect, and some are easy to get around (F3). |
| 5 | Documentation is honest about limits and enforcement | MET | ENVIRONMENT.md separates "Process only. Not technically enforced" and "read-only is by instruction, not by sandbox". The hook claim "Configured in this clone" checks out: `core.hooksPath=scripts/git-hooks`. Small wording gap (F3). |
| 6 | Architecture is sound, minimal, and covers data integrity and dates | MET with gaps | DayKey, versioned schedules, archive-first deletes, a migration test for every version, injected Calendar/clock, no seconds/86400, deterministic notification IDs, the 64-pending limit. Gaps: F7, F8, F9, F10. |
| 7 | Nothing builds the app yet | MET | No `*.swift`, `.pbxproj`, `.xcodeproj`, `.plist`, `.entitlements` or `Package.swift` in the tree. `verify.sh` reports the package and project as absent. |

## Findings
| ID | Severity | Location | Issue | Remediation |
|---|---|---|---|---|
| F1 | MAJOR | `scripts/git-hooks/pre-commit:5-14` | The content scan has three bypasses, all reproduced in a scratch clone: **(a)** it greps the working-tree file, not the staged blob. I staged a key, overwrote the working copy, and commit `3b0069f` went in with the key (`git show HEAD:k1.txt` shows `[RSA PRIVATE KEY header]`). **(b)** `--diff-filter=ACM` leaves out renames. A `git mv` plus an appended EC key header committed as `4dbfad5` "rename … (98%)". **(c)** `for f in $FILES` splits names on spaces, so `my notes.txt` with an OpenSSH key header committed as `2bae651`. Afterwards `scripts/verify.sh config` printed "PASS: secret scan of tracked files" while that file was tracked. That is the kind of false assurance the hard rules forbid. | Read the staged content (`git show ":$f"`, or `git diff --cached -U0` and grep the added lines). Use `--diff-filter=ACMR`. Iterate NUL-safely (`git diff --cached -z --name-only` / `git ls-files -z` with `while IFS= read -r -d ''`). For `--all`, scan `git show HEAD:"$f"`, or both index and worktree. Add `scripts/test_hooks.sh` that replays these three cases in a temp repo and run it from `verify.sh config`. |
| F2 | MINOR | `scripts/check_config.py:46-49` | The read-only check passes if `tools` is omitted and `disallowedTools: Write` alone is set. Edit and NotebookEdit would then be inherited. Jurors are also not checked for write tools. Frontmatter written as a YAML list is not parsed. | Require an explicit `tools` list with no Write/Edit/NotebookEdit for the read-only agents and the jury, and require all three in `disallowedTools`. |
| F3 | MINOR | `.claude/settings.json`; ENVIRONMENT.md:39 | `git clean -fd` is denied, but `-df`, `-xfd` and `-f -d` are not. `git restore .`, `git checkout -- .` and `rm -rf` are not covered. Read-deny leaves out `.pem`, `.key`, `.cer` and `.provisionprofile`, and `cat` via Bash gets around Read-deny anyway. ENVIRONMENT.md says "Configured; applies" without these caveats. | Add the obvious variants. State in ENVIRONMENT.md that deny rules are best-effort prefix matches and that the real safeguards are the instruction in CLAUDE.md plus Ben's approval. |
| F4 | MINOR | `docs/ci/ios-ci.yml.proposed` | `|| [ $? -eq 2 ]` treats any partial result as green. That includes "Ascend.xcodeproj does not exist" being NOT VERIFIED, so CI would pass without having run any iOS test. | When proposing activation, accept exit 2 only when the sole NOT VERIFIED line is the device check, or add a `--ci` mode that fails on any other NOT VERIFIED. Pin actions by SHA. |
| F5 | MINOR | `.claude/agents/product-planner.md` | It points to `docs/PRODUCT.md`, but the repo has `docs/PRODUCT-BRIEF.md`. | Align the paths. |
| F6 | MINOR | CLAUDE.md workflow step 6 vs `review-changes/SKILL.md` step 5 | CLAUDE.md says `docs/reviews/YYYY-MM-DD-<name>.md`; the skill says `…-<name>-cycle<N>.md`. | Use one convention. The cycle-suffixed one is better for re-review tracking. |
| F7 | MINOR | ARCHITECTURE.md "Goal progress" | A unique `(goalID, sourceID)` stops the *same* source counting twice. It does not solve the stated case where "a task and a habit both relate to a goal", because those are two different sources. SwiftData unique constraints also upsert silently rather than reject. | Define which event is authoritative when a task belongs to a linked habit, how undo removes the entry, and the upsert semantics. Settle this in the Phase 2 plan with tests. |
| F8 | MINOR | ARCHITECTURE.md / ADR 0001 | "Keeps a later sync option open (CloudKit)" conflicts with using unique constraints. To my knowledge, CloudKit-backed SwiftData does not support unique constraints and needs optional or defaulted attributes and relationships. This is not verified against current docs here. | Have `ios-platform-specialist` verify this and record the trade-off in the ADR. Don't change the design for sync yet. |
| F9 | MINOR | ARCHITECTURE.md "Persistence"/"Widgets" | Writes from the app and from the widget's AppIntent process to one SwiftData store (stale contexts, concurrent writes) are not addressed in the architecture doc, only in the specialist's prompt. | Add a short rule, e.g. one writer path, refresh after a widget-intent write, persistent history if needed. Test it in Phase 4. |
| F10 | MINOR | ARCHITECTURE.md vs `release-check` | Persistence promises JSON *export* as the "recovery path", but there is no import. The AscendData line says export/import, and release-check needs "re-import verified". A backup that can't be restored is not recovery. | State whether import is in the MVP. If it is deferred, call export "data portability", not recovery. |
| F11 | SUGGESTION | ARCHITECTURE.md DayKey | Say explicitly that a DayKey is fixed at logging time using the time zone current then, and never recomputed after travel. | One sentence; QA already tests travel. |
| F12 | SUGGESTION | `test-and-verify/SKILL.md:7` | I'm not sure `${ARGUMENTS:-all}` is a supported substitution form; it may render literally. This is harmless because `verify.sh` defaults to `all`. | Use `$ARGUMENTS`. |
| F13 | SUGGESTION | `.gitignore` | The hook blocks `*.pem` and `*.key`, but `.gitignore` doesn't list them. | Add them so the two stay in line. |

## Builds executed (command → result)
- No app build exists and none should at Phase 0. `which swift xcodebuild` → neither found (exit 1). iOS build: NOT VERIFIED (Linux).

## Tests executed (command → result)
- `scripts/verify.sh` → exit 2: "18 agents, 5 skills checked, 0 errors", PASS on config, PASS on the secret scan, NOT VERIFIED ×3 (no package yet, no xcodebuild, device checks), "RESULT: PASSED (PARTIAL…)".
- `python3 scripts/check_config.py` → "18 agents, 5 skills checked, 0 errors" (exit 0).
- `git config --get core.hooksPath` → `scripts/git-hooks` (the hook is installed in this clone).
- Hook, in a scratch clone: staged `[RSA PRIVATE KEY header]` → **blocked** (exit 1, "refusing to commit secrets"). This confirms the main agent's claim. The bypasses (a), (b) and (c) above all → **committed**. `verify.sh config` afterwards → PASS (false negative).
- The main agent's claim that headless `claude -p` listed 18 agents and 5 skills: **NOT VERIFIED.** Running `claude -p` in this review sandbox needed approval I don't have. The static lint is consistent with the claim.
- Whether the settings.json deny/ask rules take effect: **NOT VERIFIED** (not exercised live).

## Remaining risks
- Merge gating and EM read-only status rely on process only, as the docs honestly say. There is no remote, branch protection or CI.
- No Swift toolchain anywhere yet, so the AscendCore date logic stays untested until Phase 1 runs on the Mac.
- `claude --version` (ENVIRONMENT.md says 2.1.310) and nested-agent discovery were not re-checked by me.

## Required manual testing
- In an interactive Claude Code session in the repo: run `/agents` and confirm all 18 agents, and confirm the 5 skills appear in `/` completion.
- Try a denied command (e.g. `git reset --hard`) and confirm it is refused, and confirm `git push` asks first.
- After the F1 fix: rerun the three bypass cases, and one staged `.p12`, against the new hook.

## Decision: REJECTED
Most of Phase 0 is in good shape. CLAUDE.md is concise and accurate. The 18 agents have distinct, sensibly restricted remits. The skills match the documented workflow. The docs are unusually honest about what is not enforced. The architecture proposal handles dates and data integrity carefully and stays minimal. Nothing builds the app. But criterion 4 requires the controls to *actually work*, and the secret scan fails in three reproducible, realistic ways (rename, partial staging, spaces in filenames). In one of them `verify.sh` then reports PASS for a tracked private key, which is false assurance from the project's own gate. The fix is small and contained. **Only F1 blocks approval.** F2–F13 are MINOR/SUGGESTION and may be fixed now or tracked. If F1 is fixed with a regression test wired into `verify.sh`, and no regressions appear, I expect to give APPROVED WITH NON-BLOCKING FINDINGS in cycle 2.

*Note: I tried to save a team-memory note about this cycle's outcome, but writing outside the repo needs approval in this session, so it was not saved.*
