Red Teaming LLMs: Breaking Things to Make Them Safer

Paper: Red Teaming Language Models to Reduce Harms (Perez et al., 2022)

## Introduction: Test Like an Adversary
To reduce real‑world harms, we must proactively probe models for dangerous behaviours—bias, toxic content, misuse instructions—before release. Red teaming borrows from security: assemble experts (and tools) to attack your own system and learn where it fails.

## The Big Idea: Structured, Iterative Red Teaming
The paper outlines processes for eliciting unsafe outputs, categorising failures, and turning findings into mitigations. It emphasises diverse, realistic scenarios and iteration: models evolve, so must the tests.

Analogy 1: It’s a fire drill for your AI—rehearse emergencies so you don’t freeze when they happen.

Analogy 2: Think penetration testing for software—ethical hackers expose vulnerabilities so engineers can fix them.

Key concept: Safety isn’t a static property. Without continuous adversarial evaluation, systems drift back into risk.

## The “So What?”: From Findings to Fixes
Red teaming informs:
- Data and instruction tuning (e.g., safer responses, refusal styles)
- Policy design and enforcement
- Product guardrails (filters, rate limits, abuse reporting)
- Monitoring frameworks and post‑deployment triggers

Crucially, it’s not just about saying “no”—it’s about guiding models towards helpful, safe alternatives.

## Connecting the Dots: A Safety Practice, Not a Patch
Within our course, this paper anchors the operational side of safety. Along with jailbreak surveys and universal attacks, it helps turn safety from a one‑time fine‑tune into an ongoing discipline that ships with each version.

## Conclusion: Build Safety Into the Release Cycle
Make red teaming part of your definition of done. The rest of this safety block explores complementary techniques like watermarking and certified robustness.

## See Also
- Prev: [42 — JailbreakZoo](42-jailbreakzoo-survey-jailbreaking-llms-chao-2024.md)
- Next: [44 — Watermarking LLMs](44-watermark-large-language-models-kirchenbauer-2023.md)

