# JailbreakZoo: Survey, Landscapes, and Horizons in Jailbreaking Large Language and Vision-Language Models (2024)

## 1) Title and citation
- JailbreakZoo: Survey, Landscapes, and Horizons in Jailbreaking Large Language and Vision-Language Models. Haibo Jin, Leyang Hu, Xinnuo Li, Peiyan Zhang, Chonghan Chen, Jun Zhuang, Haohan Wang. 2024. arXiv:2407.01599.
- PDF: [llm_papers_syllabus/JailbreakZoo_Survey_Jailbreaking_LLMs_Chao_2024.pdf](../llm_papers_syllabus/JailbreakZoo_Survey_Jailbreaking_LLMs_Chao_2024.pdf)

## 2) TL;DR (4–6 bullets)
- Provides a comprehensive survey of jailbreak attacks and defenses for both text-only LLMs and multimodal VLMs, aiming for a unified view of risks and mitigations.
- Categorizes jailbreak strategies into fine-grained types (e.g., gradient-based, evolutionary-based, demonstration-based, rule-based, multi-agent-based) and surveys parallel defense families.
- Frames alignment background (prompt-tuning alignment, RLHF), then details attack/defense landscapes and evaluation guidance for LLMs and VLMs.
- Highlights rapid evolution and gaps: fragmented benchmarks, limited cross-model comparability, and defenses that often overfit to specific attack styles.
- Argues for layered, adversary-aware defenses (prompt detection/perturbation, demonstration cues, generation intervention, response evaluation, fine-tuning), plus standardized evaluations.
- Emphasizes extending coverage to VLMs, where prompt-image perturbations and proxy-transfer pose new surface areas.

## 3) Problem and Motivation
Alignment (via prompt-tuning and RLHF) reduces harmful outputs but is brittle: carefully crafted prompts can elicit policy-violating responses. As jailbreak research expands across both LLMs and VLMs, the landscape becomes fragmented—techniques differ in assumptions, access, and modalities; defenses similarly vary and are hard to compare. This survey organizes the space, identifies common mechanisms, and proposes a cohesive framing to guide future research and practice.

Motivation: practitioners need structured guidance to triage threats and choose defense layers; researchers need a taxonomy that maps attack families to failure modes and to evaluation methods that are reproducible and comparable.

## 4) Core Idea and Contributions
- Unified taxonomy: Synthesizes jailbreak strategies for LLMs and VLMs into fine-grained categories along with parallel defense families and evaluation criteria.
- Scope breadth: Covers text-only LLMs and vision-language models, emphasizing modality-specific tactics (e.g., prompt-to-image injection) and their transfer.
- Alignment context: Grounds the survey in alignment techniques (prompt-tuning alignment and RLHF), clarifying how jailbreaks exploit gaps between policy intent and model behavior.
- Practical orientation: Provides high-level guidance for layered defenses and comprehensive evaluations, not just enumerations of methods.

## 5) Method (plain-language)
This is a literature survey. It first sets background context (alignment methods and a typical jailbreaking process), then catalogs jailbreak strategies and defenses. For LLMs, it introduces five prominent jailbreak families (gradient-, evolutionary-, demonstration-, rule-, and multi-agent-based) and six defense families (prompt detection, prompt perturbation, demonstration-based, generation intervention, response evaluation, and model fine-tuning). For VLMs, it analogously covers prompt-to-image injection, prompt-image perturbation, and proxy model transfer attacks, then maps to defenses and evaluation. The paper closes with research gaps and future directions.

Key intuitions:
- Jailbreaks often exploit a search process over inputs (gradients, evolution, multi-agent exploration) or leverage demonstrations/rules to steer the model around safety policies.
- Defenses mirror these axes: detect or sanitize prompts before generation; inject robustifying demonstrations; intervene during decoding; or evaluate and filter responses post hoc; longer-term, fine-tune to increase inherent robustness.

## 6) Comparison to Prior Work (1–3 precise contrasts)
- Compared to red-teaming frameworks that focus on automated exploration (e.g., searcher-based taxonomies), this survey centers on jailbreak mechanisms and how they subvert alignment (Sec. 1–2), connecting them directly to defense types (Sec. 3.2, 4.2).
- Unlike LLM-only surveys, JailbreakZoo expands to VLMs with modality-specific attacks such as prompt-image perturbations and proxy-model transfer (Sec. 4.1), making the taxonomy more complete for multimodal systems.
- Relative to dataset/bias-focused surveys, it targets structural jailbreak tactics and defense mechanics rather than data-centric bias sources, while still acknowledging evaluation needs (Sec. 3.3, 4.3).

