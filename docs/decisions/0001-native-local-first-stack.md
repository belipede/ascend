# 0001 Native, local-first stack with a pure-Swift core

Date: 2026-10-24 · Status: Proposed (awaiting Ben's approval)

**Context.** Personal MVP first, correctness and data integrity are the top priorities, solo developer, no budget committed.

**Decision.** Swift + SwiftUI + SwiftData (versioned schemas) + WidgetKit + App Intents + UserNotifications. No backend, accounts or third-party dependencies. Business logic in a pure `AscendCore` package; persistence in `AscendData`; data in an App Group container shared with the widget. JSON export as backup.

**Consequences.** Zero running cost; data stays on device (simplest privacy story). No multi-device sync until a later decision (CloudKit is the natural option and is kept possible by stable UUIDs and timestamps). Builds require a Mac.

**Alternatives.** Core Data (more mature migration tooling, more boilerplate); GRDB/SQLite (third-party dependency); cross-platform frameworks (worse widget/intents support). Revisit if SwiftData migration or widget-sharing problems appear in Phase 1.
