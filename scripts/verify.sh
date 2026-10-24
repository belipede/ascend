#!/usr/bin/env bash
# Runs every check this machine can run. Prints NOT VERIFIED for the rest.
# Exit: 0 = everything ran and passed, 1 = a check failed, 2 = passed but partial.
# Usage: scripts/verify.sh [--ci] [all|config|core|app]
# --ci: any NOT VERIFIED other than the manual device check counts as a failure.
set -uo pipefail
cd "$(dirname "$0")/.."
CI=0; [[ "${1:-}" == "--ci" ]] && { CI=1; shift; }
SCOPE="${1:-all}"
FAIL=0; PARTIAL=0
pass() { echo "PASS: $*"; }
fail() { echo "FAIL: $*"; FAIL=1; }
nv()   { echo "NOT VERIFIED: $*"; PARTIAL=1; (( CI )) && [[ "$*" != physical-device* ]] && FAIL=1; }
want() { [[ "$SCOPE" == all || "$SCOPE" == "$1" ]]; }

echo "== Machine: $(uname -s) $(uname -m)"

if want config; then
  echo "== Config checks"
  if python3 scripts/check_config.py; then pass "agent and skill definitions"; else fail "agent and skill definitions"; fi
  if scripts/git-hooks/pre-commit --all; then pass "secret scan of tracked files"; else fail "secret scan of tracked files"; fi
  if scripts/test_hooks.sh; then pass "secret-scan hook regression tests"; else fail "secret-scan hook regression tests"; fi
fi

if want core; then
  echo "== AscendCore (pure Swift package)"
  if [[ ! -f Packages/AscendCore/Package.swift ]]; then
    nv "AscendCore tests: package does not exist yet (Phase 1)"
  elif ! command -v swift >/dev/null; then
    nv "AscendCore tests: swift toolchain not installed on this machine"
  else
    swift --version | head -1
    if swift test --package-path Packages/AscendCore; then pass "AscendCore swift test"; else fail "AscendCore swift test"; fi
    [[ "$(uname -s)" != Darwin ]] && echo "NOTE: Linux Foundation can differ from Apple Foundation; core tests must also pass on macOS before approval."
  fi
fi

if want app; then
  echo "== iOS app and widget"
  if ! command -v xcodebuild >/dev/null; then
    nv "iOS build and tests: xcodebuild not available (needs macOS with Xcode)"
  elif [[ ! -d Ascend.xcodeproj ]]; then
    nv "iOS build and tests: Ascend.xcodeproj does not exist yet (Phase 1)"
  else
    xcodebuild -version | head -1
    DEST="${ASCEND_SIM_DEST:-platform=iOS Simulator,name=iPhone 16}"
    if xcodebuild -project Ascend.xcodeproj -scheme Ascend -destination "$DEST" test -quiet; then
      pass "xcodebuild test ($DEST)"
    else
      fail "xcodebuild test ($DEST)"
    fi
  fi
  nv "physical-device checks always need a manual run (see docs/ENVIRONMENT.md)"
fi

echo "== Summary"
if (( FAIL )); then echo "RESULT: FAILED"; exit 1; fi
if (( PARTIAL )); then echo "RESULT: PASSED (PARTIAL - see NOT VERIFIED above)"; exit 2; fi
echo "RESULT: PASSED"; exit 0
