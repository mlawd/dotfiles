# Orchestrator Architecture

## Overview

The orchestrator owns the live working state. It handles discovery,
planning, flow control, branch operations, and user communication, and
delegates narrow execution and review tasks to specialized sub-agents.

```
orchestrator (primary)
  |-- explore                      (Phase 1: codebase discovery)
  |
  +-- per phase in Phase 3:
      |-- orchestrator-implementer (implement + verify)
      |-- orchestrator-reviewer    (code review)
      +-- orchestrator-implementer (fix if needed; reuse or refresh, max 3 cycles)
  |
  +-- orchestrator-planner         (fallback planning/replanning)
```

## Agents

| Agent                        | Mode             | Permissions                        | Purpose                                           |
| ---------------------------- | ---------------- | ---------------------------------- | ------------------------------------------------- |
| `orchestrator`               | primary          | no edit/write, bash: gt/git only   | Coordinates the full flow across all phases        |
| `orchestrator-planner`       | subagent, hidden | read-only, bash: git log only      | Fallback planning/replanning for complex tasks     |
| `orchestrator-implementer`   | subagent, hidden | full access (edit, write, bash)    | Implements a single phase/PR and runs verification |
| `orchestrator-reviewer`      | subagent, hidden | read-only, bash: git diff/log/show | Reviews code changes, produces structured report   |

## Commands

| Command      | Phases    | Description                                          |
| ------------ | --------- | ---------------------------------------------------- |
| `/forge`     | 1-2-3-4   | Full flow: discovery, planning, implementation, done |
| `/plan`      | 1-2       | Discovery and planning only (no code changes)        |
| `/implement` | 3-4       | Implementation and completion (needs approved plan)  |

## Planning

The orchestrator converts exploration results into a structured
Exploration Packet and uses it to produce the implementation plan
directly. If a task is unusually large or noisy, the orchestrator may
delegate a fallback planning pass to `orchestrator-planner`.

```mermaid
---
title: Planning (Phases 1-2)
---

sequenceDiagram
    actor u as User
    participant o as Orchestrator
    participant e as explore
    participant p as orchestrator-planner

    u ->> o: Explains what to build
    o ->> o: Fetch ticket (if ID provided)
    o ->> o: Read project context
    o ->> e: Explore codebase
    e ->> o: Codebase findings
    loop needs clarification
        o ->> u: Ask question
        u ->> o: Provide answer
    end
    opt fallback planning needed
        o ->> p: Context + Exploration Packet + requirements
        p ->> o: Structured plan
    end
    o ->> o: Produce plan directly when possible
    o ->> u: Proposed plan
    loop has alterations
        u ->> o: Sends alterations
        o ->> o: Makes alterations
        o ->> u: Updated plan
    end
    u ->> o: Confirms plan
```

## Implementation

```mermaid
---
title: Implementation (Phases 3-4)
---

sequenceDiagram
    actor u as User
    participant o as Orchestrator
    participant i as orchestrator-implementer
    participant r as orchestrator-reviewer

    o ->> o: gt sync
    loop each phase in plan
        o ->> o: gt create branch
        o ->> i: Phase details + conventions
        i ->> i: Implement + verify
        i ->> o: Implementation report
        o ->> o: gt modify --all
        o ->> r: Phase intent + ticket context
        r ->> r: Review changes
        r ->> o: APPROVE or REQUEST_CHANGES

        loop REQUEST_CHANGES (max 3 cycles)
            o ->> o: Decide reuse vs fresh implementer
            o ->> i: Review findings to fix
            i ->> i: Fix + verify
            i ->> o: Fix report
            o ->> o: gt modify --all
            o ->> r: Re-review
            r ->> o: APPROVE or REQUEST_CHANGES
        end

        o ->> o: gt submit
        o ->> u: Phase N/total complete (branch + PR link)
    end

    o ->> o: gt submit --stack
    o ->> o: Link PRs to Shortcut
    o ->> u: Final summary (all PR links)
```

## Handoff Rules

- Use a full packet once, then prefer delta handoffs for fix cycles.
- Keep the orchestrator's working context compact.
- Treat immutable phase artifacts as snapshots, not shared scratchpads.
