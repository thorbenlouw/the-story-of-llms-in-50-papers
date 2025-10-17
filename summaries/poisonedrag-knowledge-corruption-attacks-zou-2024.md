# PoisonedRAG: Knowledge Corruption Attacks to Retrieval-Augmented Generation of Large Language Models (Zou et al., 2024)

## 1) Title and Citation
- PoisonedRAG: Knowledge Corruption Attacks to Retrieval-Augmented Generation of Large Language Models. Wei Zou, Runpeng Geng, Binghui Wang, Jinyuan Jia. 2024. arXiv:2402.07867.
- PDF: [llm_papers_syllabus/PoisonedRAG_Knowledge_Corruption_Attacks_Zou_2024.pdf](../llm_papers_syllabus/PoisonedRAG_Knowledge_Corruption_Attacks_Zou_2024.pdf)

## 2) TL;DR
- Shows a practical, high-success poisoning attack on RAG systems by injecting a few crafted texts into the knowledge database to force targeted answers.
- Frames the attack as an optimization with two necessary conditions: retrieval (poison must be retrieved) and generation (poison must drive the target answer when used as context).
- Provides black-box and white-box procedures to construct malicious texts that meet both conditions; decomposes each poison into retrieval- and generation-oriented parts.
- Achieves up to ~97% Attack Success Rate (ASR) with as few as 5 malicious texts per targeted question in a multi-million-document corpus; outperforms prior baselines (<70% ASR).
- Evaluates across multiple datasets (e.g., NQ, HotpotQA, MS MARCO), 8 LLMs (e.g., GPT‑4, LLaMA‑2), and realistic RAG apps (Wikipedia chatbot, advanced RAG, and an LLM agent).
- Standard paraphrasing and perplexity-based filters are insufficient; highlights a new attack surface in RAG and the need for dedicated defenses.

## 3) Problem and Motivation
RAG augments an LLM with retrieved passages from an external knowledge database to ground answers, reduce
hallucinations, and extend knowledge beyond the model’s training cutoff. While accuracy and efficiency in RAG have been
extensively studied, the security of RAG’s knowledge database—the component that stores the retrievable texts—has
received far less attention. PoisonedRAG asks: what if a malicious actor can inject a small number of crafted texts into
that database? If those texts are frequently retrieved and, when used as context, push the LLM to emit the attacker’s
chosen answer to a chosen question, the system becomes vulnerable to targeted misinformation and manipulation.

The paper identifies the knowledge database as a practical attack surface: an adversary can edit public sources (e.g.,
Wikipedia), seed malicious web pages, or modify internal enterprise wikis to insert adversarial passages. Because many
RAG systems retrieve a handful of top‑k passages for prompts, even a tiny number of targeted poisons can disproportionately
influence generation. This is particularly concerning for safety-critical domains (e.g., finance, health, cybersecurity), where
single-answer accuracy and truthfulness are paramount.

## 4) Core Idea and Contributions
- Formulates knowledge corruption in RAG as a constrained optimization problem: choose a small set of malicious texts
  so that, for targeted questions, the LLM outputs targeted answers when conditioned on retrieved context.
- Derives two necessary conditions for each malicious text:
  - Retrieval condition: the text must be retrieved among top‑k for the target question (embedding similarity and retriever behavior).
  - Generation condition: with the text as context, the LLM should produce the target answer for the target question.
- Designs black‑box and white‑box construction methods that craft each malicious text as a concatenation of two
  sub‑texts tuned to satisfy retrieval and generation conditions, respectively.
- Demonstrates high attack success with very few injected texts on multi‑million‑document corpora; shows superiority
  over prior baseline attacks and robustness to hyperparameter choices.
- Evaluates simple defenses (paraphrasing, perplexity filters) and shows they are insufficient, motivating stronger RAG‑specific defenses.

## 5) Method (Plain Language)
Threat model and objective. The attacker selects a set of target questions and desired target answers (e.g., “Who is the CEO
of OpenAI?” → “Tim Cook”). The goal is to inject a small number N of malicious texts per target question into the knowledge
database such that, when the RAG pipeline retrieves top‑k passages and feeds them to the LLM, the LLM outputs the target
answer. The paper casts this as maximizing the fraction of targeted questions for which the LLM’s answer equals the attacker’s
target when using the retrieved context from the poisoned database.

