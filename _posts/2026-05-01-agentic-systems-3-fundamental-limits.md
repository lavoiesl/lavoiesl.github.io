---
title: Agentic systems are bound by the same fundamental limits
date: 2026-05-01 09:00:00 -0400
tags: ["AI", "Agentic Systems", "Software Engineering"]
toc: true
---

<div class="notice--primary" markdown="1">
This article is part of a series on agentic systems:

1. [Agentic systems are struggling to scale (this should feel familiar)](/2026/05/agentic-systems-1-struggling-to-scale)
2. [Agentic systems are still in the artisanal era](/2026/05/agentic-systems-2-artisanal-era)
3. **[Agentic systems are bound by the same fundamental limits](/2026/05/agentic-systems-3-fundamental-limits)** 👈
4. [Artifacts are compression: how systems handle complexity](/2026/05/agentic-systems-4-artifacts-are-compression)
5. [Why all systems become pipelines](/2026/05/agentic-systems-5-why-all-systems-become-pipelines)
6. [Long-lived systems need modularity](/2026/05/agentic-systems-6-long-lived-systems-need-modularity)
7. [Designing agentic systems for engineering organizations](/2026/05/agentic-systems-7-designing-systems)
8. [Writing this series with AI: a postmortem](/2026/05/agentic-systems-8-writing-with-ai-postmortem)
</div>

Brittleness explains part of what teams are feeling. It does not remove the deeper limits that govern any workflow once it has to scale.

Every system that scales eventually runs into the same reality:

The constraint defines the system.

These are not AI-native limits. Engineering has been running into them for decades.

## Capacity is not throughput

The default assumption is simple: add more capacity, get more output. Add more agents, get more work done.

That is exactly the assumption behind many AI replacement efforts, and it is why those efforts reversed so quickly. Adding more AI capacity did not remove escalation, approval, testing, or exception handling. It only pushed more work toward those stages.

In practice, adding more agents still did not increase throughput in real systems. Local work sped up. The constrained stages did not.

## Two constraints, one outcome

[Amdahl's Law][1] and modern delivery bottlenecks describe the same system from two angles.

| Constraint | What it means | Example |
| --- | --- | --- |
| Serial fraction | Some work must still happen in order | Requirement clarification, approval, deployment |
| Bottleneck stage | One constrained stage sets throughput | Code review, integration, compliance review |

[Amdahl's 1967 paper][1] says the maximum improvement to a system is limited by the fraction that remains serial. [Atlassian's modern explainer][2] makes the team version concrete: if only about 20% of the lifecycle is individual work, even **"instant"** AI on that slice only raises overall throughput to about **1.25x** because the other 80% still moves at normal system speed.

Operationally, the same limit shows up as a queue.

If review is slow, faster drafting creates a review queue. If integration is slow, faster implementation creates an integration queue. If approvals are slow, faster planning creates an approval queue.

The form changes. The constraint does not.

## Why agentic systems hit this early

Agentic systems often try to scale by increasing what is easiest to increase:

* More agents
* More parallel tasks
* More intermediate output

That improves local productivity. It does not automatically improve delivery.

As [Atlassian][2] notes, once AI accelerates drafting, the system starts accumulating work at reviews, approvals, and risk checks. [The Engineering Leadership Newsletter][3] makes the same point with one concrete example: code review can become the bottleneck even when implementation gets faster.

This is why the layoff-and-rehiring cycle from Part 1 matters so much. The failure was not that AI produced nothing. The failure was that the system still depended on narrow stages where judgment, escalation, and validation lived.

## Scaling means working the constraint

The mistake is optimizing whatever looks most scalable.

Parallel work is usually easy to add. Sequential dependencies and bottlenecks are not.

Effective systems focus on:

* Reducing unnecessary serial dependencies
* Identifying the real bottleneck
* Controlling what reaches constrained stages

Most of the system can get faster without the system moving faster at all.

## What the bottleneck changes

Once constrained stages define throughput, raw upstream context becomes a liability.

You cannot ask every downstream step to reread everything and still expect the system to move. The next design question is therefore simple: what exactly should cross those bottlenecks, and in what form?

👉 [Part 4: Artifacts are compression: how systems handle complexity](/2026/05/agentic-systems-4-artifacts-are-compression)

[1]: https://www3.cs.stonybrook.edu/~rezaul/Spring-2012/CSE613/reading/Amdahl-1967.pdf "Validity of the single processor approach to achieving large scale computing capabilities - Gene M. Amdahl"
[2]: https://www.atlassian.com/blog/ai-at-work/how-amdahls-law-still-applies-to-modern-day-ai-inefficiencies "How Amdahl's law still applies to modern-day AI inefficiencies - Atlassian"
[3]: https://newsletter.eng-leadership.com/p/code-review-is-the-new-bottleneck "Code review is the new bottleneck - Engineering Leadership Newsletter"
