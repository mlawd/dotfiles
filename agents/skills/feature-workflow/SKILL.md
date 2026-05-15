---
name: feature-workflow
description: Use for non-trivial feature work that should be clarified, split into vertical slices, implemented as stacked PRs when appropriate, and passed through implementation/review/fix loops before push or submit.
---

# Feature Workflow

Use this workflow to turn non-trivial feature work into small, reviewable, vertically sliced changes with explicit implementation, review, and verification gates.

This skill defines the process only. Use the active agent system's normal mechanisms for implementation, review, testing, Git, Graphite, and PR submission.

## When to use

Use this workflow when:

- the task may require more than one reviewable change
- one PR would mix unrelated concerns
- a foundational change enables later user-facing or behavior-level work
- review would be easier as smaller dependent changes
- the diff is likely to become large
- the work has meaningful correctness, migration, UX, or integration risk

Do not force this workflow for trivial, single-purpose, low-risk changes.

## Goals

The orchestrator is responsible for enforcing the process:

1. clarify the goal
2. plan vertical slices
3. decide whether the work should be one PR or a stack
4. implement one slice at a time
5. review each slice
6. send review fixes back to the original implementer/context where practical
7. verify before pushing or submitting

## Goal clarity gate

Before implementation, establish:

- the user-visible or behavior-level outcome
- acceptance criteria
- constraints, risks, and non-goals
- how success will be verified

If the desired outcome is unclear, use the available interview or goal workflow before planning.

## Vertical slicing rules

Prefer vertical slices over horizontal/layer-only slices.

Each slice should:

- deliver behavior, user-visible value, or a complete enabling capability where possible
- be independently reviewable
- include the code, tests, docs, migrations, or config needed for that slice
- keep the diff focused on one coherent purpose
- leave the system in a working state

Avoid by default:

- backend-only work followed later by frontend-only work
- database/API/UI/test layers split into separate PRs without independent value
- tests-only-at-the-end
- large mixed-purpose PRs
- broad refactors bundled with feature behavior

Horizontal or foundation-only slices are allowed only when technically necessary. If used, state why they are necessary and how they enable later slices.

## Stacked PR decision

Use stacked PRs when:

- the work naturally separates into multiple reviewable slices
- one PR would be too large or hard to review
- earlier slices provide foundations for later slices
- independent review of each slice would reduce risk
- separate PRs would make rollout, revert, or discussion clearer

Use a single PR when:

- the change is small and coherent
- splitting would add ceremony without reducing risk
- the slices would not be independently meaningful or reviewable

## Workflow

For each feature or slice:

1. Confirm the intended outcome and planned scope.
2. Implement the smallest coherent vertical slice.
3. Run relevant checks for that slice.
4. Inspect the diff for scope creep, accidental changes, and obvious defects.
5. Run a review pass.
6. If review finds blocking issues, return fixes to the original implementer/context where practical.
7. Re-run affected checks.
8. Re-review if the fixes materially changed the code.
9. Push or submit only after the slice passes the submit gate.
10. Continue to the next slice in the stack.

## Review/fix loop

Review findings should be classified as either:

- blocking: correctness, regression, security, data, test, or serious maintainability issues
- non-blocking: suggestions, polish, style, or future improvements

Blocking findings must be fixed before push or submit unless the user explicitly accepts the risk.

When fixing review findings:

- prefer the original implementer/context for continuity
- fix only the reported issues unless a minimal adjacent change is required
- avoid expanding the slice without reassessing the plan
- track review iterations explicitly

If two review rounds still produce major or blocking findings, stop and reassess the plan before continuing.

## Submit gate

Do not push or submit a slice unless:

- it matches the planned scope
- it is appropriately single-PR or part of a stack
- relevant checks have run
- review has completed
- blocking review findings are fixed or explicitly accepted by the user
- skipped checks, known risks, and follow-ups are called out

## Completion summary

At completion, report:

- the stack order, or why a single PR was used
- what each slice delivers
- review status
- checks run and results
- skipped checks or known risks
- any follow-up work that remains
