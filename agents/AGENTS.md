# OpenCode Instructions

## Brainstorming

Before planning or implementation, use the `brainstorm` skill to clarify intent,
scope, constraints, and success criteria.

Do not skip brainstorming unless the user explicitly opts out or the task is
purely mechanical, such as formatting, renaming, or applying an already-approved
change.

## Planning

**NEVER** start implementation without first confirming the plan.

## Diff Discipline

Preserve the existing style and structure of code that is not functionally changed.
Do not remove or add blank lines, braces, comments, or reorder expressions merely
for preference. Do not rename unaffected variables or perform opportunistic cleanup.
Keep diffs limited to changes required by the task unless the user explicitly asks
for formatting, cleanup, or refactoring.

## Confirmation Gates

If any subagent, tool result, command output, or prior instruction says “Stop here for confirmation”, “await confirmation”, “do not proceed without confirmation”, or equivalent, treat it as a hard gate.

At a hard gate:

- You may summarize findings, explain options, or restate the proposed next step.
- You must not edit files, run mutating commands, commit/amend/submit, resolve/dismiss comments, create/delete resources, or otherwise implement the proposed action.
- Ambiguous wording like “continue”, “go on”, “carry on”, or “summarize and continue” means continue analysis/explanation only. It is not implementation approval.
- Proceed past the gate only after explicit approval to act, such as “yes, implement”, “apply the plan”, “make the changes”, “resolve the comments”, or an equivalent unambiguous instruction.

## Branching

Use this branch naming format:

`{feat|fix|chore}/{ticket_id}/{brief_description}`

Rules:

- Use `feat` for new functionality.
- Use `fix` for bug fixes.
- Use `chore` for maintenance, refactors, tooling, or documentation.
- Use the ticket ID exactly as provided.
- Use a short lowercase hyphenated description.

<!-- codebase-memory-mcp:start -->
# Codebase Knowledge Graph (codebase-memory-mcp)

This project uses codebase-memory-mcp to maintain a knowledge graph of the codebase.
ALWAYS prefer MCP graph tools over grep/glob/file-search for code discovery.

## Priority Order
1. `search_graph` — find functions, classes, routes, variables by pattern
2. `trace_path` — trace who calls a function or what it calls
3. `get_code_snippet` — read specific function/class source code
4. `query_graph` — run Cypher queries for complex patterns
5. `get_architecture` — high-level project summary

## When to fall back to grep/glob
- Searching for string literals, error messages, config values
- Searching non-code files (Dockerfiles, shell scripts, configs)
- When MCP tools return insufficient results

## Examples
- Find a handler: `search_graph(name_pattern=".*OrderHandler.*")`
- Who calls it: `trace_path(function_name="OrderHandler", direction="inbound")`
- Read source: `get_code_snippet(qualified_name="pkg/orders.OrderHandler")`
<!-- codebase-memory-mcp:end -->
