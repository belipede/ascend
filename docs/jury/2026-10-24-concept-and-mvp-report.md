# Jury report: product concept and MVP scope (full jury, 2026-10-24)

Brief: [2026-10-24-concept-and-mvp-brief.md](2026-10-24-concept-and-mvp-brief.md) · Raw reports: [2026-10-24-concept-and-mvp/](2026-10-24-concept-and-mvp/)
Method: each juror ran as an independent headless Claude Code session using its agent definition (`claude -p --agent <name>`), given only the brief. Jurors with web tools could search; only the competitor analyst did. All jurors are simulated perspectives, not user research.

| Juror | Recommendation | Confidence | Evidence |
|---|---|---|---|
| CFO | CONDITIONAL | MEDIUM | WEAK |
| Investor | CONDITIONAL | MEDIUM | WEAK |
| Marketer | CONDITIONAL | MEDIUM (process) / LOW (market) | WEAK |
| Engineer | CONDITIONAL | MEDIUM | WEAK–MODERATE |
| Futurist | CONDITIONAL | MEDIUM | WEAK |
| Competitor Analyst | CONDITIONAL | LOW | WEAK (web, secondary sources) |
| Everyday Person | CONDITIONAL | LOW | WEAK |
| Strategist | CONDITIONAL | MEDIUM | WEAK |
| Lawyer | CONDITIONAL | MEDIUM | WEAK–MODERATE |
| Designer | CONDITIONAL | MEDIUM | WEAK |
| Operator | CONDITIONAL | MEDIUM | WEAK–MODERATE |

All eleven support building the **personal** MVP and oppose commercial spend until there is evidence. Nobody opposed outright; nobody gave unconditional support.

## Agreement
1. **Prove the loop early with a thin vertical slice** (Strategist, Engineer, Investor, Designer). The current plan builds ~80% of the requirements before the first real use, and the widget and goal-dedupe are the riskiest parts.
2. **Goal linking must be optional and fast** (Everyday Person, Designer, Marketer). Habits and tasks must work standalone; a goal can be attached later. A starter template ("Read 24 books") should build the chain in under a minute. Creation ≤3 fields.
3. **Design the missed-day experience before streaks** (Everyday Person, Designer, Competitor). Show "5 of last 7" rather than a broken streak; one-tap rest/pause; bulk reschedule or drop overdue tasks.
4. **Export is not a backup until import works** (Operator, Engineer; also EM finding F10). Add import + a round-trip test; snapshot the store before migrations; a small Diagnostics screen.
5. **The widget is the highest-risk item**; ship it last, with an append-only check-off intent (Engineer, Operator, Strategist).
6. **Define validation before Phase 5**: a written kill/continue metric (e.g. "Ben opens Today on ≥10 of 14 days unprompted"), 3–5 outside testers, a short competitor teardown (CFO, Investor, Strategist, Marketer, Everyday Person).
7. **No monetisation, sync, AI or analytics before evidence**; "no account, data stays on your device" is a credible positioning (Marketer, Lawyer, CFO).
8. **Expose core actions as App Intents** (log habit, add task, today, goal progress): cheap, needed for widgets anyway, future-proofs for Siri/assistants (Futurist, Competitor).

## Material disagreements
- **How much to cut.** Strategist would defer subtasks, task recurrence, N×/week habits, milestones as an entity, 365-day rates, per-item reminders. Designer would cut nothing but keep goal progress read-only at first. Investor would also defer JSON export, while Operator and Engineer want export *and* import earlier.
- **The 5-level hierarchy.** Competitor Analyst and Designer suggest goal → habit/task with optional milestones; Ben's brief specifies the full hierarchy. Strides reportedly draws "too complicated" complaints (weak evidence).
- **Differentiation.** Competitor Analyst found Strides already markets "habits + goals" (FACT per App Store aggregator); what appeared missing is the full chain with one honest progress number. LOW confidence: absence in a few searches is not proof.

## Implications
- **User:** the risk is setup friction and guilt after a bad week, not missing features.
- **Financial:** cash ≈ $0 until device installs; Apple Developer Program (USD 99/yr published price) needed for widget/TestFlight route without a Mac. Real cost is founder time and ongoing iOS-release maintenance.
- **Technical:** cross-process shared-store writes and migrations are the main integrity risk.
- **Commercial:** crowded, price-sensitive category (TickTick ~$36/yr, Streaks one-time, Strides $4.99/mo per secondary sources, unverified). No pricing work until retention evidence.
- **Legal:** low while local-only. User-entered goals can be sensitive; any sync/AI/analytics needs a fresh privacy review. Trademark search on "Ascend" before any public launch (qualified lawyer). Jurisdiction unconfirmed.
- **Operational:** silent failures (reminders, widget writes, date bugs) need diagnostics; Mac access is a hard dependency.

## Alternatives considered
A. Original MVP as briefed. B. Thin loop first, then expand in slices (majority view). C. Habits-only app (rejected by most: loses the differentiator).

## Recommended decision: RECOMMENDED WITH CONDITIONS
Build the personal MVP as **thin slices (option B)**, with optional goal linking, missed-day design up front, import + restore, diagnostics, widget last, and a written kill/continue metric before Phase 5. No commercial work until that metric and outside testers give evidence. Ben decides.
