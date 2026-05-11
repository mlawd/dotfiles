---
name: test-driven-development
description: Write tests before implementation. Red-Green-Refactor cycle. Use when implementing features or fixing bugs to ensure tests actually cover the new behaviour.
consumer: implementer subagent or any agent writing code
calibration: all model tiers
---

# Test-Driven Development

Write the test before the implementation. Watch it fail. Make it pass. Refactor. Repeat.

## When to invoke

- Implementing a new feature with observable behaviour
- Fixing a bug (write a regression test that fails, then fix)
- Adding a function with a clear contract

Skip when:
- The change has no observable behaviour to test (e.g., pure refactor with no API change)
- The codebase explicitly prohibits new test coverage for the change

## The cycle

### Red: Write a failing test

- Write a test that describes the desired behaviour
- The test must fail for the right reason — usually "function does not exist" or "behaviour does not yet match"
- Run the test and observe the failure. Confirm the failure message is what you expect.

If the test passes immediately, the test is wrong — it isn't actually testing the new behaviour. Fix the test before continuing.

### Green: Make it pass

- Write the minimum code needed to make the test pass
- Do not add code that isn't required by the current test
- Run the test, confirm it passes
- Run the full test suite, confirm nothing else broke

### Refactor: Clean up

- Improve the implementation without changing behaviour
- Run the full test suite after each refactoring step
- Stop when the code is clean enough for the current iteration

### Repeat

Move to the next behaviour. Write the next failing test.

## What makes a good test

- **Describes behaviour, not implementation** — "returns 404 when user not found", not "calls userRepo.findById"
- **Has one clear assertion** — multiple assertions per test obscure what failed
- **Has a meaningful name** — reading the test name should tell you what it does
- **Doesn't depend on other tests** — order independence is mandatory
- **Doesn't depend on external systems** — mock or stub at the edges

## Composition

- Use `systematic-debugging` when a test fails unexpectedly during Green
- Use `verification-before-completion` before claiming the feature done

## Rules

- Test first; implementation second
- Watch the test fail before making it pass
- One behaviour per test
- Minimum code to pass; refactor after green
- Full suite green before moving on