Two necessary conditions per malicious text. Because directly solving the optimization is intractable, the authors derive two
necessary conditions and design heuristics around them:
- Retrieval condition: ensure the poison text is retrieved for the target question. Intuitively, tune the poison so its embedding is
  similar to the question’s embedding (under the deployed or a surrogate retriever), so it lands in top‑k.
- Generation condition: ensure the LLM produces the target answer when the poison text is used as context for the question,
  making the target answer highly likely when the poison co‑occurs with other retrieved passages.

Text decomposition. Each malicious text P is constructed as P = P_retrieval || P_generation (concatenation), where:
- P_retrieval contains lexical/semantic cues to increase similarity to the target question (e.g., exact terms, synonyms, anchor
  entities) to satisfy the retrieval condition.
- P_generation is phrased to steer the LLM toward the target answer (e.g., a factual‑sounding statement embedding the target
  answer with relevant context), satisfying the generation condition.

Attack settings and construction procedures.
- Black‑box setting: the attacker does not access the victim database contents or LLM internals. They rely on a surrogate
  retriever and general LLM behavior to craft poisons with high likelihood of transfer. Techniques include embedding‑space
  heuristics to match queries and iterative text edits to increase target‑answer likelihood when used as context.
- White‑box setting: with stronger knowledge about the retriever/embeddings, the attacker can more precisely optimize the
  retrieval condition and fine‑tune phrasing for generation.

Evaluation protocol. The attack is tested across multiple datasets (e.g., Natural Questions, HotpotQA, MS MARCO), 8 LLMs
(including GPT‑4 and LLaMA‑2), and realistic RAG applications (e.g., Wikipedia chatbot, advanced RAG setups, and an
LLM agent). The metric is Attack Success Rate (ASR): the fraction of targeted questions whose answers match the attacker’s
specified target under attack.

Defense probes. The paper assesses two common filters—passage paraphrasing and perplexity‑based detection—which aim to
sanitize or detect unnatural text. Neither approach meaningfully reduces ASR, suggesting existing generic filters are
insufficient for RAG‑specific poisoning.

## 6) Comparison to Prior Work
- RAG systems: Prior research largely improved retrieval quality or efficiency (better retrievers, faster indexing/serving) but did
  not analyze knowledge‑base poisoning. PoisonedRAG highlights a distinct security dimension for RAG.
- Prompt injection vs. knowledge poisoning: Prompt injection corrupts the instruction/input. PoisonedRAG corrupts the
  external knowledge substrate and remains effective even when prompts look benign, making it stealthier in knowledge‑grounded setups.
- NLP poisoning/backdoors: Classic data poisoning/backdoors often target supervised training data and require retraining. In
  contrast, PoisonedRAG attacks a retrieval layer feeding a frozen LLM, requiring no model retraining and presenting lower
  attacker cost with high impact.

## 7) Results and What They Mean
Key empirical findings (high‑level):
- High ASR with few poisons: On NQ, the black‑box attack reaches about 97% ASR by injecting only 5 malicious texts per
  targeted question into a knowledge base with roughly 2.68M clean texts.
- Broad applicability: Strong results hold across HotpotQA and MS MARCO, across 8 LLMs, and in three realistic settings:
  an “advanced” RAG pipeline, a Wikipedia‑grounded chatbot, and an LLM agent.
- Outperforms baselines: Against several state‑of‑the‑art baselines, PoisonedRAG consistently attains substantially higher ASR
  (baselines <70% ASR on NQ), indicating the importance of jointly satisfying retrieval and generation conditions.
- Hyperparameter robustness: Ablations show the attack’s effectiveness is not brittle to reasonable k/N choices and other
  settings, underscoring practical viability.
- Defense efficacy: Paraphrasing and perplexity filters do not meaningfully lower ASR, revealing a gap in current defenses.

Implications:
- Practical threat: Because many knowledge bases incorporate public or semi‑public content (e.g., Wikipedia, web crawls,
  partner knowledge portals), the ability to inject or subtly edit a handful of documents can yield outsized influence.
- Defense priorities: Retrieval‑time sanitization, poisoning‑aware indexing, cross‑document consistency checks, and answer‑
  aware reranking merit focused study. End‑to‑end evaluation of RAG security (beyond prompt filters) is necessary.

## 8) Limitations and Failure Modes
- Attack preconditions: The attacker must be able to submit or edit content that will be ingested; systems with curated,
  authenticated, or cryptographically signed content reduce exposure.
