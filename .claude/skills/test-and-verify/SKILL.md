---
name: test-and-verify
description: Run the builds and tests this machine can run, investigate failures, and report actual results with NOT VERIFIED for anything that could not run. Use after any code change and before any review.
argument-hint: [optional scope, e.g. core | app | all]
---
Verify scope: $ARGUMENTS (empty means all)

1. Run `scripts/verify.sh $ARGUMENTS` and capture the full output. It detects the platform:
   - Linux with `swift`: builds and tests the `AscendCore` package only.
   - macOS with Xcode: builds the app and widget for the simulator and runs all test targets.
   - Anything it cannot run is printed as `NOT VERIFIED: <reason>`. Exit 0 = all ran and passed, 1 = failure, 2 = passed but partial.
2. If anything fails: read the failure, find the root cause, and fix the code (not the test) unless the test is wrong, in which case explain why. Rerun. Never skip, disable, or weaken a test to get green.
3. Report in this format, with real output excerpts:
```
## Verification report
Machine: <OS, Xcode/Swift version>
| Step | Command | Result |
Failures: <none | details>
NOT VERIFIED: <list and reason>
Manual / device checks still needed: <list>
```
Never say "passes" for something that did not run.
