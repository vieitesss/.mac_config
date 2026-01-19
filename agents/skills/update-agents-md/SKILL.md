---
name: update-agents-md
description: Generate or refactor AGENTS.md files following progressive disclosure principles for optimal context efficiency.
compatibility: opencode
metadata:
  workflow: documentation
---

## What I do
- Analyze existing AGENTS.md files or create new ones from scratch
- Apply progressive disclosure principles to maximize context efficiency
- Create hierarchical documentation structures (root + domain-specific docs)
- Ensure AGENTS.md follows best practices: minimal, focused, and future-proof

## Core Philosophy

**The ideal AGENTS.md is as small as possible.** Every token loads on every single request, regardless of relevance. Frontier LLMs can follow ~150-200 instructions consistently—don't waste this budget on irrelevant guidance.

### The Instruction Budget
- Small, focused AGENTS.md = more tokens for task-specific work
- Large, bloated AGENTS.md = fewer tokens for actual work + agent confusion
- Irrelevant instructions = token waste + distraction = worse performance

### Progressive Disclosure
Give agents only what they need right now. Point to other resources when needed. Agents are fast at navigating documentation hierarchies.

## Essential Content Only

The absolute minimum for root AGENTS.md:

1. **One-sentence project description** (acts like a role-based prompt)
   - Example: "This is a React component library for accessible data visualization."
   - Anchors every decision the agent makes

2. **Package manager** (only if not npm)
   - Example: "This project uses pnpm workspaces."

3. **Build/typecheck commands** (only if non-standard)
   - Example: "Run `just build` to build all packages."

**That's it.** Everything else goes in separate files using progressive disclosure.

## How I Work

### 1. Assessment Phase
- Read current AGENTS.md (if exists) and understand project context
- Explore codebase briefly to understand: project type, tech stack, structure
- Identify what's essential vs. what belongs elsewhere
- Find contradictions, stale documentation, and bloat
- Flag instructions that are:
  - Redundant (agent already knows this)
  - Too vague to be actionable
  - Overly obvious (like "write clean code")
  - Conflicting with other instructions
  - Stale (file paths, outdated patterns)

### 2. Clarification Phase
Ask the user:
- What is the one-sentence description of this project?
- What package manager do you use (if not npm)?
- Are there non-standard build/typecheck commands?
- If contradictions exist: which version should I keep?
- Which flagged instructions should be deleted vs. moved?

### 3. Content Organization Phase
Group remaining instructions by domain:
- TypeScript/language conventions
- Testing patterns
- API design patterns
- Architecture decisions
- Git workflow preferences
- CI/CD processes
- Security practices
- Performance guidelines

### 4. File Structure Proposal
Propose a hierarchical documentation structure:

```
AGENTS.md                    # Minimal root with essentials only
docs/
├── TYPESCRIPT.md           # Language conventions
├── TESTING.md              # Testing patterns
├── API_CONVENTIONS.md      # API design
├── ARCHITECTURE.md         # Architectural decisions
└── GIT_WORKFLOW.md         # Commit style, PR process
```

For monorepos:
```
AGENTS.md                    # Monorepo-wide essentials
docs/                        # Shared conventions
packages/
├── api/
│   └── AGENTS.md           # API-specific guidance
└── web/
    └── AGENTS.md           # Web-specific guidance
```

### 5. Generation Phase
Create files with:
- **Conversational tone**: Light touch, no imperatives, no all-caps forcing
- **Domain concepts**: Describe capabilities, not file structure
- **External links**: Point to framework docs, external guides when helpful
- **Future-proof**: Avoid file paths and structure documentation
- **Clear references**: Link between docs when they relate

### 6. Validation
Ensure:
- No stale file paths or outdated patterns
- No conflicting instructions across files
- Conversational language throughout
- Each file focuses on one domain
- Root AGENTS.md is truly minimal

## Writing Style Guidelines

### Good Examples

**Root AGENTS.md:**
```markdown
This is a React component library for accessible data visualization.

This project uses pnpm workspaces.

For TypeScript conventions, see docs/TYPESCRIPT.md
For testing patterns, see docs/TESTING.md
```

**Monorepo Root:**
```markdown
This is a monorepo containing web services and CLI tools.

Use pnpm workspaces to manage dependencies.

See each package's AGENTS.md for specific guidelines.
```

**Package-Level (packages/api/AGENTS.md):**
```markdown
This package is a Node.js GraphQL API using Prisma.

Follow docs/API_CONVENTIONS.md for API design patterns.
```

**Domain Doc (docs/TYPESCRIPT.md):**
```markdown
# TypeScript Conventions

Use `interface` instead of `type` for object shapes when possible.

For testing TypeScript code, see TESTING.md

External reference: [TypeScript Handbook](https://www.typescriptlang.org/docs/handbook/)
```

