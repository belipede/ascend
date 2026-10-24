---
name: jury-review
description: Convene the Product Jury on a product decision - targeted jurors or the full eleven - and produce a consolidated recommendation that shows disagreements. Use for MVP scope, monetisation, privacy, major integrations, positioning or launch decisions; not for routine implementation.
argument-hint: <decision question> [--full | --jurors cfo,lawyer,...]
disable-model-invocation: true
---
Jury question: $ARGUMENTS

1. Write a brief to `docs/jury/<date>-<slug>-brief.md`: the decision, options, relevant facts and their sources, constraints, and what is unknown. Keep it neutral; do not argue for an option.
2. Select jurors. Use `--full` (all eleven) only for MVP definition, major direction, monetisation models or public launch. Otherwise pick the relevant ones, e.g.:
   - Widgets: jury-engineer, jury-designer, operator
   - Pricing: cfo, investor, marketer, strategist, lawyer, operator
   - Habit design: everyday-person, jury-designer, strategist, jury-engineer, competitor-analyst
   - Data collection: lawyer, jury-engineer, operator (plus engineering-manager)
3. Invoke each selected juror agent independently and in parallel, giving each only the brief (not other jurors' output). Juror agents: cfo, investor, marketer, jury-engineer, futurist, competitor-analyst, everyday-person, strategist, lawyer, jury-designer, operator.
4. Save each juror's report verbatim to `docs/jury/<date>-<slug>/<juror>.md`.
5. Write the consolidated report `docs/jury/<date>-<slug>-report.md`:
   - Table: juror, recommendation, confidence, evidence quality
   - Areas of agreement; material disagreements (do not smooth them over)
   - User impact; financial, technical, commercial, legal and operational implications
   - Alternatives considered
   - Recommended decision: RECOMMENDED | RECOMMENDED WITH CONDITIONS | NEEDS MORE EVIDENCE | NOT RECOMMENDED
6. Rules: a majority vote never overrides a serious legal, security or data-integrity concern. The jury never overrides an engineering-manager rejection. Juror opinions are not validated demand. Ben decides.
