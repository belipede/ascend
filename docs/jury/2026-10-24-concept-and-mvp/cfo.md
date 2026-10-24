## Juror: CFO

**Recommendation:** CONDITIONAL. Support the personal MVP, and block Phase 6 spending until the validation gates below are met.

**Strongest argument:**
- The personal MVP has almost no cash cost. The brief commits no budget, and the design has no backend, no third-party dependencies and no API calls (FACT: PRODUCT-BRIEF.md and ARCHITECTURE.md, "Explicitly not built").
- The cost that matters is Ben's time across Phases 1–5. This is mostly sunk, because the app is for personal use first.
- The deferrals are sound for cost. Cutting the encouragement engine, statistics screen, calendar views and AI saves the most build and maintenance effort.

**Main risk:**
- The MVP spends engineering effort on a crowded category before anyone has shown they would pay. Roadmap Phase 6 mentions "research" only after the build.
- Overlooked recurring costs:
  - Founder maintenance every iOS and Xcode release, which is unavoidable for WidgetKit, SwiftData and App Intents.
  - Schema-migration tests for every version, as ARCHITECTURE.md requires.
  - A Mac, which is required for building (FACT: CLAUDE.md). Whether Ben already owns one is unknown.
- At launch, support time and a privacy policy become costs.

**Key assumption:**
- The phase-5 build that Ben uses for 1–2 weeks is a valid signal of value. Ben is one user and is also the builder, so this proves little about willingness to pay.
- Free-tier cost assumptions below are unchecked.

**Suggested improvement:**
1. Before Phase 6, run a cheap validation that costs about $0:
   - Ben uses the app daily for 4+ weeks.
   - 3–5 acquaintances test it via TestFlight or friend installs.
   - Set a written kill/continue threshold, for example "still using it at week 4".
2. Confirm which Apple account tier Ben needs. ESTIMATE (from memory, NOT VERIFIED this session):
   - Free provisioning allows personal device installs, but the build expires after about 7 days.
   - Free provisioning may restrict capabilities such as App Groups, which the widget needs.
   - If so, the paid Apple Developer Program (about US$99/year, a published price I did not re-check) becomes a Phase 4 cost, not a Phase 6 one.
   - Ask Ben before spending, per CLAUDE.md.
3. Defer any paid-feature design until retention is shown. On launch economics:
   - ESTIMATE (NOT VERIFIED): Apple takes 30%, or 15% under the Small Business Program.
   - Habit-app pricing is unresearched. Do not model revenue without a competitor price survey, which is for the competitor-analyst.
4. Keep the "no backend" stance. Sync (CloudKit or otherwise) is the first real recurring cost and the biggest scope jump.

**Confidence:** MEDIUM

**Evidence quality:** WEAK. It rests on the three repo docs and general knowledge of Apple's program. I made no web check of current prices or terms, and I have no user, market or revenue data.

**Answers to my questions:**
- **Cost to build and maintain?** Cash is about $0 to Phase 5, or about $99/year if the widget forces a paid account (ESTIMATE). Founder time is the real cost. It is unquantified in the docs, and I will not invent a figure.
- **Is the expected value worth it?** For personal use, yes. For commercial use, it is unproven and there is no evidence either way.
- **Can we validate more cheaply?** Yes. Use the existing Phase 5 dogfooding, add a handful of friends, and set a pre-agreed threshold. Do not build StoreKit or sync before then.
- **Overlooked recurring expenses?**
  - Apple's annual fee.
  - iOS/Xcode upgrade maintenance.
  - Migration-test upkeep.
  - Mac hardware.
  - Support and privacy-policy upkeep at launch.
  - Possible sync/hosting costs in Phase 6.
