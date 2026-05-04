# Part 8 Plan: How I Wrote This Series With AI

## Working title options

1. How I wrote this series with AI
2. The postmortem: writing a series about agentic systems with agentic tools
3. This series was mostly AI-assisted. That is not the interesting part.
4. The writing process proved the thesis

---

## What this article should do

This piece should not read like a novelty disclosure, a tool review, or a defensive justification.

It should read like a postmortem.

The article has four jobs:

1. Acknowledge plainly that the series was heavily AI-assisted.
2. Explain the actual workflow in enough detail to be useful.
3. Show that the process only worked once it became structured, staged, and artifact-driven.
4. Reflect on what I would change next time to reach the same quality faster.

The key move is to make the process itself an example of the series thesis.

---

## Core thesis

The central claim for Part 8 should be:

> The interesting part is not that AI helped write the series. The interesting part is that the writing only became good once the work was turned into a system: plans, artifacts, review loops, explicit roles, and human judgment at the irreversible edges.

Supporting claims:

1. AI accelerated exploration, drafting, and revision.
2. AI did not automatically produce coherence, quality, or taste.
3. The biggest gains came from structure, not model cleverness.
4. The final quality came from repeated human editorial correction.
5. The writing workflow ended up mirroring the argument of the series itself.

---

## Narrative spine

The article should move through this sequence:

1. Direct disclosure
2. Reframe the real lesson
3. Walk through the pipeline that emerged
4. Show what worked and why
5. Show what failed and why
6. Explain what would have reached the outcome faster
7. Close by linking the process back to the thesis of the series

The article should feel less like “here are the tools I used” and more like “here is the system I accidentally built.”

---

## Detailed section plan

## 1. Opening: say it plainly

### Goal

Establish trust quickly. Do not bury the disclosure.

### What to say

- This series was mostly written with AI assistance.
- ChatGPT helped with brainstorming and research.
- Copilot handled most of the drafting and revision loops.
- But the method matters more than the percentage.

### Desired effect

Readers should feel that the article is candid and precise, not evasive or theatrical.

### Opening angle

Use a sentence like:

> This series was largely AI-assisted, but the surprising part is not that the tools could generate prose. It is that the prose only became worth keeping once the work was turned into a structured system.

---

## 2. Reframe: this was not one-shot generation

### Goal

Kill the naive picture early.

### What to say

- I did not ask one model for seven finished essays.
- The process became a multi-stage human-AI workflow.
- The system had distinct phases: ideation, structuring, research, drafting, critique, and refinement.

### Reflection to merge from both notes

- From the ChatGPT note: name this as a pipeline and as orchestration.
- From the Copilot note: stress that quality emerged only after persistent artifacts and explicit review loops.

### Key line to build toward

> I was not using AI as a ghostwriter. I was building a pipeline that let different models do different kinds of work under constraint.

---

## 3. Explain the actual workflow in order

### Goal

Give the reader a concrete process they can inspect.

### Section structure

Break this into five short subsections.

### 3.1 Discovery

- Brainstorm with ChatGPT voice chat.
- Explore the problem until the interesting tension becomes visible.
- Explain why voice was useful: low-friction exploration before the shape of the series existed.

### 3.2 Architecture

- Rewrite the raw ideas into a coherent high-level plan.
- Identify the narrative spine.
- Split the topic into article-sized units.
- Write one plan per article.

### 3.3 Evidence

- Use deep research to find prior art.
- Gather more sources than needed.
- Rank sources by usefulness, not just availability.
- Reject weak and obscure sources even if they technically support the point.

### 3.4 Artifacts and persistence

- Move the high-level plan, research notes, and per-article briefs into a markdown repository.
- Explain why that mattered: ideas stopped living in chat history and became inspectable artifacts.

### 3.5 Drafting and review

- Use Copilot to draft the posts.
- Use AI to review for duplication, weak arguments, unsupported claims, poor transitions, and structural drift.
- Manually identify repeated failure patterns and force revisions.
- Repeat until acceptable.

### Critical interpretation

This is where the article should say explicitly:

> The important shift was not “AI wrote the article.” The important shift was that the writing process became decomposed into stages with stable inputs and outputs.

---

## 4. What actually made the process work

### Goal

Extract the principles, not just the chronology.

### Subsection A: Role separation

- ChatGPT as ideation partner
- ChatGPT deep research as source scout
- Copilot as drafter and reviser
- AI review as structural critic
- Human as editor, architect, and quality gate

Make the point that role separation worked better than using one undifferentiated assistant for everything.

### Subsection B: Artifacts

- high-level plan
- narrative spine
- article briefs
- markdown drafts
- review notes

