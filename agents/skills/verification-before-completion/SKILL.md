---
name: verification-before-completion
description: Before claiming work is complete, fixed, or passing, run verification commands and confirm output. Evidence before assertions, always.
consumer: any agent about to claim completion
calibration: all model tiers
---

# Verification Before Completion

Before you claim work is done, fixed, or passing, you must run verification commands and confirm the output. Evidence before assertions, always.

## When to invoke

Right before:
- Reporting "implementation complete"
- Reporting "all tests pass"
- Reporting "the bug is fixed"
- Committing changes
- Creating a PR
- Marking a todo as complete

If you're about to use words like "done", "complete", "passing", "fixed", "working" — invoke this skill first.

## The rule

You may not claim success without running the verification command that proves it, in this turn, and seeing the output.

Past success doesn't count. Code review doesn't count. "It looks right" doesn't count.

## Process

### 1. List what needs verifying

For the work in question, write down (mentally or in your todo tool):
- Each test command that should pass
- Each lint/format/type-check command
- Each build/compile command
- Any other observable outcome ("the file exists", "the function returns X")

### 2. Run each one

Execute the commands in this turn. Read the actual output. Confirm:
- Exit code is success
- No silent failures (e.g., test framework reports 0 tests run)
- No warnings that should be errors
- Output matches expectation

### 3. Claim only what you verified

- If a command passed, you can claim it passed
- If you didn't run a command, you cannot claim it passed
- If you ran a command and it failed, you must fix and re-run before claiming success

## Red flags — STOP if you catch yourself thinking these

| Thought | Reality |
| --- | --- |
| "Tests probably pass" | Run them |
| "I'll verify in the next turn" | No, now |
| "The change is small enough that..." | Small changes break things too |
| "The build worked last time" | Last time was last time |
| "I can see the code is correct" | Reading isn't running |
| "The test framework would have caught it" | Only if you ran it |

## Composition

This skill is invoked BY other skills, not independently:
- `implementation` invokes this before reporting
- `orchestrating-stacked-prs` invokes this before final summary
- Direct user requests for "is this done?" should also invoke this

## Rules

- No claims of success without observed evidence in the current turn
- Run verification commands; do not infer from code review
- If you can't run verification (e.g., no relevant command), say so explicitly rather than claim
- Failures must be fixed and re-verified, not noted-and-ignored
