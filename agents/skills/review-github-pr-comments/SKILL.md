---
name: review-github-pr-comments
description: Review GitHub pull request review summaries, inline review comments, and bot feedback, then decide whether each reviewer point should be fixed, rejected, deferred, or marked already handled based on the PR goal, current code, and repository conventions. Apply accepted reviewer suggestions when asked. Use when the user asks to review GitHub comments, PR reviewer feedback, CodeRabbit or Qodo comments, review summaries, or whether reviewer suggestions should be acted on.
---

# Review GitHub PR Comments

## Overview

Review GitHub PR feedback end to end. Fetch the latest review summaries and thread comments, understand the PR goal and current code, classify each reviewer point as fix, reject, defer, or already handled, and implement accepted comments when requested.

Refresh GitHub data at the start of every run. Review comments can change during PR development, and old thread text is often stale by the time the branch moves forward.

## Workflow

### 1. Identify the PR

- Use a PR number or URL from the user if one is provided.
- Otherwise infer the PR from the current branch.
- Stop and report the problem if there is no active PR.

Start with:

```bash
git branch --show-current
gh pr view --json number,url,title,body,baseRefName,headRefName
```

### 2. Understand the PR before judging comments

- Read the PR title and body to understand the intended outcome.
- Read the current diff against the base branch.
- Read commit messages on the branch to see how the implementation evolved.
- Read the affected files and nearby tests or related code before deciding whether a comment is correct.
- Check project conventions when they matter: lint rules, formatter config, contribution docs, test layout, and surrounding local patterns.

Use current code and current PR intent, not the original review snapshot, as the source of truth.

Helpful commands:

```bash
gh pr diff
git log $(gh pr view --json baseRefName --jq '.baseRefName')..HEAD --oneline
gh pr checks
```

### 3. Fetch review summaries and inline threads

- Gather both review summaries and review threads.
- If the user names specific reviewers or bots, filter to those authors.
- Otherwise include all reviewer feedback, including bots such as CodeRabbit, Qodo, Copilot, and human reviewers.
- Read the entire thread, not only the first comment. Later replies often narrow, update, or effectively withdraw the original concern.
- Prefer the latest reviewer-authored message in a thread when determining the current ask.
- Note whether the thread is resolved or outdated before treating it as actionable.

Use `references/github-queries.md` for GraphQL query templates when `gh pr view` is not enough.

### 4. Normalize the feedback into review points

- Collapse duplicate comments that point at the same issue.
- Split broad summaries into concrete review points when possible.
- Mark a point as `already handled` if the current branch already addresses it.
- Mark a point as `stale` if the code moved or later discussion made the original text obsolete.
- Mark a point as `out of scope` if it targets unrelated pre-existing code that should be handled separately.

### 5. Decide whether to fix, reject, defer, or mark handled

Evaluate every point against these questions:

- Does the comment describe a real bug, regression, correctness issue, security issue, or meaningful maintainability problem?
- Does it fit the PR goal, or would it pull the PR into unrelated work?
- Is it still true in the current code, or was it already fixed by later commits?
- Does the suggested direction match the repository's conventions and existing local patterns?
- Would applying it break behavior, tests, or the deliberate design of the PR?

Choose one decision per point:

- `fix`: The issue is valid and should be addressed in this PR.
- `reject`: The comment is wrong, stale, contradicted by the code, or conflicts with the PR goal or project conventions.
- `defer`: The comment is reasonable but belongs in follow-up work instead of this PR.
- `already handled`: The current branch already resolves the concern.

Reject comments when they are speculative, purely stylistic without local support, based on outdated code, or would expand the PR beyond its purpose.

### 6. Implement accepted comments when asked

- If the user asked only for review or triage, do not edit code.
- If the user asked to apply accepted feedback, convert each `fix` decision into a concrete code change and implement it.
- Re-read the relevant file sections before editing so the implementation matches the current code, not only the reviewer wording.
- Make the smallest correct change that addresses the review point without expanding the PR unnecessarily.
- If multiple accepted comments overlap, implement them together in one coherent change instead of stacking redundant edits.
- Add or update tests when the accepted comment changes behavior, fixes a bug, or closes a missing coverage gap.
- Do not perform unrelated refactors while implementing accepted comments.
- If implementation shows the reviewer comment was based on a misunderstanding, stop treating it as `fix`, change the decision, and explain why.
- Verify the accepted fixes with the most relevant checks available.
- Do not resolve GitHub threads unless the user explicitly asks for that action.

### 7. Report the result clearly

Use a concise structure like this:

```markdown
## PR Context
- Goal: ...
- Current branch state: ...

## Review Summaries
- Reviewer: summary

## Comment Decisions
- fix - reviewer - `path:line` - reason
- reject - reviewer - `path:line` - reason
- defer - reviewer - `path:line` - reason
- already handled - reviewer - `path:line` - reason

## Applied Changes
- `path`
  - accepted comment: ...
  - implementation: ...

## Verification
- `test command` - result
```

## Decision Rules

- Never decide from comment text alone; always inspect the current code and PR goal.
- Prefer the latest thread state over the oldest review text.
- Treat top-level review summaries as context, not as enough evidence by themselves.
- If the feedback is ambiguous, state the ambiguity and ask one focused follow-up question.
- If a comment is valid but broader than this PR, defer it instead of silently rejecting it.
- If a comment is accepted, implement it fully or report the concrete blocker that prevented implementation.
