---
name: merge-github-prs
description: "Merge one or more GitHub pull requests, especially when the user wants to merge multiple PRs in one batch. Use when Claude needs to inspect PR relationships, squash-merge by default, retry with --admin only when GitHub requires it, resolve conflicts against main or another base branch, and retarget or refresh dependent open PRs after earlier merges."
---

# Merge GitHub PRs

Merge GitHub pull requests safely with `gh` and `git`. Default to squash merges, understand each PR before changing code, and keep the remaining open PRs mergeable after every merge.

## Workflow

1. Gather context for every requested PR and the repository default branch.
2. Determine whether the PRs are independent or stacked.
3. Merge in dependency order with `--squash` first.
4. If GitHub reports conflicts, update the PR branch locally, resolve conflicts semantically, push, and retry.
5. After each merge, inspect remaining open PRs that depend on the merged branch and retarget or refresh them.

## Gather Context First

Use GitHub CLI for repository and PR state. For multiple PRs, gather metadata in parallel when possible.

```bash
gh repo view --json defaultBranchRef,nameWithOwner
gh pr view <pr> --json number,title,body,state,isDraft,baseRefName,headRefName,mergeStateStatus,reviewDecision,statusCheckRollup
gh pr diff <pr>
gh pr list --state open --json number,title,baseRefName,headRefName,isDraft
```

Always read the title, body, and diff before resolving conflicts. Preserve the intent of the PR, not just the text around the conflict markers.

## Determine Merge Order

- If `baseRefName` is the default branch, the PR can usually merge directly.
- If `baseRefName` matches another requested PR's `headRefName`, treat the set as stacked. Merge the base PR first.
- If a requested PR depends on an open branch that is not part of the request, stop and confirm whether that dependency should merge first.
- When order is still ambiguous, prefer the most foundational PR first: shared types, schema, or refactors before consumers.

## Default Merge Strategy

Attempt every PR with squash merge first.

```bash
gh pr merge <pr> --squash
```

Do not switch to `--merge` or `--rebase` unless the user explicitly asks.

Use `--admin` only after a normal squash merge fails and GitHub indicates admin privileges are required to complete the merge. Do not use `--admin` blindly to bypass failing checks or missing review requirements. If admin mode would override review or CI policy rather than just satisfy repository rules, surface the risk and confirm before bypassing it.

If a PR is already merged, confirm it and move on. If a PR is draft, blocked for unresolved review work, or has failing checks that should not be bypassed, stop and report the blocker.

## Resolve Merge Conflicts

When `mergeStateStatus` is `DIRTY` or `gh pr merge` reports conflicts:

1. Check out the PR branch locally.

```bash
gh pr checkout <pr>
git fetch origin
```

2. Merge the latest base branch into the PR branch.

```bash
git merge origin/<base-branch>
```

Prefer merging over rebasing for shared PR branches unless the repo clearly uses rebases.

3. Read each conflicted file and the PR diff before editing.
4. Resolve conflicts semantically:
- Keep both sides when the changes are compatible.
- Keep the new base-branch structure when the PR only needs adaptation.
- Keep the PR behavior when that behavior is the reason the branch exists.
5. Run the narrowest relevant validation that covers the conflict.
6. Commit the conflict resolution and push the branch.
7. Retry the squash merge.

```bash
gh pr merge <pr> --squash
```

8. If GitHub still requires admin to finish, retry with:

```bash
gh pr merge <pr> --squash --admin
```

## Handle Multiple Open PRs

After merging one PR, inspect the remaining open PRs again. Look for branches whose `baseRefName` or expected merge base changed because of the merge.

### Parallel PRs Against Main

If several PRs target `main` and one merge causes conflicts in the next PR, update the remaining PR branch by merging `origin/main` into it, resolve conflicts, push, and retry the merge.

### Stacked PRs

If PR B targets PR A's branch and PR A is merged:

- Retarget PR B to the default branch when it now stands on its own.

```bash
gh pr edit <pr-b> --base <default-branch>
```

- Update PR B's branch with the latest default branch.
- Resolve conflicts.
- Verify the PR diff now contains only PR B's intended changes.

Use `gh pr diff <pr>` after retargeting to confirm the stack collapsed correctly.

## Safety Rules

- Determine dependencies before merging anything.
- Do not resolve conflicts mechanically with `ours` or `theirs` unless the desired behavior is obvious and narrow.
- Do not use `--admin` as the first merge attempt.
- Do not leave remaining open PRs pointing at stale branches when a merged PR was their base.
- Prefer the smallest necessary branch updates to keep history understandable.

## Reference

Read [references/conflict-playbook.md](references/conflict-playbook.md) when merge conflicts involve stacked PRs, retargeting, or already-open PRs that need cleanup after earlier merges.
