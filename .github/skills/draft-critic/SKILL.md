---
name: draft-critic
description: 'Run a findings-first structural critique of a draft. Use for logic gaps, duplication, transition failures, thesis drift, pacing problems, and sections that summarize instead of progress.'
argument-hint: 'Draft to critique for structure and logic'
---

# Draft Critic

## When to Use
- Review a first draft before line editing
- Find duplicated ideas or weak transitions
- Check whether a section drifts from the thesis
- Identify unsupported claims, pacing problems, or structural dead weight

## Required Inputs
- The draft to review
- The intended thesis or article goal
- Optional outline or neighboring article context

## If Unclear, Ask
- What is the main claim of this piece?
- Do you want findings only, or findings plus rewrite suggestions?
- Should the review optimize for structure, pacing, or evidence first?

## Procedure
1. Restate the draft's apparent thesis and check it against the intended goal.
2. Read the draft section by section and classify issues into a small set of concrete categories.
3. Prefer findings over rewrites unless the user asks for direct replacement text.
4. Report the highest-leverage issues first.
5. For each issue, explain why it weakens the draft and what kind of fix is needed.

## Issue Categories
- duplication
- weak transition
- unsupported claim
- argument drift
- flattened distinction
- pacing problem
- summary instead of progression

## Output Format
- Thesis check
- Findings ordered by importance
- For each finding:
  - location or section
  - issue category
  - why it matters
  - recommended fix type

## Output Template
```md
## Thesis Check

## Findings
1. Location:
   Category:
   Problem:
   Why it matters:
   Fix type:

## Overall Risk
-
```

## Completion Checks
- Findings are specific and local, not vague impressions
- The review distinguishes structural issues from stylistic ones
- Repeated ideas are identified once and grouped when possible
- The review does not rewrite the whole draft unless asked

## Anti-Patterns
- Saying "tighten this" without naming the failure mode
- Mixing structural critique with minor copy edits
- Rewriting large sections when the user asked for review
- Treating all issues as equal severity