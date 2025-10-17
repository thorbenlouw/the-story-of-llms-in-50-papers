# PoisonedRAG (Zou et al., 2024) — Notes

PDF: llm_papers_syllabus/PoisonedRAG_Knowledge_Corruption_Attacks_Zou_2024.pdf
Week/Section: Extension Track A — Security and Robustness of LLMs

## Key Contributions
- Identifies the RAG knowledge database as a practical attack surface.
- Formalizes “knowledge corruption” as an optimization over injected texts.
- Derives two necessary conditions per poison: retrieval and generation.
- Crafts each poison by concatenating a retrieval‑oriented sub‑text with a generation‑oriented sub‑text.
- Presents black‑box and white‑box construction procedures; no model retraining required.
- Demonstrates high ASR with few poisons across datasets, LLMs, and realistic RAG apps.
- Evaluates simple defenses (paraphrasing, perplexity); finds them insufficient.

## Method Sketch
- Threat model: attacker selects question→target‑answer pairs; can inject N texts per target into the corpus.
- Objective: maximize fraction of targets for which the LLM outputs attacker’s answer given top‑k retrieved context.
- Retrieval condition: optimize for high similarity between question and poison under the retriever; aim top‑k inclusion.
- Generation condition: phrase poison so that, as context, it drives the LLM to produce the target answer.
- Construction: P = P_retrieval || P_generation; tune each segment for its condition.
- Settings:
  - Black‑box: surrogate retriever + heuristic generation steering; rely on transfer.
  - White‑box: use knowledge of embeddings/retriever to optimize retrieval; refine phrasing for generation.
- Metric: Attack Success Rate (ASR) over targeted questions.

## Prior Work Contrast
- Differs from prompt injection (input‑level): attacks the knowledge layer; prompts can remain benign.
- Differs from classic data poisoning/backdoors: no retraining; manipulates retrieval into a frozen LLM.
- Complements RAG literature focused on accuracy/efficiency by adding a security perspective.

## Notable Results
- NQ (≈2.68M docs): ~97% ASR with 5 poisons per target in black‑box setting.
- Consistent gains across HotpotQA and MS MARCO; 8 LLMs incl. GPT‑4, LLaMA‑2.
- Outperforms SOTA baselines (<70% ASR on NQ); robust to reasonable hyperparameters.
- Paraphrasing and perplexity filters do not substantially reduce ASR.

## Limitations
- Requires corpus write access or ingestion control; strong curation reduces feasibility.
- Transferability may drop if victim retriever diverges from surrogate (esp. black‑box).
- Domain‑specific moderation and provenance could flag/downgrade poisons.
- Targeted attack; broad misinformation requires many targets (more detectable).

## 10–12 Bullet Outline (Draft)
- RAG pipeline overview; motivation for external knowledge and typical top‑k retrieval.
- Threat model: targeted questions and attacker‑chosen answers; attacker’s injection capability.
- Formulation: maximize success over question set under retrieved context from poisoned corpus.
- Two conditions: retrieval (top‑k inclusion) and generation (answer steering as context).
- Poison structure: concatenated retrieval‑cue segment and generation‑steering segment.
- Black‑box crafting: surrogate embeddings, lexical/semantic anchors; iterative phrasing edits.
- White‑box crafting: direct optimization against known retriever; fine‑grained control.
- Evaluation datasets (NQ, HotpotQA, MS MARCO) and LLMs (GPT‑4, LLaMA‑2, others).
- Realistic settings: advanced RAG, Wikipedia chatbot, LLM agent; ASR metric definition.
- Key results: ~97% ASR with 5 poisons; superiority over baselines; robustness ablations.
- Defense probes: paraphrasing and perplexity filters; insufficiency; need for RAG‑specific defenses.
- Implications: prioritize adversary‑aware retrieval/reranking, provenance, and end‑to‑end security evaluation.

