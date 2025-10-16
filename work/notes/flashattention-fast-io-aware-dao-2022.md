# FlashAttention: Fast and Memory-Efficient Exact Attention with IO-Awareness
## Notes and Outline

**Paper**: FlashAttention: Fast and Memory-Efficient Exact Attention with IO-Awareness
**Authors**: Tri Dao, Daniel Y. Fu, Stefano Ermon, Atri Rudra, Christopher Ré
**Year**: 2022
**Venue**: NeurIPS 2022
**arXiv**: 2205.14135

**Course Context**:
- Week 6: Inference Efficiency & Hardware
- Key Topics: Quadratic bottleneck in inference, KV Caching, FlashAttention mechanics (tiling and fusion), Quantization schemes

---

## Key Contributions

1. **IO-aware attention algorithm** that accounts for GPU memory hierarchy (HBM vs SRAM)
2. **Tiling technique** to avoid materializing N×N attention matrix in slow HBM
3. **Recomputation strategy** for backward pass that's faster despite more FLOPs
4. **Theoretical analysis**: O(N²d²/M) HBM accesses vs O(Nd + N²) for standard attention
5. **Lower bound proof**: No exact attention can asymptotically improve HBM accesses
6. **Block-sparse extension** for even longer sequences (up to 64K)

## Method Sketch

### Core Problem
- Standard attention has O(N²) memory and time complexity
- Most operations are memory-bound, not compute-bound on modern GPUs
- Existing approximate methods don't achieve wall-clock speedup due to memory access overhead

### Solution: IO-Aware Algorithm
1. **Tiling**: Split Q, K, V into blocks that fit in SRAM
2. **Incremental softmax**: Compute softmax by blocks using scaling trick
3. **Kernel fusion**: All operations (matmul, mask, softmax, dropout, matmul) in one CUDA kernel
4. **Recomputation**: Don't store attention matrix; recompute in backward pass from Q, K, V blocks

### Key Techniques
- **Forward pass**: 
  - Outer loop over K, V blocks (loads to SRAM once)
  - Inner loop over Q blocks (loads multiple times)
  - Maintains running statistics (m, ℓ) for softmax normalization
  - Block size: Bc = √(M/4d), Br = min(√(M/4d), d)

- **Backward pass**:
  - Recompute attention matrix on-the-fly
  - Store only softmax statistics (m, ℓ) and random number generator state
  - No need to store O(N²) attention matrix

## Prior Work Contrast

1. **vs. Standard Attention**:
   - Standard: Materializes N×N matrix, Θ(Nd + N²) HBM accesses
   - FlashAttention: No materialization, Θ(N²d²/M) HBM accesses
   - 9× fewer HBM accesses for typical values

2. **vs. Approximate Attention** (Reformer, Linformer, Performer):
   - Most approximate methods focus on FLOP reduction
   - Still have high memory access overhead
   - FlashAttention is exact and faster for seq length < 1K-2K

3. **vs. Rabe & Staats [66]**:
   - Both use tiling and recomputation
   - Rabe & Staats: Focuses on memory footprint
   - FlashAttention: Focuses on memory accesses (primary runtime factor)
   - FlashAttention: Incremental output update (1 copy) vs K copies in R&S

## Notable Results

### Training Speed
- **BERT-large**: 15% faster than MLPerf 1.1 record (17.4 vs 20.0 min)
- **GPT-2 small**: 3.5× faster than HuggingFace, 2× faster than Megatron-LM
- **GPT-2 medium**: 3× faster than HuggingFace, 1.8× faster than Megatron-LM
- **Long Range Arena**: 2.4× speedup on average

### Model Quality with Longer Context
- GPT-2 with 4K context: 0.7 better perplexity than 1K context
- MIMIC-III (medical docs): 4.3 point improvement (16K vs 512 seq length)
- ECtHR (legal docs): 8.5 point improvement (8K vs 512 seq length)
- **Path-X** (16K): First Transformer to achieve >50% accuracy (61.4%)
- **Path-256** (64K): Block-sparse FlashAttention achieves 63.1% accuracy

### Benchmark Performance
- Up to 7.6× faster than PyTorch attention (Fig 1)
- 3× faster runtime for seq length 128-2K
- 20× more memory efficient than exact attention baselines
- Scales to 64K sequence length

## Limitations

