# Retentive Network: A Successor to Transformer for Large Language Models (Sun et al., 2023)

Yutao Sun, Li Dong, Shaohan Huang, Shuming Ma, Yuqing Xia, Jilong Xue, Jianyong Wang, Furu Wei. arXiv:2307.08621 (v4 Aug 2023).

## TL;DR
- Proposes RetNet, replacing attention with a multi-scale retention mechanism supporting parallel, recurrent, and chunkwise recurrent computation.
- Achieves training parallelism like Transformers, while enabling O(1) per-step inference without KV caches and with length-invariant latency/memory.
- Reports strong scaling curves and in-context learning; for a 7B model at 8k tokens, 8.4× faster decode and ~70% memory savings vs Transformers with KV cache.
- Chunkwise recurrent mode supports efficient long-sequence modeling with linear complexity.
- Positions RetNet as meeting the “impossible triangle”: training parallelism, good performance, and low-cost inference.

## Problem and Motivation
Transformers offer parallel training but incur quadratic attention cost and maintain large KV caches at inference, leading to memory-bound latency that worsens with length and batch. Many alternatives trade off performance or parallelism. Can we keep parallel training and competitive quality while delivering constant-time, cache-free inference?

## Core Idea and Contributions
- Retention mechanism: A content interaction that has dual forms—parallel (for training) and recurrent (for inference)—plus a chunkwise hybrid for long inputs.
- O(1) inference: The recurrent form yields constant per-step compute/memory and removes KV cache complexity, improving throughput and latency and making cost length-invariant.
- Chunkwise retention: Partition sequences; compute parallelly within chunks and summarize across chunks recurrently for linear long-sequence complexity.
- Strong empirical profile: Competitive scaling and in-context learning; substantial throughput and memory gains during inference; training memory/time savings vs Transformer baselines (even with FlashAttention).

## Method (plain-language)
- Derive a retention operator with parallel and recurrent formulations. During training, use the parallel form to fully exploit GPU parallelism. During inference, use recurrence to update a small state in O(1) per step.
- For long sequences, split into chunks. Within each chunk, use the parallel retention to compute local representations; across chunks, use recurrent summarization to control memory and complexity.
- Build a RetNet block with multi-scale retention heads and a feed-forward network.

Why it works: The same operator supports both training parallelism and efficient inference. Multi-scale retention captures contextual patterns across distances without quadratic attention.

## Comparison to Prior Work
- Linearized attention: Achieves recurrence but often loses modeling power. RetNet aims to retain Transformer-level quality while preserving recurrence.
- RNN accelerations: Efficient inference but sacrifice training parallelism; RetNet keeps training parallelism via the parallel retention formulation.
- SSMs (S4 family): Offer linear scaling but can underperform on language; RetNet targets LLM competitiveness with dual-form retention.

## Results and What They Mean
- 7B @ 8k: 8.4× faster decode, ~70% less GPU memory vs Transformer with KV cache; inference latency insensitive to batch size, enabling high throughput.
- Training: 25–50% memory savings and up to 7× acceleration vs standard Transformer; advantage even relative to FlashAttention implementations.
- Performance: Competitive scaling curves and in-context learning compared to Transformers.

Implications:
- Practical successor path: Constant-time inference without KV management simplifies serving stacks and improves cost predictability for long prompts.
- RAG & Memory (Week 11): Length-invariant inference cost makes RetNet attractive for multi-document prompts and long-running sessions.

## Limitations and Failure Modes
- Maturity and ecosystem: Less battle-tested than Transformers; tooling and integration paths are evolving.
- Behavior under extreme tasks: Need broader evidence across reasoning-heavy or tool-augmented tasks.
- Compatibility: Some features and optimizations (e.g., attention-specific tricks) do not transfer and require reengineering.

## Fit to This Course (Week: Week 11, Section: Retrieval‑Augmented Generation (RAG) & Memory)
- Key Topics & Labs: Trade-offs between memory, context, and knowledge; serving efficiency.
- Relevance: RetNet provides O(1) per-step inference and chunkwise linear modeling, directly addressing long-context serving and cost.

## Discussion Questions
1) How does retention compare to attention on tasks requiring explicit cross-position alignment?
2) What scheduling/batching changes would best exploit RetNet’s length-invariant latency in production serving?
3) Can chunkwise retention be aligned with passage boundaries in RAG to improve evidence utilization?
4) Which benchmarks most stress-test retention’s capacity for global reasoning vs. attention?
5) Could hybrid RetNet–attention layers yield the best of both worlds for specific submodules (e.g., cross-attention)?

## Glossary
- Retention mechanism: Dual-form operator with parallel and recurrent representations for training/inference.
- Chunkwise recurrent: Hybrid strategy that computes within chunks in parallel and summarizes across chunks recurrently.
- O(1) inference: Constant per-token compute/memory cost independent of sequence length.
- Length-invariant latency: Inference speed that does not degrade with input length.
- KV cache: Stored key/value tensors for attention; not needed in RetNet inference.

## References and Claim Checks
- “Retention supports parallel, recurrent, and chunkwise representations” (Abstract; pdftotext lines ~15–20, 126–133).
- “O(1) inference; improved throughput, latency, GPU memory; length-invariant cost” (lines ~18–19, 134–139).
- “7B @ 8k: 8.4× faster, ~70% memory savings vs Transformer KV cache” (lines ~134–138).
- “Simultaneous training parallelism and good performance (‘impossible triangle’)” (Figure 2 and text; lines ~102–114, 126–132).