- Retriever specificity: If the deployed retriever heavily differs from the attacker’s surrogate, transferability may drop (especially
  in black‑box mode), though the paper reports strong transfer empirically.
- Content moderation: Domain‑specific moderation (semantic consistency, authority checks, edit reputation) may detect or
  down‑rank poisons. However, generic perplexity/paraphrase filters were not sufficient in the paper’s tests.
- Temporal dynamics: Frequent re‑indexing with deduplication and drift detection could reduce poison persistence.
- Targeted nature: The attack is tailored to specific question→answer pairs; broad untargeted misinformation requires more
  coverage and may be easier to detect.

## 9) Fit to This Course (Week: Extension Track A, Section: Security and Robustness of LLMs)
- Key Topics & Labs (from syllabus, Extension A): LLM threat models; training‑time poisoning vs. inference‑time evasion and
  jailbreaks; defenses and red‑teaming; certified robustness; RAG‑specific attacks and mitigations.
- Course fit: This paper is central to the security lens on RAG. It complements Week 11’s RAG module by exposing a distinct
  failure mode in the knowledge layer and motivates pipeline‑level defenses. Lab ideas: implement a small RAG index, inject
  1–5 targeted poisons, measure ASR vs. k and retriever choice; prototype a defense (e.g., answer‑aware reranking, poison‑
  sensitive embedding outlier detection) and compare trade‑offs.

## 10) Discussion Questions
- How should we design retrievers and rerankers to be explicitly adversary‑aware without excessively harming recall on
  legitimate but rare facts?
- Which part of a RAG pipeline (indexing, retrieval, generation, post‑processing) offers the best leverage for early poison
  detection? What simple, scalable checks would you try first?
- Can we formalize “generation condition” suppression via answer‑aware training/reranking without needing reference answers
  at inference time? What proxies might approximate this?
- In enterprise settings with private knowledge bases, which governance or provenance controls (e.g., signed documents,
  audit trails) most effectively reduce attack feasibility without crippling agility?
- How transferable are poisoned texts across retrievers and domains? What measurements would establish robust transfer or
  isolate failure modes?

## 11) Glossary
- Retrieval‑Augmented Generation (RAG): A pipeline that retrieves passages from an external knowledge base and conditions
  an LLM’s generation on them.
- Knowledge database: The document store (e.g., vector index over web/Wikipedia/enterprise docs) used by the retriever.
- Attack Success Rate (ASR): The fraction of targeted questions for which the model outputs the attacker’s intended answer
  under attack.
- Retrieval condition: The requirement that a malicious text is retrieved among top‑k for the target question.
- Generation condition: The requirement that, when used as context, the malicious text pushes the LLM to produce the target
  answer for the target question.
- Black‑box setting: The attacker lacks access to the victim LLM and database contents; crafts transferable poisons using a
  surrogate.
- White‑box setting: The attacker has detailed knowledge of system components (e.g., retriever embeddings) and optimizes
  accordingly.
- Poisoned text (poison): An injected passage designed to manipulate retrieval and generation to achieve targeted answers.
- Paraphrasing defense: A preprocessing step that rewrites passages to remove surface cues; here found insufficient.
- Perplexity‑based detection: A filter that flags low‑likelihood text as suspicious; not effective against PoisonedRAG poisons.

## 12) References and Claim Checks
- Paper: [llm_papers_syllabus/PoisonedRAG_Knowledge_Corruption_Attacks_Zou_2024.pdf](../llm_papers_syllabus/PoisonedRAG_Knowledge_Corruption_Attacks_Zou_2024.pdf)
- Claim checks (with section/quote hints):
  - “We propose PoisonedRAG, the first knowledge corruption attack to RAG” (Introduction; see Abstract and first page).
  - “Two conditions … retrieval condition and generation condition …” (Overview/Design; see “Overview of PoisonedRAG”).
  - “97% ASR by injecting 5 malicious texts … into a knowledge database with 2,681,468 clean texts” (Evaluation summary on NQ).
  - “8 LLMs (e.g., GPT‑4, LLaMA‑2) and three real‑world applications” (Evaluation setup summary section).
  - “Outperforms SOTA baselines … baselines <70% ASR on NQ” (Evaluation; baseline comparison paragraph).
  - “Paraphrasing and perplexity‑based defenses are insufficient” (Defenses section; evaluation summary).
  - “Wikipedia edits plausible at non‑trivial rates (6.5%)” (Threat model cites prior work on editability; see discussion with [37]).
