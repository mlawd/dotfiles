---
name: subagent-driven-development
description: Use when executing multi-phase implementation plans with Builder and Architect subagents.
---

# Subagent-Driven Development

Use this skill when you are executing a plan through subagents rather than doing the work directly.

## Core model

- Builder subagents implement phases.
- Architect subagents review phases.
- Each implementation phase gets a fresh Builder session.
- Each review gets a fresh Architect session.
- If a phase needs changes, resume the original Builder task ID for that phase.
- Remember the Builder task ID for every phase.

## Workflow

1. Start a Builder subagent for the current phase with the full implementation prompt.
2. Record that Builder task ID in the orchestrator context.
3. Let the Builder implement, verify, and summarize the phase.
4. Start a fresh Architect subagent for code review.
5. The Architect must invoke the `code-review` skill and review only the current phase output.
6. If the Architect requests changes, send the findings back to the original Builder task ID.
7. Start another fresh Architect session for re-review.
8. If the phase passes, move to the next phase with a fresh Builder session.

## Review policy

- Never reuse an Architect session for a later review.
- Never switch to a different Builder when fixing a phase.
- Keep the original Builder task ID as the source of truth for all fixes in that phase.
- If any issue remains after the 3rd review of the same phase, including minor issues, stop and ask the human.

## Orchestrator responsibilities

- Own phase ordering and overall progress.
- Track Builder task IDs.
- Launch fresh review sessions.
- Pass review findings back to the original Builder.
- Escalate unresolved 3rd-review issues to the human.

## Prompt shape

- Builder prompts should include the phase goal, required files or context, and the expectation to report blockers clearly.
- Architect prompts should include the phase goal, the current diff or implementation summary, and a reminder to use the `code-review` skill.

## Guardrails

- Do not begin the next phase until the current phase review passes.
- Do not let review findings leak into later phases unless they are still unresolved.
- Do not ask the human to approve routine fix loops; only escalate on the 3rd review if issues remain.
