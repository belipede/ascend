#!/usr/bin/env bash
# Regression tests for scripts/git-hooks/pre-commit in a throwaway repo.
set -uo pipefail
HOOK="$(cd "$(dirname "$0")" && pwd)/git-hooks/pre-commit"
T=$(mktemp -d); trap 'rm -rf "$T"' EXIT
cd "$T" && git init -q && git config user.email t@t && git config user.name t
KEY="-----BEGIN RSA PRIV""ATE KEY-----"   # split so this file does not trip the scan
FAILS=0
expect_block() { if "$HOOK" >/dev/null; then echo "  hook test FAILED (not blocked): $1"; FAILS=1; else echo "  hook test ok: $1"; fi; git reset -q --hard 2>/dev/null; git clean -qfdx; }
echo clean > base.txt && git add base.txt && git commit -qm base --no-verify
echo "$KEY" > a.txt && git add a.txt;                                         expect_block "staged key"
echo "$KEY" > b.txt && git add b.txt && echo clean > b.txt;                   expect_block "key staged, worktree overwritten"
git mv base.txt moved.txt && echo "$KEY" >> moved.txt && git add moved.txt;   expect_block "rename plus key"
echo "$KEY" > "my notes.txt" && git add "my notes.txt";                       expect_block "space in filename"
echo x > cert.p12 && git add -f cert.p12;                                     expect_block ".p12 file"
echo fine > ok.txt && git add ok.txt
if "$HOOK" >/dev/null; then echo "  hook test ok: clean file allowed"; else echo "  hook test FAILED: clean file blocked"; FAILS=1; fi
git commit -qm ok --no-verify
echo "$KEY" > "sp ace.txt" && git add "sp ace.txt" && git commit -qm leak --no-verify && echo clean > "sp ace.txt"
if "$HOOK" --all >/dev/null; then echo "  hook test FAILED (--all missed committed key)"; FAILS=1; else echo "  hook test ok: --all finds committed key"; fi
exit $FAILS
