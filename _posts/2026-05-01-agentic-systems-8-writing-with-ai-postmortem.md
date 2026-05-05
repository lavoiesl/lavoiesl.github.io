---
title: "Writing this series with AI: a postmortem"
date: 2026-05-01 09:00:00 -0400
description: "A postmortem on writing this series with AI: what structure, artifacts, review loops, and manual judgment actually contributed, and where the models failed."
tags: ["AI", "Agentic Systems", "Software Engineering", "Writing", "Series"]
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
7. [Designing agentic systems for engineering organizations](/2026/05/agentic-systems-7-designing-systems)
8. **[Writing this series with AI: a postmortem](/2026/05/agentic-systems-8-writing-with-ai-postmortem)** 👈
</div>

This series was mostly written with AI assistance.

I want to say that plainly because pretending otherwise would be silly. What feels more worth saying is that the parts that work did not come from some perfect prompt. They came from turning a messy writing process into something more structured: plans, artifacts, review passes, explicit roles, and a lot of manual correction when the drafts drifted or sounded wrong.

That felt worth writing down. If the series has a useful point, I more or less learned it while writing it: AI was helpful, but only after I gave it a system to work inside.

## The workflow

I did not get here by asking for seven finished essays and polishing the result. The process was much more iterative. [Microsoft Research describes LLM-assisted writing as a process where users "actively refine, explore, and co-construct text"][1], which feels close to what happened here.

| Phase | Primary tool | Output | What mattered most |
| --- | --- | --- | --- |
| Discovery | ChatGPT voice chat | Raw ideas, tensions, candidate directions | Speed and breadth |
| Architecture | ChatGPT plus manual synthesis | High-level plan, narrative spine, article map | Coherence |
| Evidence | ChatGPT deep research plus manual triage | Source list, prior art, examples | Source quality |
| Persistence | Markdown repository | Plans, research notes, article briefs | Stable artifacts |
| Drafting | Copilot | Initial article drafts | Throughput |
| Review | Copilot plus manual critique | Gap analysis, rewrite targets, defect patterns | Judgment |

ChatGPT handled discovery, planning, and source gathering. Copilot handled the file-based drafting and review loops. My part was to keep cutting weak sources, fixing tone, and deciding what survived.

In practice the loop was simple:

1. Use ChatGPT to brainstorm, outline, and gather sources.
2. Turn that into article plans and stable files in the repo.
3. Use Copilot to draft and review against those files.
4. Manually rewrite the parts that still felt weak, generic, or unsupported.

That separation mattered more than the specific tools.

## What actually made it work

What made it work was structure, artifacts, and iteration.

[OpenAI argues that customers "typically achieve greater success with an incremental approach"][2]. That is a better description of the workflow than any story about fully autonomous generation.

Moving the work out of chat and into plans, briefs, and drafts made it easier to keep the argument stable. Once those artifacts existed, the models had something concrete to work against instead of a fading conversational context.

The useful skill ended up being learning how to inspect output, identify the failure mode, and redirect the next pass without reopening the whole problem.

Most of the quality still came from manual judgment: rejecting obscure sources, removing citation clutter, rewriting robotic transitions, and cutting sections that sounded tidy but dead. That is probably the part people underestimate most when they talk about AI-assisted writing.

## Where the models struggled

The hardest failures were structural rather than grammatical or obviously hallucinatory.

The models were prone to soft argument drift: flattening distinctions, overexplaining points that had already been made, or turning a causal sequence into a list of adjacent observations. That showed up most clearly in endings and transitions, which often sounded like mini summaries instead of the next step in an argument.

They were also too willing to keep weak evidence if it fit the paragraph: obscure sources, repetitive links, or claims that sounded supported until the source was inspected closely.

And then there was the prose itself. It could look polished while still feeling generic. [The literature review paper on AI-assisted writing warns that "LLM outputs always appear at first glance to be well written, well informed and thought out, but closer reading reveals gaps, biases and lack of depth"][4]. That matches my experience almost exactly.

The uncomfortable part is that the workflow depended on me being able to notice those problems. If I could not tell when a source was weak or a section had subtly drifted, the process would have produced something smoother and worse.

## What I would do differently next time

The most useful part of the postmortem for me is what I would change next. The series got to a result that I like, but not efficiently.

### 1. Lock the constraints and artifacts earlier

I would define the thesis, source bar, stylistic anti-patterns, and review rubric much sooner. I would also create a claim map and source map for each article before drafting begins. A lot of the late-stage editing came from discovering those constraints too late.

### 2. Separate review and measure it

Too many prompts tried to fix everything at once. Next time I would separate factual review, structural review, prose review, and citation review. I would also track time per article, major rewrite passes, source replacements, and human editing time after the first draft. Without that, it is easy to say AI made the process faster and much harder to say where it actually did.

### 3. Encode the recurring roles into the system

I kept rediscovering the same roles in ad hoc prompts: series architect, source triage reviewer, article planner, structural critic, style enforcer, citation hygiene reviewer. Next time I would codify some of those into reusable skills or specialized agents with clearer contracts.

[OpenAI's guidance is to "maximize a single agent's capabilities first"][2], so I would still start small. But [GitHub's documentation notes that "you can create specialized custom agents for different tasks"][3], and that seems like the right direction for work that keeps repeating the same evaluation patterns.

[GitHub also puts this plainly: "The more Copilot cloud agent knows about the code in your repository, the tools you use, and your coding standards and practices, the more effective it will become"][3]. The writing equivalent is straightforward: the more the system knows about source quality, tone, formatting preferences, and the series spine, the less time gets wasted rediscovering them.

## The process proved the thesis

The series argued that agentic systems do not scale because of intelligence alone. They scale when work is decomposed into artifacts, pipelines, interfaces, and validation loops.

The writing process followed the same pattern. Publishable essays came from structured plans, stable artifacts, repeated review loops, and human intervention rather than one-shot generation.

The [literature review paper is even harsher on this point, warning that "a press-button strategy leaving AI to do the work is a recipe for disaster"][4]. That is exactly right. The more autonomous the drafting looked, the more human the editing had to become.

This also speaks about the immaturity of my writing process. I managed to get by because it was only a few articles, but it would definitely not scale to something like a multi-chapter book without the improvements above.

So if there is one lesson I would keep from this process, it is this: AI did not replace the writing system. It made the writing system more necessary.

[1]: https://www.microsoft.com/en-us/research/publication/prototypical-human-ai-collaboration-behaviors-from-llm-assisted-writing-in-the-wild/ "Prototypical Human-AI Collaboration Behaviors from LLM-Assisted Writing in the Wild - Microsoft Research"
[2]: https://openai.com/business/guides-and-resources/a-practical-guide-to-building-ai-agents/ "A practical guide to building agents - OpenAI"
[3]: https://docs.github.com/en/copilot/concepts/agents/cloud-agent/about-cloud-agent "About GitHub Copilot cloud agent - GitHub Docs"
[4]: https://arxiv.org/abs/2603.20235 "Writing literature reviews with AI: principles, hurdles and some lessons learned"