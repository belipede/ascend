# 0003 Thin-slice MVP

Date: 2026-10-24 · Status: Accepted (Ben chose this option, following the full-jury recommendation)

**Decision.** Build the personal MVP in slices, using the app for real between slices.
- **Slice 1 (Phases 1–2):** goals with a numeric target and deadline; habits (daily, selected weekdays) with check-off; tasks with due date and priority; optional goal links (habits/tasks work standalone); Today screen showing which goal each item moves; JSON export **and import** with a round-trip test; missed-day display designed before streaks ("5 of last 7", one-tap rest/pause).
- **Then ~1 week of real use**, measured against a written keep/stop metric agreed with Ben before the trial.
- **Later slices, in order unless evidence changes it:** milestones, N×/week habits, task recurrence, subtasks, reminders, diagnostics screen, App Intents, widget (last).

**Consequences.** Earlier real use; riskiest work (widget, cross-process writes) happens after the loop is shown useful. Nothing from Ben's requirements is dropped; it is resequenced. Jury report: docs/jury/2026-10-24-concept-and-mvp-report.md.
