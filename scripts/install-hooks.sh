#!/usr/bin/env bash
# One-time per clone: use the repo's git hooks.
cd "$(dirname "$0")/.." && git config core.hooksPath scripts/git-hooks && echo "git hooks installed"
