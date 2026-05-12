---
name: planning
description: Produce a stacked PR implementation plan with verbose phase packets calibrated for lighter-reasoning implementers. In-context by default — no disk artifacts unless requested.
consumer: orchestrator primary, planner subagent
calibration: strong-reasoning models (primary); produces output for lighter-reasoning implementers
---

# Planning

Produce a stacked-PR implementation plan. Phases are vertical slices that ship independently. Packets are verbose enough that a lighter-reasoning implementer can execute without drift.

## Input

- **Intent block** — from brainstorming or directly from the user
- **Exploration packet** — from the `exploring` skill or `explore` subagent
- **Project conventions** — file naming, branch naming, available scripts

## Output

A plan in conversation context. No file written unless the user explicitly asks for one.

## Process

### 1. Slice the work vertically

Each phase is an independently-deployable PR slice. Constraints:

- Each phase ships working, tested code on its own
- Each phase builds on the previous (stacked, not parallel)
- No forward references — phase N never imports from phase N+1
- Target 1-5 phases. >5 is a signal to decompose differently (different sub-feature, separate plan)
- A phase touching more than ~10 files is too big — split it

Prefer vertical end-to-end slices over horizontal layer-by-layer phases. Use horizontal slicing only when a shared foundation, migration, or risk reduction step is clearly necessary.

### 2. Per-phase: produce an implementation packet

For Phase 1, produce a FULL packet. For later phases, default to LIGHT. These full/light packets are implementation handoff artifacts and should be retained internally by default.

**Full packet:**
- Goal (one sentence)
- Branch name (follows project conventions)
- Allowed files (the implementer must not modify outside this list)
- Read first (files the implementer must read before editing)
- Relevant symbols (functions, types, classes by name and location)
- Reference patterns (existing files that show the approach to mirror)
- Edit recipe (concrete numbered steps)
- Verification commands (specific to this phase, not just "run all tests")
- Non-goals (explicit exclusions to prevent scope creep)
- Done when (observable completion conditions)

**Light packet:**
- Goal
- Branch name
- Likely files (rough scope)
- Builds on (what previous phases established)
- Non-goals
- Done when

### 3. Mark refresh hooks

For each phase after Phase 1, decide:

- **Refresh after previous phase: yes** — the previous phase's implementation may shift what this phase needs; re-exploration after Phase N completes will upgrade this light packet to full before Phase N+1 starts
- **Refresh after previous phase: no** — this phase's shape is stable; light packet can be promoted directly using the previous phase's report

Default to `yes` unless the phase is genuinely independent.

### 4. Present the plan in one shot

After producing the plan, present it to the user. By default, the user sees a concise plan; do not dump the full verbose packet contents unless requested. Use this structure:

```
## Implementation Plan
**Total phases:** N

### Phase 1: {short description}
**Branch:** feat/sc-{id}/1-{kebab-description}
**Value Delivered:** {what this slice provides}
**Likely Edit Surface:** {files/modules}
**Verification:** {how we'll know it works}
**Packet fidelity:** full

### Phase 2: {short description}
**Branch:** feat/sc-{id}/2-{kebab-description}
**Value Delivered:** {what this slice provides}
**Likely Edit Surface:** {files/modules}
**Verification:** {how we'll know it works}
**Packet fidelity:** light
**Refresh after previous phase:** yes
```

Then ask one question: "Does this look good? I'll start implementing once you approve."

This is the ONLY approval gate inside planning. After the user approves, the plan is a living document the orchestrator owns — no further "please confirm" gates during execution.

### 5. Self-check before presenting

- Each phase independently deployable? (no forward references, no broken builds)
- Vertical slices preferred? (horizontal phases justified?)
- Verification commands specific? (not just "run all tests")
- Packet detail proportional? (Phase 1 full, later light + refresh marks)
- No phase >10 files? (split if so)
- Branch names follow convention?
- All acceptance criteria addressed?

Fix issues before presenting. Do not present a plan that fails self-check.

## Revisability

The plan is not frozen. Mid-execution, the orchestrator may:

- Refresh a light packet to full after the previous phase ships
- Split a phase that grew unexpectedly large
- Add a phase if a missing piece is discovered
- Re-present a changed plan to the user for re-approval if the shape materially shifts

None of these require a new planning session — they're part of normal execution flow.

## Hand-off

Hand the plan to the workflow skill that owns execution (e.g., `orchestrating-stacked-prs`). The plan lives in conversation context; no file is created. The full implementation packet is supplied to the orchestrator/implementer even if hidden from the user-facing plan.

## When to persist

Only if the user explicitly asks ("save this plan," "write this to a doc"). In that case, write to `docs/plans/{date}-{topic}.md` and offer a commit, but do not commit without explicit confirmation.

## Rules

- In-context by default; no file artifacts
- One approval gate (after presentation)
- Phase 1 packet at full fidelity; later phases light + refresh-on-demand
- Packets are internal handoff artifacts; show users a concise plan summary, not raw verbose packets, unless requested
- Packets must be verbose enough for a lighter-reasoning implementer to execute without drift
- No forward references between phases
- 1-5 phases; split or decompose otherwise
- Phases >10 files must be split
- Self-check before presenting
