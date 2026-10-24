# Ascend

iPhone app that turns goals into daily habits and tasks. **Status: Phase 0 (team and plan configured, no app code yet).**

- Start here: [CLAUDE.md](CLAUDE.md)
- Environment and build prerequisites: [docs/ENVIRONMENT.md](docs/ENVIRONMENT.md)
- Architecture proposal: [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md)
- Roadmap: [docs/ROADMAP.md](docs/ROADMAP.md)

## Setup (per clone)
```
scripts/install-hooks.sh     # secret-scanning pre-commit hook
scripts/verify.sh            # runs what this machine can run; exit 2 = partial
```

## Using the team in Claude Code
- Agents: ask by name, e.g. "use the engineering-manager agent to review feature/habits against main", or `@engineering-manager`. List with `/agents`.
- Skills: `/plan-feature <name>`, `/test-and-verify`, `/review-changes <name>`, `/jury-review <question> [--full]`, `/release-check personal`.

## Known limitations
No app code yet. Cloud sessions cannot build or test iOS code; see docs/ENVIRONMENT.md.
