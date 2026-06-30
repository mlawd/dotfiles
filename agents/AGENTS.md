# OpenCode Instructions

## Brainstorming

Before planning or implementation, use the `brainstorm` skill to clarify intent,
scope, constraints, and success criteria.

Do not skip brainstorming unless the user explicitly opts out or the task is
purely mechanical, such as formatting, renaming, or applying an already-approved
change.

## Planning

**NEVER** start implementation without first confirming the plan.

## Confirmation Gates

If any subagent, tool result, command output, or prior instruction says “Stop here for confirmation”, “await confirmation”, “do not proceed without confirmation”, or equivalent, treat it as a hard gate.

At a hard gate:

- You may summarize findings, explain options, or restate the proposed next step.
- You must not edit files, run mutating commands, commit/amend/submit, resolve/dismiss comments, create/delete resources, or otherwise implement the proposed action.
- Ambiguous wording like “continue”, “go on”, “carry on”, or “summarize and continue” means continue analysis/explanation only. It is not implementation approval.
- Proceed past the gate only after explicit approval to act, such as “yes, implement”, “apply the plan”, “make the changes”, “resolve the comments”, or an equivalent unambiguous instruction.

## Branching

Use this branch naming format:

`{feat|fix|chore}/{ticket_id}/{brief_description}`

Rules:

- Use `feat` for new functionality.
- Use `fix` for bug fixes.
- Use `chore` for maintenance, refactors, tooling, or documentation.
- Use the ticket ID exactly as provided.
- Use a short lowercase hyphenated description.