Call them artifacts explicitly.

### Subsection C: Iteration over prompting

- The process succeeded because of revision loops, not a perfect prompt.
- The useful skill was evaluation and redirection.

### Subsection D: Governance

- quality gates were manual
- source quality had to be enforced
- tone had to be corrected repeatedly
- formatting had to be curated

### Best synthesis sentence

> The system worked because I kept turning fuzzy conversation into explicit artifacts, then forcing each later stage to operate on those artifacts instead of improvising from scratch.

---

## 5. Where AI failed

### Goal

Show the reader that the real problems were deeper than cosmetic glitches.

### Subsection A: Structural errors

- argument drift
- weak transitions
- flattened distinctions
- inversion of cause and effect
- plausible but weakly supported claims

Use the line:

> The hardest errors were structural, not stylistic.

### Subsection B: Source quality failures

- obscure sources
- low-value citations
- technically relevant but rhetorically useless links
- tendency to keep bad evidence if it fits the sentence

### Subsection C: Generic prose

- robotic cadence
- repeated sentence shapes
- overuse of tidy summaries
- safe but lifeless phrasing

### Subsection D: Operator dependence

- the workflow only worked because I could tell when the argument was getting weaker
- the system depends heavily on domain knowledge and editorial taste

### Best synthesis sentence

> The models were good at producing text that looked finished. They were much less reliable at producing argument that actually was finished.

---

## 6. What I would do differently to reach the outcome faster

### Goal

This is the most useful section. It should be concrete and operational.

### 6.1 Lock constraints earlier

- freeze the thesis sooner
- define the source bar before drafting
- write the stylistic anti-patterns at the start
- define what counts as a good transition, a good citation, and a good closing

### 6.2 Add explicit planning artifacts

Create these before drafting begins:

- claim map per article
- source map per article
- list of non-negotiable narrative beats
- anti-pattern checklist
- final review rubric

### 6.3 Separate review types earlier

Do not mix everything into one revision prompt.

Use separate passes for:

- factual support
- structure and logic
- prose and tone
- citations and formatting

### 6.4 Measure the workflow

Track:

- time spent per article
- number of full rewrite passes
- number of source swaps
- human editing time after first draft
- recurring defect categories

### 6.5 Write reusable AI skills for the roles

This is the most important addition beyond the current two notes.

The faster path next time would be to codify the recurring roles into reusable skills instead of rediscovering the same instructions during each pass.

#### Recommended initial skill set

1. `series-architect`
   - when to use: turning a broad topic into a narrative spine and article map
   - inputs: thesis, audience, article count, non-goals
   - outputs: spine, section map, forward progression checks

2. `source-triage`
   - when to use: ranking sources by credibility, relevance, rhetorical value, and redundancy
   - outputs: keep / maybe / reject list and reason for each

3. `article-planner`
   - when to use: converting a series spine into one article brief with claims, evidence, and transitions
   - outputs: article plan with sections, target examples, and risks

4. `structural-critic`
   - when to use: reviewing a draft for duplication, weak logic, inversion, poor transitions, and drift from thesis
   - outputs: findings-first critique, not rewritten prose

5. `style-enforcer`
   - when to use: checking for robotic tone, repetitive cadence, over-short sentences, summary-bot endings, and generic phrasing
   - outputs: concrete rewrite guidance with examples

6. `citation-hygiene`
   - when to use: removing low-value links, replacing weak sources, and converting trailing anchors into earned inline citations
   - outputs: keep / cut / inline-quote recommendations

#### Important design note

Do not start with ten skills.

The faster path is probably:

1. one strong planning skill
2. one strong review skill
3. one citation/style cleanup skill

Then split further only if the review prompts become overloaded.

This keeps the workflow aligned with the more defensible guidance from OpenAI: start simple, then divide roles when complexity actually demands it.

### 6.6 Keep a defect log from the first article onward

Every time a recurring failure appears, add it to a standing list.

Examples:

- avoid obscure sources when stronger reporting exists
- no table-of-contents transitions
- no neat-but-empty section endings
- no short staccato cadence for serious analytical sections
- no citation clusters that add no argumentative value

This turns frustration into system memory.

---

## 7. The meta-insight: the process mirrored the thesis

### Goal

This is the real closing argument.

### What to say

- The series argued that agentic systems scale only when work is decomposed into artifacts, stages, and validation loops.
- The writing process followed the same rule.
- One-shot generation did not produce publishable results.
- Plans, artifacts, review gates, and human intervention did.

### Strong closing line candidate

> The way I wrote this series turned out to be the best evidence for the series itself: AI did not replace the system. It became useful only once it was placed inside one.

---

## Tone guidance

