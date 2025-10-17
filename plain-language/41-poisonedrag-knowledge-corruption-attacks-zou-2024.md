When the Library Lies: Poisoning RAG Systems

Paper: PoisonedRAG: Knowledge Corruption Attacks to Retrieval‑Augmented Generation (Zou et al., 2024)

## Introduction: Trusting What You Retrieve
RAG systems rely on external corpora—wikis, documents, proprietary knowledge bases. But what if an attacker slips in plausible‑looking, poisonous text? This paper shows that even a handful of poisoned passages can steer answers towards attacker‑chosen outputs with high success.

## The Big Idea: Small, Targeted Corruption, Big Impact
By inserting crafted passages into a large corpus, adversaries bias retrieval and, consequently, generation. Because RAG trusts retrieved context, the model repeats the lie. The attack is strikingly efficient: a few poisoned documents among millions can dominate responses for specific queries.

Analogy 1: It’s like salting a search index with a few fake tech‑support pages that outrank the real fixes.

Analogy 2: Imagine a library where someone misfiles a handful of authoritative‑looking pamphlets in the right section. Readers looking for help will find—and cite—them.

Key concept: Retrieval is a high‑leverage control point. If the index is compromised, the model’s outputs follow.

## The “So What?”: Secure the Data Pipeline
Defences must address the full RAG stack:
- Ingest hygiene: source verification, deduplication, reputation signals
- Retrieval robustness: adversarial‑aware scoring, diversity over top‑K
- Attribution and auditing: track which passages influenced an answer
- Response‑time checks: detect contradictions or anomalous sources

For teams operating RAG in production, this paper moves “data security” from nice‑to‑have to critical path.

## Connecting the Dots: Safety Beyond the Base Model
We’ve seen universal jailbreaks at the prompt level; PoisonedRAG attacks the knowledge layer. Together they argue for defence‑in‑depth. In our course, this motivates provenance tooling, content moderation on ingestion, and answer‑time verification (cross‑checking, ensemble retrieval).

## Conclusion: Guard the Index
RAG’s strength—live knowledge—is also its weakness. Build pipelines that assume adversaries will target ingestion and retrieval.

## See Also
- Prev: [40 — Breaking Down the Defences](40-breaking-down-the-defenses-attacks-llms-2024.md)
- Next: [42 — JailbreakZoo](42-jailbreakzoo-survey-jailbreaking-llms-chao-2024.md)

