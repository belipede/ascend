## Juror: Lawyer

**Recommendation:** CONDITIONAL. I support the local-only personal MVP. I would gate Phase 6 on the legal items below.

**Strongest argument:**
- FACT (docs/ARCHITECTURE.md): the design has no backend, accounts, analytics SDKs, third-party dependencies, AI or subscriptions.
- That means the MVP collects almost no data off-device, has no third-party licence exposure, and has no subscription-disclosure duties.
- JSON export from day one is a good start on data portability.
- OPINION: this is close to the lowest-legal-risk way to build a consumer app.

**Main risk:**
- Goals, habits and notes can reveal sensitive information, such as health, mental health, finances, religion or relationships. These are user-entered free text, so they could count as special-category or sensitive data under GDPR and some US state laws.
- The risk is small while data stays on-device. It grows sharply if Phase 6 adds sync, AI planning or analytics.
- Phase 6 lists "sync" and "AI planning" (ROADMAP), and both would send this data off-device.
- If AI planning sends goal text to a third-party model, that is a new processor, a new cross-border transfer and a new disclosure.

**Key assumption:**
- Data never leaves the device before launch.
- Ben has not confirmed his jurisdiction or the launch markets, so the applicable regimes are unknown. Possible regimes include GDPR/UK GDPR, Singapore PDPA, US state laws and COPPA.
- OPINION: the user's email suggests a possible Singapore link. That is not confirmed, so please confirm.

**Suggested improvement:**
1. Keep the App Group store and the JSON export on-device only. Warn users that an export file is unencrypted and sits outside the app's protection once shared.
2. Check that the SwiftData store uses iOS file protection (an ESTIMATE, to be verified by the platform specialist).
3. Before any App Store submission, plan for:
   - A privacy policy URL. Apple requires one in App Store Connect for all apps (NOT VERIFIED this session; check the current guideline 5.1.1).
   - App Privacy "nutrition label" answers.
   - A privacy manifest (PrivacyInfo.xcprivacy). Required-reason APIs such as UserDefaults and file timestamps need declared reasons even for a local-only app.
   - An in-app way to delete all data. Guideline 5.1.1(v) covers account deletion, but local deletion should be offered anyway.
   - An age rating and a decision on whether to target children. Avoid targeting under-13s.
4. Subscriptions (StoreKit) would need clear price and renewal terms, a restore-purchases option, and consumer-law checks. Cancellation and auto-renewal rules vary by market.
5. Avoid health or wellness claims in marketing. They could trigger health-app scrutiny and regulator attention.
6. Check the name "Ascend" for trademark conflicts before launch. It is very common, and the clearance search has not been done. This needs a qualified lawyer.
7. Notification wording ("encouraging messages") should stay non-medical and non-coercive.
8. Write the licence record now: the dependency list is currently empty. If any package is added, record its licence (avoid GPL/AGPL for App Store distribution).

**Confidence:** MEDIUM

**Evidence quality:** WEAK to MODERATE. It rests on the three repo docs, which are FACT, and on my general knowledge of Apple and privacy regimes. I did not fetch current Apple guideline text this session, so all Apple requirements are NOT VERIFIED against current text.

**Answers to my questions:**
- **What data does this feature collect?** Only user-entered goals, habits, tasks, notes and completion logs, stored locally. There is no telemetry. Notification permission is the only OS permission.
- **Is the data necessary?** Yes for function. The brief lists no analytics or accounts, and I recommend keeping it that way until the research phase.
- **What disclosures or permissions may be required?** For personal use, only the notification permission prompt. At launch you would need a privacy policy, nutrition-label answers, a privacy manifest, terms of use, and subscription disclosures if monetised.
- **Are dependency licences compatible?** There are no dependencies, so no issue. Re-check if one is added.
- **Does the decision create avoidable legal risk?** No. The risk is deferred to Phase 6. Sync, AI and analytics would each need a fresh privacy review. The trademark check and the confirmation of Ben's jurisdiction are the open items.