The article should sound:

- candid
- unsentimental
- technically reflective
- specific about failure
- not defensive

Avoid:

- boosterism
- anti-AI panic
- tool tribalism
- vague claims about productivity without evidence
- percentage games about authorship

---

## Sources to use in the published article

Use the stronger sources below. The ChatGPT note had useful reflections, but some of its suggested support came from weaker writing-advice sites. For the published article, prefer the sources in this section.

### Quote 1: Human-AI collaboration is iterative, not passive

> "Rather than passively accepting output, users actively refine, explore, and co-construct text."

Use for:

- supporting the claim that the real skill was iterative steering, not one-shot prompting
- validating the description of the workflow as co-construction

Source: [Microsoft Research on LLM-assisted writing][1]

### Quote 2: Incremental approaches work better than jumping to full autonomy

> "Customers typically achieve greater success with an incremental approach."

Use for:

- supporting the claim that the workflow improved when it became staged rather than fully generative
- supporting the argument that the faster path next time should still begin with a simple system

Source: [OpenAI, A practical guide to building agents][2]

### Quote 3: Only split roles when complexity actually demands it

> "Our general recommendation is to maximize a single agent's capabilities first."

Use for:

- framing the counterfactual section about skills and specialized roles
- arguing against premature over-orchestration

Source: [OpenAI, A practical guide to building agents][2]

### Quote 4: Specialized roles are legitimate when the task really differs

> "You can create specialized custom agents for different tasks."

Use for:

- supporting the proposal to codify recurring writing roles into skills or specialized agents
- connecting the retrospective to a practical next iteration of the workflow

Source: [GitHub Docs, About Copilot cloud agent][3]

### Quote 5: AI output looks finished before it is finished

> "LLM outputs always appear at first glance to be well written, well informed and thought out, but closer reading reveals gaps, biases and lack of depth."

Use for:

- supporting the section on structural failures
- supporting the claim that evaluation was harder than generation

Source: [Writing literature reviews with AI: principles, hurdles and some lessons learned][4]

### Quote 6: One-button automation is the wrong mental model

> "A press-button strategy leaving AI to do the work is a recipe for disaster."

Use for:

- punctuating the section on what did not work
- rejecting the one-shot generation framing

Source: [Writing literature reviews with AI: principles, hurdles and some lessons learned][4]

### Quote 7: Repository knowledge and instructions improve effectiveness

> "The more Copilot cloud agent knows about the code in your repository, the tools you use, and your coding standards and practices, the more effective it will become."

Use for:

- supporting the idea that reusable skills, instructions, and persistent artifacts would have made the writing workflow faster on later passes
- connecting skills to memory and system design rather than to mere prompting

Source: [GitHub Docs, About Copilot cloud agent][3]

---

## Suggested source handling

For the article itself:

- Use Microsoft Research and the arXiv paper as the primary support for the reflective claims about collaboration and failure.
- Use OpenAI and GitHub docs to support the “what I would do differently next time” section about roles, specialization, and incremental system design.
- Avoid relying on weaker blog-style writing-advice sources in the published piece unless a stronger source is unavailable.

---

## Candidate structure for the final article

Approximate structure:

1. Opening disclosure
2. Why that is not the interesting part
3. The pipeline I ended up building
4. What actually made it work
5. Where the models failed
6. What I would do differently next time
7. Why this proved the thesis of the series

Estimated length:

- 1,600 to 2,300 words

That is long enough to be useful and short enough not to feel like an appendix.

---

## One-paragraph summary of the plan

Part 8 should present the series as a case study in human-AI orchestration. It should acknowledge the heavy AI assistance, explain the pipeline that emerged, argue that structure mattered more than raw generation, show the recurring failure modes that required human correction, and end by reflecting that the process itself validated the thesis of the series. The counterfactual section should explain how the same result could have been reached faster by introducing constraints earlier, separating review passes sooner, tracking defects and metrics, and codifying recurring roles into reusable skills.

[1]: https://www.microsoft.com/en-us/research/publication/prototypical-human-ai-collaboration-behaviors-from-llm-assisted-writing-in-the-wild/ "Prototypical Human-AI Collaboration Behaviors from LLM-Assisted Writing in the Wild - Microsoft Research"
[2]: https://openai.com/business/guides-and-resources/a-practical-guide-to-building-ai-agents/ "A practical guide to building agents - OpenAI"
[3]: https://docs.github.com/en/copilot/concepts/agents/cloud-agent/about-cloud-agent "About GitHub Copilot cloud agent - GitHub Docs"
[4]: https://arxiv.org/abs/2603.20235 "Writing literature reviews with AI: principles, hurdles and some lessons learned"