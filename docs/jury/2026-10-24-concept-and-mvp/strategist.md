## Juror: Strategist
Recommendation: CONDITIONAL

Strongest argument: The architecture suits a personal-first build. It is local-only, has no dependencies, keeps the streak and date logic in a testable core, and has one exit test: Ben using it for 1–2 weeks (Phase 5). That test is the only evidence the project will produce, so everything before it should serve it. (OPINION, based on the brief and roadmap.)

Main risk: The MVP is about 80% of Ben's full requirement list, and the "deferred" items are the easy ones. These are the biggest cost areas: recurrence, versioned schedules, weekly-streak logic, subtasks, milestones, a single-source progress ledger and an interactive widget. Together they put Phases 1–4 at a lot of Mac-dependent work before any real use (ESTIMATE, not measured). The core claim is that the goal→habit→task link changes behaviour, yet the app only meets real use at Phase 5. Phase 2 also builds habits, tasks and goals in parallel. Nothing in the docs says which of them proves the loop. (FACT: docs/ROADMAP.md.)

Key assumption: Seeing why today's actions matter is what makes people stick with habits. No source in the brief supports this (FACT: brief says "no users, no research"). Competitor coverage is also unchecked, so the differentiation claim is unproven. The claim is plausible but unverified (OPINION).

Suggested improvement:
- Slice vertically. Build a thin loop first: one goal with a numeric target and deadline, habits and tasks linked to it, a Today view showing "this moves goal X by Y", and manual progress. Use it for a week before building the rest.
- Defer from the MVP:
  - Subtasks.
  - Task recurrence. Habits already cover recurring behaviour.
  - N×/week habits and their weekly-streak logic. Start with daily and selected weekdays.
  - 365-day rates and longest-streak display.
  - Milestones as a separate entity. Use a goal with a numeric target first.
  - Per-item reminders beyond one daily nudge.
  - Move the widget behind an in-app-only week of dogfooding. It is the costliest device-dependent item.
- Keep from Phase 1: DayKey, versioned schema and JSON export. These are expensive to reverse. The UUID and timestamp fields are cheap insurance.
- Pre-Phase-6 validation, which costs almost nothing: Ben's own usage log, a written competitor teardown of 3–4 apps, and 5 informal interviews. Define a kill/continue metric before Phase 5, for example "Ben opens Today on at least 10 of 14 days unprompted". (This is a proposal, not an existing threshold.)
- Set no commercial scope or monetisation before that evidence exists.

Confidence: MEDIUM

Evidence quality: WEAK. It rests on the brief, roadmap and architecture docs only. There is no user, market or competitor data.

Answers to my questions:
- Advances the core vision? Partly. Habits, tasks and widgets are table stakes. Only the link and progress ledger carry the vision, and they should come first.
- Right feature now? Build the thin linked loop now. Phase 1 is right, but Phase 2 should be reordered.
- Deliberately avoid? Everything on the deferred list, plus the cuts above, AI planning, sync and any monetisation work before Phase 5 evidence.
- Smallest version that proves the idea? One goal → linked habit and task → Today view → progress, used daily for a week on Ben's phone.
- Expensive to reverse? The SwiftData schema and migrations, the DayKey model, the progress-ledger design, the iOS 18 minimum, and App Group store placement. Settle these carefully. Everything else is cheap to change.
