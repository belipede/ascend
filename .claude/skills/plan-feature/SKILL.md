---
name: plan-feature
description: Plan a feature before coding - problem, acceptance criteria, dependencies, agents, risks and the minimal implementation plan. Use at the start of any substantial feature.
argument-hint: <feature name or description>
---
Plan the feature: $ARGUMENTS

1. Read CLAUDE.md, docs/ARCHITECTURE.md, docs/ROADMAP.md and any existing docs/features/ file for it. Confirm the feature is in the approved phase scope; if not, stop and flag it to Ben as a scope change.
2. If it adds or changes data models, persistence, or app/widget sharing, consult the `ios-architect` agent. If it touches WidgetKit, App Intents or notifications, consult `ios-platform-specialist`. If it adds or changes a screen, consult `ui-ux-designer`. Consult only those that apply.
3. Write `docs/features/<kebab-name>.md` (under ~80 lines) with:
   - Problem (one paragraph, user's view)
   - Acceptance criteria: numbered, each testable, each marked how it will be verified (unit test / UI test / simulator / device / manual)
   - Out of scope
   - Data model and migration impact
   - Date/time edge cases that apply
   - Dependencies and agents involved
   - Risks
   - Implementation steps (small commits)
   - Test list
4. Report the plan summary and any decision Ben must make. Do not start implementation in this skill.
