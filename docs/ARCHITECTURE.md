# Architecture proposal (Phase 0, awaiting approval)

Status: PROPOSED. Nothing here is built yet.

## Modules
```
Ascend.xcodeproj
├─ Ascend (app target)            SwiftUI screens, navigation, design system
├─ AscendWidgets (extension)      WidgetKit timelines + App Intents for interactive actions
└─ Packages/
   ├─ AscendCore                  Pure Swift. Value types + logic. No SwiftUI, no SwiftData.
   │    DayKey, Schedule, StreakCalculator, RecurrenceEngine,
   │    GoalProgressCalculator, CompletionRate, ReminderPlanner
   └─ AscendData                  SwiftData @Model types, VersionedSchema + MigrationPlan,
                                   repositories, JSON export/import, App Group store location
```
Why two packages: date/streak/recurrence/progress logic is where correctness risk lives. Keeping it free of SwiftData/SwiftUI makes it fast to test, deterministic (injected `Calendar` and clock), and runnable without a simulator. Models in `AscendData` convert to `AscendCore` value snapshots for calculations. No other layers (no view models per screen by default, no protocols with one implementation).

## Key data rules
- **DayKey** `(year, month, day)` in the user's calendar is how anything "per day" is stored (habit logs, rest days). Never a raw `Date` for a calendar day, never seconds ÷ 86400. A DayKey is fixed when logged, using the time zone current at that moment, and is never recomputed after travel.
- **Schedules are versioned**: a habit has `ScheduleVersion(effectiveFrom: DayKey, rule)`. Changing a schedule adds a version; past days are evaluated against the rule that applied then.
- **History is append-only in practice**: archive instead of delete by default. Hard delete is explicit, confirmed, and cascades deliberately (documented per model).
- **Stable UUIDs + createdAt/modifiedAt** on every record (cheap now; keeps a later sync option open). No sync built.
- **Goal progress has one source per event**: a `ProgressEntry` has `goalID`, `amount`, `day`, and an optional `sourceID` (habit log or task). This stops the *same* event counting twice. When a task and a habit both relate to one goal they are different events, so the rule is: each goal declares **one measure** (count, minutes, pages, percent of milestones) and **which linked items feed it**; items not chosen as a source are shown as linked context but add no progress. Undo deletes the entry created by that source. Duplicate checks are done explicitly in the repository (SwiftData `#Unique` upserts silently, and may not suit CloudKit). Final rules and tests: Phase 2 plan.
- Hierarchy: Goal (yearly/monthly/weekly/daily period) → Milestone → linked Habits / Tasks. "Weekly plan" is a view over the week's tasks/habits linked to goals, not a separate stored entity (decision for MVP).

## Streak definition (draft, to be confirmed in Phase 2 plan)
- Only **scheduled** days count. Unscheduled, paused and rest days are skipped, neither breaking nor extending a streak.
- Current streak = consecutive scheduled days completed, ending today or the most recent scheduled day (today not yet failing until it ends).
- Weekly-frequency habits ("3× per week") streak in **weeks**, using the user's first weekday.
- Missing a day resets *current* streak only; longest streak, totals and completion rates are kept and shown. Completion rate = completed scheduled days ÷ scheduled days in window (7/30/365).

## Persistence
SwiftData store in the App Group container, shared by app and widget extension. Every schema is a `VersionedSchema`; every change ships with a migration stage and a test that opens a store from each prior version. Manual **JSON export** (Files/share sheet) from day one. Export alone is data portability, not recovery: **import/restore** is a proposed MVP item (Phase 5) and is only called a backup once a restore has been tested.

App and widget both write to the store (the widget via App Intents). Rule: every write goes through `AscendData` repositories; the app refreshes its model context when it returns to the foreground and after a widget-intent write (persistent history tracking if needed). Concurrency tests: Phase 4.

## Notifications
Local only (`UNUserNotificationCenter`). Deterministic identifiers (`habit.<uuid>.<slot>`) so rescheduling replaces rather than duplicates. A single `ReminderPlanner` (pure, in Core) computes the desired set; a small scheduler diffs it against pending requests. Respect the 64-pending limit by scheduling the nearest occurrences. Denied permission → reminders UI shows a calm explanation with a Settings link; the app works without them.

## Widgets
Timeline reads from the shared store. App calls `WidgetCenter.reloadTimelines` after writes. Interactive check-off via `AppIntent` (iOS 17+) writes through the same `AscendData` repository. Lock Screen widgets later in Phase 4.

## Minimum iOS (decision for Ben)
Proposed **iOS 18.0**: interactive widgets (17+), mature SwiftData, and SwiftData history/indexes. Final choice depends on the iOS version on Ben's iPhone and the Xcode version on the Mac. NOT VERIFIED against current Apple docs for every API; the iOS Platform Specialist checks this in Phase 1.

## Explicitly not built
Backend, accounts, cloud sync, analytics SDKs, third-party dependencies, AI features, subscriptions. Revisit only with Ben's approval (Phase 6).
