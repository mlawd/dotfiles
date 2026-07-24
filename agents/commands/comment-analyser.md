---
name: comment-analyser
description: Analyse comments associated with a Graphite Stack
---

Run this command from the normal primary/orchestrator flow. Do not assign the
whole command to a fixed subagent in frontmatter.

Workflow:

1. Start a subagent whose only job is to load and follow the
   `comment-analyser` skill.
   - The subagent analyses unresolved PR review comments across the current
     Graphite stack.
   - It categorises each unresolved thread as **needs fix** or **dismiss** and
     proposes an action.
   - It must not edit files, resolve/dismiss comments, run mutating commands,
     commit, amend, submit, or otherwise implement changes.
2. Present the subagent's findings to the user, including the proposed action
   for each unresolved thread.
3. Stop for confirmation. Do not proceed until the user explicitly approves the
   proposed fixes/dismissals.
4. After confirmation, continue with the normal subagent-driven development
   process for the approved fixes: plan lanes, delegate implementation to the
   appropriate specialists, verify the result, and report back.
