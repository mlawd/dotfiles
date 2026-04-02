---
name: comment-resolver
description: Implement fixes and resolve comments across a Graphite stack using output from comment-analyser
agent: build
---

# /comment-resolver -- Implement fixes across a stack

Takes the output from `/comment-analyser` and works through the stack
bottom-to-top, implementing code fixes, posting replies to dismissed
comments, resolving threads, and submitting the updated stack.

---

## Phase 1: Parse input

The comment-analyser output contains a per-branch breakdown of
unresolved PR comments. Each comment falls into one of two categories:

- **Needs fix** -- a code change is required. The analyser will have
  described what the fix should be.
- **Dismiss** -- the comment doesn't warrant a code change. The
  analyser will have prepared a reply explaining why.

Parse this output and build a work plan: an ordered list of branches
(bottom of stack first) with the actions for each.

Present the work plan to the user and **wait for confirmation before
proceeding**.

---

## Phase 2: Confirm stack state

Before making changes, verify the stack is clean:

```
gt log short
git status
```

If there are uncommitted changes, stop and ask the user what to do.
If the stack structure doesn't match the analyser output, stop and
flag the discrepancy.

---

## Phase 3: Implement (loop per branch, bottom-to-top)

Navigate to the bottom branch that has action items:

```
gt checkout {branch-name}
```

For each branch with actions, execute steps 3a through 3f.

### 3a. Implement code fixes

For each "needs fix" comment on this branch, make the code change.
Follow the conventions in the repo's `CLAUDE.md` and `AGENTS.md`.

If multiple fixes touch the same file, apply them all before moving
to verification.

### 3b. Run verification

Run the project's test, lint, and build commands. Check `package.json`
for the exact scripts. Common patterns:

```
npm test
npm run lint
npm run build
npm run format:check
```

**If tests fail:** Fix the failing tests, then re-run. Cap at 3
attempts per branch -- if still failing, stop and escalate to the
user.

**If lint fails:** Run the auto-fixer (`npm run lint -- --fix` or
`npm run format`) and verify again.

### 3c. Amend the branch

Stage all changes and amend to keep a clean single commit:

```
gt modify --all --no-interactive
```

### 3d. Reply to and resolve dismissed comments

For each "dismiss" comment on this branch:

1. **Post the reply** using the `gh` CLI:

```bash
gh api graphql -f query='
  mutation($threadId: ID!, $body: String!) {
    addPullRequestReviewThreadReply(input: {
      pullRequestReviewThreadId: $threadId,
      body: $body
    }) { comment { id } }
  }
' -f threadId="{THREAD_NODE_ID}" -f body="{PREPARED_REPLY}"
```

2. **Resolve the thread:**

```bash
gh api graphql -f query='
  mutation($threadId: ID!) {
    resolveReviewThread(input: { threadId: $threadId }) {
      thread { id isResolved }
    }
  }
' -f threadId="{THREAD_NODE_ID}"
```

If a `gh` call fails, warn the user but continue -- comment
resolution is non-blocking.

### 3e. Show progress

Log what was done on this branch:
- Which comments were fixed (with a one-line summary of each change)
- Which comments were replied to and resolved
- Verification result (pass/fail)

### 3f. Move to next branch

```
gt up
```

Repeat from 3a for the next branch with action items.
Skip branches that have no actions.

---

## Phase 4: Restack and verify

After all branches have been modified, restack to propagate changes
from lower branches into upper ones:

```
gt restack --no-interactive
```

If restack introduces merge conflicts, stop and ask the user for
guidance.

After restacking, check out the top branch of the stack and run
verification one final time to confirm nothing broke:

```
npm test
npm run lint
npm run build
```

If the final verification fails, identify which restack-introduced
change caused the failure and fix it, then `gt modify --all --no-interactive`
on the affected branch.

---

## Phase 5: Submit

Push the entire stack in one go:

```
gt submit --stack --no-interactive --no-edit
```

---

## Phase 6: Summary

Present a completion summary:

```
## Comment resolution complete

**Branches modified:** {N}
**Comments fixed:** {N}
**Comments dismissed (replied + resolved):** {N}

### Per-branch breakdown:
1. `{branch-name}` -- {N} fixed, {N} dismissed
   - Fixed: {one-line summary of each fix}
   - Dismissed: {one-line summary of each reply}
2. ...

All tests passing. Stack submitted.
```

---

## Error handling

- **Test failures after 3 attempts:** Stop and present the failure
  to the user with context about what was tried.
- **Restack conflicts:** Stop and ask the user for guidance. Suggest
  manual conflict resolution then `gt restack --continue`.
- **`gt` command failures:** Show the error output and ask the user
  for guidance.
- **`gh` command failures:** Warn but continue. Track which comments
  could not be replied to or resolved and include them in the summary.
- **Stack mismatch:** If the current stack doesn't match the analyser
  output, stop immediately and flag it.
