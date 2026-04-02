---
name: comment-analyser
description: Analyse comments associated with a Graphite Stack
agent: plan
subtask: true
---

## Phase 1: Discover the stack

Run `gt log short` to ascertain which branches are in the current
stack. For each branch, run `gh pr list --head {branch} --json number`
to get the PR number.

## Phase 2: Load unresolved comments

For each PR in the stack (bottom-to-top), fetch review threads:

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
- Consider the whole stack -- a comment on one branch may be addressed
  by changes in another branch.

Categorise each thread as one of:

- **Needs fix** -- a code change is required. Describe what the fix
  should be and which files need to change.
- **Dismiss** -- the comment doesn't warrant a code change. Prepare a
  reply explaining why.

## Phase 4: Present output

Present findings grouped by branch (bottom of stack first). For each
branch, list every unresolved thread with:

- **Thread ID** -- the GraphQL node ID (from `reviewThreads.nodes[].id`)
- **File and line** -- where the comment lives
- **Comment summary** -- what the reviewer asked for
- **Category** -- `needs fix` or `dismiss`
- **Action** -- for fixes: description of the change; for dismissals:
  the prepared reply text

Example format:

```
### `feat/sc-1234/1-add-auth` (PR #42)

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

Before anything is implemented, check with the human for confirmation
or ask if something should be done differently. The human may:

- Reclassify a thread (fix <-> dismiss)
- Adjust a proposed fix or reply
- Add context that changes the analysis

**Do not proceed to implementation.** This command only analyses.
The `/comment-resolver` command handles implementation.
