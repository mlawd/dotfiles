# Orchestrator Architecture

## Overview

The orchestrator delegates all work to specialized sub-agents via flat
delegation — the orchestrator is always the caller, sub-agents return
results to it, and it manages flow control, branch operations, and
user communication.

```
orchestrator (primary)
  |-- explore                      (Phase 1: codebase discovery)
  |-- orchestrator-planner         (Phase 2: create plan)
  |-- orchestrator-plan-reviewer   (Phase 2: review plan)
  |
  +-- per phase in Phase 3:
      |-- orchestrator-implementer (implement + verify)
      |-- orchestrator-reviewer    (code review)
      +-- orchestrator-implementer (fix if needed, max 3 cycles)
```

## Agents

| Agent                        | Mode             | Permissions                        | Purpose                                           |
| ---------------------------- | ---------------- | ---------------------------------- | ------------------------------------------------- |
| `orchestrator`               | primary          | no edit/write, bash: gt/git only   | Coordinates the full flow across all phases        |
| `orchestrator-planner`       | subagent, hidden | read-only, bash: git log only      | Produces structured implementation plans           |
| `orchestrator-plan-reviewer` | subagent, hidden | read-only, no bash                 | Reviews plans for feasibility and scoping          |
| `orchestrator-implementer`   | subagent, hidden | full access (edit, write, bash)    | Implements a single phase/PR and runs verification |
| `orchestrator-reviewer`      | subagent, hidden | read-only, bash: git diff/log/show | Reviews code changes, produces structured report   |

## Commands

| Command      | Phases    | Description                                          |
| ------------ | --------- | ---------------------------------------------------- |
| `/forge`     | 1-2-3-4   | Full flow: discovery, planning, implementation, done |
| `/plan`      | 1-2       | Discovery and planning only (no code changes)        |
| `/implement` | 3-4       | Implementation and completion (needs approved plan)  |

## Planning

```mermaid
---
title: Planning (Phases 1-2)
---

sequenceDiagram
    actor u as User
    participant o as Orchestrator
    participant e as explore
    participant p as orchestrator-planner
    participant r as orchestrator-plan-reviewer

    u ->> o: Explains what to build
    o ->> o: Fetch ticket (if ID provided)
    o ->> o: Read project context
    o ->> e: Explore codebase
    e ->> o: Codebase findings
    loop needs clarification
        o ->> u: Ask question
        u ->> o: Provide answer
    end
    o ->> p: Context + requirements
    p ->> o: Structured plan
    o ->> r: Plan + requirements
    r ->> o: APPROVE or REVISE
    opt REVISE (max 2 cycles)
        o ->> p: Plan + review feedback
        p ->> o: Revised plan
        o ->> r: Revised plan
        r ->> o: APPROVE or REVISE
    end
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
