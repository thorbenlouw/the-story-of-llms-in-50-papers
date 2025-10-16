# FlashAttention: Fast and Memory-Efficient Exact Attention with IO-Awareness

**Authors**: Tri Dao, Daniel Y. Fu, Stefano Ermon, Atri Rudra, Christopher Ré  
**Venue**: NeurIPS 2022  
**arXiv**: [2205.14135](https://arxiv.org/abs/2205.14135)  
**Institution**: Stanford University, University at Buffalo

---

## TL;DR

- FlashAttention is an **IO-aware attention algorithm** that achieves 2-4× wall-clock speedup over standard attention by minimizing memory reads/writes between GPU HBM (slow) and SRAM (fast), not just reducing FLOPs.
- Uses **tiling** to process attention in blocks that fit in fast SRAM, avoiding materialization of the large N×N attention matrix in slow HBM, and employs **recomputation** in the backward pass instead of storing intermediate values.
- Achieves **Θ(N²d²/M) HBM accesses** versus Θ(Nd + N²) for standard attention, with a proven lower bound showing this is optimal for a range of SRAM sizes.
- Enables training Transformers **faster** (15% speedup on BERT, 3× on GPT-2) and with **longer context** (up to 64K sequence length with block-sparse variant), yielding quality improvements and breakthrough results on long-context tasks.
- Demonstrates that **memory access patterns, not just compute**, are the primary bottleneck for attention on modern GPUs, shifting focus from FLOP reduction to IO optimization.

---

## 1. Problem and Motivation

Transformer models have become the dominant architecture in NLP and vision, but they suffer from a fundamental scalability challenge: the self-attention mechanism has quadratic time and memory complexity in sequence length N. As sequences grow longer, this O(N²) bottleneck makes training and inference increasingly expensive and memory-intensive.

Many approximate attention methods have been proposed to reduce this complexity—from sparse approximations (Reformer, Longformer) to low-rank methods (Linformer, Performer). While these methods successfully reduce the theoretical number of floating-point operations (FLOPs) to near-linear in N, **they often fail to achieve meaningful wall-clock speedups** in practice. The authors identify a critical oversight: these methods focus on computational complexity while ignoring the cost of **memory access** (IO operations).

On modern GPUs, compute speed has vastly outpaced memory bandwidth. An A100 GPU has 19 TB/s SRAM bandwidth but only 1.5 TB/s HBM bandwidth—more than 10× difference. Most attention operations are **memory-bound**, meaning their runtime is dominated by reading and writing data between different levels of the GPU memory hierarchy, not by arithmetic operations. Standard attention repeatedly materializes the large N×N attention matrix in slow High Bandwidth Memory (HBM), incurring massive IO costs that no amount of FLOP reduction can address.

---

## 2. Core Idea and Contributions

FlashAttention introduces an **IO-aware exact attention algorithm** that explicitly minimizes data movement between GPU memory levels. The key insight is to restructure attention computation to avoid ever writing the full N×N attention matrix to HBM, instead keeping intermediate results in fast SRAM as much as possible.

The paper makes four major contributions:

1. **Algorithm Design**: A tiling-based attention algorithm that splits Q, K, V into blocks, loads them into SRAM, performs all attention operations there, and incrementally updates the output—all in a single fused CUDA kernel.

2. **Theoretical Analysis**: Proves FlashAttention requires O(N²d²/M) HBM accesses (where M is SRAM size and d is head dimension) versus Ω(Nd + N²) for standard attention. For typical values (d=64-128, M≈100KB), this represents up to 9× fewer memory accesses.

3. **Optimality Proof**: Demonstrates via a lower bound that no exact attention algorithm can asymptotically improve on this IO complexity for all SRAM sizes in the range [d, Nd].

4. **Block-Sparse Extension**: Extends the approach to block-sparse attention with complexity O(N²d²/M·s) where s is the sparsity ratio, enabling efficient attention on sequences up to 64K tokens.

---

## 3. Method

### The Memory Hierarchy Challenge

GPUs have a memory hierarchy with vastly different speeds: fast on-chip SRAM (19 TB/s, ~192KB per streaming multiprocessor) and slow HBM (1.5 TB/s, ~40GB). Standard attention:
1. Loads Q, K from HBM, computes S = QK^T, writes S to HBM
2. Reads S from HBM, computes P = softmax(S), writes P to HBM  
3. Reads P, V from HBM, computes O = PV, writes O to HBM

This materializes the N×N matrices S and P in HBM, incurring O(N²) memory accesses for each pass.

### Tiling Strategy

FlashAttention's core technique is **tiling**: split Q, K, V into blocks small enough to fit in SRAM, then compute attention incrementally block-by-block. The challenge is the **softmax coupling**—softmax is computed over each row, coupling all columns of K.

The solution uses **softmax decomposition**: For vectors x^(1), x^(2), we can compute softmax of their concatenation by tracking max and sum statistics:
- m(x) = max(m(x^(1)), m(x^(2)))
- ℓ(x) = e^(m(x^(1)) - m(x)) · ℓ(x^(1)) + e^(m(x^(2)) - m(x)) · ℓ(x^(2))

**Forward Pass Algorithm**:
- Set block sizes Bc = ⌈M/(4d)⌉, Br = min(⌈M/(4d)⌉, d)
- Outer loop: Load each K_j, V_j block (size Bc × d) into SRAM
- Inner loop: For each Q_i block (size Br × d):
  - Compute attention scores S_ij = Q_i K_j^T on SRAM
  - Update running max and sum statistics (m, ℓ)
  - Incrementally update output O_i using rescaled contributions
- Result: Exact attention with O(N) extra memory, no N×N matrix stored

**Backward Pass**: Instead of storing P (which would require O(N²) memory), FlashAttention recomputes attention blocks on-the-fly from Q, K, V during backpropagation. While this adds FLOPs, the reduction in memory access makes it faster overall. Only the softmax normalization statistics (m, ℓ) need to be saved from the forward pass.

**Kernel Fusion**: The entire attention computation—matrix multiplies, masking, softmax, dropout, and the second matrix multiply—is fused into a single CUDA kernel, avoiding intermediate writes to HBM.

### Block Sizes

Block sizes are chosen to fit in SRAM:
- Bc controls K, V block size: must fit Bc × d
- Br controls Q, O block size: must fit Br × d  
- Attention block S_ij must fit: Br × Bc
- Typical sizes: Bc ≈ 128-256 depending on M and d

---

## 4. Comparison to Prior Work

**1. vs. Standard Attention**:  
Standard implementations (PyTorch, Megatron) materialize S and P matrices in HBM, requiring Θ(Nd + N²) HBM accesses. FlashAttention avoids this materialization entirely, achieving Θ(N²d²/M) accesses. For d²/M ≪ N (always true in practice since d=64-128 and M≈100KB), this represents massive reduction—up to 9× fewer accesses as shown in Figure 2.

**2. vs. Approximate Attention Methods**:  
Methods like Reformer, Linformer, and Performer reduce FLOPs to O(N log N) or O(N), but they still suffer from memory access overhead and often achieve little wall-clock speedup for sequences under 2K tokens (Figure 3). FlashAttention provides exact attention that's faster than approximate methods for typical sequence lengths, with crossover only at 1K-2K tokens depending on the method.

**3. vs. Rabe & Staats [2021]**:  
Both use tiling and recomputation, but with different goals. Rabe & Staats focuses on reducing total memory footprint (max GPU memory used), while FlashAttention optimizes memory **accesses** (the primary runtime factor). Key differences: FlashAttention incrementally updates a single output copy (vs. K copies), analytically simplifies the backward pass (vs. full gradient checkpointing), and achieves 4% faster runtime at 512 tokens versus similar speed for Rabe & Staats.

---

## 5. Results and What They Mean

### Training Speed Improvements

FlashAttention demonstrates substantial end-to-end speedups across models:
- **BERT-large** (512 tokens): 15% faster than MLPerf 1.1 record (17.4 vs 20.0 minutes to target accuracy on 8× A100)
- **GPT-2 small** (1K tokens): 3.5× faster than HuggingFace, 2× faster than Megatron-LM  
- **GPT-2 medium**: 3× faster than HuggingFace, 1.8× faster than Megatron-LM
- **Long Range Arena**: 2.4× average speedup across tasks

These improvements come despite FlashAttention performing more FLOPs (due to recomputation)—demonstrating that **memory access, not computation, determines runtime**.

### Longer Context Enables Better Models

The linear memory scaling unlocks training with much longer sequences:
- **GPT-2 with 4K context** trains 30% faster than Megatron's 1K context version while achieving 0.7 better perplexity
- **Document classification**: 4.3 point improvement on MIMIC-III medical documents (16K vs 512 tokens); 8.5 point improvement on ECtHR legal cases (8K vs 512 tokens)
- **Path-X** (16K): FlashAttention achieves 61.4% accuracy—the **first Transformer** to beat random chance on this challenge
- **Path-256** (64K): Block-sparse FlashAttention achieves 63.1% accuracy—the **first sequence model** to succeed on this task

These results validate a key hypothesis: many tasks benefit from longer context, but standard attention's memory requirements prevented models from accessing it.

### Benchmarking

Runtime and memory scale favorably:
- Up to 7.6× faster than PyTorch on GPT-2 attention (Figure 1)
- 3× faster at common sequence lengths (128-2K)
- 20× more memory efficient than exact baselines
- Block-sparse variant faster than all approximate/sparse methods tested

---

## 6. Limitations and Failure Modes

**Implementation Complexity**: FlashAttention requires writing custom CUDA kernels—a far lower-level task than PyTorch programming. Each new attention variant needs a new kernel, demanding significant engineering effort. Implementations may not transfer across GPU architectures without modification.

**Hardware Specificity**: Block sizes must be tuned for each GPU's SRAM size. The A100 (192KB SRAM) allows different optimal block sizes than a T4 (smaller SRAM), leading to different speedup profiles (Figure 8 shows less speedup on T4).

**Single-GPU Scope**: The analysis assumes single-GPU computation. Multi-GPU attention parallelization introduces another memory hierarchy level (cross-GPU HBM transfer), requiring different optimization strategies not addressed here.

**Attention-Only**: While attention is the most memory-intensive Transformer operation, other layers (LayerNorm, MLP) also touch HBM. The paper doesn't address system-wide IO optimization.

**Crossover Points**: For very long sequences (>2K), some approximate methods become faster than FlashAttention. However, block-sparse FlashAttention remains fastest across all lengths tested.

---

## 7. Fit to This Course (Week 6: Inference Efficiency & Hardware)

FlashAttention directly addresses Week 6's core themes:

**Quadratic Bottleneck**: The paper provides both theoretical analysis and practical solution to attention's O(N²) memory complexity. The IO complexity proof (Theorem 2) shows FlashAttention achieves O(N²d²/M) HBM accesses—asymptotically optimal for the parameter regime.

**Hardware-Aware Optimization**: FlashAttention exemplifies **IO-aware algorithm design**, explicitly modeling the GPU memory hierarchy (HBM vs SRAM). This connects to the week's focus on understanding how hardware characteristics (bandwidth, memory size) constrain and inform algorithm design.

**Tiling and Fusion**: The paper demonstrates both techniques in detail. Tiling (Section 3.1) breaks computation into SRAM-sized blocks, while kernel fusion (Section 2.1) combines operations to minimize HBM traffic. Algorithm 1 provides concrete implementation guidance.

**Relation to KV Caching**: While FlashAttention targets training, the memory hierarchy principles apply to inference optimizations like KV caching. Both recognize that memory access patterns, not compute, determine performance on modern accelerators.

**Lab Connections**: Understanding FlashAttention prepares students for:
- Profiling memory-bound vs compute-bound operations
- Reasoning about cache-aware algorithm design  
- Recognizing when approximate methods provide insufficient speedup
- Implementing custom CUDA kernels for specialized operations

The paper shifts perspective from "make attention faster by reducing FLOPs" to "make attention faster by accessing memory less"—a crucial insight for modern deep learning systems.

---

## 8. Discussion Questions

1. **Memory Hierarchy Trade-offs**: FlashAttention performs more FLOPs (due to recomputation) but fewer memory accesses, yet achieves faster runtime. Under what conditions would recomputation slow down rather than speed up an algorithm? How does this relate to the arithmetic intensity concept?

2. **Approximate vs Exact**: Many approximate attention methods (Reformer, Linformer) have better asymptotic complexity than FlashAttention but are slower in practice for sequences <2K. What does this teach us about the gap between theoretical complexity and practical performance? When should we choose approximate methods?

3. **Multi-GPU Extension**: The paper identifies multi-GPU attention as a limitation. If we have 8 GPUs computing attention over a very long sequence, what new memory access patterns emerge? How would you modify FlashAttention's tiling strategy to account for cross-GPU communication costs?

4. **Generalization Beyond Attention**: The authors suggest FlashAttention principles could apply to other memory-bound operations (Section 5). Consider batch normalization or layer normalization—could similar tiling strategies reduce their HBM accesses? What about matrix multiplication in MLP layers?

5. **Hardware Evolution**: FlashAttention's speedup depends on the SRAM/HBM bandwidth ratio (currently ~10×). If future GPUs increase HBM bandwidth closer to SRAM bandwidth, how would this affect FlashAttention's advantages? Would the algorithm still be useful?

---

## 9. Glossary

**HBM (High Bandwidth Memory)**: GPU's main off-chip memory; larger capacity (~40GB) but slower bandwidth (~1.5 TB/s on A100). All model parameters and most intermediate activations reside here.

**SRAM (Static Random Access Memory)**: GPU's fast on-chip memory; much smaller (~192KB per streaming multiprocessor on A100) but 10× faster bandwidth (~19 TB/s). Used as cache for active computations.

**IO Complexity**: The number of memory reads and writes between different levels of the memory hierarchy (e.g., HBM ↔ SRAM). Often dominates runtime for memory-bound operations.

**Tiling**: Algorithmic technique that breaks a large computation into smaller blocks (tiles) that fit in fast memory. Each tile is processed completely before moving to the next, minimizing slow memory accesses.

**Kernel Fusion**: Combining multiple operations into a single GPU kernel to avoid intermediate writes to HBM. For example, fusing matmul → softmax → dropout → matmul.

**Memory-Bound Operation**: An operation whose runtime is limited by memory bandwidth rather than compute throughput. Most element-wise operations (softmax, ReLU, dropout) are memory-bound on modern GPUs.

**Arithmetic Intensity**: The ratio of FLOPs performed to bytes transferred from memory. High intensity operations (large matrix multiply) are compute-bound; low intensity (softmax) are memory-bound.

**Recomputation**: Trading compute for memory by recalculating intermediate values rather than storing them. In FlashAttention, the attention matrix is recomputed in the backward pass instead of being saved from the forward pass.

**Block-Sparse Attention**: Attention mechanism where sparsity is defined over blocks rather than individual elements. Predefined block patterns (e.g., butterfly) determine which blocks are computed vs masked to zero.

**Streaming Multiprocessor (SM)**: The basic processing unit of a GPU, containing CUDA cores and dedicated SRAM. An A100 has 108 SMs, each with 192KB SRAM.

**Gradient Checkpointing**: Memory optimization technique that recomputes parts of the forward pass during backpropagation instead of storing all intermediate activations. Trades compute for memory.

**Softmax Normalization Statistics**: In FlashAttention, the row-wise max (m) and sum (ℓ) values needed to correctly combine softmax computations across blocks. Storing only these O(N) values instead of the O(N²) attention matrix enables memory efficiency.

---

## 10. References

- Dao, T., Fu, D. Y., Ermon, S., Rudra, A., & Ré, C. (2022). FlashAttention: Fast and Memory-Efficient Exact Attention with IO-Awareness. *NeurIPS 2022*. [arXiv:2205.14135](https://arxiv.org/abs/2205.14135)
- Rabe, M. N., & Staats, C. (2021). Self-attention does not need O(n²) memory. *arXiv:2112.05682*
- Vaswani, A., et al. (2017). Attention is all you need. *NeurIPS 2017*
- Child, R., et al. (2019). Generating long sequences with sparse transformers. *arXiv:1904.10509*

## Figure Insights

- Figure 1 (Tiling Diagram): Visualizes block-wise attention computation and
  on-chip accumulation of softmax stats to avoid materializing O(N²) matrices.
- Figure 2 (HBM Access Analysis): Breaks down reads/writes per kernel showing
  major reductions from fusion and IO-aware design.
- Figure 3 (Runtime/Memory Benchmarks): Benchmarks vs PyTorch and Triton
  baselines across sequence lengths, demonstrating speed and memory savings.
