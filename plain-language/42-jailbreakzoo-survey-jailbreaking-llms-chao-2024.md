JailbreakZoo: A Map of How People Break Chatbots

Paper: JailbreakZoo: Survey, Landscapes, and Horizons in Jailbreaking LLMs (2024)

## Introduction: The Cat‑and‑Mouse of Safety
Once chatbots met the public, creative users—and adversaries—started pushing boundaries. “Jailbreaks” are prompts that bypass safety rules to elicit restricted outputs. JailbreakZoo surveys the space, cataloguing techniques, trends, and where research should go next.

## The Big Idea: Taxonomy and Benchmarks for Jailbreaks
JailbreakZoo organises attacks (role‑play, obfuscation, translation, multi‑turn set‑ups, tool‑assisted prompts) and provides evaluation scaffolding so we can compare models, track regressions, and standardise defences.

Analogy 1: Think of antivirus test suites—shared samples let vendors test detection. JailbreakZoo plays a similar role for LLM safety.

Analogy 2: It’s a climbing wall with labelled routes. If your model slips on grade 5 routes (e.g., role‑play), you know exactly where to train and harden.

Key concept: Without shared datasets and taxonomies, safety progress is hard to measure. JailbreakZoo aims to make it measurable.

## The “So What?”: Operationalising Safety Work
For practitioners, the value is immediate:
- Regression testing of safety before releases
- Coverage analysis: which jailbreak families still work?
- Defence targeting: train or filter against the most transferable attacks

It also encourages the community to move from anecdote‑driven patching to systematic evaluation.

## Connecting the Dots: From Paper Defences to Pipelines
In our course arc, JailbreakZoo complements the universal‑attack and PoisonedRAG results: it standardises the testing ground. That’s how organisations build repeatable safety pipelines, not just ad‑hoc fixes.

## Conclusion: Measure to Improve
You can’t fix what you can’t measure. JailbreakZoo provides the yardsticks to harden systems over time.

## See Also
- Prev: [41 — PoisonedRAG](41-poisonedrag-knowledge-corruption-attacks-zou-2024.md)
- Next: [43 — Red Teaming](43-red-teaming-reduce-harms-perez-2022.md)

