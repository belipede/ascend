## Juror: Futurist

**Recommendation:** CONDITIONAL

**Strongest argument:** The architecture already fits a 3–5 year horizon without overbuilding. It keeps pure logic in `AscendCore`, uses versioned SwiftData schemas, gives every record a stable UUID, and exports JSON. Those choices keep the options open that matter most: sync, App Intents and Siri, on-device AI planning, and a later move to another storage layer. The deferrals (no AI, no backend, no SDKs) are also correct for now.

**Main risk:** The loop's differentiation is likely to erode.
- TREND: OS-level assistants are getting better at turning natural-language intent into plans and reminders. Apple has shipped App Intents and on-device Foundation Models, and I believe Apple Intelligence is moving toward on-device model access for third-party apps. I have NOT VERIFIED this against current Apple docs in this session.
- OPINION: By 3–5 years out, "make a plan from a goal" will probably be a commodity that the OS or generic assistants do. A pure tracker with manual entry could feel dated.
- What should last is the user's own linked history of goals, habits and progress, and the single-source progress rule that keeps it honest.

**Key assumption:** Users will still want a dedicated, structured goal system in 2029–2031 rather than a conversational assistant that holds the plan for them. Nothing in the brief tests this. It is SPECULATION.

**Suggested improvement:**
1. Expose the core actions as App Intents: log habit, add task, query today and query goal progress. Build them in Phase 4 alongside the widget intents, which need them anyway. These intents let Siri, Shortcuts and future assistants drive the app at near-zero extra cost.
2. Keep `AscendCore` free of UI and storage types, and keep the JSON export schema versioned and documented. It then serves as the interface for any future AI or sync layer.
3. Add an ADR with an "AI-ready" boundary. The plan-generation input and output should be plain structured values (goal, milestones, suggested habits) that a user accepts or rejects. Build no AI now. Any AI feature should be on-device first, with no data leaving the phone without Ben's approval.
4. Don't build sync, a plugin system, or a protocol layer "for the future". The UUID and modifiedAt fields are enough.
5. Treat HealthKit, EventKit and Apple Calendar import as optional Phase 6+ inputs that auto-complete habits. They would reduce manual logging, which is probably the biggest drag on any tracker. This fits the "single source per event" design.

**Confidence:** MEDIUM

**Evidence quality:** WEAK. It rests on the three project docs, which are FACT about the plan. The platform-trend claims come from my general knowledge (cutoff June 2026) and are not checked against live sources. Nothing about user expectations has been measured.

**Answers to my questions:**
- **User expectations in 3–5 years (TREND/SPECULATION):** I expect less manual logging, with automatic signals from Health and Calendar. I expect conversational capture ("add a 20-minute reading habit toward my book goal") and adaptive plans that adjust after a missed week. I also expect on-device privacy as a baseline. Guilt-free framing will matter more as trackers multiply.
- **Developments that could help:** On-device language models for plan drafting and weekly review summaries, deeper App Intents and Siri integration, richer widgets and Live Activities, and passive data from Health and Calendar.
- **Staying adaptable without overengineering:** Keep the Core/Data split, the versioned schemas, the stable IDs and the exported JSON. Add App Intents for the core actions. Defer everything else until real usage shows a need.
