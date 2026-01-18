---
name: commit-changes
description: Create conventional, one-line commits from current git changes, splitting related updates into separate commits.
compatibility: opencode
metadata:
  workflow: git
---

## What I do
- Inspect the repo state with `git status`, `git diff`, and recent `git log`
- Group related changes and create separate commits per group
- Ensure each commit message is unique, one line, and conventional

## Commit rules
- Use Conventional Commits: `feat:`, `fix:`, `docs:`, `refactor:`, `test:`, `chore:`
- Scope is optional: `feat(scope):` when helpful
- One-line messages only (no body)
- Never mix unrelated changes in the same commit
- Skip secrets or sensitive files (e.g., `.env`)

## How I work
1. Review unstaged and staged changes.
2. Propose commit grouping by related files/intent.
3. Stage each group and commit with a one-line Conventional Commit.
4. Repeat until all relevant changes are committed.
5. Show `git status` at the end and summarize commits.

## When to use me

Use this when you are ready to commit changes in your git repository and want to ensure a clean, organized commit history.
