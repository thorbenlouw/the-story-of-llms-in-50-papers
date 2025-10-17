# JailbreakZoo: Survey, Landscapes, and Horizons in Jailbreaking LLMs and VLMs (Chao et al., 2024) — Notes

PDF: llm_papers_syllabus/JailbreakZoo_Survey_Jailbreaking_LLMs_Chao_2024.pdf
Track/Section: Extension Track A — Security and Robustness of LLMs

## Key Contributions
- Comprehensive survey of jailbreak strategies and defenses for LLMs and VLMs.
- Paper states seven distinct jailbreak types; details fine‑grained categories and methodologies.
- Unified perspective connecting attack taxonomies with defense strategies and evaluation.
- Coverage includes both text‑only LLMs and multimodal VLMs.

## Method Sketch (Structure of the Survey)
- Background: alignment (prompt‑tuning alignment, RLHF) and typical jailbreaking process (Sec. 2.1–2.2).
- LLM threats: jailbreak strategy categories (Sec. 3.1.x) and defense families (Sec. 3.2.x).
- VLM threats: jailbreak categories (Sec. 4.1.x) and defenses (Sec. 4.2.x).
- Comprehensive evaluation recommendations (Sec. 3.3, Sec. 4.3) and additional resources (Sec. 3.4).

## Prior Work Contrast
- Extends prior surveys by unifying LLM and VLM perspectives; emphasizes fine‑grained categorization.
- Distinct from red‑teaming frameworks (e.g., searcher‑based) by focusing on jailbreak mechanisms.

## Notable Results/Findings
- LLM jailbreak categories (headers observed): Gradient‑based; Evolutionary‑based; Demonstration‑based; Rule‑based; Multi‑agent‑based (Sec. 3.1.1–3.1.5).
- LLM defense categories: Prompt detection; Prompt perturbation; Demonstration‑based; Generation intervention; Response evaluation; Fine‑tuning (Sec. 3.2.1–3.2.6).
- VLM jailbreak categories: Prompt‑to‑image; Prompt‑image perturbation; Proxy model transfer (Sec. 4.1.1–4.1.3).
- VLM defenses mirror LLM defenses with modality‑specific adaptations (Sec. 4.2.x).

## Limitations (Survey Perspective)
- Rapidly evolving space; taxonomies may require frequent updates.
- Lack of standardized, multi‑metric evaluation across models and modalities.
- Defense efficacy often context‑specific; generalization remains open.

## 10–12 Bullet Outline (Draft)
- Motivation and definition of jailbreak; example case (Fig. 1) and scope (LLMs and VLMs).
- Alignment background: prompt‑tuning alignment and RLHF.
- LLM jailbreak taxonomy: gradient‑based; evolutionary‑based; demonstration‑based; rule‑based; multi‑agent‑based.
- LLM defense taxonomy: prompt detection; prompt perturbation; demonstration‑based; generation intervention; response evaluation; fine‑tuning.
- Evaluation criteria: comprehensive evaluation considerations for LLMs.
- VLM jailbreak taxonomy: prompt‑to‑image; prompt‑image perturbation; proxy model transfer.
- VLM defense taxonomy and evaluation.
- Discussion of research gaps and unified perspective.
- Implications for practitioners: layered defenses, model‑agnostic checks, and policy alignment.
- Course fit: Extension Track A (security), complements PoisonedRAG and watermark/certified robustness topics.

