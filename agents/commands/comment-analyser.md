---
name: comment-analyser
description: Analyse comments associated with a Graphite Stack
agent: oracle
subtask: true
---

Load and follow the `comment-analyser` skill to analyse unresolved PR review
comments across the current Graphite stack.

This command only analyses -- it categorises each unresolved thread as **needs
fix** or **dismiss** and proposes an action, then stops for confirmation. Use the
`comment-resolver` command to implement the result.
