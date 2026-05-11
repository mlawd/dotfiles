---
name: brainstorming
description: Establish shared intent before any meaningful work. Proportional to ambiguity — skips when intent is clear, deepens when forks exist. Produces no artifacts.
consumer: any agent that takes user requests for creative or implementation work
calibration: strong-reasoning models (primary)
---

# Brainstorming

Establish shared intent before meaningful work begins. Proportional — skip when clear, deepen when forks exist. No persisted artifacts.

## When to invoke

Invoke at the start of any task where you might modify behaviour, build something, or change non-trivial code. Skip for pure information retrieval or trivial single-line fixes.

## The triage gate

Before anything else, answer these three questions internally:

1. **Is intent clear?** Do you know what to build and why?
2. **Is scope clear?** Do you know what's in and what's out?
3. **Is there a real fork?** Are there multiple defensible approaches that materially differ?

Route based on the answers:

- All three clear → emit intent block and hand off
- Intent or scope unclear → enter clarification mode
- Real fork exists → enter options mode (may also need clarification first)

## Clarification mode

- Ask one focused question at a time
- Prefer multiple choice (A/B/C/D, including "or something else")
- Ask only what materially changes the outcome
- Stop the moment intent and scope flip to "clear"
- Do not ask procedural questions (e.g., "should I write tests?") — those are answered by your workflow skills

## Options mode

Only enter when triage flagged a real fork. Then:

- Present 2 options (3 max) — each in 2-3 lines
- State your recommendation in 1 sentence with reasoning
- Skip option presentation entirely if no genuine fork emerged in clarification

## Section-by-section design

When the work warrants a design discussion (multi-step plan, new architecture, non-trivial refactor):

- Break the design into sections (mental model, components, flow, etc.)
- Present one section at a time
- Get explicit sign-off after each section before moving on
- Be ready to backtrack and revise earlier sections

This applies whenever the user is reviewing your thinking — not just for new features. The default is incremental approval, not a single big reveal.

## Hand-off: the intent block

When triage clears, emit this in conversation (NOT as a file):

```
## Intent
{One paragraph: what we're building and why.}

## Non-goals
- {Explicit scope exclusion}
- {Explicit scope exclusion}
```

Hand off to your planning skill with this block as input.

## What this skill does NOT do

- Write a design doc to disk (no `docs/specs/`, no dated files)
- Force a "2-3 approaches with tradeoffs" template when no fork exists
- Block trivial work behind ceremonial gates
- Persist its output anywhere

If the user explicitly asks for a written design document, that's a separate task — write it, but don't make it the default output.

## Rules

- One question per message in clarification mode
- Triage proportionally — trivial tasks pass the gate immediately
- No artifacts unless explicitly requested
- Hand off through the intent block, in-context, no file persistence
- Section-by-section approval when designing
