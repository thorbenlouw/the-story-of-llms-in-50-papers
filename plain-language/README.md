# Plain‑Language Posts Index

This folder contains the course’s plain‑language posts, ordered to match the
syllabus. Each entry links to an explainer that connects the paper to the
course narrative with accessible analogies and context.

## Phase I: The Transformer Foundations

- Phase Overview: [The Transformer Foundations](phase-01-the-transformer-foundations.md)
- [01 — Attention Is All You Need](01-attention-is-all-you-need-vaswani-2017.md) — The Transformer
  architecture and self‑attention unlock parallelism and long‑range context.
- [02 — Recurrent Neural Network Regularisation](02-rnn-regularization-zaremba-2014.md) — RNN
  regularisation highlights limits of the pre‑Transformer era.
- [03 — Improving Language Understanding (GPT‑1)](03-improving-language-understanding-gpt1-radford-2018.md) —
  Pre‑train on next‑token prediction, then fine‑tune for tasks.
- [04 — BERT: Bidirectional Pre‑Training](04-bert-pretraining-devlin-2018.md) — Masked language modelling
  for deep bidirectional understanding.
- [05 — T5: Text‑to‑Text Transfer](05-t5-unified-text-to-text-raffel-2019.md) — Unifies all NLP tasks as
  text‑to‑text for a single training interface.
- [06 — RoFormer: Rotary Positional Embeddings](06-roformer-enhanced-transformer-su-2021.md) — Position as
  rotation for better long‑context behaviour and extrapolation.

## Phase II: Scaling and Efficiency

- Phase Overview: [Scaling and Efficiency](phase-02-scaling-and-efficiency.md)
- [07 — Scaling Laws for Language Models](07-scaling-laws-neural-language-models-kaplan-2020.md) — Bigger
  models predictably improve; plan scaling with power laws.
- [08 — Training Compute‑Optimal LLMs (Chinchilla)](08-training-compute-optimal-llm-hoffmann-2022.md) — Balance
  parameters and data for best returns per FLOP.
- [09 — Switch Transformers (Mixture‑of‑Experts)](09-switch-transformers-moe-fedus-2021.md) — Sparse
  activation routes tokens to a single expert for trillion‑scale capacity.
- [10 — LLaMA 2: Open Foundation + Chat](10-llama-2-open-foundation-touvron-2023.md) — Open models plus an
  open alignment and safety playbook.
- [11 — FlashAttention: IO‑Aware Exact Attention](11-flashattention-fast-io-aware-dao-2022.md) — Tile and
  fuse to cut memory traffic and speed attention.
- [12 — GPTQ: Accurate Post‑Training Quantisation](12-gptq-accurate-post-training-quant-frantar-2022.md) — 4‑bit
  weight compression for single‑GPU inference with minimal loss.

## Phase III: Alignment, Evaluation, and Safety

- Phase Overview: [Alignment, Evaluation, and Safety](phase-03-alignment-evaluation-safety.md)
- [13 — FLAN: Instruction Tuning](13-flan-finetuned-zero-shot-wei-2021.md) — Teach models to follow
  instructions across tasks; zero‑shot gets useful.
- [14 — Emergent Abilities of LLMs](14-emergent-abilities-llm-wei-2022.md) — Some skills appear suddenly at
  scale; prompting helps only past thresholds.
- [15 — HELM: Holistic Evaluation](15-helm-holistic-evaluation-liang-2022.md) — Standardised, multi‑metric
  evaluation across scenarios, risks, and costs.
- [16 — BIG‑bench: Community Capability Suite](16-big-bench-beyond-imitation-game-srivastava-2022.md) — 200+ tasks
  for broad capability and prompt‑sensitivity probes.
- [17 — InstructGPT: RLHF For Following Instructions](17-instructgpt-training-instructions-ouyang-2022.md) — Align
  with human preferences; smaller, aligned beats bigger, unaligned.
- [18 — Deep RL From Human Preferences (2017)](18-deep-rl-human-preferences-christiano-2017.md) — Learn rewards
  from pairwise preferences; the RM blueprint for RLHF.
- [19 — DPO: Direct Preference Optimisation](19-dpo-direct-preference-optimization-rafailov-2023.md) — Optimise on
  preferences directly; drop the reward model and PPO.
- [20 — Constitutional AI: Harmlessness From AI Feedback](20-constitutional-ai-harmlessness-bai-2022.md) — Replace
  many human labels with AI feedback guided by written principles.
- [21 — TruthfulQA: Measuring Imitative Falsehoods](21-truthfulqa-measuring-falsehoods-lin-2021.md) — Test when
  models parrot myths; truth vs informativeness trade‑offs.
