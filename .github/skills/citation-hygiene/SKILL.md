---
name: citation-hygiene
description: 'Run a sourcing-only citation pass. Use for weak links, redundant evidence, inline-quote choices, citation clutter, and source replacement without touching prose style.'
argument-hint: 'Draft to review for citations and source quality'
---

# Citation Hygiene

## When to Use
- Remove weak or redundant citations without reopening structure
- Replace low-value links with stronger sources
- Convert trailing citation piles into earned inline support
- Decide where a quote is justified and where a plain citation is enough

## Required Inputs
- The draft to review
- Optional source list or citation preferences
- Any known source-quality bar for the piece

## If Unclear, Ask
- Is the goal to cut clutter, strengthen evidence, or both?
- Are inline quotes preferred over bare links when a source says something memorable?
- Are there source types that should be avoided or deprioritized?

## Procedure
1. Read the claims the citations are supposed to support.
2. Evaluate each citation for credibility, direct relevance, redundancy, and rhetorical value.
3. Mark citations as keep, cut, replace, merge, or quote inline.
4. Prefer the strongest representative when several sources make the same point.
5. Flag places where the draft is under-sourced, over-sourced, or sourced with technically relevant but weak material.
6. End with concrete citation changes, not broad research advice.

## Output Format
- Supported claim or section
- Keep / cut / replace / merge decisions
- Inline quote opportunities
- Highest-priority citation fixes

## Output Template
```md
## Supported Claim Or Section

## Keep
- Citation: why it stays

## Cut Or Replace
- Citation: why it fails

## Merge
- Citation cluster: strongest representative

## Quote Inline
- Citation: what is worth quoting

## Highest-Priority Fixes
-
```

## Completion Checks
- Every kept citation earns its place
- Redundant links are collapsed instead of preserved by default
- Quote recommendations are selective and justified
- Recommendations stay focused on sourcing, not prose style

## Anti-Patterns
- Keeping a link because it already exists in the draft
- Treating citation count as a proxy for rigor
- Mixing tone fixes into a sourcing-only pass
- Recommending quotes from sources with no salient line