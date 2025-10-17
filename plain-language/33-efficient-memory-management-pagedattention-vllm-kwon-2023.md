Serving More Users with the Same GPUs: PagedAttention

Paper: Efficient Memory Management for LLM Serving with PagedAttention (vLLM) (Kwon et al., 2023)

## Introduction: The KV‑Cache Bottleneck
When LLMs generate text, they cache key/value (KV) tensors from attention so future tokens don’t recompute everything. Great for speed—but the cache fragments GPU memory when many requests of different lengths interleave. Like a warehouse filled with odd‑sized boxes, you end up with wasted space and lower throughput.

vLLM’s PagedAttention borrows a classic operating‑systems idea—paging—to pack and reuse KV memory efficiently. The result: far higher throughput and better GPU utilisation in real deployments.

## The Big Idea: Bring Virtual Memory to Attention
Instead of allocating one contiguous KV block per request, PagedAttention slices KV cache into fixed‑size “pages” that can be flexibly assigned and reclaimed. The attention kernels are modified to read these pages with minimal overhead.

Analogy 1: It’s like Tetris for GPU memory—standard‑sized pieces pack tightly, avoiding gaps.

Analogy 2: Think of a library using same‑size book boxes. Any book set fits into some number of boxes; when you return a set, the boxes go back into the pool—no awkward leftovers.

By turning a memory‑management problem into a paging abstraction, vLLM keeps GPUs busy and cuts tail latency. Crucially, it integrates with sampling and batching strategies common in serving.

Key concept call‑out: The “KV cache” is the working memory of attention. Managing it well is central to practical LLM throughput.

## The “So What?”: Throughput Wins and Lower Costs
In experiments, PagedAttention significantly boosts tokens‑per‑second at constant hardware. For teams operating chat or API services, that translates into lower cost per token and smoother latency under load. It also enables larger batches without running out of memory.

Beyond benchmarks, the approach shows the growing influence of systems thinking in LLMs: borrowing tools from OS design to unlock performance.

## Connecting the Dots: Engineering for Scale
In the course story, after we master training and adaptation (LoRA), we need to serve models to real users. PagedAttention is a prime example of the systems work that makes LLMs economical at scale. It dovetails with quantisation, faster attention kernels, and scheduling—together forming the backbone of modern inference stacks.

## Conclusion: Practical Magic from Paging
By treating attention memory like paged virtual memory, vLLM fits more work into the same GPUs. Next, we’ll look at MemGPT, which pushes tool‑use further by giving the model structured memories it can manage like an operating system.

## See Also
- Prev: [32 — LoRA](32-lora-low-rank-adaptation-hu-2021.md)
- Next: [34 — MemGPT](34-memgpt-llms-operating-systems-wu-2023.md)

