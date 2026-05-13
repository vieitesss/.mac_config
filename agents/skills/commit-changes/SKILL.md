---
name: commit-changes
description: Create conventional, one-line commits from current git changes, splitting work into the smallest sensible atomic commits.
compatibility: opencode
metadata:
  workflow: git
---

## What I do
Inspect repo state, split changes into the smallest atomic groups by intent, and commit each group with a one-line Conventional Commit message.

## Rules
- Conventional Commits: `feat:`, `fix:`, `docs:`, `refactor:`, `test:`, `chore:` — scope optional
- One logical change per commit; never mix unrelated changes
- Split independent fixes, features, docs, tests, refactors — combine only when tightly coupled
- One-line messages ONLY (no body)
- Do NOT add yourself as co-author
- Skip secrets/sensitive files (e.g., `.env`)

## Workflow
1. Run `git status`, `git diff`, recent `git log`
2. Identify smallest safe atomic groups
3. Stage each group and commit
4. Repeat until all relevant changes are committed
5. Show `git status` and summarize commits
