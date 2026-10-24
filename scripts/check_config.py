#!/usr/bin/env python3
"""Lint .claude agent and skill definitions: frontmatter present, required keys, unique names, known tools."""
import pathlib, re, sys

ROOT = pathlib.Path(__file__).resolve().parent.parent
KNOWN_TOOLS = {"Read", "Grep", "Glob", "Bash", "Write", "Edit", "NotebookEdit", "WebFetch", "WebSearch"}
REQUIRED_AGENTS = {
    "ios-architect", "ui-ux-designer", "qa-engineer", "ios-platform-specialist", "code-reviewer",
    "product-planner", "engineering-manager", "cfo", "investor", "marketer", "jury-engineer", "futurist",
    "competitor-analyst", "everyday-person", "strategist", "lawyer", "jury-designer", "operator",
}
REQUIRED_SKILLS = {"plan-feature", "test-and-verify", "review-changes", "jury-review", "release-check"}
READ_ONLY = {"engineering-manager", "code-reviewer"}
WRITE_TOOLS = {"Write", "Edit", "NotebookEdit"}

def frontmatter(path):
    text = path.read_text()
    m = re.match(r"^---\n(.*?)\n---\n(.+)", text, re.S)
    if not m:
        return None, ""
    fields = {}
    for line in m.group(1).splitlines():
        if line.lstrip().startswith("- "):
            errors.append(f"{path}: use comma-separated values, not YAML lists, in frontmatter")
        if ":" in line:
            k, v = line.split(":", 1)
            fields[k.strip()] = v.strip()
    return fields, m.group(2)

errors, names = [], {}
for p in sorted((ROOT / ".claude/agents").rglob("*.md")):
    fm, body = frontmatter(p)
    rel = p.relative_to(ROOT)
    if fm is None:
        errors.append(f"{rel}: missing frontmatter"); continue
    for key in ("name", "description"):
        if not fm.get(key):
            errors.append(f"{rel}: missing {key}")
    if len(body.strip()) < 200:
        errors.append(f"{rel}: system prompt suspiciously short")
    for key in ("tools", "disallowedTools"):
        for t in filter(None, (x.strip() for x in fm.get(key, "").split(","))):
            if t not in KNOWN_TOOLS:
                errors.append(f"{rel}: unknown tool {t!r} in {key}")
    name = fm.get("name")
    if name in names:
        errors.append(f"{rel}: duplicate agent name {name!r} (also {names[name]})")
    names[name] = rel
    if name in READ_ONLY or "jury" in p.parts:
        tools = {t.strip() for t in fm.get("tools", "").split(",") if t.strip()}
        if not tools:
            errors.append(f"{rel}: read-only agent {name} needs an explicit tools list")
        if tools & WRITE_TOOLS:
            errors.append(f"{rel}: read-only agent {name} has write tools {sorted(tools & WRITE_TOOLS)}")
    if name in READ_ONLY:
        denied = {t.strip() for t in fm.get("disallowedTools", "").split(",")}
        if not WRITE_TOOLS <= denied:
            errors.append(f"{rel}: {name} must list Write, Edit, NotebookEdit in disallowedTools")
for missing in sorted(REQUIRED_AGENTS - names.keys()):
    errors.append(f"missing agent {missing}")

skills = set()
for p in sorted((ROOT / ".claude/skills").glob("*/SKILL.md")):
    fm, body = frontmatter(p)
    rel = p.relative_to(ROOT)
    if fm is None or not fm.get("name") or not fm.get("description"):
        errors.append(f"{rel}: missing name/description frontmatter"); continue
    if fm["name"] != p.parent.name:
        errors.append(f"{rel}: name {fm['name']!r} does not match folder")
    skills.add(fm["name"])
for missing in sorted(REQUIRED_SKILLS - skills):
    errors.append(f"missing skill {missing}")

for e in errors:
    print("  config error:", e)
print(f"  {len(names)} agents, {len(skills)} skills checked, {len(errors)} errors")
sys.exit(1 if errors else 0)