- [22 — Measuring Faithfulness in Chain‑of‑Thought](22-measuring-faithfulness-cot-lanham-2023.md) — Intervene on
  the chain; separate reasoning from rhetoric.

Tip: Each post ends with a “See Also” section that links to the previous and
next paper to keep you oriented as you read through the series.

## Phase IV: Agents and the Future

- Phase Overview: [Agents and the Future](phase-04-agents-and-the-future.md)
- [23 — Chain‑of‑Thought Prompting](23-chain-of-thought-reasoning-wei-2022.md) — “Show your working” to unlock
  multi‑step reasoning on maths, logic, and symbolic tasks.
- [24 — ReAct: Reasoning + Acting](24-react-reasoning-and-acting-yao-2022.md) — Interleave thoughts, tool calls,
  and observations to ground answers.
- [25 — Toolformer: Self‑Taught Tool Use](25-toolformer-llms-use-tools-schick-2023.md) — Learn when/how to call
  tools via self‑annotation filtered by likelihood.
- [26 — Gorilla: API‑Accurate Generation](26-gorilla-llm-connected-apis-patil-2023.md) — Fine‑tune on schemas and
  examples for reliable, executable API calls.
- [27 — Flamingo: Multimodal Few‑Shot](27-flamingo-visual-language-model-alayrac-2022.md) — Bridge vision into LLMs
  with connectors; prompt across images + text.
- [28 — LLaVA: Visual Instruction Tuning](28-llava-visual-instruction-tuning-liu-2023.md) — Open recipe for
  multimodal chat via a lightweight visual adapter.
- [29 — Kosmos‑2: Grounded Multimodal](29-kosmos-2-grounding-multimodal-peng-2023.md) — From “see and tell” to
  “see and point” with spatial grounding tokens.

- [30 — RAG: Retrieval‑Augmented Generation](30-rag-retrieval-augmented-generation-lewis-2020.md) — Ground answers
  with retrieved evidence; updatable knowledge and provenance.
- [31 — Lost in the Middle](31-lost-in-the-middle-long-context-liu-2023.md) — Long contexts under‑use the
  middle; retrieval and formatting still matter.
- [32 — LoRA: Low‑Rank Adaptation](32-lora-low-rank-adaptation-hu-2021.md) — Parameter‑efficient fine‑tuning via
  low‑rank adapters; cheap, modular skills.
- [33 — PagedAttention (vLLM)](33-efficient-memory-management-pagedattention-vllm-kwon-2023.md) — OS‑style paging
  for KV cache; higher throughput on the same GPUs.
- [34 — MemGPT](34-memgpt-llms-operating-systems-wu-2023.md) — Structured memories and routines; models manage
  their own context across long tasks.
- [35 — Mamba](35-mamba-linear-time-sequence-modeling-gu-dao-2023.md) — Linear‑time SSM backbone; long contexts
  with lower cost.
- [36 — Retentive Network (RetNet)](36-retentive-network-retnet-wu-2023.md) — Dual‑mode retention for parallel
  training and cheap inference.
- [37 — Hyena Hierarchy](37-hyena-hierarchy-poli-2023.md) — Long‑range mixing via fast convolutions; efficient
  alternatives to attention.
- [38 — Jamba (Hybrid Transformer‑Mamba)](38-jamba-hybrid-transformer-mamba-lieber-2024.md) — Hybrid layers combine
  strengths for performance and efficiency at scale.
- [39 — Universal Attacks on Aligned LLMs](39-universal-adversarial-attacks-aligned-llms-zou-2023.md) — Transferable
  jailbreak suffixes break safety across models.
- [40 — Breaking Down the Defences](40-breaking-down-the-defenses-attacks-llms-2024.md) — Survey of LLM attacks;
  system‑level defence priorities.
- [41 — PoisonedRAG](41-poisonedrag-knowledge-corruption-attacks-zou-2024.md) — Small corpus poisons steer RAG;
  secure ingestion and retrieval.
- [42 — JailbreakZoo](42-jailbreakzoo-survey-jailbreaking-llms-chao-2024.md) — Taxonomy and benchmarks for
  jailbreaks; measure and harden safety.
- [43 — Red Teaming](43-red-teaming-reduce-harms-perez-2022.md) — Structured adversarial testing to find and fix
  harms before release.
- [44 — A Watermark for LLMs](44-watermark-large-language-models-kirchenbauer-2023.md) — Lightweight statistical
  marks enable post‑hoc detection and provenance.
- [45 — Certified Robustness to Word Substitutions](45-certified-robustness-word-substitutions-jia-2019.md) —
  Provable guarantees under word‑swap attacks.
- [46 — Poisoning During Instruction Tuning](46-poisoning-instruction-tuning-qi-2023.md) — Small, targeted poisons
  bias alignment; lock down the data pipeline.
