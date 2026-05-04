---
title: Long-lived systems need modularity
date: 2026-05-01 09:00:00 -0400
description: "Long-lived agentic systems need modularity: explicit interfaces, stable handoffs, and local change boundaries that survive new tools, models, and teams."
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
6. **[Long-lived systems need modularity](/2026/05/agentic-systems-6-long-lived-systems-need-modularity)** 👈
7. [Designing agentic systems for engineering organizations](/2026/05/agentic-systems-7-designing-systems)
8. [Writing this series with AI: a postmortem](/2026/05/agentic-systems-8-writing-with-ai-postmortem)
</div>

Pipelines explain how complex work moves. They do not explain what lets a system survive change.

That is what modularity is for.

Long-lived systems need modularity because tools change, models change, teams change, and workflows still have to keep working.

> You cannot modularize what is not already structured.

If the stages, handoffs, and responsibilities are still ambiguous, there is nothing stable to make replaceable.

## Modularity is survivability

A pipeline can be clear and still be fragile.

If planning logic lives in one operator's head, if approval criteria only exist in one long transcript, or if recovery depends on one coordinating agent, the workflow cannot absorb change.

| Without modularity | With modularity |
| --- | --- |
| Changing one tool destabilizes the whole workflow | Components can change behind stable interfaces |
| Knowledge is trapped in one actor or session | Knowledge is carried in explicit handoffs |
| Failures spread across the system | Blast radius stays local |

Bus-factor problems are really design problems. The risk is not merely that someone leaves. The risk is that the workflow was never encoded in a form the rest of the system could reuse.

## Good boundaries localize change

Good modularity means small, substitutable parts with a clean separation between interface and implementation.

The key question is not whether the boxes are large or small. It is whether change stays local.

A good boundary lets you replace one part without forcing the rest of the system to rediscover intent, state, or operating rules. A bad boundary only redraws the diagram while the real coupling remains hidden underneath.

## Aviation solved this at the handoff

Part 1 pointed to the aviation version of this problem.

As [Maximilian Walterskirchen][1] points out, autopilot did not remove pilots from the system. It changed the interface between automation, procedure, and human takeover. Aviation became safer because the system learned to formalize when automation should lead, when humans should re-enter, and how that handoff should happen.

Long-lived agentic systems need the same discipline. When a model changes, a tool fails, or a task falls outside the expected path, the workflow needs a stable takeover point rather than a hidden dependency on one giant prompt.

## Real systems already optimize for replaceable interfaces

The most useful current examples are not theoretical.

| System example | Stable interface |
| --- | --- |
| GitHub Copilot cloud agent | Plan, branch diff, checks, and pull request are explicit handoff objects [2][3] |
| Microsoft agent orchestration guidance | Typed payloads, persisted state, evaluator loops, and human approvals keep stages replaceable [4] |
| OpenAI's agent guidance | Start single-agent, then add specialization only when the task shape actually demands a new boundary [5] |

These systems do not scale by hiding more state inside the model. They scale by making interfaces explicit enough that one stage can evolve without collapsing the others.

## What modularity buys you

In practice, modularity buys three things.

* Replaceability: one evaluator, planner, or model can change without rewriting the whole workflow.
* Evolvability: the system can adopt better tools gradually instead of through all-or-nothing rewrites.
* Long-term stability: humans can still inspect, resume, and correct the workflow because the state lives in artifacts and contracts.

Automation makes modularity more valuable, not less.

## The final design question

Once the boundaries are clear enough to survive change, the remaining problem is organizational.

Who plans, who executes, who checks, and where should judgment stay human? That is the last step in the argument, because modularity only matters if it can be turned into a real operating model.

👉 [Part 7: Designing agentic systems for engineering organizations](/2026/05/agentic-systems-7-designing-systems)

[1]: https://mwalterskirchen.dev/blog/piloting-agentic-engineering/ "Piloting Agentic Engineering - What Software Engineers Can Learn From The Aviation Industry"
[2]: https://docs.github.com/en/copilot/concepts/agents/cloud-agent/about-cloud-agent "About GitHub Copilot cloud agent - GitHub Docs"
[3]: https://docs.github.com/en/copilot/how-tos/use-copilot-agents/cloud-agent/research-plan-iterate "Research, plan, and iterate on code changes with Copilot cloud agent - GitHub Docs"
[4]: https://learn.microsoft.com/en-us/azure/architecture/ai-ml/guide/ai-agent-design-patterns "AI agent orchestration patterns - Microsoft"
[5]: https://openai.com/business/guides-and-resources/a-practical-guide-to-building-ai-agents/ "A practical guide to building AI agents - OpenAI"