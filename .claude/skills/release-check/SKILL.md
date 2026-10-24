---
name: release-check
description: Review a release candidate against technical, product, privacy, operational and App Store requirements. Use before installing a build for daily personal use, before TestFlight, and before any App Store submission.
argument-hint: <personal | testflight | appstore> [git ref]
disable-model-invocation: true
---
Release check: $ARGUMENTS

Work through the list for the given release type. Mark each item PASS (with evidence), FAIL, NOT VERIFIED, or N/A. Never mark PASS without evidence.

## All release types
- [ ] Clean `scripts/verify.sh all` on macOS with Xcode; paste summary
- [ ] Latest engineering-manager review for each feature in the build is APPROVED or APPROVED WITH NON-BLOCKING FINDINGS (link docs/reviews/)
- [ ] No open BLOCKER/CRITICAL findings anywhere in docs/reviews/
- [ ] Migration tested from every shipped schema version (list versions)
- [ ] Data export works and re-import / readback verified
- [ ] No secrets, certificates or profiles in git (`git log -p | grep` patterns from scripts/git-hooks/pre-commit)
- [ ] Device checklist (docs/ENVIRONMENT.md) run on a physical iPhone: install, launch, relaunch persistence, log habit, complete task, goal progress, notifications fire/cancel, permission denied path, widgets show current data, interactive widget action, Dynamic Type XXL, VoiceOver pass on Today, dark mode
- [ ] Known limitations documented in README

## TestFlight additionally
- [ ] Ben approved distributing to testers
- [ ] Version/build numbers bumped; signing unchanged except as Ben approved
- [ ] Privacy manifest present and accurate; no tracking

## App Store additionally (requires Ben's explicit approval to submit)
- [ ] Run `/jury-review --full` on launch readiness
- [ ] App Store Review Guidelines checked against current version (cite URL and date)
- [ ] Privacy nutrition label answers match actual data use
- [ ] Privacy policy URL and support URL live
- [ ] In-app purchase / subscription disclosures, restore purchases (if any)
- [ ] Account/data deletion path if accounts exist
- [ ] Screenshots, description and keywords make no unsupported claims

Output a table of results and a verdict: READY, READY WITH KNOWN ISSUES (list), or NOT READY (list blockers). Do not upload, submit, or publish anything.
