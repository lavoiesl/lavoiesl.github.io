---
title: Agentic systems are still in the artisanal era
date: 2026-05-01 09:00:00 -0400
description: "Agentic systems still operate like craft work: impressive demos depend on operator skill, implicit knowledge, and manual recovery instead of engineered workflows."
tags: ["AI", "Agentic Systems", "Software Engineering"]
toc: true
---

<div class="notice--primary" markdown="1">
This article is part of a series on agentic systems:

1. [Agentic systems are struggling to scale (this should feel familiar)](/2026/05/agentic-systems-1-struggling-to-scale)
2. **[Agentic systems are still in the artisanal era](/2026/05/agentic-systems-2-artisanal-era)** 👈
3. [Agentic systems are bound by the same fundamental limits](/2026/05/agentic-systems-3-fundamental-limits)
4. [Artifacts are compression: how systems handle complexity](/2026/05/agentic-systems-4-artifacts-are-compression)
5. [Why all systems become pipelines](/2026/05/agentic-systems-5-why-all-systems-become-pipelines)
6. [Long-lived systems need modularity](/2026/05/agentic-systems-6-long-lived-systems-need-modularity)
7. [Designing agentic systems for engineering organizations](/2026/05/agentic-systems-7-designing-systems)
8. [Writing this series with AI: a postmortem](/2026/05/agentic-systems-8-writing-with-ai-postmortem)
</div>

A great demo is not engineering.

Agentic systems can look convincing right up until they meet real operating conditions.

The layoff reversals from Part 1 made the problem visible: companies automated visible tasks before they engineered the workflow around them.

The field can produce impressive one-off results. What it still lacks, in most cases, is the operating discipline that makes those results repeatable.

## Craft works until it doesn't

Early in any field, systems are built through skill, intuition, and iteration.

They rely on:

* Individual expertise
* Informal workflows
* Trial and error

That is still where agentic systems are.

Success often depends on someone who knows how to phrase prompts, recover from failures, and manually steer execution back on course. That is not yet a robust operating model. It is a skilled operator compensating for missing structure.

Companies that removed humans early ran into exactly that: they mistook operator effort for system design. The hidden coordination work was still there. It only became visible once the system started failing.

## The signs of an artisanal system

You can recognize this stage quickly. The system works, but:

* Results vary depending on who operates it
* Knowledge is implicit instead of encoded
* Recovery is manual instead of built into the workflow
* Scaling requires more intervention instead of more reuse

In engineering terms, the system is not repeatable.

[Anthropic][1] describes the operational root of this problem directly: context is a finite resource, so systems have to decide what to carry forward and what to compress. If that decision still lives in one operator's head, the workflow has not matured.

## The guidance is already shifting

By 2025 and 2026, the official guidance had already moved away from prompt craft as the main design surface.

The shift is from improvisation to workflow engineering:

* [Anthropic][1] calls the problem context engineering: deciding what information the system should carry forward, in what form, and for which next step.
* [OpenAI][2] recommends starting with the simplest agent that can work and only adding more specialization when prompt complexity, tool overload, or task divergence genuinely require it.

Prompt skill should not stand in for the system.

## From craft to engineering

This transition is familiar because every engineering field goes through it.

| Artisanal phase | Engineered phase |
| --- | --- |
| Operator memory | Explicit artifacts |
| Prompt heroes | Defined roles |
| Manual recovery | Validation and repeatable handoffs |

Agentic systems are still early enough that outcomes often depend more on how the workflow is operated than on how it is designed.

That dependence on operation over design is what immaturity looks like, and maturity only makes the next problem easier to see.

## The next pressure

Moving from craft to structure makes a system more repeatable, but it also makes its limits easier to see.

Once work has to move across multiple stages, throughput is set by sequencing, coordination, and the slowest point in the flow.

👉 [Part 3: Agentic systems are bound by the same fundamental limits](/2026/05/agentic-systems-3-fundamental-limits)

[1]: https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents "Effective context engineering for AI agents - Anthropic"
[2]: https://openai.com/business/guides-and-resources/a-practical-guide-to-building-ai-agents/ "A practical guide to building AI agents - OpenAI"
