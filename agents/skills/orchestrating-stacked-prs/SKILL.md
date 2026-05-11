---
name: orchestrating-stacked-prs
description: End-to-end workflow for turning a ticket or task description into a stack of small, reviewable, independently-deployable PRs. Coordinates exploration, planning, implementation, and review by dispatching specialist subagents.
consumer: orchestrator primary (no edit/write permissions; can dispatch subagents and run gt/git)
calibration: strong-reasoning model (primary)
---

# Orchestrating Stacked PRs

You coordinate feature implementation by delegating work to specialist subagents. You manage branches, gather context, plan, and dispatch — you do not write code yourself.

## Sub-roles you dispatch

- **explore** — codebase discovery
- **planner** — fallback planning when the primary's planning skill needs isolated context (optional; you usually plan inline using the `planning` skill)
- **implementer** — executes a single phase
- **reviewer** — reviews changes on a branch

## Input

The user provides either:

- A ticket ID (e.g., a numeric identifier)
- A free-text description

If a ticket ID is present, fetch the ticket details first. If only text is provided, treat it as the task description and ask for acceptance criteria if missing.

## Phase 1: Discovery

### 1a. Fetch ticket (if ID provided)

Use the available ticket-tracker tools to fetch full ticket details: title, description, acceptance criteria, labels, epic context.

### 1b. Read project context

Read these files from the working directory (skip any that don't exist):

- `CLAUDE.md`
- `AGENTS.md`
- `README.md`
- Package manifest (`package.json`, `pyproject.toml`, `Cargo.toml`, etc.) for available scripts

### 1c. Explore the codebase

Follow the `exploring` skill to produce an Exploration Packet. Dispatch the `explore` subagent for any wide-net searches; do narrow inspection inline.

### 1d. Establish shared intent

Follow the `brainstorming` skill. Skip ceremony when intent is clear; clarify when not. Emit an intent block before moving on.

## Phase 2: Planning

Follow the `planning` skill to produce a stacked-PR plan in-context. Present it to the user and wait for explicit approval before Phase 3.

If the plan is unusually complex or the primary's context is getting tight, dispatch the `planner` subagent for a fallback planning pass instead.

## Phase 3: Implementation (loop per phase)

Before starting, ensure trunk is up to date by running the stacked-PR sync command (`gt sync --no-interactive` in projects using Graphite).

For each phase in the approved plan:

### 3a. Refresh packet if needed

If the current phase's packet is marked `Refresh after previous phase: yes`:

1. Dispatch the `explore` subagent to inspect what changed in the previous phase
2. Upgrade this phase's light packet to full fidelity using the exploration findings + previous phase report
3. Use the refreshed packet for the implementer dispatch

Skip for Phase 1 or if refresh: no.

### 3b. Dispatch implementer

Dispatch the implementer subagent with:

- Phase description and intent
- Ticket context
- Project conventions (from 1b)
- The implementation packet verbatim
- Verification commands
- Instructions: fix any failures before reporting; no git operations; treat the packet as source of truth

Store the returned task identifier so you can reuse the implementer's context for follow-up fixes when helpful.

**When to start a fresh implementer task instead of reusing:**

- Estimated context use above ~10-15%
- Phase has already had 2+ fix rounds
- Latest review feedback materially changes the approach
- Prior task has noisy/stale context

For fresh dispatches, provide a compact handoff: current branch state, files already changed, latest verification status.

For fix-cycle reuses, prefer delta-only handoff: latest review findings, files already changed, current verification status, any packet fields that changed.

### 3c. Create the stacked branch

Stage changes and create the branch in one step. For Graphite:

```
git add -A && gt create {branch-name} -m "{commit message}" --no-interactive
```

### 3d. Dispatch reviewer

Dispatch the reviewer subagent with:

- Phase description and intent
- Ticket context (if available)
- Instruction to diff against the previous branch in the stack

The reviewer follows the `code-review` skill in isolated context.

### 3e. Address findings

If the reviewer returns REQUEST_CHANGES with CRITICAL or WARNING items:

1. Decide whether to reuse the implementer task or start fresh (use the criteria from 3b)
2. Provide: review findings, current phase description, current packet, "fix only the reported issues unless a minimal adjacent change is required"
3. After fixes, amend the branch (`gt modify --all --no-interactive` for Graphite)
4. Re-dispatch the reviewer

**Cap at 2 review cycles.** If new CRITICAL issues keep appearing, stop and escalate to the user.

### 3f. Submit the branch

Push the branch to update its PR (`gt submit --no-interactive --no-edit` for Graphite).

### 3g. Phase completion message

After successful submission, display:

```
## Phase {N}/{total} complete

**Branch:** `{branch-name}`
**PR:** {URL}
**Review:** Approved

Proceeding to phase {N+1}...
```

Last phase: replace the trailer with "All phases implemented. Proceeding to final submission..."

### 3h. Context discipline

After each phase, retain only the live working set:

- User goal and acceptance criteria
- Approved plan
- Current phase packet
- Latest review findings
- Branch/PR state

Discard aggressively: full exploration dumps, old implementation reports, old review reports, failed attempts, superseded packet versions.

### 3i. Continue to next phase

Repeat from 3a.

## Phase 4: Completion

### 4a. Submit the full stack

For Graphite: `gt submit --stack --no-interactive --no-edit`.

### 4b. Link PRs to the ticket tracker

If a ticket ID exists, link each PR URL to the ticket and post a summary comment listing all PRs.

### 4c. Final summary

Present:

```
## Implementation complete

**Ticket:** {id} — {title}

**Stack ({N} PRs):**
1. PR #{num} — {title} ({url})
2. PR #{num} — {title} ({url})
...

All tests passing. Code review approved.

PRs will merge in order from bottom of stack to top.
```

## Error handling

- **Subagent failures**: Present situation to user with full context; do not retry blindly
- **gt/git failures**: Show the error and ask for guidance; for merge conflicts suggest `gt restack`
- **Ticket tracker failures**: Continue without ticket integration; notify the user
- **Phase grows too large**: If a phase would touch >10 files, split it; ask the user before restructuring

## Small task fast path

For small/low-risk tasks where the full stacked workflow is overkill:

1. Explore narrowly
2. Plan inline (single phase)
3. Dispatch the implementer once
4. Dispatch the reviewer only if the change is risky or cross-cutting
5. Submit as a single branch

Use the full stacked workflow when the work truly benefits from phase separation or isolated review.

## Composition with other skills

- Use `brainstorming` at the start when intent is unclear
- Use `exploring` for the discovery phase
- Use `planning` to produce the plan
- The implementer follows `implementation`
- The reviewer follows `code-review`
- Use `verification-before-completion` before final summary

## Rules

- Never write code directly — always dispatch
- One approval gate at end of planning; no others during execution
- Cap review cycles at 2 per phase
- Context discipline: drop superseded artifacts aggressively
- Branch and PR operations: only the orchestrator runs them
