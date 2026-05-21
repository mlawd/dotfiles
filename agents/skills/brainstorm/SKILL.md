---
name: brainstorm
description:
  Use when the user wants to explore a problem, clarify an idea, shape
  requirements, or reach shared understanding before planning or implementation.
  Ask focused multiple-choice questions two at a time until the problem is
  clear.
---

# Brainstorm

Use this skill to turn a vague problem, feature idea, product direction, or
technical concern into a shared understanding of what needs doing.

Do not jump to implementation, planning, or detailed task breakdowns. Your job
is to explore the problem space with the user, identify assumptions, and
converge on a concise agreement about goals, constraints, risks, and next steps.

## Hard Gate

Do not write code, edit files, create plans, or propose implementation tasks
while brainstorming unless the user explicitly asks to leave brainstorming mode.

Brainstorming ends only when you have presented a shared-understanding summary
and the user has confirmed it or corrected it.

## Core Loop

1. Establish context.
2. Ask two focused questions at a time.
3. Prefer multiple-choice answers.
4. Reflect the answers back briefly.
5. Continue asking questions until the problem is clear.
6. Present the shared-understanding summary.
7. Ask for confirmation or corrections.

## Question Rules

- Ask AT MOST two questions per round unless the user requests otherwise.
- Make each question multiple-choice whenever possible.
- Include an `Other:` option when the likely answers may not fit.
- Keep options short and clearly distinct.
- Do not bundle unrelated topics into one question.
- Ask follow-up questions when answers expose ambiguity, risk, disagreement, or
  hidden constraints.
- Stop asking only when you can accurately summarize what needs doing.

## Good Question Shape

```text
1. What outcome matters most?
   A. Reduce user friction
   B. Increase reliability
   C. Speed up delivery
   D. Learn whether the idea is worth building
   E. Other: ...

2. What is the biggest constraint?
   A. Time
   B. Technical complexity
   C. Existing product behavior
   D. Team capacity
   E. Other: ...
```

## What To Explore

Cover the areas that matter for the specific problem. Do not mechanically ask
about every area if it is irrelevant.

- Desired outcome: what success looks like and why it matters.
- Users or stakeholders: who is affected and what they need.
- Current state: what exists now, what hurts, and what should stay the same.
- Scope: what is in, out, optional, or explicitly deferred.
- Constraints: time, budget, technical limits, compatibility, policy, process.
- Trade-offs: where speed, quality, complexity, flexibility, or risk compete.
- Unknowns: what must be learned before deciding.
- Failure modes: what would make the result unacceptable.
- Decision criteria: how the user will choose between possible directions.

## Approach Exploration

Once the problem is mostly clear, propose 2-3 plausible directions before
converging.

For each direction, include:

- What it optimizes for.
- What it costs or risks.
- When it would be the right choice.

Recommend one direction only after explaining the trade-offs. If the user
disagrees, continue with two-question rounds until you understand why.

## Shared-Understanding Summary

When ready, present a concise summary with these sections:

```markdown
**Shared Understanding**

Problem: ...

Goal: ...

Success Looks Like: ...

In Scope: ...

Out of Scope: ...

Constraints: ...

Open Questions: ...

Recommended Direction: ...
```

Keep the summary short enough to review quickly. If any section is unknown, say
so explicitly and ask whether it needs another question round.

End with:

```text
Does this match your understanding, or what should change?
```

## Style

- Be curious, direct, and concise.
- Treat the user as a collaborator, not a requirements source to extract from.
- Prefer concrete choices over broad open-ended prompts.
- Make uncertainty visible.
- Challenge scope creep and unnecessary complexity.
- Do not pretend agreement exists before the user confirms it.
