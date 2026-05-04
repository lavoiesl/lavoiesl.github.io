## Task List: Agentic Systems Series Remediation

### P0: Credibility blockers
1. Remove the broken placeholder in part 1 where the autopilot analogy currently says “As described in ,”.
2. Decide whether to keep the autopilot analogy at all.
3. If the autopilot analogy stays, add a real source and tighten the claim so it only covers the shift from execution to monitoring/validation.
4. Audit every external citation across all six posts.
5. Classify each citation as primary, official, secondary, commentary, login-gated, or inaccessible.
6. Replace any citation that is commentary about a primary source when the primary source is available.
7. Remove or rewrite any claim that currently depends on a login-gated source.
8. Remove or rewrite any claim that currently depends on inaccessible or unverifiable pages.
9. Standardize citation style across the full series.
10. Verify that every cited link directly supports the exact nearby claim.

### P0: Unsupported or overstated claims
11. Recheck the “companies reduced engineering and operational roles because they assumed agents could take over the pipeline” claim in part 1.
12. Either add direct evidence for that labor-market claim or soften it substantially.
13. Recheck the “code review is becoming the new bottleneck” claim in part 5.
14. Either replace that example with a stronger source or reframe it as a possible bottleneck rather than a general one.
15. Recheck the “all systems become pipelines” framing in part 3.
16. Add caveats so it does not read as an absolute law across all exploratory or creative domains.
17. Recheck the “industry is shifting from prompt engineering to system design” framing in part 4.
18. Replace weak evidence for that shift with stronger official or research-backed sources.
19. Recheck any quote in part 6 that only supports an adjacent idea, not the exact point being argued.
20. Rewrite any sentence where the claim is stronger than the evidence.

### P0: Core argument support
21. Add citations to part 2.
22. Add citations to part 3.
23. Use the research drafts as the primary evidence reservoir for those two posts.
24. Add support in part 2 for the claim that raw context degrades usefulness.
25. Add support in part 2 for the claim that artifacts are a form of compression.
26. Add support in part 2 for the claim that different roles need different representations.
27. Add support in part 3 for the claim that staged work emerges from specialization.
28. Add support in part 3 for the claim that staged work emerges from dependency structure.
29. Add support in part 3 for the claim that staged work emerges from risk management.
30. Add support in part 3 for the cross-industry convergence argument.

### P1: Narrative spine repairs
31. Strengthen the bridge from part 1 to part 2.
32. Explicitly show why “AI amplifies the system” leads to “structured handoffs matter.”
33. Explicitly show why code-quality drift and coordination failure make artifacts necessary.
34. Strengthen the bridge from part 2 to part 3.
35. Explicitly show why artifacts need a structured flow and not just better documentation.
36. Strengthen the bridge from part 5 to part 6.
37. Explicitly show how Amdahl’s Law and the Theory of Constraints lead to the design principles in part 6.
38. Add a short roadmap in part 1 that names the full series arc.
39. Make each “what comes next” section feel causally necessary, not merely topical.
40. Make the end of part 5 set up design constraints, not just “here is the next post.”
41. Add an explicit diagnosis-to-prescription transition at the start of part 6.

### P1: Remove duplication
42. Identify every repeated argument across parts 2, 3, and 6.
43. Keep the definition of artifacts in part 2.
44. Keep the definition of pipelines in part 3.
45. Keep the practical design application in part 6.
46. Remove repeated claims about role separation where they do not add new evidence.
47. Remove repeated claims about validation where they do not add new evidence.
48. Remove repeated claims about coordination overhead where they do not add new evidence.
49. Identify every repeated constraint argument across parts 5 and 6.
50. Keep the conceptual explanation of serial work and bottlenecks in part 5.
51. Keep only the operational design implications of those limits in part 6.
52. Recheck the whole series after edits to ensure no thesis paragraph is being restated twice.

### P1: Fill reasoning gaps
53. Add a section explaining why artifacts are better than raw-context reinterpretation.
54. Support that explanation with long-context and context-engineering evidence.
55. Add a section explaining what makes an artifact effective beyond “it is structured.”
56. Define the properties of a good handoff artifact more concretely.
57. Add a section explaining what happens when artifacts go stale.
58. Add a section explaining what happens when artifacts are vague.
59. Add a section explaining what happens when downstream roles receive the wrong artifact shape.
60. Add a section explaining the failure modes of planner/implementer/evaluator separation.
61. Add a section explaining how handoffs fail when acceptance criteria diverge.
62. Reconcile the “strong systems come first” principle in part 6 with the series’ broader argument that structure must often be built incrementally.
63. Clarify where simple prompting is still enough.
64. Clarify where artifact and orchestration overhead is justified.
65. Clarify where looser exploratory workflows may work temporarily but scale poorly.

