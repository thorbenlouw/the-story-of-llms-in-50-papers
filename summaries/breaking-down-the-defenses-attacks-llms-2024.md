1) Title and citation
- Breaking Down the Defenses: A Comparative Survey of Attacks on Large Language Models. Arijit Ghosh Chowdhury, Md Mofijul Islam, Vaibhav Kumar, Faysal Hossain Shezan, Vaibhav Kumar, Vinija Jain, Aman Chadha. arXiv:2403.04786 (v2, 2024). PDF: llm_papers_syllabus/Breaking_Down_the_Defenses_Attacks_LLMs_Survey_2024.pdf

2) TL;DR
- Surveys the attack surface of LLMs across jailbreaks, prompt injection, and data poisoning, organizing methods into a practical taxonomy for security analysis.
- Distinguishes white-box vs. black-box threat models and catalogs representative techniques (e.g., PAIR, universal adversarial suffixes, AutoDAN, HOUYI).
- Highlights how small, carefully engineered prompts or data perturbations can reliably bypass safety constraints in popular models and services.
- Reviews defense strategies as external guardrails (I/O filtering) versus training-based mitigations, noting trade-offs and failure patterns.
- Emphasizes rapidly evolving tactics and the need for systematic evaluation, defense-in-depth, and continuous red teaming.

3) Problem and Motivation
Modern LLMs are deployed broadly and mediate user queries, tools, and knowledge, making their failure modes security-relevant. The paper surveys how adversaries can manipulate LLM behavior at inference time (e.g., jailbreaks, prompt injection) and at training/fine-tuning time (e.g., data poisoning, backdoors). The authors’ goal is to provide a concise map of attacks and mitigations to support threat modeling and defense selection for LLM systems. They motivate the work by the increasing societal stakes and widespread integration of LLMs into products and services, where integrity, privacy, and safety must be robust, not aspirational (Introduction; cf. Amodei et al. 2016; Hendrycks et al. 2023 mentioned in context).

4) Core Idea and Contributions
- A unifying taxonomy of LLM attacks organized by access (white-box vs. black-box) and by attack vector (jailbreaks, prompt injection, data poisoning), with representative techniques and concrete references.
- A curated synthesis of automated and human-in-the-loop attack methodologies, distilling what makes them effective and transferable.
- A defense overview split into external guardrails (input/output filtering) and training-time mitigations, clarifying where each is applicable, scalable, and brittle.
- Pointers to open challenges and research directions for hardening LLMs against rapidly evolving adversarial techniques.

5) Method
This is a survey, not a single experimental system. The paper’s methodological contribution is a taxonomy and comparative synthesis, anchored by exemplars and brief mechanism descriptions:
- Threat models (Sec. 2): White-box attacks assume full access to weights/data; black-box attacks interact only via the API/interface, yet can be highly effective on deployed systems (Sec. 2.1–2.2).
- Taxonomy (Sec. 3; Fig. 1): Organizes attacks into jailbreaks (3.1), prompt injection (3.2), and data poisoning (3.3), and pairs them with mitigation strategies (4.3) grouped into external guarding versus training-based defenses. Figure 1 visually maps techniques and defenses.
- Jailbreaks (Sec. 3.1): Includes query-based iterative methods (PAIR), universal suffixes, persona modulation, cross-modal/low-resource strategies, and objective manipulation via prompt engineering. Mechanistically, these methods exploit models’ next-token predictability and safety filters’ brittleness to crafted context.
- Prompt injection (Sec. 3.2): Frames attacks that hijack the instruction-following objective in agent/tool settings by feeding malicious instructions in context (e.g., via retrieved or tool-returned text), including objective manipulation, prompt leaking, and scalable automated methods (HOUYI, AutoDAN).
- Data poisoning (Sec. 3.3): Covers poisoning or backdoors introduced at pretraining, instruction tuning, or fine-tuning stages, with techniques that implant triggers or bias behavior that surfaces at inference.
- Mitigations (Sec. 4.3): External guardrails (input/output filters, policy checkers, safety classifiers) versus training-time strategies (safety tuning, distillation, curriculum, robustness methods). The survey highlights I/O filtering’s deployment convenience and common bypasses, and training methods’ cost/coverage trade-offs.

6) Comparison to Prior Work
- JailbreakZoo (Chao et al., 2024) is a broad taxonomy and survey of jailbreaks. This survey overlaps on jailbreak content but places it alongside prompt injection and data poisoning, framing a fuller threat surface for system builders. In contrast, JailbreakZoo dives deeper into attack categories and benchmarks specifically for jailbreaks.
- Universal adversarial suffixes (Zou et al., 2023) show transferability of appended strings across models/services; this survey contextualizes such results within a larger family of automated attacks and emphasizes their black-box practicality.
- Prompt injection frameworks (e.g., PromptInject; Abdelnabi et al., 2023; Perez & Ribeiro, 2022) focus on hijacking agent objectives. This survey integrates those ideas into a unified view that ties tool-use contexts (retrieval, APIs) with the need for contextual sanitization.