## 7) Results and What They Mean
As a survey, the “results” are organization and synthesis rather than new experiments. Practical takeaways:
- Attack taxonomy (LLMs): gradient-based (optimize token sequences with gradient signals), evolutionary-based (iterative mutation/selection), demonstration-based (examples/roleplay), rule-based (structured instructions), multi-agent-based (coordinated prompting/feedback cycles) (Sec. 3.1.1–3.1.5).
- Defense taxonomy (LLMs): prompt detection (classify/block risky inputs), prompt perturbation (sanitize/transform), demonstration-based (embed refusal patterns), generation intervention (decoding constraints/tools), response evaluation (safety classifiers/critics), model fine-tuning (robustness via SFT/RLHF-style updates) (Sec. 3.2.1–3.2.6).
- VLM attacks and defenses: prompt-to-image injection, prompt-image perturbations, proxy-transfer methods; defenses mirror LLM strategies with vision-specific checks (Sec. 4.1–4.2).
- Evaluation: calls for comprehensive, standardized evaluation across models and modalities, with multi-metric reporting and reproducible protocols (Sec. 3.3, 4.3).

Implications:
- Security posture should be layered: combine pre-input detection/perturbation, in-generation constraints, and post-generation checks, while investing in robust fine-tuning.
- Multimodal systems add attack channels (image perturbations, cross-modal cues); defenses must reason across modalities and provenance.
- Research gaps include transferability across models, standardized benchmarks, and defenses that generalize beyond specific jailbreak styles.

## 8) Limitations and Failure Modes
- Taxonomy drift: The space evolves quickly; categories and exemplars may become outdated without continuous updates.
- Evaluation fragmentation: Lack of unified benchmarks risks overfitting defenses to narrow attack sets; cross-model comparability remains limited.
- Defense side effects: Prompt perturbation and strict generation intervention can harm helpfulness/utility if over-applied; fine-tuning may trade off capability.
- Modality gaps: VLM-specific defenses lag LLM defenses; visual adversarial perturbations are hard to detect reliably.

## 9) Fit to This Course (Week: Extension Track A, Section: Security and Robustness of LLMs)
- Key Topics & Labs: Jailbreaking/evasion, prompt injection, poisoning vs. jailbreaks, defense layering (detection, perturbation, evaluation), standardized evaluation.
- Course fit: Pairs with PoisonedRAG (knowledge-layer attacks) by covering prompt-level and multimodal jailbreaks. Useful for a lab that implements a small adversarial prompting harness evaluating multiple attack types and measuring defense trade-offs (precision/recall vs. helpfulness).

## 10) Discussion Questions (5)
- Which defense layer (pre-input detection, in-generation intervention, post-response evaluation, fine-tuning) offers the best security–usability trade-off for production chat models?
- How can we design evaluation protocols that measure jailbreak transfer across models and modalities without overfitting defenses to a single attack family?
- For VLMs, what simple, scalable checks can detect prompt-image perturbations without heavy compute or degrading UX?
- Can demonstration-based defenses be systematically constructed (and audited) to avoid new bypasses while preserving helpfulness?
- What standards should accompany model releases (e.g., red-team reports, safety cards, evals) to support downstream risk management?

## 11) Glossary (8–12 terms)
- Jailbreaking: Prompting or conditioning a model to bypass alignment/safety restrictions and produce disallowed content.
- Prompt-tuning alignment: Steering model behavior via curated prompts/datasets to align outputs with ethical guidelines (Sec. 2.1.1).
- RLHF: Reinforcement Learning from Human Feedback; aligns models by optimizing against a reward model trained on human preferences (Sec. 2.1.2).
- Gradient-based jailbreak: Attack that uses gradient signals to optimize adversarial prompts/suffixes (Sec. 3.1.1).
- Evolutionary-based jailbreak: Attack that uses mutation/selection (e.g., genetic algorithms) to evolve prompts (Sec. 3.1.2).
- Demonstration-based jailbreak: Uses examples/roleplay/story framing to induce prohibited behavior (Sec. 3.1.3).
- Rule-based jailbreak: Uses structured instructions/rules to skirt policies (Sec. 3.1.4).
- Multi-agent-based jailbreak: Coordinates multiple agents to explore and refine adversarial prompts (Sec. 3.1.5).
- Generation intervention: Defense that constrains decoding or injects safety tools during generation (Sec. 3.2.4).
- Response evaluation: Post-generation safety checking/classification to accept, refuse, or rewrite outputs (Sec. 3.2.5).

## 12) References and Claim Checks
- Paper: [llm_papers_syllabus/JailbreakZoo_Survey_Jailbreaking_LLMs_Chao_2024.pdf](../llm_papers_syllabus/JailbreakZoo_Survey_Jailbreaking_LLMs_Chao_2024.pdf)
- Claim checks (with section/page hints):
  - “Our study categorizes jailbreaks into seven distinct types” (Abstract; first page of PDF).
  - LLM jailbreak categories enumerated in headers (Sec. 3.1.1–3.1.5: gradient-, evolutionary-, demonstration-, rule-, multi-agent-based).
  - LLM defense families enumerated (Sec. 3.2.1–3.2.6: prompt detection, prompt perturbation, demonstration-based, generation intervention, response evaluation, fine-tuning).
  - VLM jailbreak categories (Sec. 4.1.1–4.1.3: prompt-to-image, prompt-image perturbation, proxy model transfer).
  - Evaluation emphasis for LLMs and VLMs (Sec. 3.3, Sec. 4.3: comprehensive evaluation guidance).
