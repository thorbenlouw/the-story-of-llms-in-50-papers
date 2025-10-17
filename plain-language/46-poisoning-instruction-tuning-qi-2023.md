When the Teacher is Malicious: Poisoning Instruction Tuning

Paper: Poisoning Language Models During Instruction Tuning (Qi et al., 2023)

## Introduction: Alignment Data as an Attack Vector
Instruction tuning makes models follow human directions. But what if some of that data is poisoned? This paper shows that injecting a small set of malicious examples into instruction‑tuning datasets can steer models towards attacker‑desired behaviours, sometimes without obvious quality drops.

## The Big Idea: Targeted Poison in the Alignment Phase
Rather than corrupting pretraining (vast and diffuse), attackers seed the smaller, high‑leverage instruction‑tuning corpus with crafted items. The model internalises harmful patterns—backdoors, misinformation styles, specific trigger behaviours—that later activate under certain prompts.

Analogy 1: It’s like substituting a few lessons in a curriculum. Most of the course is sound, but a handful of skewed examples bias the student’s future answers.

Analogy 2: Think of a recipe book with a few pages swapped—most dishes taste fine, but specific ones go wrong in a predictable way.

Key concept: Small, curated datasets used late in training wield outsized influence. That makes them prime targets for poisoning.

## The “So What?”: Secure the Alignment Pipeline
Defences include:
- Data provenance and contributor vetting
- Outlier and influence detection to flag suspicious items
- Diverse, redundant sources for critical instructions
- Post‑tune audits: trigger scans, behavioural tests, and safety evals

For builders, the lesson mirrors PoisonedRAG: data pipelines are part of the threat model. Treat instruction‑tuning corpora like production code—reviewed, logged, and monitored.

## Connecting the Dots: Safety is End‑to‑End
We’ve seen prompt‑level and retrieval‑level attacks; this one hits the alignment stage. In our course, it reinforces that securing LLMs requires attention from pretraining to deployment, not just model‑time guardrails.

## Conclusion: Trust, but Verify Your Data
Instruction tuning is powerful—and sensitive. Build processes that assume data can be malicious and prove it isn’t.

## See Also
- Prev: [45 — Certified Robustness](45-certified-robustness-word-substitutions-jia-2019.md)
- Next: —

