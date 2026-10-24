## Juror: Engineer
Recommendation: CONDITIONAL

Strongest argument: The architecture puts correctness risk in the right place. It follows the CLAUDE.md priority order (data integrity first).
- Streak, recurrence, DayKey and progress logic sit in a pure-Swift `AscendCore` package. Calendar and clock are injected, so it is testable on Linux. (FACT: docs/ARCHITECTURE.md; CLAUDE.md says cloud sessions have no Xcode.)
- Versioned schemas, versioned schedules, append-only history, a single-source progress rule and JSON export from day one are proportionate for a solo build.
- The brief says "no view models, no single-implementation protocols". That avoids overengineering.

Main risk: Phases 1–5 are heavy for a solo founder, and the riskiest parts can't be tested in the environment where most code gets written.
- (FACT: roadmap) Phases 1–5 can only be built on a Mac. Cloud sessions can write code but can't compile it. Swift 6 concurrency, SwiftData and App Intents errors will pile up unverified.
- (OPINION) The widget and the app both write to a shared SwiftData store in an App Group. Concurrent writes, stale timelines and migrations across two processes are the likeliest source of data-integrity bugs. This is the highest-risk item in the MVP.
- (OPINION) Versioned schedules, the unique `(goalID, sourceID)` constraint, week-based streaks and the 64-notification cap are each more complicated than they look. Together they make a large core for an unvalidated idea.
- (ESTIMATE, no data) The tests are meant to catch the bugs the widget will introduce. They only exercise the shared-store paths on a Mac, and delivery needs a device.

Key assumption: AscendCore's logic stays isolated. Models convert to value snapshots, and the widget and app go through the same repository. If SwiftData types leak into calculations, or the widget writes by another path, the testability benefit is lost.

Suggested improvement:
1. Build vertically. Ship habits + Today + JSON export on the device first (Ben dogfoods it), then add tasks, goals and the widget. The widget is the highest-risk piece, so it should come last, not tied to Phase 2's scope.
2. Run a Phase 1 spike on a Mac: app and widget extension sharing one store, with a migration test. Do this before committing to the rest.
3. Consider a simpler widget design. The widget could be read-only first, with check-off via an intent that only appends a log row (append-only, so there is nothing to conflict on).
4. Keep the minimum iOS decision (18.0) open until Ben's device version is known. It is currently NOT VERIFIED.
5. Add an import round-trip test for the JSON export. Export that has never been restored is not a backup.
6. Write the streak definition ADR before any code. It is still marked draft.

Confidence: MEDIUM

Evidence quality: WEAK to MODERATE. It rests on reading three proposal docs. Nothing is built, no code or tests were inspected, and I didn't check Apple docs for the iOS API claims.

Answers to my questions:
- Simplest robust solution? Mostly yes for the core and persistence. The widget and the goal-progress dedupe are where it stops being simple. Sequence them later.
- What can fail? Shared-store writes from two processes, migrations, DST and week-boundary streak bugs, notification limits, and unverifiable cloud-written Swift code.
- Is the architecture justified? Yes for the two packages, DayKey and versioned schemas. Goal-progress dedupe is justified only once goals ship.
- Easier or harder later? Easier. Stable UUIDs and timestamps keep sync open, and no layers means little to unwind. The cost is a larger up-front data model.
