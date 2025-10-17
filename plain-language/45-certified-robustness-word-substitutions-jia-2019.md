Provable Defences Against Word‑Swap Attacks

Paper: Certified Robustness to Adversarial Word Substitutions (Jia et al., 2019)

## Introduction: When Small Edits Flip the Answer
Even simple word swaps—synonyms, paraphrases—can break NLP systems. Adversaries exploit this by subtly changing inputs without altering meaning. This paper brings formal guarantees to the table: methods that certify a model’s prediction won’t change under a set of allowed substitutions.

## The Big Idea: Certifying Stability
The authors define a threat model where specific word substitutions are allowed (e.g., synonym sets) and derive certification bounds showing when a classifier’s output is provably invariant. Techniques include smoothed classifiers and interval bounds over discrete perturbations.

Analogy 1: It’s like earthquake‑proofing a building. You can’t stop tremors (small edits), but you can certify the structure won’t collapse under a specified magnitude.

Analogy 2: Think warranty testing—within certain usage conditions, the device is guaranteed to behave.

Key concept: “Certified robustness” moves us from empirical hope (“seems robust”) to verifiable guarantees (“is robust under these perturbations”).

## The “So What?”: From Benchmarks to Guarantees
For safety‑critical or high‑stakes deployments, empirical robustness isn’t enough. Certification provides assurance to regulators and users. While early work focused on classifiers, the mindset influences how we think about robustness for generative models, too (e.g., bounding harmful triggers).

## Connecting the Dots: Formal Methods Enter NLP
In our course arc, this paper is the formal counterpoint to red teaming. We need both: creative adversarial testing and mathematical guarantees. Together, they tighten the safety net around language systems.

## Conclusion: Promises You Can Prove
Certified robustness lays groundwork for verifiable NLP safety. Next, we’ll examine data‑time attacks during instruction tuning.

## See Also
- Prev: [44 — Watermarking LLMs](44-watermark-large-language-models-kirchenbauer-2023.md)
- Next: [46 — Poisoning During Instruction Tuning](46-poisoning-instruction-tuning-qi-2023.md)

