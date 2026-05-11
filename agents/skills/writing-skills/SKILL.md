---
name: writing-skills
description: How to write, edit, or verify skill files. Use when creating a new skill, modifying an existing one, or checking a skill for portability and consistency.
consumer: any agent editing skill files
calibration: strong-reasoning models
---

# Writing Skills

Skills are markdown files that codify reusable workflows. They live in `skills/<name>/SKILL.md` and are loaded on-demand.

## Skill anatomy

Every skill follows this structure:

- YAML frontmatter with `name`, `description`, `consumer`, `calibration`
- Title (h1) matching or extending the skill name
- One-paragraph summary of what the skill does and when to use it
- `## When to invoke` section listing specific triggers
- `## Process` section (numbered or sectioned workflow)
- `## Composition` section (optional) — how this skill interacts with others
- `## Rules` section — non-negotiable constraints as imperative bullets

## Writing principles

### 1. Capability-first prose

Refer to tools by capability, not specific names:

- "Use your file-read tool" — not "Use the Read tool"
- "Run the verification commands" — not "Run Bash with `npm test`"
- "Dispatch a subagent" — not "Use the Task tool"

This keeps skills portable across harnesses.

### 2. Calibrated detail

- Strong-reasoning consumers: terse, principle-based content
- Lighter-reasoning consumers: explicit procedural rails, anti-drift guards
- Note the calibration in frontmatter

### 3. Self-contained

A skill should be readable without loading other files. If another skill is required, name it explicitly with a "follow the X skill" reference rather than embedding its content.

### 4. No artifacts unless asked

Skills should not write files, commit code, or persist anything by default. Their output is in-conversation behaviour.

### 5. Prescriptive Rules section

Every skill ends with a Rules section: 3-7 bullet points stating non-negotiable constraints. Use imperatives. No hedging.

## Checklist for a new skill

Before considering a skill done:

- [ ] Frontmatter complete (name, description, consumer, calibration)
- [ ] Title and one-paragraph summary
- [ ] Clear "When to invoke" section
- [ ] Numbered process or sectioned workflow
- [ ] No harness-specific tool names in body prose
- [ ] No slash commands referenced
- [ ] No absolute paths
- [ ] References to other skills use skill names (no file paths)
- [ ] Rules section with imperative bullet points
- [ ] No artifacts produced by default
- [ ] Skill is testable: a reader can tell what success looks like

## Anti-patterns

- **Wall of text** — break content into sections with headers
- **Vague rules** — "be careful" is not a rule; "fix failures before reporting" is
- **Tool-name lock-in** — referencing `TodoWrite` makes the skill harness-specific
- **Implicit dependencies** — naming another skill without saying "follow it" is ambiguous
- **Aspirational without enforcement** — describing ideal behaviour with no triggers
- **Duplicating other skills** — if you find yourself rewriting another skill's content, reference it instead

## When editing existing skills

- Preserve the existing structure unless explicitly restructuring
- Verify references from other skills still work (grep for the skill name in other SKILL.md files)
- Update frontmatter if consumer or calibration changes

## Rules

- Every skill needs frontmatter, summary, process, and rules sections
- Capability-first prose; no harness-specific tool names
- Self-contained; compose by reference
- No artifacts by default
- Rules section uses imperatives, not suggestions
- Verify references when editing
