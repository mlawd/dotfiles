---
name: code-review
description: Review code changes on a branch for correctness, security, performance, and quality. Produce a structured report with a verdict. Designed to run in clean, isolated context to give fresh eyes on changes.
consumer: reviewer subagent (read-only permissions; can run git diff/log/show)
calibration: strong-reasoning models
---

# Code Review

Review code changes for correctness, security, performance, and quality. Produce a structured report with a verdict.

This skill works best when invoked in clean, isolated context — you have no knowledge of the implementation conversation, which is intentional. Your fresh perspective catches issues the implementer may have become blind to.

## Process

### 1. Understand scope

- Run `git diff --stat` to see which files changed and how much
- Run `git diff` to read the full diff
- If a branch name is provided, diff against the base branch

### 2. Understand intent

- Read any ticket description, PR body, or commit messages provided in your prompt
- If none provided, infer intent from code changes and file names

### 3. Read surrounding context

For each changed file:

- Read enough unchanged code to understand the module's purpose
- Check imports, types, and related test files
- Note existing patterns and conventions

### 4. Review against the checklist

Evaluate every change against each category below.

### 5. Produce the structured report

Return findings in the format specified at the bottom of this skill.

## Review categories

### Correctness

- Does the code do what the ticket/description asks for?
- Are edge cases handled (nulls, empty collections, boundary values)?
- Are error paths handled gracefully — no swallowed exceptions?
- Is state managed correctly (race conditions, stale closures, mutations)?

### Security

- No hardcoded secrets, API keys, or credentials
- Input validation and sanitisation where needed
- Protection against injection (SQL, XSS, command injection)
- Auth/authz checks present where required
- Sensitive data not logged or exposed in error messages

### Performance

- No unnecessary computation inside loops or hot paths
- Appropriate data structures and algorithms
- Database queries are efficient (no N+1, proper indexing considered)
- No unbounded growth (memory leaks, uncapped collections)
- Large operations are paginated or streamed where appropriate

### Code quality

- Follows existing project conventions and patterns
- Functions are focused — single responsibility
- Naming is clear and consistent with the codebase
- No dead code, commented-out blocks, or TODO debris
- DRY — no unnecessary duplication
- Appropriate abstractions (not too much, not too little)

### Testing

- New/changed behaviour has corresponding tests
- Tests cover the happy path AND meaningful edge cases
- Tests are deterministic (no flaky timing, no external dependencies)
- Test names describe the scenario, not the implementation
- Mocking is minimal and appropriate

### Documentation

- Public APIs have clear doc comments
- Complex logic has inline comments explaining why, not what
- README or docs updated if behaviour changed for consumers

## Output format

```
## Review summary
[1-3 sentence overall assessment: is this ready to merge, or does it need work?]

## Findings

### CRITICAL (must fix before merge)
- [file:line] Description of the issue
  **Why:** Explanation of impact
  **Suggested fix:** Concrete suggestion

### WARNING (should fix)
- [file:line] Description of the issue
  **Why:** Explanation of impact
  **Suggested fix:** Concrete suggestion

### SUGGESTION (consider improving)
- [file:line] Description of the suggestion
  **Why:** How this would improve the code

### WHAT LOOKS GOOD
- [Optional brief notes on what was done well]

## Verdict
[ APPROVE | REQUEST_CHANGES ]
[If REQUEST_CHANGES, list the specific items that must be addressed]
```

## Rules

- Be specific. Always reference file names and line numbers.
- Be constructive. Every criticism must include a suggested fix.
- Be honest. Do not rubber-stamp — if there are problems, say so.
- Be proportionate. Don't nitpick formatting if there's a security hole.
- Distinguish between blocking issues and stylistic preferences.
- If the diff is clean and you have no findings, say so — a short "APPROVE" with brief positive notes is a perfectly valid review.
