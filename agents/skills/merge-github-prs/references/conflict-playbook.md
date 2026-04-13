# Conflict Playbook

Read this file when the main workflow is not enough and you need detailed guidance for stacked PRs, branch retargeting, or conflicts that ripple into other open PRs.

## Quick Commands

```bash
gh repo view --json defaultBranchRef,nameWithOwner
gh pr list --state open --json number,title,baseRefName,headRefName,isDraft
gh pr view <pr> --json number,title,body,baseRefName,headRefName,mergeStateStatus,reviewDecision,statusCheckRollup
gh pr diff <pr>
gh pr checkout <pr>
gh pr edit <pr> --base <branch>
git fetch origin
git merge origin/<base-branch>
git push
```

## Interpret PR State

- `CLEAN`: GitHub believes the PR can merge cleanly.
- `DIRTY`: The branch conflicts with its current base. Update the branch locally and resolve conflicts before retrying the merge.
- `BLOCKED`: The PR is blocked by policy, review state, or checks. Inspect the blocker before deciding whether `--admin` is appropriate.
- `UNKNOWN` or missing details: Re-run `gh pr view` after a short pause or after refreshing the branch state.

## Resolve Conflicts Semantically

Use this checklist before editing any conflict markers:

- Read the PR title and body.
- Read the PR diff, not just the conflicted file.
- Read the current base-branch version of the file.
- Identify whether the conflict came from a rename, file move, or surrounding refactor on the base branch.
- Preserve tests added on either side unless one side clearly supersedes the other.
- Prefer adapting the PR to the new structure instead of reverting recent base-branch cleanup.

Avoid blanket `ours` or `theirs` strategies for anything larger than a trivial generated file.

## Distinguish Parallel And Stacked PRs

Use `baseRefName` and `headRefName` to classify the relationship.

- Parallel PRs: several PRs target the default branch directly.
- Stacked PRs: one PR targets another feature branch instead of the default branch.

For stacked PRs, merge the lower layer first. After it lands, re-check every dependent PR because the best next action may be retargeting instead of more conflict resolution.

## Retarget A Dependent PR

Retarget a dependent PR after its base PR lands when the remaining branch now represents a standalone delta.

1. Confirm the old base branch has already merged or is no longer the correct comparison target.
2. Change the PR base branch.

```bash
gh pr edit <pr> --base <default-branch>
```

3. Check out the PR branch and merge the latest default branch into it.
4. Resolve conflicts.
5. Push the branch.
6. Re-run `gh pr diff <pr>` and verify the PR contains only its intended changes.

If the diff still includes changes that should have disappeared with the old base, stop and inspect the branch history before merging.

## Refresh Remaining Open PRs After Each Merge

After every successful merge:

1. Run `gh pr list --state open --json number,title,baseRefName,headRefName,isDraft` again.
2. Look for PRs whose base branch was just merged or deleted.
3. Update those PRs before merging the next one.
4. Prefer fixing the next PR in sequence immediately so the batch keeps moving.

This prevents the first merged PR from leaving the rest of the stack in a stale or misleading state.

## Decide Whether To Use --admin

Use `--admin` only after a normal squash merge fails.

Safe cases:

- GitHub requires admin privileges for the final merge action even though the PR is otherwise ready.
- The user explicitly asked to bypass a known administrative gate.

Escalate or confirm first:

- Required checks are failing.
- Required reviews are missing.
- The PR is draft.
- The policy violation changes the repository's normal review expectations.

When in doubt, explain what `--admin` would bypass before using it.
