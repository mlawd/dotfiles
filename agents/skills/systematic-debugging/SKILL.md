---
name: systematic-debugging
description: When encountering a bug, test failure, or unexpected behaviour, work through it systematically before proposing fixes. Reproduce, isolate, understand, then fix.
consumer: any agent encountering a bug or failure
calibration: all model tiers; especially important for lighter-reasoning implementers
---

# Systematic Debugging

When something doesn't work the way you expected, work through it systematically. Don't pattern-match a fix from a vibe.

## When to invoke

- A test you expected to pass is failing
- A command returned an unexpected error
- Code behaviour differs from what the implementation says
- An implementation step is failing for unclear reasons

Skip for trivial typos with obvious fixes.

## Process

### 1. Reproduce

- Run the exact command that failed
- Capture the exact output (don't paraphrase the error)
- Confirm the failure is reproducible, not a flake

If you can't reproduce, the bug isn't actionable — stop and ask the user for more information.

### 2. Read the error carefully

- What is the actual error message, line by line?
- Where in the stack does it originate?
- What is the assertion (for test failures) — expected vs. actual?
- What does the surrounding output say (warnings, logs, setup messages)?

### 3. Form a specific hypothesis

State explicitly:
- What you think is happening
- Why you think that
- What evidence would confirm or refute it

A vague hypothesis ("something with the imports") isn't actionable. A specific hypothesis ("the import path uses `./foo` but the file is at `./bar/foo`") is.

### 4. Test the hypothesis

Pick the smallest change or check that would confirm or refute. Examples:
- Add a `console.log` / `print` to verify a value
- Read the file the error points to
- Run a smaller subset of the failing test
- Check the actual filesystem state vs. assumed state

### 5. Fix only after the hypothesis is confirmed

- Make the minimal change that fixes the confirmed cause
- Re-run the original failing command
- Confirm the failure is gone AND no new failures appeared

### 6. Verify nothing else broke

Run the broader verification (full test suite, lint, type-check) to ensure the fix didn't break adjacent code.

## Anti-patterns

- **Pattern-matching a fix** — "this looks like that other bug, let me try the same fix" without verifying it's the same root cause
- **Trying random changes** — flailing without a hypothesis is wasted time
- **Fixing the symptom, not the cause** — making the test pass without understanding why it failed
- **Silencing errors** — catching and swallowing without understanding what was wrong
- **Assuming the framework is broken** — it's almost always your code

## Stuck?

If 3 hypotheses in a row are wrong, stop and:
- Re-read the error message from scratch
- Re-read the code involved from scratch
- Consider whether your mental model of how the system works is wrong
- Ask for help with a complete reproduction case

## Rules

- Reproduce before debugging
- Read errors carefully — every line
- One specific hypothesis at a time
- Verify the hypothesis before fixing
- Fix the cause, not the symptom
- Re-verify after fixing
