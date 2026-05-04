---
title: Agentic systems are struggling to scale (this should feel familiar)
date: 2026-05-01 09:00:00 -0400
tags: ["AI", "Agentic Systems", "Software Engineering"]
toc: true
---

<div class="notice--primary" markdown="1">
This article is part of a series on agentic systems:

1. **[Agentic systems are struggling to scale (this should feel familiar)](/2026/05/agentic-systems-1-struggling-to-scale)** 👈
2. [Agentic systems are still in the artisanal era](/2026/05/agentic-systems-2-artisanal-era)
3. [Agentic systems are bound by the same fundamental limits](/2026/05/agentic-systems-3-fundamental-limits)
4. [Artifacts are compression: how systems handle complexity](/2026/05/agentic-systems-4-artifacts-are-compression)
5. [Why all systems become pipelines](/2026/05/agentic-systems-5-why-all-systems-become-pipelines)
6. [Long-lived systems need modularity](/2026/05/agentic-systems-6-long-lived-systems-need-modularity)
7. [Designing agentic systems for engineering organizations](/2026/05/agentic-systems-7-designing-systems)
8. [Writing this series with AI: a postmortem](/2026/05/agentic-systems-8-writing-with-ai-postmortem)
</div>

---

The agents work. The system fails.

That is the pattern showing up across companies that tried to turn AI into a headcount strategy instead of a systems strategy.

Between 2023 and 2026, executives cut teams on the assumption that AI could absorb large parts of the workflow. The reversal came fast. [Forbes][1] and [Human Resources Director][2], both drawing on the same rehiring pattern, point to the same outcome: companies tried to remove a workflow and discovered they had only removed the people holding it together. Careerminds survey data cited by HRD reports that **two-thirds of companies are already rehiring roles they cut for AI**. More than half said the rehiring began within six months.

[TechRepublic][3] reports that **55% of companies now regret AI-driven layoffs**. [Computerworld][4], summarizing Forrester, adds the missing diagnosis: too often management laid people off based on **the future promise of AI**, not on proven capability inside a working system.

This is the important point:

> The industry is not struggling because AI is weak, it's because systems were removed faster than they could be replaced.

AI did not remove the system. It accelerated it until the weak parts became impossible to ignore.

## The first public failures are already here

Klarna became the clearest public example. Its leadership said AI was handling work equivalent to roughly **700 customer service agents**, and the move was framed as evidence that replacement at scale had arrived. But as [Digital Applied's Klarna analysis][5] summarizes, the routine volume held while customer satisfaction fell on the complex interactions that actually required judgment, escalation, and trust. Klarna then shifted back toward rehiring and a hybrid model.

That is not an isolated story. It is the same system failure in a more visible form.

| Local gain | System failure |
| --- | --- |
| AI handled routine volume | Quality dropped on edge cases |
| Staffing costs looked lower on paper | Rehiring and correction costs erased savings |
| Output arrived faster | Judgment, escalation, and accountability became the constraint |

The failure is easy to misread. The models did useful work. The diagnosis was wrong.

Companies removed the human layer that interpreted ambiguity, handled exceptions, and preserved continuity across the workflow. Once that layer was gone, the system degraded.

## The wrong conclusion

The easy conclusion is that the models still are not capable enough.

That misses the failure mode.

The failure is not in the agent. It is in the system it operates in.

What broke first was the control layer around the agent: intent definition, handoffs, validation, and exception handling.

## The real problem is coordination

The same pattern shows up in engineering teams building agentic systems.

An agent can write a function. It can scaffold something meaningful.

But ask it to help ship a real feature, one that spans research, design, implementation, testing, and rollout, and the surrounding system starts to break down.

That happens because agentic systems today often:

* Pass too much raw context
* Blur roles between planning and execution
* Lack clear handoffs and validation

Those failures are connected. When work is passed forward as raw context instead of as a structured handoff, every downstream step has to reinterpret intent, constraints, and success criteria for itself. Local work speeds up, but system throughput does not improve.

This is not a model problem. It is a coordination problem.

## The deeper pattern: learning from autopilot

As [Maximilian Walterskirchen's essay on piloting agentic engineering][6] argues, autopilot did not simplify aviation. It forced the system around the cockpit to become more explicit.

Pilots were not removed from the loop. Their role shifted toward supervision, intervention, and takeover when automation no longer fit the situation. The new risk appeared at the handoff back to the human.

> Automation does not remove the system. It shifts control within it.

That is the same structural change happening in software organizations. Agents do more local work, but the surrounding system still has to decide when to delegate, what to pass forward, how to validate results, and where human judgment remains necessary.

AI is not failing. Systems are failing under acceleration.

## The key insight: AI amplifies the system

The [2025 DORA report][7] names the principle directly: **"AI is an amplifier, not a fix."** Faster drafting does not repair unclear ownership, brittle reviews, or weak validation. It exposes them.

That is why the recurring debate about smarter models misses the main constraint.

The real question is not:

> How do we make agents smarter?

It is:

> How do we structure systems so intelligence can scale without losing control?

This series argues that agentic systems are not an AI problem, but a systems engineering problem.

## The next question

If faster agents still yield brittle systems, the problem is not a lack of intelligence. It is that too much of the work is still being held together by operators compensating in real time.

So the next step is not to jump straight to architecture diagrams. It is to understand the maturity of the field itself, and why so many systems still depend on craft more than design.

👉 [Part 2: Agentic systems are still in the artisanal era](/2026/05/agentic-systems-2-artisanal-era)

[1]: https://www.forbes.com/councils/forbestechcouncil/2026/04/24/why-companies-regret-laying-off-workers-for-ai/ "Why Companies Regret Laying Off Workers For AI - Forbes"
[2]: https://www.hcamag.com/ca/news/general/businesses-rush-to-rehire-staff-after-regretted-ai-driven-cuts/568293 "Businesses rush to rehire staff after regretted AI-driven cuts - Human Resources Director"
[3]: https://www.techrepublic.com/article/news-leaders-regret-ai-driven-layoffs/ "'We Acted Too Quickly': Over Half of Companies Regret AI-Driven Layoffs, Report Finds - TechRepublic"
[4]: https://www.computerworld.com/article/4084372/analysts-companies-will-face-setbacks-after-ai-layoffs.html "Forrester: Companies regret many AI-related layoffs - Computerworld"
[5]: https://www.digitalapplied.com/blog/klarna-reverses-ai-layoffs-replacing-700-workers-backfired "Klarna Reverses AI Layoffs: Why Replacing 700 Failed - Digital Applied"
[6]: https://mwalterskirchen.dev/blog/piloting-agentic-engineering/ "Piloting Agentic Engineering - What Software Engineers Can Learn From The Aviation Industry"
[7]: https://www.thoughtworks.com/insights/reports/the-2025-dora-report "The 2025 DORA report - Thoughtworks"
