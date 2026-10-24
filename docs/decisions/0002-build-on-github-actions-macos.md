# 0002 Build and test on GitHub Actions macOS runners

Date: 2026-10-24 · Status: Accepted (Ben chose this option)

**Context.** Ben develops on Windows; cloud Claude sessions run on Linux. iOS apps build only on macOS with Xcode.

**Decision.** Claude writes code in cloud sessions; every push/PR builds and runs tests on GitHub-hosted macOS runners via `scripts/verify.sh --ci`. The workflow (docs/ci/ios-ci.yml.proposed) is activated in Phase 1, when the Xcode project exists, so it never reports green without running iOS tests.

**Consequences.** ~10-minute feedback loop, no interactive simulator. GitHub Free includes 2,000 Actions minutes/month for private repos; macOS overage USD 0.062/min (GitHub billing docs, read 2026-10-24); how fast macOS jobs consume the free quota must be confirmed on the account's billing page. Installing on Ben's iPhone without a Mac requires the Apple Developer Program (USD 99/yr) and TestFlight uploads from CI with signing secrets in GitHub Actions secrets. That spend and the signing setup need Ben's approval, expected around Phase 4–5.

**Alternatives.** Rented cloud Mac (monthly cost), buying a Mac (upfront cost, best loop). Can switch later without code changes.
