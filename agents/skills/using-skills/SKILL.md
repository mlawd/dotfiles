---
name: using-skills
description: Entry-point skill that establishes how to find and use skills. Invoke at conversation start. Skills are loaded on-demand when a task matches their description.
consumer: any agent that has access to skills
calibration: all model tiers
---

# Using Skills

Skills are reusable workflows that codify how to do specific things well. Load them on-demand when a task matches.

## The rule

At the start of every conversation, scan your available skills. When a task could match a skill's description — even at 1% probability — invoke that skill before acting.

## When to invoke a skill

| Task type | Skills likely to apply |
| --- | --- |
| New feature or behaviour change | `brainstorming`, then `planning`, then `implementation` |
| Bug fix | `systematic-debugging`, then `implementation` |
| Plan from a ticket | `exploring`, `brainstorming`, `planning` |
| Execute a phase | `implementation` |
| Review a branch | `code-review` |
| About to claim "done" | `verification-before-completion` |
| Multi-PR feature | `orchestrating-stacked-prs` |
| Writing or editing a skill | `writing-skills` |

## Priority order

When multiple skills could apply:

1. **Process skills first** (brainstorming, debugging) — these determine HOW to approach the task
2. **Workflow skills next** (planning, orchestrating-stacked-prs) — these structure the WORK
3. **Implementation skills last** (implementation, code-review) — these EXECUTE

Example: "Let's build X" → brainstorming first, then planning, then implementation.

## Composition by reference

Skills reference other skills by name in prose. When a skill says "follow the X skill," load X via the skill tool and follow it. This is composition, not import — each skill is self-contained but expects others to exist in the environment.

## Red flags

If you catch yourself thinking these, STOP and check for a relevant skill:

| Thought | Action |
| --- | --- |
| "This is too simple to need a skill" | Check anyway |
| "Let me just explore first" | Skills tell you how to explore |
| "I'll skip the formal process" | Use the skill or explicitly note why |
| "I remember this skill" | Skills change; re-read it |

## User instructions override skills

If the user explicitly says "skip X" or "do Y directly," follow the user. Skills set defaults; user instructions are authoritative.

## Rules

- Check for relevant skills before acting on any task
- Invoke skills via the skill tool — don't paraphrase from memory
- Compose by reference — load referenced skills as needed
- User instructions override skill defaults
