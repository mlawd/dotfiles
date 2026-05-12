---
name: exploring
description: Discover relevant codebase context and normalize findings into a structured Exploration Packet. Used as input for planning and as a refresh mechanism between phases.
consumer: orchestrator primary, explore subagent
calibration: strong-reasoning or general-purpose models
---

# Exploring

Discover the relevant codebase context for a task. Produce a structured Exploration Packet that becomes input for planning or a refresh for in-flight packets. The Exploration Packet is an internal handoff artifact; users should receive concise summaries unless they request the raw packet.

## When to invoke

- At the start of new work, before planning
- Between phases, when a packet is marked `Refresh after previous phase: yes`
- Whenever a planner or implementer is missing concrete context they need

## Process

### 1. Frame the search

Be explicit about what you're looking for. Prefer 2-4 narrow searches over one wide scan. Each search should have:

- A clear scope (which directories or modules)
- A clear intent (what question you're answering)

### 2. Search

Use your file-search and content-search tools to find:

- Source files in the affected areas
- Existing types, interfaces, and signatures
- Test files and test utilities
- Module structure and import conventions
- Similar past implementations to mirror

### 3. Inspect

Read enough of each candidate file to confirm relevance. Don't just collect names — confirm they're actually what you think they are.

### 4. Produce the Exploration Packet

Normalize findings into this exact structure. This internal structure is for downstream planning and implementation and should not be displayed verbatim to the user by default.

```
## Exploration Packet

### Scope searched
- Areas inspected: {list}
- Search intent: {list of questions answered}
- Confidence: high | medium | low

### Relevant files
- `path/to/file.ext` — {role, why it matters}
- ...

### Relevant symbols
- `{symbol name}` in `path/to/file.ext` — {purpose / impact}
- ...

### Reference patterns
- `path/to/example.ext` — {pattern to copy}
- ...

### Constraints and conventions observed
- Import style: {note}
- File naming: {note}
- Testing pattern: {note}
- Data flow notes: {note}

### Likely edit surface
- Must change: {files}
- May change: {files}
- Probably should not change: {files}

### Open questions / missing facts
- {only if needed}
```

### 5. Communicate findings to the user

After producing the packet, summarize the findings for the user:
- Summarize in 3-5 bullets maximum.
- Mention likely edit surface and confidence/risk briefly.
- Ask at most one clarification question, only if it materially affects the plan.
- Do not list every missing fact; send the highest-impact unknown to brainstorming as the next question.

## What this skill does NOT do

- Make architectural decisions (that's planning)
- Write code (that's implementation)
- Decide what to build (that's brainstorming)

Exploring is observation, not judgment.

## Rules

- Treat Exploration Packet as internal/downstream context by default
- Show users concise summaries, not raw packets, unless requested
- Ask users at most one clarification question at a time
- Keep concrete file paths/symbol names in the packet for downstream agents; no vague summaries
- 2-4 narrow searches preferred over one wide scan
- Confirm relevance by inspection; don't trust file names alone
- Flag missing facts explicitly under Open questions
- The packet is the source of truth for downstream planning — don't collapse data into prose