### P1: Strengthen part 4
66. Replace Matchfit as a core source.
67. Replace the Medium article as a core source.
68. Replace the LinkedIn post as a core source.
69. Keep the Springer paper only if it is being used for a narrow, defensible claim.
70. Add stronger official or primary sources for context engineering.
71. Add stronger official or primary sources for simple-vs-complex agent system design.
72. Add stronger official or primary sources for orchestration and evaluation.
73. Rebuild the evidence chain so part 4 feels like an argument about system maturity, not internet trend commentary.

### P1: Strengthen part 5
74. Replace Wikipedia as the primary grounding for Amdahl’s Law.
75. Link to Gene Amdahl’s original paper or an equivalent direct source.
76. Replace Wikipedia as the primary grounding for Brooks / The Mythical Man-Month.
77. Use Brooks more carefully so the analogy supports coordination limits rather than becoming a slogan.
78. Rebuild the bottleneck section with stronger TOC grounding.
79. Make the examples in part 5 clearly illustrative, not universal.
80. Tie the examples back to the real design consequences in part 6.

### P1: Strengthen part 6
81. Decide whether to keep the current eight-principle structure.
82. If the structure stays, make each principle do distinct work.
83. Add one concrete workflow example to part 6.
84. Add one concrete handoff artifact example to part 6.
85. Add one concrete validation flow example to part 6.
86. Add one concrete human-oversight mechanism to part 6.
87. Replace The Verge citation with GitHub’s official Agent HQ post or equivalent official source.
88. Tighten Principle 1 so it is supported by artifact- and handoff-specific evidence, not just tool documentation language.
89. Tighten Principle 2 so role separation is shown as an engineering control, not an org-chart metaphor.
90. Tighten Principle 3 so orchestration is defined in operational terms.
91. Tighten Principle 4 so testing/evals are tied to concrete system checks.
92. Tighten Principle 5 so deployment and feedback loops are tied to real guardrails and review mechanisms.
93. Tighten Principle 6 so modular human-agent collaboration is framed as staged adoption rather than a slogan.
94. Tighten Principle 7 so it clearly inherits the argument from part 5 instead of repeating it.
95. Tighten Principle 8 so it does not sound circular or fatalistic.
96. Make the finale feel like a payoff, not a recap.

### P2: Add real-world grounding
97. Add one concrete failure case where an unstructured agentic system broke down.
98. Make sure that case shows one of the series’ claimed failure modes: drift, duplication, review overload, coordination collapse, or validation failure.
99. Add one concrete success case where structured artifacts or orchestration improved outcomes.
100. Make sure the success case actually illustrates the design being recommended, not just “multi-agent worked.”
101. Add one example where humans remain in the loop for judgment, approval, or exception handling.
102. Add one example where the system deliberately keeps the task simple and avoids unnecessary agent complexity.

### P2: Source upgrades
103. Keep GitClear as the primary source for the code-quality drift discussion if the exact claims remain accurate.
104. Drop DevClass as the main support for those same GitClear claims.
105. Pull stronger lifecycle/process sources into parts 2 and 3 from the research drafts.
106. Pull stronger agent-design and context-engineering sources into parts 4 and 6 from the research drafts.
107. Pull stronger multi-agent failure and framework-evaluation sources into parts 4 and 5 from the research drafts.
108. Pull stronger Amdahl and TOC sources into part 5 from the research drafts.
109. Prefer original papers, official reports, standards, handbooks, and official engineering posts over commentary.
110. Only use secondary sources when primaries are unavailable or when the secondary source is intentionally being cited as commentary.

### P2: Structural polish
111. Recheck the opening and closing paragraph of each post so each one has a single clear job.
112. Make sure part 1 is diagnosis, not partial solution.
113. Make sure part 2 is about artifacts, not pipelines.
114. Make sure part 3 is about pipelines, not artisanal practice.
115. Make sure part 4 is about maturity/discipline, not constraints.
116. Make sure part 5 is about limits, not broad design advice.
117. Make sure part 6 is about design response, not repeated diagnosis.
118. Recheck series navigation blocks in all six posts.
119. Recheck every “Part X” forward link.
120. Recheck every title and subtitle for overlap in meaning.

### Final verification
121. Open every external link after revisions.
122. Confirm every link still resolves to the intended source.
123. Confirm every nearby claim is actually supported by that exact source.
124. Confirm no placeholder text remains anywhere in the series.
125. Confirm no social-post citation remains as the sole support for a substantive claim.
126. Confirm parts 2 and 3 now have adequate citations.
127. Confirm part 6 now contains concrete operational payoff.
128. Confirm duplicated arguments have been removed.
129. Confirm the causal progression across all six posts is now explicit.
130. Confirm the final version still preserves the series’ core thesis while making it more rigorous.
