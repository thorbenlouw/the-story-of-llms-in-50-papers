How Attackers Target LLMs: A Field Guide to Breaking the Defences

Paper: Breaking Down the Defences: A Comparative Survey of Attacks on Large Language Models (Chowdhury et al., 2024)

## Introduction: The Expanding Attack Surface
LLMs now power chatbots, coding tools, and agents that can browse or call APIs. That reach brings a growing menu of attacks: jailbreaks, prompt injection, data poisoning, indirect prompt manipulation via tools, and more. This survey maps the terrain and compares methods and defences.

## The Big Idea: A Unified View of LLM Attacks
Rather than isolated anecdotes, the paper organises attacks by vectors (input, retrieval, tool use), goals (policy evasion, data exfiltration, targeted misbehaviour), and settings (closed‑book, RAG, agents). It highlights how capabilities—like tool use—create new pathways for adversaries.

Analogy 1: Think of LLM systems like airports. More runways (tools), more destinations (integrations), and more passengers (users) mean more checkpoints are needed—and more clever smuggling attempts.

Analogy 2: It’s a vulnerability catalogue for AI stacks, much like OWASP for web security.

Key concept: Security must be system‑wide. Guardrails in the base model do little if a retrieval layer can be poisoned or a tool call leaks secrets.

## The “So What?”: Practical Defence Priorities
The survey distils best practices:
- Layered defences: input filters, retrieval sanitisation, output checks
- Red‑teaming and continuous evaluation
- Safer tool interfaces and least‑privilege design
- Data curation and poisoning resistance for training and RAG corpora

It also surfaces gaps where empirical evidence is thin, guiding future work and internal security roadmaps.

## Connecting the Dots: From Model to System Security
In the course narrative, we’ve moved from models to systems (RAG, tool use, agents). This survey stresses that security thinking must expand with that scope. It prepares us for concrete techniques like watermarking and certified robustness.

## Conclusion: Treat LLMs Like Production Systems
With broader integrations come richer attacks. Security isn’t a one‑off fine‑tune; it’s an engineering discipline spanning data, prompts, tools, and monitoring.

## See Also
- Prev: [39 — Universal Adversarial Attacks](39-universal-adversarial-attacks-aligned-llms-zou-2023.md)
- Next: [41 — PoisonedRAG](41-poisonedrag-knowledge-corruption-attacks-zou-2024.md)

