# Subagent Architecture

## Overview

The architecture has three layers:

- **Skills** — portable markdown describing *how* to do specific work well (methodology, checklists, output formats). Live in `agents/skills/<name>/SKILL.md`.
- **Agents** — OpenCode-specific execution profiles (model, permissions, context isolation). Live in `agents/agents/<name>.md`. Each agent loads one or more skills on entry.
- **Commands** — entry points that route to an agent. Live in `commands/<name>.md`.

The orchestrator owns the live working state. It handles discovery, planning, flow control, branch operations, and user communication, and delegates narrow execution and review tasks to specialized sub-agents.

```
orchestrator (primary, loads `orchestrating-stacked-prs` skill)
  |-- explore                      (Phase 1: codebase discovery)
  |
  +-- per implementation phase:
      |-- builder                  (loads implementation prompt)
      |-- architect                (loads `code-review` skill)
      +-- builder (same phase task ID; fix if needed; review limit applies)
  |
  +-- orchestrator-planner         (loads `planning` skill, fallback only)
```

## Skills

| Skill | Used by | Purpose |
| --- | --- | --- |
| `using-skills` | All agents | Entry-point; how to find and invoke skills |
| `brainstorming` | Orchestrator | Establish shared intent before work |
| `exploring` | Orchestrator, explore subagent | Discover codebase context, produce Exploration Packet |
| `planning` | Orchestrator, planner subagent | Produce stacked-PR plan with verbose packets |
| `orchestrating-stacked-prs` | Orchestrator | End-to-end stacked PR workflow |
| `subagent-driven-development` | Orchestrator | Execute multi-phase work with Builder/Architect review loops |
| `implementation` | Implementer subagent | Execute a single phase, anti-drift, packet-following |
| `code-review` | Reviewer subagent | Review changes, produce verdict |
| `verification-before-completion` | All agents claiming done | Evidence before assertions |
| `systematic-debugging` | All agents debugging failures | Reproduce, isolate, fix |
| `test-driven-development` | Implementer | Red-Green-Refactor |
| `writing-skills` | Anyone editing skills | Skill structure, portability, anti-patterns |

## Agents

| Agent | Mode | Permissions | Bound skills |
| --- | --- | --- | --- |
| `orchestrator` | primary | no edit/write, bash: gt/git only | `orchestrating-stacked-prs` (+ all others composed by reference) |
| `orchestrator-planner` | subagent, hidden | read-only, bash: git log only | `planning` |
| `orchestrator-implementer` | subagent, hidden | full access (edit, write, bash) | `implementation`, `verification-before-completion` |
| `orchestrator-reviewer` | subagent, hidden | read-only, bash: git diff/log/show | `code-review` |
| `builder` | subagent | read/edit, todowrite, bash without git/gh/gt | implementation phase work |
| `architect` | subagent | read-only, git/gh/gt allowed for review inspection | `code-review` |

## Commands

| Command | Phases | Description |
| --- | --- | --- |
| `/forge` | 1-2-3-4 | Full flow: discovery, planning, implementation, done |
| `/plan` | 1-2 | Discovery and planning only (no code changes) |
| `/implement` | 3-4 | Implementation and completion (needs approved plan) |

## How the layers compose

1. A command routes to an agent
2. The agent loads its bound skill(s) on entry
3. The skill describes the workflow in portable, capability-first prose
4. The agent provides the harness-specific execution (permissions, model, subagent dispatch)
5. Skills compose by referencing each other in prose ("follow the X skill") — loaded on demand

This separation gives:

- **Portability**: skills are markdown and run on any harness with a competent model
- **Reuse**: the same skill content backs the orchestrator's primary behaviour, subagent specializations, and ad-hoc invocations
- **Configurability**: each agent has its own model and permission profile while sharing skill content

## Context and Communication

- **Internal Packets**: The orchestrator keeps detailed exploration context in internal Exploration Packets and implementation details in verbose packets. These prevent re-exploration and ensure implementer fidelity but should not be shown raw to users.
- **Conversational Flow**: User-facing communication should be summarized, conversational, and focused on one question or decision at a time (matching the style of obra/superpowers).
- **Persistence**: Unlike obra/superpowers which may persist context into spec/plan docs, this orchestrator primarily keeps packets as internal in-context artifacts to minimize disk noise, unless explicit persistence is requested.

## Asymmetric calibration

The system intentionally runs the implementer on lighter-reasoning models (Sonnet 4.6 tier, GPT-5.4 Mini, Gemini 3.1 Flash) while the orchestrator/planner/reviewer run on stronger-reasoning models. This means:

- The `planning` skill produces verbose packets specifically as anti-drift rails for the implementer
- The `implementation` skill is procedural and protective — trusts the packet, resists exploration
- The orchestrator and reviewer skills are terser, principle-based — they trust the model's judgment

The verbose phase packet is a feature, not bloat — it's the planner's gift to the implementer.

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

    u ->> o: Explains what to build
    o ->> o: Fetch ticket (if ID provided)
    o ->> o: Read project context
    o ->> e: Explore codebase (exploring skill)
    e ->> o: Codebase findings
    o ->> o: Invoke brainstorming skill (if intent unclear)
    loop needs clarification
        o ->> u: Ask question
        u ->> o: Provide answer
    end
    o ->> o: Invoke planning skill (plan in-context)
    opt fallback planning needed
        o ->> p: Context + Exploration Packet + requirements
        p ->> o: Structured plan
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
    participant b as Builder
    participant a as Architect

    o ->> o: gt sync
    loop each phase in plan
        o ->> b: Phase details + prompt + conventions
        b ->> b: Implement phase + verify
        b ->> o: Implementation report + task ID
        o ->> o: gt create branch
        o ->> a: Phase intent + current diff + review prompt
        a ->> a: Code-review skill (fresh session)
        a ->> o: APPROVE or REQUEST_CHANGES

        loop REQUEST_CHANGES (same Builder task ID; max 3 reviews)
            o ->> b: Review findings to fix
            b ->> b: Fix + verify
            b ->> o: Fix report
            o ->> o: gt modify --all
            o ->> a: Fresh re-review
            a ->> o: APPROVE or REQUEST_CHANGES
        end

        opt issues remain after 3rd review
            o ->> u: Escalate for human input
        end

        o ->> o: gt submit
        o ->> u: Phase N/total complete (branch + PR link)
    end

    o ->> o: gt submit --stack
    o ->> o: Link PRs to ticket tracker
    o ->> u: Final summary (all PR links)
```

## Handoff Rules

- Use a full packet once, then prefer delta handoffs for fix cycles.
- Keep the orchestrator's working context compact.
- Treat immutable phase artifacts as snapshots, not shared scratchpads.
- Skills compose by reference, loaded on-demand to avoid context bloat.
- Reuse the original Builder task ID for fixes in a phase.
- Start a fresh Architect session for every review.
- Escalate to the user after the 3rd review if any issue remains, including minor issues.

## Portability

Skills are written in capability-first prose: "use your file-edit tool" rather than "use the Edit tool". This keeps them harness-portable across OpenCode, Claude Code, Copilot CLI, Codex, and Gemini. Each skill is self-sufficient; no per-install configuration is required.

The agent wrappers (this directory's `.md` files) are OpenCode-specific by design — they encode the permissions, model assignments, and subagent dispatch. Porting to another harness means rewriting the agent wrappers; the skills carry over unchanged.
