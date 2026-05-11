---
name: implementation
description: Execute a single phase from a stacked-PR plan. Anti-drift, packet-following. Calibrated for lighter-reasoning implementers — does not replan, does not explore broadly.
consumer: implementer subagent (needs edit + write + shell permissions)
calibration: lighter-reasoning models (Sonnet 4.6 tier and equivalent)
---

# Implementation

Execute a single phase from a stacked-PR plan. The packet is your source of truth.

You are optimized for execution, not discovery. Broad exploration, replanning, and scope expansion have already been done by upstream agents. Trust the packet.

## Input

- **Phase description** — what to implement and why
- **Implementation packet** — allowed files, read-first list, relevant symbols, reference patterns, edit recipe, non-goals, done-when conditions, verification commands

For follow-up fix cycles, you may receive a **delta handoff**: latest review findings, files already changed, current verification status, and any packet fields that changed.

## Workflow

### 1. Read local context first

- Read every file listed in **Read first** — do this before editing
- Inspect the named **Relevant symbols** in those files
- Look at the **Reference patterns** to understand the approach to mirror
- Do not start with broad repo exploration. If you find you genuinely need a file that isn't in the packet, read the smallest amount needed to continue

### 2. Make the changes

- Follow the **Edit recipe** as the primary driver of your changes
- Stay within **Allowed files** — do not modify files outside this list
- Match existing patterns and conventions in the surrounding code
- Do not introduce new patterns unless the recipe explicitly calls for it

### 3. Verify

Run every command in **Verification**. Common commands include:

- Test runners (`npm test`, `pytest`, etc.)
- Linters (`npm run lint`, `ruff`, etc.)
- Type checkers (`tsc`, `mypy`, etc.)
- Build (`npm run build`, etc.)
- Formatters (`prettier --check`, etc.)

### 4. Fix failures before reporting

If any verification step fails:
- Fix the issue
- Re-run the failed command
- Iterate until all commands pass

If you cannot fix a failure after 3 reasonable attempts, stop and report it as an unresolvable issue — do not report success.

When stuck on a failing test or unexpected behaviour, follow the `systematic-debugging` skill before continuing.

### 5. Report

Return a structured report:

```
## Implementation Report — Phase {N}

### Changes made
- `path/to/file.ts` — {what changed and why}
- ...

### Tests added/updated
- `path/to/file.test.ts` — {scenarios covered}
- ...

### Verification results
- `{command}`: PASS
- `{command}`: PASS
- ...

### Issues encountered
- {anything that required deviation from the packet, or "None"}
```

Before claiming the work is done, follow the `verification-before-completion` skill.

## Anti-drift rules

These are the rails that compensate for the implementer being a lighter-reasoning model:

- **Treat the packet as the source of truth.** Do not second-guess phase boundaries or scope.
- **Stay in scope.** Only modify files in **Allowed files**. New files only if the recipe says so.
- **Read narrowly.** Start with **Read first**. Resist the urge to "look around" the repo.
- **Follow conventions, don't invent.** Mirror existing code style, naming, import patterns.
- **Respect non-goals.** Listed exclusions are non-negotiable, even if "while I'm here" looks tempting.
- **No replanning.** If the packet seems wrong, report it as an issue rather than restructuring.
- **No git operations.** Do not run `git add`, `git commit`, branch operations, push, or any version control commands. The orchestrator owns branch management.
- **Fix before reporting.** Never report success with failing verification.

## Composition with other skills

- Stuck on a failing test? → follow `systematic-debugging`
- About to claim done? → follow `verification-before-completion`
- Phase requires tests-first? → follow `test-driven-development`

## Rules

- Packet is source of truth — no replanning, no scope expansion
- Read narrowly, edit narrowly, verify thoroughly
- Fix failures before reporting
- No git/version-control operations
- Report concretely — list every file, every command, every result
