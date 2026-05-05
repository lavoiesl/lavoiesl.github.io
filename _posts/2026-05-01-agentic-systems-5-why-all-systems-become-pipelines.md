---
title: Why all systems become pipelines
date: 2026-05-01 09:00:00 -0400
description: "Complex, high-stakes work converges on pipelines. Agentic systems need explicit stages, transitions, and outputs once work spans multiple dependent steps."
tags: ["AI", "Agentic Systems", "Software Engineering"]
toc: true
---

<div class="notice--primary" markdown="1">
This article is part of a series on agentic systems:

1. [Agentic systems are struggling to scale (this should feel familiar)](/2026/05/agentic-systems-1-struggling-to-scale)
2. [Agentic systems are still in the artisanal era](/2026/05/agentic-systems-2-artisanal-era)
3. [Agentic systems are bound by the same fundamental limits](/2026/05/agentic-systems-3-fundamental-limits)
4. [Artifacts are compression: how systems handle complexity](/2026/05/agentic-systems-4-artifacts-are-compression)
5. **[Why all systems become pipelines](/2026/05/agentic-systems-5-why-all-systems-become-pipelines)** 👈
6. [Long-lived systems need modularity](/2026/05/agentic-systems-6-long-lived-systems-need-modularity)
7. [Designing agentic systems for engineering organizations](/2026/05/agentic-systems-7-designing-systems)
8. [Writing this series with AI: a postmortem](/2026/05/agentic-systems-8-writing-with-ai-postmortem)
</div>

Pipelines are easy to mistake for bureaucracy until the work actually has to survive multiple stages.

Artifacts only work because pipelines exist.

Not every exploratory task needs one. But once work becomes multi-stage, interdependent, and high-consequence, staged flow stops being optional.

[NASA's systems engineering handbook][1] and [Anthropic's guide on building effective agents][2] describe different domains, but both converge on the same point: scaled work moves through explicit stages with different responsibilities and outputs.

## Why stages appear

Pipelines are not a stylistic choice. They are a response to how complex work behaves.

| Force | Why it creates stages |
| --- | --- |
| Specialization | Different stages need different kinds of reasoning |
| Dependency | Some work cannot begin until earlier decisions exist |
| Risk management | Early stages reduce uncertainty before later stages commit resources |

Those pressures keep reappearing even when the vocabulary changes.

## Convergence across systems

Software delivery moves from planning to design to implementation to testing to deployment. [NASA][1] describes comparable lifecycle stages for systems engineering, while [Anthropic][2] describes workflow patterns such as chaining, routing, orchestrator-workers, and evaluator loops. The vocabulary changes, but the requirement does not: multi-stage work needs explicit transitions.

## The canonical flow

While terminology varies, most systems still look broadly like this:

```mermaid
graph LR
Research --> Planning --> Design --> Implementation --> Testing --> Deployment --> Support
```

Each stage consumes an artifact, transforms it, and emits a new artifact for the next stage.

Pipelines matter because they are not just sequences of tasks. They are coordination mechanisms for turning one usable representation of work into the next.

## Where agentic systems drift

Many agentic systems still ignore this shape.

They rely on:

* A single agent handling multiple stages
* Loosely defined transitions between steps
* Minimal separation between planning and execution

It can look flexible in a demo, but it scales poorly. Work loops, direction drifts, and validation gets deferred.

[Anthropic][2] explicitly recommends simple, composable patterns instead of unnecessary framework complexity for exactly this reason.

## Security is another reason stages appear

Prompt injection makes the security case concrete. [OWASP][3] treats indirect prompt injection as a major risk for systems that read external content and recommends least-privilege access plus human approval for high-risk actions.

That principle should already feel familiar from human systems. [NIST][4] recommends only giving users, or processes acting on their behalf, the least privilege needed for assigned tasks. In practice, a stage that reads broadly from untrusted sources should produce an artifact, not take broad write actions; review happens there, and only later stages get narrower permissions.

## What pipelines still do not solve

A pipeline explains how work moves. It does not explain why that flow survives change.

Stages can be clear and still remain fragile if their meaning lives in one operator, one model, or one transcript. Durability comes from boundaries that can survive changing tools, teams, and requirements.

👉 [Part 6: Long-lived systems need modularity](/2026/05/agentic-systems-6-long-lived-systems-need-modularity)

[1]: https://www.nasa.gov/reference/systems-engineering-handbook/ "Systems Engineering Handbook - NASA"
[2]: https://www.anthropic.com/engineering/building-effective-agents "Building effective agents - Anthropic"
[3]: https://genai.owasp.org/llmrisk/llm01-prompt-injection/ "LLM01:2025 Prompt Injection - OWASP GenAI Security Project"
[4]: https://csrc.nist.gov/glossary/term/least_privilege "Least privilege - NIST Computer Security Resource Center"
