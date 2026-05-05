---
title: "Artifacts are compression: how systems handle complexity"
date: 2026-05-01 09:00:00 -0400
description: "Artifacts compress complexity for the next stage. Specs, PRDs, test plans, and release evidence keep agentic systems from passing raw context downstream."
tags: ["AI", "Agentic Systems", "Software Engineering"]
toc: true
---

<div class="notice--primary" markdown="1">
This article is part of a series on agentic systems:

1. [Agentic systems are struggling to scale (this should feel familiar)](/2026/05/agentic-systems-1-struggling-to-scale)
2. [Agentic systems are still in the artisanal era](/2026/05/agentic-systems-2-artisanal-era)
3. [Agentic systems are bound by the same fundamental limits](/2026/05/agentic-systems-3-fundamental-limits)
4. **[Artifacts are compression: how systems handle complexity](/2026/05/agentic-systems-4-artifacts-are-compression)** 👈
5. [Why all systems become pipelines](/2026/05/agentic-systems-5-why-all-systems-become-pipelines)
6. [Long-lived systems need modularity](/2026/05/agentic-systems-6-long-lived-systems-need-modularity)
7. [Designing agentic systems for engineering organizations](/2026/05/agentic-systems-7-designing-systems)
8. [Writing this series with AI: a postmortem](/2026/05/agentic-systems-8-writing-with-ai-postmortem)
</div>

Once a system has real bottlenecks, handoffs stop being optional paperwork because downstream stages are constrained.

If a downstream stage has to keep rereading and reinterpreting everything upstream, the bottleneck has not gone away. It has simply moved.

As systems grow, the amount of available information grows faster than the ability to process it. [Pinecone][1] notes that even long-context models suffer from the lost-in-the-middle problem, where buried information gets missed. [Anthropic][2] turns that into an operating rule: context is finite, so systems should pass forward the smallest set of high-signal tokens rather than the whole transcript.

If your system depends on full context, it is already broken.

## Artifacts are compression

Complex systems do not pass raw information forward; they compress it into artifacts.

Healthy delivery systems already do this. [Atlassian's PRD guide][3] describes the PRD as a single source of truth for purpose, features, user needs, and success criteria. The same logic applies to specs, designs, test plans, and release evidence.

| Artifact | What it preserves |
| --- | --- |
| Product requirements document | Purpose, user needs, and success criteria |
| Specification or design doc | Constraints, interfaces, and decisions |
| Test plan | What must be validated before release |
| Diff and release evidence | What changed and how to verify it |

These are not documentation extras. They are the interfaces that keep downstream work from rediscovering upstream intent.

## Compression and expansion

Artifacts move through a recurring pattern: each stage expands the current artifact through research, planning, or execution, then recompresses the result into something the next stage can actually use.

* Research turns raw signals into a problem framing
* Product framing turns that into requirements
* Design turns requirements into concrete solutions
* Engineering turns solutions into code, tests, and release evidence

[IBM's traceability guidance][4] shows how that flow stays coherent: requirements, implementation, and test artifacts remain linked so downstream stages can work from the current artifact instead of the entire upstream discussion.

## What makes an artifact effective

Artifacts only reduce coordination cost if they are designed well.

| Property | Why it matters |
| --- | --- |
| Lossy but intentional | They preserve what matters for the next step |
| Role-specific | Different stages need different representations |
| Structured | Consistency makes them easy to consume and validate |
| Traceable | Later stages can verify they still satisfy earlier intent |

Without these properties, the handoff degrades back into raw context.

## Where agentic systems go wrong

Many agentic systems still rely on large prompts with mixed context, loosely structured outputs, and a single agent spanning multiple roles.

That removes the structure [Anthropic][2] recommends: compact context, explicit compaction, and clear boundaries around what each step should receive. It asks each stage to recover intent from a transcript instead of receiving a handoff that already encodes the objective, constraints, and output shape.

The result is predictable: outputs drift, reasoning repeats, and ambiguity moves downstream.

## Why this still is not enough

A good artifact reduces ambiguity, but by itself it is only a local act of compression.

It becomes operational only when there is an ordered flow of stages that know when to expand it, when to validate it, and when to pass it on. Without that structure, even good documents stay inert.

👉 [Part 5: Why all systems become pipelines](/2026/05/agentic-systems-5-why-all-systems-become-pipelines)

[1]: https://www.pinecone.io/learn/chunking-strategies/ "Chunking Strategies for LLM Applications - Pinecone"
[2]: https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents "Effective context engineering for AI agents - Anthropic"
[3]: https://www.atlassian.com/agile/product-management/requirements "What is a product requirements document? - Atlassian"
[4]: https://www.ibm.com/docs/en/engineering-lifecycle-management-suite/doors-next/7.2.0?topic=requirements-traceability "Requirements traceability - IBM"
