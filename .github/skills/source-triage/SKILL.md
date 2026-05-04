---
name: source-triage
description: 'Evaluate candidate sources before or during drafting. Use for keep-or-reject decisions, redundancy cuts, quote selection, evidence ranking, and replacement priorities.'
argument-hint: 'Claim, section, or source list to rank'
---

# Source Triage

## When to Use
- Rank candidate sources before drafting
- Cut weak, obscure, or redundant citations
- Decide which sources deserve an inline quote
- Replace technically relevant evidence that adds little rhetorical value

## Required Inputs
- Claim, topic, or article brief
- Source list, notes, or links to evaluate
- Optional citation preferences or source-quality bar

## If Unclear, Ask
- Is the main goal credibility, speed, rhetorical sharpness, or broad coverage?
- Are there source types to prefer or avoid?
- Should the output optimize for a short keep list or a fuller keep/maybe/reject pass?

## Procedure
1. Restate the claim or section the sources are meant to support.
2. Review each source for:
   - credibility
   - direct relevance
   - uniqueness versus neighboring sources
   - rhetorical value in context
   - quotability
3. Classify each source as keep, maybe, replace, or reject.
4. Explain why low-value sources fail, not just that they fail.
5. Identify where a strong source should be quoted inline instead of parked as a trailing link.
6. Call out clusters of sources that all make the same point and recommend the strongest representative.
7. End with a prioritized evidence set the drafter can use directly.

## Output Format
- Claim or section being supported
- Keep / maybe / replace / reject recommendations
- Reason for each classification
- Inline quote candidates
- Replacement priorities if the evidence set is weak

## Output Template
```md
## Supported Claim

## Keep
- Source: why it stays

## Maybe
- Source: what is missing

## Replace Or Reject
- Source: why it fails

## Inline Quote Candidates
- Source: salient line or reason to quote
```

## Completion Checks
- Kept sources are not just relevant but useful
- Redundant sources are collapsed rather than preserved by default
- Weak but tempting citations are explicitly rejected when they lower the bar
- Quote recommendations are reserved for sources with a genuinely salient line or framing

## Anti-Patterns
- Keeping a source only because it loosely matches a sentence
- Treating quantity of citations as proof of quality
- Recommending quotes from sources that say nothing memorable
- Ignoring redundancy among several medium-quality sources