---
name: revision-metrics
description: 'Track editorial churn across revisions. Use for defect logs, rewrite-pass counts, recurring failure patterns, source-fix tracking, and workflow adjustments that reduce rework.'
argument-hint: 'Draft or series revision history to measure'
---

# Revision Metrics

## When to Use
- Track recurring failure patterns across revisions
- Keep a defect log for one article or a full series
- Measure whether rewrite loops are improving the draft or just churning it
- Decide when a workflow needs a new review pass, stricter constraints, or a new specialized skill

## Required Inputs
- Draft or series being tracked
- Current revision stage or available revision history
- Quality bar or main editorial risks
- Optional existing defect categories or process notes

## If Unclear, Ask
- Is this for one draft, one article family, or a whole series?
- Do you want a lightweight metrics snapshot or a fuller defect log?
- Which outcomes matter most: structural quality, citation quality, tone, or human editing effort?

## Procedure
1. Define the tracking unit: section, article, or series.
2. Choose a small metric set that is actually useful. Default to:
   - number of rewrite passes
   - recurring defect categories
   - source swaps or citation corrections
   - human editing effort after first draft
3. Log defects by category, severity, and where they recur.
4. Separate defects caused by planning, structure, evidence, and prose.
5. Summarize whether the revision loop is converging, flat, or getting noisier.
6. Recommend one process adjustment that would most reduce future rework.

## Output Format
- Scope of tracking
- Metrics snapshot
- Defect log by category
- Trend summary
- Recommended workflow change

## Output Template
```md
## Scope

## Metrics Snapshot
- Rewrite passes:
- Source swaps:
- Human editing effort:

## Defect Log
- Category: location, severity, recurrence

## Trend Summary

## Recommended Process Change
```

## Default Defect Categories
- structural drift
- weak transition
- unsupported claim
- redundant citation
- generic prose
- tonal mismatch
- human-only fix required

## Completion Checks
- Metrics stay small enough to use repeatedly
- Defects are actionable, not vague complaints
- The summary distinguishes quality improvement from mere text churn
- The recommended workflow change follows from repeated evidence in the log

## Anti-Patterns
- Tracking everything and learning nothing
- Mixing editorial severity with personal annoyance
- Using metrics as a substitute for judgment
- Logging defects without changing the workflow that caused them