# Roadmap

Each phase ends with an engineering-manager review and Ben's approval before the next starts.

| Phase | Scope | Exit criteria | Where it must run |
|---|---|---|---|
| 0 Setup | Agents, skills, controls, audit, jury, plan | EM audit + Ben approval | Cloud (done here) |
| 1 Foundation | Xcode project, AscendCore + AscendData packages, schema v1, app shell + tab navigation, design tokens, DayKey + date utilities with tests, JSON export skeleton | Builds; data persists across relaunch; core tests pass on macOS; EM approved | **Mac** (cloud can write code, cannot build) |
| 2 Core | Habits + streaks, tasks + recurrence, goals + milestones + links, Today dashboard | End-to-end flows on simulator; calculation tests incl. DST/boundaries; EM approved | Mac |
| 3 Reminders | Local notifications, permission-denied path, basic stats (7/30-day rates) | Scheduling/dup/cancel tests; documented metrics; EM approved | Mac + device for delivery |
| 4 Widgets | Today widget (Home), interactive check-off; Lock Screen if time | Widget/app consistency; device test; EM approved | Mac + **iPhone** |
| 5 Personal release | `/release-check personal`, install on Ben's iPhone, 1–2 weeks of real use | Device checklist passed and recorded | iPhone |
| 6 Commercial | Only after approval: research, sync, StoreKit, privacy policy, App Store | Full-jury review | — |

Deferred backlog (not scheduled): Lock Screen widgets, morning/evening reviews, calendar views, statistics screen, search/filters, categories, encouragement engine, quiet hours, Apple Calendar, AI planning, sync.