1. **CUDA implementation required**: Need low-level CUDA programming, not portable
2. **Block size tuning**: Optimal block sizes depend on SRAM size (hardware-specific)
3. **Single GPU focus**: Multi-GPU parallelization not addressed
4. **Limited to attention**: Other memory-bound ops in Transformers could benefit

## Figure Insights

- **Figure 1**: Shows tiling strategy and 7.6× speedup on GPT-2
- **Figure 2**: HBM access is primary runtime factor; block size affects performance
- **Figure 3**: Runtime and memory scaling with sequence length

## Equations/Algorithms

- **Standard attention**: S = QK^T, P = softmax(S), O = PV
- **Softmax decomposition**: Key insight for tiling
  - m(x) = max(m(x^(1)), m(x^(2)))
  - ℓ(x) = e^(m(x^(1)) - m(x)) · ℓ(x^(1)) + e^(m(x^(2)) - m(x)) · ℓ(x^(2))
- **IO complexity**: Θ(N²d²/M) for FlashAttention vs Θ(Nd + N²) for standard

## Course Connection

**Week 6 Topics**:
1. **Quadratic bottleneck**: FlashAttention addresses O(N²) memory and time
2. **KV Caching**: Related memory optimization for inference
3. **Tiling and fusion**: Core FlashAttention mechanics explained in detail
4. **Hardware awareness**: Explicit consideration of GPU memory hierarchy

**Lab Relevance**:
- Understanding SRAM vs HBM trade-offs
- Importance of kernel fusion for memory-bound operations
- How algorithmic improvements can beat hardware constraints
- Foundation for understanding other efficient attention variants

## Discussion Seeds

1. Why do approximate attention methods often fail to achieve wall-clock speedup despite FLOP reduction?
2. How does the memory hierarchy (SRAM/HBM) on GPUs differ from CPU cache hierarchies?
3. What are the trade-offs between recomputation and storing intermediate values?
4. How might FlashAttention principles apply to other memory-bound neural network operations?
5. What challenges arise when extending FlashAttention to multi-GPU distributed training?

## Glossary Terms

- **IO complexity**: Number of memory reads/writes between levels of memory hierarchy
- **HBM (High Bandwidth Memory)**: GPU's main memory (slower, larger ~40GB)
- **SRAM**: GPU on-chip memory (faster, smaller ~192KB per SM)
- **Tiling**: Breaking computation into blocks that fit in fast memory
- **Kernel fusion**: Combining multiple operations into single GPU kernel
- **Memory-bound operation**: Performance limited by memory access, not computation
- **Arithmetic intensity**: Ratio of FLOPs to memory accesses
- **Recomputation**: Recalculating values instead of storing them
- **Block-sparse attention**: Attention with predefined sparsity pattern in blocks
- **Streaming multiprocessor (SM)**: GPU processing unit with dedicated SRAM
- **Gradient checkpointing**: Trading compute for memory in backward pass
- **IO-aware algorithm**: Algorithm designed considering memory hierarchy

---

## 10-12 Bullet Outline for Summary

1. **Problem**: Transformers slow/memory-hungry on long sequences due to O(N²) attention; existing solutions don't achieve wall-clock speedup
2. **Core insight**: Memory access (IO) is the bottleneck, not FLOPs; need IO-aware algorithms
3. **Solution overview**: FlashAttention uses tiling + recomputation to avoid materializing N×N matrix
4. **Tiling technique**: Process attention in blocks that fit in fast SRAM; incremental softmax with statistics tracking
5. **Recomputation**: Don't store attention matrix; recompute in backward from Q,K,V blocks (faster despite more FLOPs)
6. **Theoretical results**: O(N²d²/M) HBM accesses vs O(Nd+N²); lower bound proof of optimality
7. **Training speedups**: 15% faster BERT, 3× faster GPT-2, 2.4× faster LRA
8. **Quality gains**: Longer context enables better models (0.7 ppl improvement, 6.4 points on doc classification)
9. **Breakthrough results**: First Transformer on Path-X (16K), Path-256 (64K with block-sparse)
10. **Block-sparse extension**: Sparsity proportional speedup; O(N²d²/M·s) complexity
11. **Limitations**: Requires CUDA programming; single-GPU focus; hardware-specific tuning
12. **Impact**: Foundation for efficient attention; demonstrates IO-awareness critical for deep learning
