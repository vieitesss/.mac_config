---
name: review-copilot-comments
description: Review unresolved Copilot comments on the current PR branch, validate their correctness and value, implement fixes, and provide a summary of actions taken.
compatibility: opencode
metadata:
  workflow: git
---

## What I do
- Detect the current branch and associated PR number
- Gather context about the PR (description, diff, commit history) and project (conventions, linting configs, local code patterns)
- Fetch unresolved review comments from GitHub Copilot
- Analyze each comment for correctness and value, cross-referencing against the PR's intent and project conventions
- Implement valid suggestions or reject invalid ones with informed reasoning
- Provide a comprehensive summary of actions taken

## How I work

### Step 1: Identify the PR

First, I need to find the PR associated with the current branch:

```bash
# Get current branch
git branch --show-current

# Find PR number for this branch
gh pr list --head $(git branch --show-current) --json number --jq '.[0].number'
```

If no PR is found, I'll notify you that this skill requires an active PR.

### Step 2: Fetch repository information

I need the repository owner and name:

```bash
# Get repo info
gh repo view --json owner,name --jq '{owner: .owner.login, name: .name}'
```

### Step 3: Gather PR and project context

Before evaluating any comments, I need to understand what this PR is about and how the project works. This context is critical for making informed accept/reject decisions — Copilot suggestions that seem correct in isolation may be wrong in the context of the PR's intent or the project's conventions.

#### 3a. Read the PR description and metadata

```bash
# Get PR title, body, labels, and base branch
gh pr view --json title,body,labels,baseRefName,headRefName,files

# Get the full diff to understand the scope of changes
gh pr diff
```

#### 3b. Read the commit history on this branch

```bash
# Understand what the PR is trying to accomplish from commit messages
git log $(gh pr view --json baseRefName --jq '.baseRefName')..HEAD --oneline
```

#### 3c. Identify project conventions

Look for configuration and convention files that inform how code should be written:

```bash
# Check for linting/formatting configs, CI config, contribution guidelines
ls -a .editorconfig .eslintrc* .prettierrc* .rubocop.yml .flake8 pyproject.toml \
  biome.json deno.json tsconfig.json Makefile justfile \
  CONTRIBUTING.md .github/CODEOWNERS 2>/dev/null
```

Read any relevant config files to understand the project's style and rules. Also scan nearby code in the same directories as the commented files to understand local patterns:

```bash
# For each file with a Copilot comment, read sibling files to understand local conventions
ls $(dirname <commented_file_path>)
```

#### 3d. Check for existing tests and CI

```bash
# Identify test framework and test location
gh pr checks --json name,status,conclusion 2>/dev/null || true

# Look for test files related to commented files
# e.g., if comment is on src/utils/parser.ts, look for tests/utils/parser.test.ts
```

This context will be used in Step 5 to make better-informed decisions about each comment.

### Step 4: Retrieve unresolved Copilot comments

Using the GitHub GraphQL API, I'll fetch all unresolved review thread comments:

```bash
gh api graphql -f query='
query {
  repository(owner: "<OWNER>", name: "<REPO>") {
    pullRequest(number: <PR_NUMBER>) {
      reviewThreads(first: 100) {
        nodes {
          isResolved
          path
          line
          comments(first: 10) {
            nodes {
              author {
                login
              }
              body
              id
            }
          }
        }
      }
    }
  }
}' --jq '.data.repository.pullRequest.reviewThreads.nodes[] | select(.isResolved == false) | {path: .path, line: .line, author: .comments.nodes[0].author.login, body: .comments.nodes[0].body, id: .comments.nodes[0].id}'
```

I'll filter for comments where `author.login` contains "copilot" or matches known Copilot bot usernames (e.g., "github-copilot[bot]", "copilot").

### Step 5: Analyze each comment

For each unresolved Copilot comment, I will:

