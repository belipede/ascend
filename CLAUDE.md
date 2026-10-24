# Ascend

Native iPhone app that connects long-term goals to daily habits and tasks:
**GOAL → PLAN → HABIT → TASK → PROGRESS**. Personal use first; possible App Store release later.

## Priorities (in order)
1. Correctness and user data integrity
2. A functional, useful MVP
3. Independent quality assurance
4. Usability and design
5. Maintainable architecture
6. Commercial scalability where justified
7. Speed and cost efficiency

## Hard rules
- Never claim a build, test, install, review or device check passed unless it actually ran. Unverified = `NOT VERIFIED`.
- Never present a mockup, placeholder or dead control as a finished feature.
- No backend, accounts, external APIs, paid services or third-party dependencies without Ben's approval.
- Ask Ben before: destructive operations, spending money, publishing anything, changing signing config, material scope or architecture changes.
- Never commit or print secrets, certificates, provisioning profiles or personal data.
- Small, reviewable commits. Inspect before overwriting or deleting.
- Calendar dates: never derive day counts by dividing seconds by 86400. Use `Calendar` in the user's time zone and the `DayKey` model (see docs/ARCHITECTURE.md).

## Stack
Swift, SwiftUI, SwiftData (versioned schemas), WidgetKit, App Intents, UserNotifications, XCTest / Swift Testing.
Business logic lives in the `AscendCore` Swift package with no SwiftUI or SwiftData imports, so it is testable on its own.

## Environment facts
- Cloud sessions run on Linux: no Xcode, no simulator, no device. iOS builds and UI tests must run on Ben's Mac.
- `scripts/verify.sh` runs what the current machine can run and prints `NOT VERIFIED` for the rest. Exit code 2 = partially verified.
- Details: docs/ENVIRONMENT.md.

## Team (in .claude/agents/)
- Specialists: `ios-architect`, `ui-ux-designer`, `qa-engineer`, `ios-platform-specialist`, `code-reviewer`, `product-planner`.
- Gatekeeper: `engineering-manager` (read-only, issues APPROVED / APPROVED WITH NON-BLOCKING FINDINGS / REJECTED / BLOCKED).
- Product Jury (jury/): `cfo`, `investor`, `marketer`, `jury-engineer`, `futurist`, `competitor-analyst`, `everyday-person`, `strategist`, `lawyer`, `jury-designer`, `operator`.
- Use only the agents a task needs. Routine code: main agent + one specialist. Substantial feature: architect → implement → QA → engineering-manager. Full jury only for MVP scope, monetisation, major privacy or launch decisions.

## Workflow for a substantial feature
1. `/plan-feature` → acceptance criteria in `docs/features/<name>.md`.
2. Implement on a branch `feature/<name>`.
3. `/test-and-verify` and record actual output.
4. `qa-engineer` assesses; then `/review-changes` (engineering-manager, plus code-reviewer for risky changes).
5. Fix findings, rerun tests, re-review. Max 3 review-fix cycles, then escalate to Ben.
6. Save the EM report to `docs/reviews/YYYY-MM-DD-<name>-cycle<N>.md`. Merge only with APPROVED or APPROVED WITH NON-BLOCKING FINDINGS.

The main agent never writes or edits an EM verdict. The jury never overrides an EM rejection. Ben has final say on product, budget and major commitments.

## Docs
docs/ENVIRONMENT.md · docs/ARCHITECTURE.md · docs/ROADMAP.md · docs/decisions/ (ADRs) · docs/reviews/ · docs/jury/
Keep docs short. Update the relevant doc in the same commit as the change.
