---
title: Designing agentic systems for engineering organizations
date: 2026-05-01 09:00:00 -0400
description: "A practical operating model for engineering teams using agents: separate planning, execution, evaluation, approval, and rollout with real gates."
tags: ["AI", "Agentic Systems", "Software Engineering"]
toc: true
---

<div class="notice--primary" markdown="1">
This article is part of a series on agentic systems:

1. [Agentic systems are struggling to scale (this should feel familiar)](/2026/05/agentic-systems-1-struggling-to-scale)
2. [Agentic systems are still in the artisanal era](/2026/05/agentic-systems-2-artisanal-era)
3. [Agentic systems are bound by the same fundamental limits](/2026/05/agentic-systems-3-fundamental-limits)
4. [Artifacts are compression: how systems handle complexity](/2026/05/agentic-systems-4-artifacts-are-compression)
5. [Why all systems become pipelines](/2026/05/agentic-systems-5-why-all-systems-become-pipelines)
6. [Long-lived systems need modularity](/2026/05/agentic-systems-6-long-lived-systems-need-modularity)
7. **[Designing agentic systems for engineering organizations](/2026/05/agentic-systems-7-designing-systems)** 👈
8. [Writing this series with AI: a postmortem](/2026/05/agentic-systems-8-writing-with-ai-postmortem)
</div>

The first post in this series opened with layoffs, regret, and rehiring. It also used autopilot as the precedent that matters: automation does not remove the system, it redistributes control inside it.

That is the design problem for engineering organizations.

The goal is not to maximize agent count. It is to place automation where it reduces load without erasing the handoffs, validation, and judgment the organization still needs.

## From diagnosis to operating model

At scale, the unit of design is not the model. It is the workflow the model participates in.

[OpenAI][1] frames agents as systems that accomplish tasks through tools and guardrails, not isolated prompts. [Microsoft's Azure guidance][2] and [Copilot Studio's multi-agent guidance][3] make the same point operationally: keep orchestration simple, validate typed payloads, persist state across stages, and require human approval for high-impact actions.

The same pattern already shows up in [GitHub Copilot's cloud agent flow][4][5]. Research happens first. A plan is formed. Work happens on a branch. Checks run. The diff gets reviewed. Only then does the pull request move forward.

## A concrete operating model

For a feature request that touches API behavior, UI text, tests, and rollout, a workable flow looks like this:

| Stage | Primary actor | Output | Gate |
| --- | --- | --- | --- |
| Planning | Human lead or planning agent | Task packet with scope, constraints, and done definition | Scope review |
| Implementation | Coding agent | Branch diff plus changed-files manifest | Tests and linters |
| Evaluation | Evaluator agent plus CI | Eval bundle with results, risks, and policy checks | Quality threshold |
| Approval | Human reviewer | Pull request decision | Merge approval |
| Rollout | Release automation plus human oversight | Deployment state and rollback path | Production gate |

That shape matters because each stage has a clear responsibility, a clear artifact, and a clear point where the next actor can say no.

The principles that follow are not abstract best practices. They are the places teams usually lose control once agents move past the demo stage.

## Principle 0 — Structure before automation

If the workflow is ambiguous, undocumented, or negotiated ad hoc in chat, agents will not fix it. They will execute the ambiguity faster. [OpenAI's guidance is blunt that "clear instructions reduce ambiguity"][1] and improve agent decision-making.

## Principle 1 — Use the interfaces the organization already understands

Requirements, specs, design docs, diffs, test plans, and approval records already move work between humans. Agent stages should plug into the same interfaces rather than inventing a parallel AI-only process. OpenAI explicitly recommends to ["use existing documents"][1] when defining agent routines.

## Principle 2 — Match orchestration to the shape of the work

Use sequential flow for linear dependencies, specialization only when roles truly diverge, and maker-checker loops where quality is the main problem. Do not choose a pattern because it sounds advanced. Microsoft says to ["use the lowest level of complexity that reliably meets your requirements"][2].

## Principle 3 — Separate planning, execution, and evaluation

One actor can sometimes do more than one role, but the responsibilities should still be distinct. GitHub's cloud agent flow deliberately separates ["research a repository, create a plan, and make code changes on a branch"][5] before review. A system that cannot tell the difference between deciding, doing, and checking will drift.

## Principle 4 — Put validation and approval inside the workflow

Tests are not cleanup. Human review is not a vague fallback. Deterministic checks and approval gates belong at the points where artifacts are produced and irreversible actions become possible. OpenAI argues that [high-risk actions should trigger human oversight][1], and Microsoft goes further by saying to ["require human approvals for high-impact cross-agent actions"][3].

Those stage boundaries are also security boundaries. They let teams limit capabilities, inspect artifacts before granting more power, and avoid giving a context-exposed agent more write access than it needs.

## Principle 5 — Optimize the real constraint, not the busiest stage

If review is slow, improve review. If validation is brittle, improve validation. If context transfer is failing, improve the artifact. More agents do not matter if the bottleneck still sits elsewhere. Microsoft recommends [tracking performance and resource usage metrics for each agent so that you can establish a baseline, find bottlenecks, and optimize][2].

## Principle 6 — Keep humans at the irreversible edges

Aviation absorbed autopilot by redesigning supervision and takeover, not by pretending pilots were obsolete. Walterskirchen's core warning is that ["pilots had been promoted from operators to supervisors of the machine"][6]. Engineering organizations should do the same with merges, production changes, policy decisions, and exception handling.

## Principle 7 — Clarity before speed

Agentic systems don't turn bad systems into good ones. They turn unclear systems into faster chaos. That is the lesson behind the layoffs in Part 1, the throughput limits in Part 3, and the autopilot precedent that runs through the series.

## What durable scale actually looks like

Taken together, the lesson is narrow and unsentimental: agents belong inside engineering organizations as bounded contributors, not as replacements for the organization itself.

They can draft, implement, and evaluate. But they only create durable leverage when handoffs are clear, validation is built in, and humans remain accountable at the irreversible edges.

The systems that scale will not look like autonomous swarms. They will look like disciplined engineering teams with better tools.

That also turned out to be the right way to write about agentic systems in the first place.

👉 [Part 8](/2026/05/agentic-systems-8-writing-with-ai-postmortem) is a postmortem on that process, and on why the writing only became good once it was treated as a system too.

[1]: https://openai.com/business/guides-and-resources/a-practical-guide-to-building-ai-agents/ "A practical guide to building AI agents - OpenAI"
[2]: https://learn.microsoft.com/en-us/azure/architecture/ai-ml/guide/ai-agent-design-patterns "AI agent orchestration patterns - Microsoft"
[3]: https://learn.microsoft.com/en-us/microsoft-copilot-studio/guidance/architecture/multi-agent-patterns "Multi-agent patterns - Microsoft"
[4]: https://docs.github.com/en/copilot/concepts/agents/cloud-agent/about-cloud-agent "About GitHub Copilot cloud agent - GitHub Docs"
[5]: https://docs.github.com/en/copilot/how-tos/use-copilot-agents/cloud-agent/research-plan-iterate "Research, plan, and iterate on code changes with Copilot cloud agent - GitHub Docs"
[6]: https://mwalterskirchen.dev/blog/piloting-agentic-engineering/ "Piloting Agentic Engineering - What Software Engineers Can Learn From The Aviation Industry"
