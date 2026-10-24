#!/usr/bin/env bash
# Regression tests for scripts/git-hooks/pre-commit. Runs ONLY inside a fresh temp repo;
# refuses to run destructive git commands anywhere else.
set -uo pipefail
unset GIT_DIR GIT_WORK_TREE GIT_INDEX_FILE
HOOK="$(cd "$(dirname "$0")" && pwd)/git-hooks/pre-commit"
T=$(mktemp -d) || { echo "test_hooks: mktemp failed; refusing to run"; exit 1; }
[[ -n "$T" && -d "$T" ]] || { echo "test_hooks: no temp dir; refusing to run"; exit 1; }
trap 'rm -rf "$T"' EXIT
cd "$T" || { echo "test_hooks: cannot cd to temp dir; refusing to run"; exit 1; }
git init -q && git config user.email t@t && git config user.name t
[[ "$(git rev-parse --show-toplevel)" == "$(pwd -P)" ]] || { echo "test_hooks: not in the temp repo; refusing to run"; exit 1; }
KEY="-----BEGIN RSA PRIV""ATE KEY-----"
FAILS=0
reset_repo() { git reset -q --hard 2>/dev/null; git clean -qfdx; }
expect_block() { if "$HOOK" >/dev/null; then echo "  hook test FAILED (not blocked): $1"; FAILS=1; else echo "  hook test ok: $1"; fi; reset_repo; }
seq 1 40 > base.txt && git add base.txt && git commit -qm base --no-verify
echo "$KEY" > a.txt && git add a.txt;                                          expect_block "staged key"
echo "$KEY" > b.txt && git add b.txt && echo clean > b.txt;                    expect_block "key staged, worktree overwritten"
git mv base.txt moved.txt && echo "$KEY" >> moved.txt && git add moved.txt
if git diff --cached --name-status | grep -q '^R'; then                        expect_block "rename plus key"
else echo "  hook test FAILED: rename fixture did not stage as a rename"; FAILS=1; reset_repo; fi
echo "$KEY" > "my notes.txt" && git add "my notes.txt";                        expect_block "space in filename"
echo x > cert.p12 && git add -f cert.p12;                                      expect_block ".p12 file"
echo x > CERT.P12 && git add -f CERT.P12;                                      expect_block "upper-case .P12 file"
printf 'bin\0ary\n%s\n' "$KEY" > blob.bin && git add blob.bin;                expect_block "key inside binary file"
echo fine > ok.txt && git add ok.txt
if "$HOOK" >/dev/null; then echo "  hook test ok: clean file allowed"; else echo "  hook test FAILED: clean file blocked"; FAILS=1; fi
git commit -qm ok --no-verify
echo "$KEY" > "sp ace.txt" && git add "sp ace.txt" && git commit -qm leak --no-verify && echo clean > "sp ace.txt"
if "$HOOK" --all >/dev/null; then echo "  hook test FAILED (--all missed committed key)"; FAILS=1; else echo "  hook test ok: --all finds committed key"; fi
exit $FAILS
