---
name: style-enforcer
description: 'Run a prose-only style pass. Use for cadence, tone, repetition, generic phrasing, over-explanation, and weak openings or endings after structure is mostly settled.'
argument-hint: 'Draft to review for tone and prose patterns'
---

# Style Enforcer

## When to Use
- Tighten prose after structural issues are mostly resolved
- Remove robotic cadence, repetitive transitions, and generic phrasing
- Catch short-paragraph fatigue and overuse of emphatic sentence fragments
- Catch overused antithetical turns such as "This is not X. It is Y."
- Check whether endings, openings, and handoffs feel earned instead of templated
- Review tone without reopening evidence or citation quality

## Required Inputs
- The draft to review
- Intended tone or voice constraints
- Any known anti-patterns to avoid

## If Unclear, Ask
- What tone should the draft preserve?
- Should the output stay findings-first, or include short rewrite examples?
- Are there known phrases, sentence habits, or ending styles to avoid?

## Author tone
The author is an Engineering Manager who values clear, concise, and engaging prose. They prefer a tone that is informative yet approachable, with a touch of personality. The writing should avoid jargon and be accessible to a broad audience while maintaining depth and insight.

It is critical that the phrasing be organic and natural, avoiding any robotic cadence or generic transitions. The style should feel polished but not overworked, preserving the author's unique voice and perspective.

The pass should also watch for industry-fatigued AI writing patterns: stacks of very short paragraphs, repeated contrast constructions, slogan-like sentence fragments, and tidy punchlines that lose force through overuse.

## Procedure
1. Read the draft for cadence, paragraph rhythm, transitions, specificity, and tonal consistency.
2. Group repeated stylistic problems into concrete patterns.
3. Check whether the draft overuses short paragraphs, sentence fragments, or contrast formulas that create a synthetic "sharpness."
4. Point to the local evidence for each pattern instead of giving vague global impressions.
5. Prefer compact rewrite guidance or short examples over full rewrites unless asked.
6. Call out where the prose sounds finished but emotionally or rhetorically hollow.
7. End with the two or three highest-leverage style fixes.

## Contrast-Line Checklist
- Keep one strong contrast line when it crystallizes the argument.
- Cut the rest unless a later contrast line genuinely escalates the claim.
- Merge adjacent short paragraphs when they are only delivering rhythm, not new meaning.
- Treat repeated "This is not X. It is Y." constructions as a series-level pattern, not as isolated sentences.

## Output Format
- Tone check
- Style findings by pattern
- Rewrite guidance or short examples
- Highest-priority cleanup targets

## Output Template
```md
## Tone Check

## Style Findings
1. Pattern:
   Evidence:
   Why it weakens the draft:
   Rewrite guidance:

## Highest-Priority Cleanup Targets
-
```

## Completion Checks
- Findings point to concrete prose patterns
- Recommendations preserve voice rather than flatten it
- The review stays focused on prose, not source selection
- Rewrite guidance is concise unless the user asks for direct replacement text
- The pass distinguishes persuasive compression from overused AI-style punchiness

## Anti-Patterns
- Saying the prose feels generic without showing the pattern
- Rewriting whole sections when a style review was requested
- Confusing structural weakness with tonal weakness
- Flattening distinctive voice into bland cleanup
- Treating every short paragraph or contrast sentence as bad instead of judging accumulation and rhythm
- Missing overused "not X, but Y" constructions because each individual instance seems fine in isolation