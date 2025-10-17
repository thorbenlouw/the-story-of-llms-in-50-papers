# Efficient Memory Management for LLM Serving with PagedAttention (Kwon et al., 2023)

Woosuk Kwon, Zhuohan Li, Siyuan Zhuang, Ying Sheng, Lianmin Zheng, Cody Hao Yu, Joseph E. Gonzalez, Hao Zhang, Ion Stoica. SOSP 2023. arXiv:2309.06180.

## TL;DR
- Identifies KV cache memory as the main throughput bottleneck for LLM serving due to fragmentation and duplication.
- Proposes PagedAttention: an attention algorithm that stores KV cache in fixed-size blocks (pages), enabling near-zero waste and flexible sharing.
- Builds vLLM atop PagedAttention, achieving 2–4× higher throughput than FasterTransformer/Orca at similar latency.
- Supports sharing KV across requests and candidates (e.g., prefix/beam sharing) with copy-on-write blocks.
- Improves with longer sequences, larger models, and complex decoding—exactly where serving gets hardest.

## Problem and Motivation
Serving LLMs is memory-bound: weights occupy most GPU memory and the rest must host dynamic KV cache for active requests. Existing systems preallocate large contiguous KV buffers per request, causing severe internal/external fragmentation and duplication, which limits batch size and kills throughput. We need a memory management and attention scheme that avoids fragmentation and enables sharing without sacrificing latency or accuracy.

## Core Idea and Contributions
- PagedAttention: reinterpret KV cache as virtual memory pages. Split each request’s KV into equal-sized blocks; store them non-contiguously and track a block table for attention reads.
- Eliminate fragmentation: small uniform blocks remove external fragmentation and reduce internal fragmentation via on-demand allocation.
- Shareable KV: enable within-request and cross-request sharing at block granularity (prefix sharing, beam search) using copy-on-write semantics.
- vLLM engine: couples PagedAttention with block-level memory management and preemptive scheduling to deliver high throughput with consistent latency.
- Generality: supports diverse decoding (greedy, sampling, beam) and mixed workloads without exposing sharing complexity to the scheduler/model code.

## Method (plain-language)
- KV cache paging: Treat tokens like bytes and requests like processes. Each token’s KV states map to one or more fixed-size blocks. Attention kernels read KV via a block table rather than contiguous pointers.
- Copy-on-write sharing: For shared prefixes (multiple samples for the same prompt, beams), blocks are shared until a write occurs; then a private block is allocated and written.
- Scheduling and batching: Iteration-level scheduling (“continuous batching”) keeps GPUs busy; PagedAttention’s abstraction allows flexible admission without managing per-request contiguous KV.
- Kernel adaptations: Fuse block-read with attention kernels (adapting FasterTransformer kernels) and reshape KV to suit block layouts for efficiency.

Why it works: Throughput is often limited by how many requests fit concurrently. Minimizing KV waste allows larger batches, which amortizes kernel launches and better utilizes compute.

## Comparison to Prior Work
- FasterTransformer: Optimizes kernels but keeps contiguous KV buffers, suffering fragmentation and poor sharing; vLLM surpasses throughput by 2–4× at similar latency.
- Orca: Throughput-oriented system with “buddy allocation” style KV management; still over-reserves memory and cannot fully share prefixes. vLLM wins without accuracy loss.
- Classic paging vs. DL caching: PagedAttention brings OS paging ideas to LLM KV management, with copy-on-write and block tables enabling sharing across decoding methods.

## Results and What They Mean
- 2–4× throughput improvements at matched latency against state-of-the-art baselines, with widening gains for longer contexts, larger models, and complex decoding.
- Near-zero KV waste: block-based allocation eliminates external fragmentation and curbs internal fragmentation; enables larger concurrent batches.
- Broad decoding support: efficient prefix sharing across multi-sample prompts and beam search, improving memory efficiency without recomputation.

Implications:
- Serving default: For production, PagedAttention-like paged KV with copy-on-write should be the baseline to maximize GPU utilization.
- RAG tie-in: With many retrieved passages, sequences get long; paged KV sustains throughput even as context grows, aligning with Week 11 goals.
- System design: Abstracting KV layout behind a block table simplifies schedulers and model executors; encourages unified handling of mixed decoding.

## Limitations and Failure Modes
- Kernel complexity: Block-aware kernels and memory layouts add engineering complexity and may lag new architectures until adapted.
- Cross-device sharing: Multi-GPU/multi-node scenarios need careful synchronization; vLLM centralizes KV management but adds coordinator overhead.
- Eviction/recompute: Under heavy load, KV eviction to CPU and recompute trades bandwidth and latency; tuning policies is non-trivial.
- Hardware assumptions: Benefits rely on sufficient bandwidth and cache behavior on current GPUs; portability to other accelerators may require rework.

## Fit to This Course (Week: Week 11, Section: Retrieval-Augmented Generation (RAG) & Memory)
- Key Topics & Labs: Infrastructure, Serving, and PEFT; throughput/latency measurement; trade-offs between memory, context, and knowledge.

Why it fits:
- Directly addresses KV cache—the dominant serving bottleneck for long contexts typical in RAG.
- Provides concrete serving techniques to meet lab goals of measuring and improving latency vs. throughput.
- Complements PEFT (LoRA) by enabling many concurrent adapters on one base via efficient KV use.

## Discussion Questions
1) How should block size be chosen to balance internal fragmentation vs. kernel efficiency?
2) When is copy-on-write sharing better than recomputing KV (consider prompt length, bandwidth, and latency SLOs)?
3) How do paged KV abstractions interact with speculative/parallel decoding and future attention variants?
4) What scheduling policies best exploit paged KV (e.g., prioritizing long prompts vs. short decodes)?
5) Can paged KV ideas extend to cross-device sharding or CPU-GPU tiering without hurting latency predictability?

## Glossary
- KV cache: Key/value tensors cached for past tokens in autoregressive decoding; dominates serving memory.
- Internal/external fragmentation: Waste from fixed large allocations vs. non-contiguous free space preventing large allocations.
- PagedAttention: Attention reading KV from fixed-size non-contiguous blocks via a block table.
- Copy-on-write: Share memory until a write occurs; then copy to a private block for modification.
- Continuous/iteration-level batching: Batching at each decode step to keep GPUs saturated as requests progress asynchronously.
- Prefix sharing: Reusing KV for shared prompt segments across samples/candidates.

## References and Claim Checks
- “PagedAttention inspired by virtual memory and paging; divides KV into blocks; near-zero waste; sharing within/across requests” (Abstract; pdftotext lines ~35–41, 150–161, 164–168).
- “2–4× throughput at similar latency vs. FasterTransformer and Orca” (Abstract; lines ~39–41, 173–186).
- “KV cache ≳30% of memory; weights ≈65%; fragmentation and duplication limit batch size” (Intro/Fig. 1; lines ~83–96, 104–116).
- “Copy-on-write block sharing supports multi-sample prompts and beam search” (lines ~1150–1167, 1176–1208).
- “Kernel adaptations fuse block reads with attention” (lines ~1496–1505).

