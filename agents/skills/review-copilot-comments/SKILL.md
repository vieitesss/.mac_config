---
name: review-copilot-comments
description: Review unresolved Copilot comments on the current PR branch, validate their correctness and value, implement fixes, and provide a summary of actions taken.
compatibility: opencode
metadata:
  workflow: git
---

## What I do
- Detect the current branch and associated PR number
- Fetch unresolved review comments from GitHub Copilot
- Analyze each comment for correctness and implementation value
- Implement valid suggestions or reject invalid ones
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

### Step 3: Retrieve unresolved Copilot comments

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

### Step 4: Analyze each comment

For each unresolved Copilot comment, I will:

1. **Read the file and context**: Use the `Read` tool to examine the file at the specified path and line
2. **Evaluate the suggestion**: Assess whether:
   - The comment identifies a real issue (bug, code smell, security concern, etc.)
   - The suggested fix is correct and valuable
   - The fix aligns with the codebase style and conventions
   - The change would improve code quality, performance, or maintainability
3. **Make a decision**: Either:
   - **Accept**: Implement the fix if it's valid and valuable
   - **Reject**: Skip if the comment is incorrect, trivial, or not applicable

### Step 5: Implement accepted fixes

For accepted comments, I will:

1. Use the `Edit` tool to apply the suggested changes
2. Test that the changes don't break anything (run builds/tests if available)
3. Track the file path and line number for the summary

### Step 6: Resolve comment threads

After implementing a fix or rejecting a comment, I'll resolve the review thread:

```bash
# Resolve a thread by replying
gh api graphql -f query='
mutation {
  addPullRequestReviewComment(input: {
    pullRequestReviewId: "<REVIEW_ID>",
    body: "✅ Implemented: <brief explanation>"
  }) {
    comment {
      id
    }
  }
}'

# Or for rejected comments
gh api graphql -f query='
mutation {
  addPullRequestReviewComment(input: {
    pullRequestReviewId: "<REVIEW_ID>",
    body: "❌ Rejected: <reason>"
  }) {
    comment {
      id
    }
  }
}'
```

Note: Resolving threads may require additional GraphQL mutations or using `gh pr review` commands.

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