### Bad Examples

**❌ Too much in root AGENTS.md:**
```markdown
Always use const instead of let.
Never use var.
Use interface instead of type when possible.
Use strict null checks.
ALWAYS RUN TESTS BEFORE COMMITTING.
Files are organized as follows:
- src/auth/handlers.ts contains authentication
- src/api/routes.ts contains API routes
...
```

**❌ Imperative/forcing tone:**
```markdown
YOU MUST ALWAYS use TypeScript strict mode.
NEVER EVER use any type.
```

**❌ File structure documentation:**
```markdown
The authentication logic lives in src/auth/handlers.ts
The API routes are in src/api/routes.ts
```
*(File paths change constantly and poison context when stale)*

**❌ Vague/obvious instructions:**
```markdown
Write clean code.
Make it maintainable.
Use best practices.
```

## What Belongs Where

### Root AGENTS.md
- Relevant to **every single task** in the repo
- One-sentence project description
- Non-standard package manager
- Non-standard build commands
- Links to domain-specific docs

### Separate Domain Files (docs/*)
- Relevant to one domain (TypeScript, testing, API design, etc.)
- Can be organized hierarchically
- Can reference each other
- Can link to external documentation

### Never Include
- File system structure/paths (changes constantly)
- Redundant information (agent already knows)
- Vague platitudes ("write good code")
- Everything that could go in a separate file
- Auto-generated comprehensive guides

## Monorepo Considerations

AGENTS.md files can exist at multiple levels and **merge with the root level**. Don't overload any level—agents see all merged files.

**Level Distribution:**

| Level | Content |
|-------|---------|
| **Root** | Monorepo purpose, navigation, shared tools |
| **Package** | Package purpose, specific tech stack, package conventions |

## Special Cases

### No Existing AGENTS.md
- Start from scratch with essentials only
- Ask clarifying questions about project
- Propose minimal root + optional domain docs

### Massive Existing AGENTS.md
- Use refactoring workflow
- Be ruthless about deletion
- Extract to multiple domain files
- Preserve user preferences (ask about contradictions)

### Monorepo Migration
- Create minimal root AGENTS.md
- Evaluate which packages need package-level AGENTS.md
- Avoid duplication between root and package levels

## Refactoring Workflow

When refactoring an existing AGENTS.md:

1. **Find contradictions**: Identify conflicting instructions and ask user which to keep

2. **Identify essentials**: Extract only what belongs in root:
   - One-sentence project description
   - Package manager (if not npm)
   - Non-standard build/typecheck commands
   - Anything truly relevant to every single task

3. **Group the rest**: Organize by logical categories (TypeScript, testing, API, Git, etc.)

4. **Create file structure**: Output:
   - Minimal root AGENTS.md with links
   - Each domain file with relevant instructions
   - Suggested docs/ folder structure

5. **Flag for deletion**: Identify instructions to remove:
   - Redundant (agent already knows)
   - Too vague to be actionable
   - Overly obvious
   - Conflicting
   - Stale file paths/outdated patterns

## Common Pitfalls to Avoid

### The "Ball of Mud" Feedback Loop
1. Agent does something you don't like
2. You add a rule to prevent it
3. Repeat hundreds of times
4. File becomes unmaintainable mess

**Solution**: Ask "Is this relevant to every task?" before adding anything.

### Auto-Generated Files
Never use initialization scripts to auto-generate AGENTS.md. They flood files with "useful for most scenarios" content, prioritizing comprehensiveness over restraint.

### Stale Documentation Poison
Unlike humans who are skeptical of bad docs, agents read documentation on every request. Stale docs actively poison context. File paths are especially dangerous.

**Solution**: Focus on domain concepts and capabilities, not structure. Avoid file paths.

### Overloading the Instruction Budget
Every irrelevant instruction wastes tokens and distracts the agent.

**Solution**: Be ruthless. If it's not essential for every task, move it or delete it.

## When to Use Me

Use this skill when you want to:
- Create a new AGENTS.md file for your project
- Refactor an existing AGENTS.md that has grown too large
- Apply progressive disclosure principles to your AI agent configuration
- Migrate from a monolithic AGENTS.md to a hierarchical documentation structure
- Audit your AGENTS.md for stale documentation and contradictions
- Ensure your AGENTS.md follows current best practices

## Output Format

At the end, I will provide:
1. **Root AGENTS.md content** (minimal, essential only)
2. **Domain-specific doc files** (grouped by topic)
3. **Suggested file structure** (where to place each file)
4. **Deletion recommendations** (what to remove and why)
5. **Summary of changes** (what was moved where)

## Remember

**The ideal AGENTS.md is small, focused, and points elsewhere.** It gives agents just enough context to start working, with breadcrumbs to detailed guidance. This keeps the instruction budget efficient, agents focused, and setup future-proof.
