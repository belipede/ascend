---
name: review-changes
description: Run the formal independent review of a change - engineering-manager verdict plus code-reviewer for risky diffs - and save the record. Use before merging any substantial feature or phase.
argument-hint: <feature name> [base ref, default main]
---
Formal review for: $ARGUMENTS

1. Determine base and head refs (default base `main`, head current branch). Make sure all changes are committed; reviewers review commits, not a dirty tree.
2. Gather inputs for the reviewer, without summarising the code for them: the acceptance criteria file (docs/features/<name>.md), the latest `/test-and-verify` report verbatim, the QA report, and the review cycle number (check docs/reviews/ for earlier cycles of this feature).
3. If the diff touches persistence, deletion, migrations, notifications, intents, import/export, entitlements or dependencies, invoke the `code-reviewer` agent first and pass its findings to the engineering manager as input.
4. Invoke the `engineering-manager` agent with the refs and inputs. Ask it to inspect the diff itself and return its standard report.
5. Save the report verbatim to `docs/reviews/YYYY-MM-DD-<name>-cycle<N>.md` and commit it. Do not edit the verdict or findings.
6. If REJECTED: fix findings, rerun `/test-and-verify`, and run this skill again (cycle N+1). After cycle 3 without approval, stop and escalate to Ben with the open findings.
7. If BLOCKED: report what would unblock it (often: run on Ben's Mac).
8. Merge only on APPROVED or APPROVED WITH NON-BLOCKING FINDINGS.
