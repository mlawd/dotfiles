---
name: comment-analyser
description:
  Use when analysing unresolved PR review comments on the current pull request.
  Detects the PR for the current branch, loads unresolved review threads,
  analyses each comment for correctness and impact, and categorises it as
  "needs fix" or "dismiss" with a proposed action. Analyses only -- never
  implements.
---

# Comment Analyser

Analyse unresolved PR review comments on the current pull request and produce a
breakdown that categorises each thread as **needs fix** or **dismiss**, with a
proposed action for each.

This skill only analyses. It does not implement fixes, post replies, or resolve
threads.

## Phase 1: Discover the current PR

Identify the pull request for the currently checked-out branch:

```bash
gh pr view --json number,title,headRefName,url
gh repo view --json owner,name
```

If `gh pr view` cannot find a PR for the current branch, stop and explain that
there is no current PR to analyse.

Do not discover, traverse, or analyse the Graphite stack. This skill is scoped
to the current PR only.

## Phase 2: Load unresolved comments

For the current PR, fetch review threads:

```bash
gh api graphql -f query='
  query($owner: String!, $repo: String!, $number: Int!) {
    repository(owner: $owner, name: $repo) {
      pullRequest(number: $number) {
        reviewThreads(first: 100) {
          nodes {
            id
            isResolved
            path
            line
            comments(first: 50) {
              nodes {
                id
                body
                author { login }
                createdAt
              }
            }
          }
        }
      }
    }
  }
' -f owner='{owner}' -f repo='{repo}' -F number={pr_number}
```

Filter to only unresolved threads (`isResolved: false`).

## Phase 3: Analyse

For each unresolved thread:

- Read the referenced file and surrounding code to understand context.
- Analyse the comment for correctness and impact.
- Consider only the current PR and local working tree. Do not assume a comment
  will be addressed by an upstack or downstack branch.

Categorise each thread as one of:

- **Needs fix** -- a code change is required. Describe what the fix should be and
  which files need to change.
- **Dismiss** -- the comment doesn't warrant a code change. Prepare a reply
  explaining why.

## Phase 4: Present output

Present findings for the current PR. List every unresolved thread with:

- **Thread ID** -- the GraphQL node ID (from `reviewThreads.nodes[].id`)
- **File and line** -- where the comment lives
- **Comment summary** -- what the reviewer asked for
- **Category** -- `needs fix` or `dismiss`
- **Action** -- for fixes: description of the change; for dismissals: the prepared
  reply text

Example format:

```
### Current PR: `feat/sc-1234/add-auth` (PR #42)

1. **Thread** `PRT_abc123` | `src/auth.ts:45`
   Reviewer asked for input validation on the token parameter.
   **Category:** needs fix
   **Fix:** Add zod validation for the token string before passing to verify().

2. **Thread** `PRT_def456` | `src/auth.ts:12`
   Reviewer suggested using a constant for the header name.
   **Category:** dismiss
   **Reply:** This header name is only used once and is already descriptive.
   Extracting to a constant would add indirection without benefit.
```

## Phase 5: Confirm

Before anything is implemented, check with the human for confirmation or ask if
something should be done differently. The human may:

- Reclassify a thread (fix <-> dismiss)
- Adjust a proposed fix or reply
- Add context that changes the analysis

**Do not proceed to implementation.** This skill only analyses.
