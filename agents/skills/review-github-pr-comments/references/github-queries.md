# GitHub Review Queries

Use these commands when you need fresh PR review data from GitHub.

## Resolve the repository and PR

```bash
OWNER=$(gh repo view --json owner --jq '.owner.login')
REPO=$(gh repo view --json name --jq '.name')
PR=$(gh pr view --json number --jq '.number')
```

## Fetch top-level review summaries

Use this query to collect review summaries such as approval notes, change requests, or long-form bot summaries.

```bash
gh api graphql \
  -F owner="$OWNER" \
  -F repo="$REPO" \
  -F pr="$PR" \
  -f query='query($owner:String!, $repo:String!, $pr:Int!) {
    repository(owner:$owner, name:$repo) {
      pullRequest(number:$pr) {
        reviews(last:100) {
          nodes {
            author { login }
            state
            body
            submittedAt
            updatedAt
            url
          }
        }
      }
    }
  }'
```

## Fetch review threads and current thread state

Use this query to inspect inline comments, whether the thread is resolved, whether the thread is outdated, and what the latest reviewer comment says now.

```bash
gh api graphql \
  -F owner="$OWNER" \
  -F repo="$REPO" \
  -F pr="$PR" \
  -f query='query($owner:String!, $repo:String!, $pr:Int!) {
    repository(owner:$owner, name:$repo) {
      pullRequest(number:$pr) {
        reviewThreads(first:100) {
          nodes {
            isResolved
            isOutdated
            path
            line
            originalLine
            updatedAt
            comments(last:20) {
              nodes {
                author { login }
                body
                createdAt
                updatedAt
                url
              }
            }
          }
        }
      }
    }
  }'
```

## Interpret the thread data

- Read the full `comments.nodes` list before deciding what the thread means.
- Use the latest reviewer-authored comment as the current request when the thread changed over time.
- Treat `isResolved: true` as informational unless the user explicitly asked to re-open past decisions.
- Treat `isOutdated: true` as a signal to compare against the current file and current diff before acting.

## Filter to specific reviewers when needed

If the user mentions CodeRabbit, Qodo, Copilot, or another reviewer explicitly, filter the collected review data by `author.login` after fetching it.