7) Results and What They Mean
While not reporting new experiments, the survey surfaces several empirical highlights from the literature with practical implications for defense planning:
- White-box vs. black-box distinction matters less than expected: black-box jailbreaks work reliably on API models, making “security by obscurity” insufficient (Sec. 2.2; discusses jailbreaks on GPT‑3.5/4 and API models).
- Iterative query-based jailbreaks (PAIR) demonstrate how few-shot interactions can refine successful jailbreak prompts against strong models, and often transfer across targets (Sec. 3.1; PAIR summary).
- Universal adversarial suffixes automatically discovered by hybrid search reliably bypass guardrails and transfer to black-box providers (Sec. 3.1; universal/automated strategies).
- HOUYI shows an 86.1% success rate in real-world LLM-integrated services, highlighting the practicality of black-box prompt injection pipelines (Sec. 3.2: “Experiments on 36 real-world LLM‑integrated services … 86.1% success rate”).
- AutoDAN uses a hierarchical genetic algorithm to produce fluent, low‑perplexity adversarial prompts that evade simple filters while maintaining high attack success (Sec. 3.2; AutoDAN description and algorithmic details).
- Figure 1 consolidates the space: jailbreaks, prompt injection, data poisoning on the attack side; input/output censorship and training-based defenses on the mitigation side (Fig. 1 caption and diagram reference).
Taken together, these highlights reinforce that: (i) practical, scalable attacks exist against production systems; (ii) safety filters and simple prompting defenses are brittle; and (iii) defense-in-depth with continuous red teaming is essential.

8) Limitations and Failure Modes
- Coverage vs. depth: The paper is concise (6 pages) and cannot deeply evaluate each attack family or provide standardized metrics across studies; it is best read as a map, not a benchmark.
- Rapidly evolving landscape: Techniques change quickly; success rates and transferability can shift with model/provider updates. Findings should be treated as trend indicators rather than static truths.
- Limited quantitative synthesis: The survey cites successes (e.g., 86.1% HOUYI) but does not aggregate cross-paper statistics into a meta-analysis, leaving open questions about comparative efficacy.
- Defense validation gap: Many defenses (filters, guardrails) can be bypassed; the field lacks robust, standardized, adversarial evaluations for deployment-ready assurance.

9) Fit to This Course (Week: Extension Track A, Section: Security and Robustness of LLMs — Attacks)
- Key Topics & Labs: This module focuses on the LLM threat model, specifically how models can be compromised at training time (poisoning) or inference time (adversarial attacks/jailbreaks), as well as defense mechanisms (course-syllabus.md, “Extension Track A”).
- Alignment: The taxonomy directly supports this track’s learning outcomes—threat modeling, recognizing key attack vectors (jailbreaks, prompt injection, poisoning), and understanding the envelope of guardrail/training defenses. It complements the hands-on readings (e.g., universal adversarial suffixes; PoisonedRAG) by situating them in a broader map of techniques and mitigations.

10) Discussion Questions
- How should LLM product teams compose defense-in-depth (filters + training) to balance cost, latency, and robustness, given the documented brittleness of single-layer defenses?
- Which attack vectors are amplified by tool use (retrieval, web, code, APIs), and how should context sanitization and tool schemas be designed to reduce prompt injection risk?
- What standardized evaluation should accompany LLM releases to truthfully represent robustness to jailbreaks and injections? What role should third-party red teaming play?
- How can training-time defenses (e.g., safety tuning, data curation, model editing) be validated against adaptive adversaries without relying solely on static benchmarks?
- What properties make an adversarial prompt “transferable” across models/providers, and how can we detect such universal patterns proactively?

11) Glossary
- Jailbreak: A prompt or strategy that causes an LLM to bypass safety constraints and produce prohibited outputs.
- Prompt Injection: Malicious instructions embedded in context (e.g., retrieved text/tool output) that hijack an LLM agent’s goals.
- Data Poisoning: The injection of malicious samples into training/fine-tuning data to bias or trigger harmful behaviors at inference.
- Backdoor: A specific, often stealthy, trigger-response mechanism implanted during training that activates a targeted behavior at test time.
- White-Box Attack: Adversary has access to model internals (weights, data, architecture), enabling gradient-based or targeted manipulations.
- Black-Box Attack: Adversary interacts only via inputs/outputs; often the real-world deployment scenario for API models.
- Universal Adversarial Suffix: A single appended string that reliably jailbreaks many prompts/models, often discovered by automated search.
- Guardrails (I/O Filtering): External classifiers/rules that screen inputs and/or outputs for policy violations without modifying the base model.
- Persona Modulation: An attack style that instructs the model to assume a persona/style that weakens safety behavior.
- Low-Perplexity Attack: An adversarial prompt crafted to look fluent/natural (low perplexity), evading simple filters while remaining effective.
- Context Sanitization: Defensive processing to remove/neutralize untrusted instructions in context (e.g., from tools or retrieved documents).
- Red Teaming: Systematic adversarial probing (human or automated) to discover failure modes and improve defenses before deployment.

12) References (selected)
- Chao et al., 2024. JailbreakZoo: Survey, Landscapes, and Horizons in Jailbreaking LLMs (survey of jailbreaks).
- Zou et al., 2023. Universal and Transferable Adversarial Attacks on Aligned LLMs (universal suffixes).
- Abdelnabi et al., 2023; Perez & Ribeiro, 2022. Prompt injection/PromptInject frameworks.
- Liu et al., 2023 (AutoDAN; HOUYI). Automated jailbreaks and prompt injection methodologies.
- Robey et al., 2023; Inan et al., 2023; Rebedea et al., 2023. Guarding/defense tools (SmoothLLM, Llama Guard, NeMo-Guardrails).

Claim checks (fidelity hints)
- White-box vs. black-box framing and examples: Sec. 2.1–2.2.
- Taxonomy and mapping across attacks/defenses: Fig. 1 and Sec. 3, Sec. 4.3.
- HOUYI prompt injection pipeline and 86.1% attack success across 36 services: Sec. 3.2 (text describes phases and success rate).
- Universal/automated jailbreak strategies (suffixes, PAIR, persona modulation): Sec. 3.1 (enumerates approaches and transferability).
- AutoDAN hierarchical genetic algorithm and low-perplexity adversarial prompts: Sec. 3.2 (algorithmic details and motivation).
- Guarding vs. training-based mitigations and deployment notes: Sec. 4.3.1 and 4.3 (external I/O filtering vs. training-time methods).