1. **Read the file and surrounding context**: Use the `Read` tool to examine the file at the specified path and line, reading a wide window (at least 50 lines above and below) to understand the full function/block
2. **Cross-reference with PR context**: Using the context gathered in Step 3:
   - **PR intent**: Does the comment align with or contradict the purpose of the PR? A suggestion to refactor code that was intentionally written that way for this PR should likely be rejected
   - **Project conventions**: Does the suggested change follow the project's established patterns (linting rules, naming conventions, error handling style, etc.)? Reject suggestions that violate project-specific conventions even if they are "generally correct"
   - **Diff scope**: Is the comment on code that was actually changed in this PR, or on pre-existing code? Suggestions on unchanged code may be valid but out of scope
   - **Related changes**: Were similar patterns used elsewhere in the same PR? If the author used a pattern consistently, a suggestion to change one instance is likely wrong or should apply everywhere
3. **Evaluate the suggestion**: Assess whether:
   - The comment identifies a real issue (bug, code smell, security concern, etc.)
   - The suggested fix is correct and valuable
   - The fix aligns with the codebase style and conventions
   - The change would improve code quality, performance, or maintainability
4. **Make a decision**: Either:
   - **Accept**: Implement the fix if it's valid, valuable, and consistent with the PR's goals and project conventions
   - **Reject**: Skip if the comment is incorrect, trivial, out of scope, or conflicts with project conventions

### Step 6: Implement accepted fixes

For accepted comments, I will:

1. Use the `Edit` tool to apply the suggested changes
2. Test that the changes don't break anything (run builds/tests if available)
3. Track the file path and line number for the summary

### Step 7: Provide summary

I'll create a structured summary:

```
## Copilot Comment Review Summary

**Total unresolved Copilot comments found**: <count>

### ✅ Accepted and Implemented (<count>)
1. **File**: `<path>` (line <line>)
   - **Comment**: <brief summary of suggestion>
   - **Action**: <what was done>
   
2. **File**: `<path>` (line <line>)
   - **Comment**: <brief summary>
   - **Action**: <what was done>

### ❌ Rejected (<count>)
1. **File**: `<path>` (line <line>)
   - **Comment**: <brief summary>
   - **Reason**: <why rejected>

### Next Steps
- Review the implemented changes
- Run tests to ensure nothing broke: `<test command>`
- Commit the changes if satisfied
```

## Comment evaluation criteria

I apply these criteria when evaluating Copilot suggestions:

### Accept if:
- **Bug fix**: Identifies and fixes a genuine bug (null pointer, off-by-one, type error, etc.)
- **Security issue**: Addresses a security vulnerability (injection, XSS, exposed secrets, etc.)
- **Performance improvement**: Meaningful performance optimization
- **Best practice**: Aligns with language/framework best practices
- **Readability**: Significantly improves code clarity
- **Consistency**: Improves consistency with existing codebase patterns

### Reject if:
- **Incorrect**: The suggestion is factually wrong or would introduce bugs
- **Trivial**: The change is too minor to be worth implementing (e.g., stylistic nitpick)
- **Context-unaware**: Copilot misunderstood the code's purpose or context
- **Contradicts PR intent**: The suggestion conflicts with the deliberate goals of the PR
- **Violates project conventions**: The change goes against established project patterns, linting rules, or style guides
- **Out of scope**: The comment targets pre-existing code not modified in this PR (flag for a separate PR/issue instead)
- **Inconsistent application**: The suggestion changes one instance of a pattern that is used consistently throughout the PR
- **Already handled**: The issue is already addressed elsewhere
- **Opinionated**: Pure style preference without clear benefit
- **Breaking**: Would break existing functionality or tests

## Error handling

If I encounter issues:
- **No PR found**: I'll notify you and suggest creating a PR first
- **No unresolved comments**: I'll confirm all Copilot comments are resolved
- **API errors**: I'll report the error and suggest checking `gh auth status`
- **Read/Edit failures**: I'll log the failure and continue with other comments

## When to use me

Use this skill when:
- You have an active PR with unresolved Copilot review comments
- You want automated review and implementation of valid Copilot suggestions
- You need to batch-process multiple Copilot comments efficiently
- You want a second opinion on whether Copilot's suggestions are valuable

## Requirements

- GitHub CLI (`gh`) installed and authenticated
- Active pull request on the current branch
- Read/write access to the repository

## Notes

- I focus only on **Copilot-authored comments** (not human reviewers)
- I only process **unresolved comments** (resolved ones are skipped)
- I implement changes autonomously but you should review before committing
- I prioritize safety: when in doubt, I reject rather than implement questionable changes
