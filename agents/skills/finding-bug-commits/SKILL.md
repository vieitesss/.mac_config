---
name: finding-bug-commits
description: Use git bisect to find the commit that introduced a bug or regression in a codebase. Use when debugging regressions, tracking down when a bug was introduced, or identifying breaking changes in git history.
compatibility: opencode
metadata:
  workflow: git
---

## What I do
- Guide you through using `git bisect` to find bug-introducing commits
- Help you choose between automated (script-based) or manual bisect approaches
- Provide step-by-step workflows with progress tracking
- Handle edge cases like untestable commits and bisect recovery

## Choosing the approach

**Use automated bisect** when:
- The bug is reproducible with a command (build, test, script)
- Testing doesn't require human judgment
- You can script the pass/fail detection

**Use manual bisect** when:
- The bug requires visual inspection or UX judgment
- Testing involves complex setup or interaction
- The reproduction steps can't be easily scripted

## Automated bisect workflow

Copy this checklist to track progress:

```
Automated Bisect Progress:
- [ ] Step 1: Identify known good and bad commits
- [ ] Step 2: Create test script (exit 0=good, 1-127=bad, 125=skip)
- [ ] Step 3: Start bisect with good/bad commits
- [ ] Step 4: Run git bisect run with test script
- [ ] Step 5: Review results and verify the culprit commit
- [ ] Step 6: Reset bisect session
```

### Step 1: Identify known commits

Find a commit where the bug exists (bad) and one where it doesn't (good):

```bash
git log --oneline -20  # Review recent history
# Or use tags: git tag -l
```

### Step 2: Create test script

Write a script that returns:
- **0** if current commit is good (bug not present)
- **1-127** if current commit is bad (bug present)
- **125** if current commit is untestable (skip it)

Example test script (`~/test.sh`):

```bash
#!/bin/sh

# Skip if build fails (unrelated to the bug)
make || exit 125

# Run the actual test
# Exit 0 if test passes (good), 1 if fails (bad)
make test
```

Make it executable:
```bash
chmod +x ~/test.sh
```

### Step 3: Start bisect

```bash
git bisect start
git bisect bad <bad-commit>      # Commit where bug exists
git bisect good <good-commit>    # Commit where bug doesn't exist
```

Or start with current HEAD as bad:
```bash
git bisect start HEAD <good-commit>
```

### Step 4: Run automated bisect

```bash
git bisect run ~/test.sh
```

Git will automatically test commits and find the first bad one.

### Step 5: Review results

Git bisect will output the culprit commit. Verify with:

```bash
git show <commit-hash>  # Review the changes
git log -1 <commit-hash>  # See the commit message
```

### Step 6: Reset

```bash
git bisect reset  # Returns to original HEAD
```

## Manual bisect workflow

Copy this checklist to track progress:

```
Manual Bisect Progress:
- [ ] Step 1: Identify known good and bad commits
- [ ] Step 2: Start bisect session
- [ ] Step 3: Test current commit manually
- [ ] Step 4: Mark commit as good or bad
- [ ] Step 5: Repeat steps 3-4 until done
- [ ] Step 6: Review results and reset
```

### Step 1: Identify known commits

Same as automated approach - find one good and one bad commit.

### Step 2: Start bisect

```bash
git bisect start
git bisect bad <bad-commit>      # Or just: git bisect bad (for HEAD)
git bisect good <good-commit>
```

Git will check out a commit roughly in the middle.

### Step 3: Test current commit

Build and test the checked-out commit. This might involve:
- Compiling the code
- Running the application
- Checking for the bug manually

### Step 4: Mark the commit

If the bug is present:
```bash
git bisect bad
```

If the bug is not present:
```bash
git bisect good
```

If the commit can't be tested (won't build, missing dependencies):
```bash
git bisect skip
```

### Step 5: Repeat

Git will check out another commit. Repeat steps 3-4 until git bisect identifies the culprit.

### Step 6: Reset

```bash
git bisect reset  # Returns to original HEAD
```

## Common patterns and edge cases

### Skipping untestable commits

If a commit can't be tested (broken build, missing files):

```bash
git bisect skip
```

Note: Too many skipped commits may prevent finding the exact culprit.

### Using custom terms

Instead of "good"/"bad", use custom terms for clarity:

```bash
git bisect start --term-old working --term-new broken
git bisect broken  # Current commit is broken
git bisect working <commit>  # This commit was working
```

Or for features (not bugs):

```bash
git bisect start --term-old without-feature --term-new with-feature
```

### Narrowing the search with paths

If you know which files are involved:

```bash
git bisect start HEAD <good-commit> -- path/to/files/
```

### Visualizing the bisect

During bisect, visualize remaining commits:

```bash
git bisect visualize  # Opens gitk or similar
# Or: git bisect view
```

### Recovering from mistakes

If you mark a commit incorrectly:

```bash
git bisect log > bisect.log  # Save current state
git bisect reset
# Edit bisect.log to remove incorrect entries
git bisect replay bisect.log
```

### Testing with temporary fixes

If newer commits need patches to build/test:

```bash
#!/bin/sh
# Apply temporary fix before testing
git cherry-pick --no-commit <fix-commit> || exit 125
make test
status=$?
git reset --hard  # Undo temporary changes
exit $status
```

## Test script examples

### Build failure detection

```bash
#!/bin/sh
make clean && make || exit 1
exit 0
```

### Test suite regression

```bash
#!/bin/sh
make || exit 125  # Skip if won't build
make test || exit 1  # Bad if tests fail
exit 0  # Good if tests pass
```

### Performance regression

```bash
#!/bin/sh
make || exit 125
# Run benchmark and check threshold
result=$(make benchmark | grep "time:" | awk '{print $2}')
threshold=1000
[ "$result" -gt "$threshold" ] && exit 1
exit 0
```

### Example-specific test

```bash
#!/bin/sh
# Test specific examples build
for dir in example/*/; do
  (cd "$dir" && zig build) || exit 1
done
exit 0
```

## When to use me

Use this skill when you need to:
- Find which commit introduced a bug or regression
- Track down when a feature broke
- Identify the source of a build failure
- Locate performance regressions in git history
- Debug "it used to work" problems

## Remember

- **Binary search is powerful**: Git bisect efficiently narrows down thousands of commits
- **Good test scripts save time**: Invest in a reliable test script for automated bisect
- **Skip carefully**: Too many skips reduce accuracy
- **Always reset**: Run `git bisect reset` when done to return to normal state
- **Document findings**: Note the culprit commit and why it caused the issue
