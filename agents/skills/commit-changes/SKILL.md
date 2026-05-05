---
name: commit-changes
description: Create conventional, one-line commits from current git changes, splitting work into the smallest sensible atomic commits.
compatibility: opencode
metadata:
  workflow: git
---

## What I do
- Inspect the repo state with `git status`, `git diff`, and recent `git log`
- Split changes into the smallest correct commit groups possible
- Prefer multiple focused commits over one broad commit whenever the changes can be separated cleanly
- Group only changes that share one intent, one fix, or one feature slice
- Ensure each commit message is unique, one line, and conventional

## Commit rules
- Use Conventional Commits: `feat:`, `fix:`, `docs:`, `refactor:`, `test:`, `chore:`
- Scope is optional: `feat(scope):` when helpful
- One-line messages only (no body)
- Never mix unrelated changes in the same commit
- Do not bundle loosely related edits just to reduce commit count
- If two changes can be committed separately without creating partial or broken history, split them
- Default to splitting by file intent, feature slice, or bug fix unless doing so would make a commit meaningless
- Skip secrets or sensitive files (e.g., `.env`)

## How I work
1. Review unstaged and staged changes.
2. Identify the smallest safe atomic groups first, then widen a group only if a split would be artificial or incomplete.
3. Propose commit grouping by intent, preferring more commits when each commit stays coherent on its own.
4. Stage each group and commit with a one-line Conventional Commit.
5. Repeat until all relevant changes are committed.
6. Show `git status` at the end and summarize commits.

## Grouping priority
1. One logical change per commit.
2. Separate independent fixes, features, docs, tests, and refactors.
3. Separate code changes from test-only or docs-only changes when practical.
4. Split large mixed changes into smaller commits even if they touch nearby files.
5. Only combine groups when they are tightly coupled and would be awkward or misleading on their own.

## When to use me

Use this when you are ready to commit changes in your git repository and want to ensure a clean, organized commit history.

# REALLY IMPORTANT:
- Do NOT add yourself as a co-author
