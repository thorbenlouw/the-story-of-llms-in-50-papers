# GPTQ: Accurate Post-Training Quantization for GPTs - Notes

**Paper:** GPTQ: Accurate Post-Training Quantization for Generative Pre-trained Transformers
**Authors:** Elias Frantar, Saleh Ashkboos, Torsten Hoefler, Dan Alistarh
**Year:** 2022 (Published at ICLR 2023)
**arXiv:** 2210.17323
**Course Week:** Week 6 - Inference Efficiency & Hardware

## Key Topics Alignment
- Quantization schemes (8-bit, 4-bit, GPTQ)
- Inference efficiency bottlenecks
- Memory vs compute tradeoffs
- Hardware-aware optimization

## Outline (10-12 bullets)

1. **Problem:** GPT-scale models (175B params) require hundreds of GB memory, limiting inference to multi-GPU setups; existing post-training quantization methods either don't scale or lose too much accuracy at low bitwidths

2. **Core Innovation:** GPTQ extends Optimal Brain Quantization (OBQ) with three major optimizations that enable scaling to billion-parameter models while achieving 3-4 bit quantization with minimal accuracy loss

3. **Key Insight 1 - Arbitrary Order:** Quantizing weights in arbitrary (fixed) order performs nearly as well as greedy order for large models, enabling all rows to use same column order

4. **Key Insight 2 - Lazy Batch Updates:** Process B=128 columns at a time, keeping updates local within blocks before global update; addresses memory-throughput bottleneck of low compute-to-memory-access ratio

5. **Key Insight 3 - Cholesky Reformulation:** Precompute Hessian inverse information using numerically-stable Cholesky decomposition to avoid indefinite matrices that cause catastrophic quantization failures in large models

6. **Method:** Layer-wise quantization minimizing ||WX - Ŵ X||²₂ using second-order (Hessian) information; processes one Transformer block (6 layers) at a time for memory efficiency

7. **Runtime Scaling:** Reduces complexity from O(d_row · d³_col) to O(max{d_row · d²_col, d³_col}), enabling 175B model quantization in ~4 GPU hours vs hundreds of hours for prior methods

8. **Results - Perplexity:** OPT-175B: 8.34 (FP16) → 8.37 (4-bit), 8.68 (3-bit); BLOOM-176B: 8.11 → 8.21 (4-bit), 8.64 (3-bit); RTN baseline collapses at 3-bit while GPTQ maintains reasonable accuracy

9. **Practical Impact:** Enables OPT-175B inference on single A100 GPU (at 3-bit); achieves 3.25× speedup on A100, 4.5× on A6000 via custom kernels for quantized-matrix × FP16-vector products

10. **Comparison to Baselines:** More than doubles compression vs round-to-nearest (RTN) at similar accuracy; competitive with AdaRound/BRECQ on small models while scaling 100× larger

11. **Extreme Quantization:** With grouping (g=128), can achieve ~2.2-bit with <1.5 PPL increase; ternary quantization achieves 9.20 PPL (vs 8.34 FP16) on OPT-175B

12. **Limitations:** No computational speedup for actual multiplications (only memory loading); requires hardware support for mixed-precision (FP16 × INT4); doesn't include activation quantization

## Key Technical Details

### Layer-wise Objective
- Minimize: argmin_Ŵ ||WX - Ŵ X||²₂
- W_l: weight matrix for layer l
- X_l: layer inputs from small calibration set (128 samples × 2048 tokens from C4)

### OBQ Extension
- Original OBQ: quantizes weights one-by-one in greedy order based on error
- GPTQ: quantizes all rows in same column order
- Benefit: Hessian inverse H⁻¹_F same for all rows (depends only on inputs X, not weights)
- Update H⁻¹ only d_col times instead of d_row · d_col times

### Algorithm Components
1. Compute Hessian inverse: H⁻¹ = (2XX^T + λI)⁻¹ via Cholesky
2. For blocks of B columns:
   - Quantize each column: Q[:,j] = quant(W[:,j])
   - Compute error: E[:,j-i] = (W[:,j] - Q[:,j]) / [H⁻¹]_jj
   - Update remaining weights in block
3. Global update after each block

### Quantization Grid
- Asymmetric per-row quantization on min-max grid
- Group-wise quantization (g=128, 1024) for better accuracy
- Compatible with any quantization scheme

## Results Summary

### Runtime (Single A100)
- OPT-13B: 20.9 min
- OPT-175B: 4.2 hours
- BLOOM-176B: 3.8 hours

### WikiText2 Perplexity (OPT-175B)
- FP16: 8.34
- 4-bit GPTQ: 8.37 (+0.03)
- 4-bit RTN: 10.54 (+2.2)
- 3-bit GPTQ: 8.68 (+0.34)
- 3-bit RTN: 7.3e3 (collapse)

### Zero-Shot LAMBADA Accuracy (OPT-175B)
- FP16: 75.59%
- 4-bit GPTQ: 76.80%
- 3-bit GPTQ: 76.19%

## Comparison to Prior Work

### vs RTN (Round-to-Nearest)
- RTN: Fast, used by LLM.int8(), ZeroQuant, nuQmm
- Works well at 8-bit, fails at 3-4 bit
- GPTQ: More than doubles compression at same accuracy

### vs Training-Based Methods
- AdaRound, BRECQ: Too slow for large models (hours for 100M params)
- ZeroQuant-LKD: 3 hours for 1.3B model → extrapolates to weeks for 175B
- GPTQ: Competitive accuracy at small scale, 1000× faster at large scale

### vs LLM.int8()
- LLM.int8(): 8-bit with outlier handling, no runtime improvement
- GPTQ: 3-4 bit, 3-4× faster inference, reduces GPU count

## Course Connection

### Inference Efficiency Theme
- Addresses memory bottleneck: 326GB (FP16) → 63GB (3-bit) for OPT-175B
- Enables single-GPU inference for models requiring 5-8 GPUs
- Speedup from reduced memory movement, not compute

### Hardware Awareness
- Memory bandwidth vs compute capability tradeoff
- Custom kernels for quantized×FP16 matrix-vector products
- Lazy batching to improve GPU utilization
- A6000 (lower bandwidth) benefits more than A100

### Quantization Fundamentals
- Post-training vs training-time quantization
- Second-order optimization (Hessian-based)
- Numerical stability at scale
- Granularity: per-row, per-group

## Questions for Discussion

1. Why does arbitrary order quantization work well for large models but not small ones?

2. How does GPTQ's second-order approach differ from simple rounding, and why is the Hessian critical?

3. What causes numerical instability when scaling to billions of parameters, and how does Cholesky address it?

4. Why does GPTQ achieve speedups without reducing actual compute? What hardware limitation prevents further gains?

5. How do grouping strategies interact with GPTQ, and what's the tradeoff between accuracy and bitrate?

## Important Sections/Claims to Verify

1. Section 4, Step 1: "Arbitrary order performs nearly as well as greedy, especially for large models"
2. Section 4, Step 2: Lazy batching provides "order of magnitude speedup for very large models"
3. Table 2: Runtime scaling - 175B in ~4 hours
4. Table 5: OPT-175B perplexity - 8.34 (FP16) to 8.37 (4-bit)
5. Table 6: 3.25× speedup on A100, 4.5× on A6000
6. Figure 1: Visual comparison showing RTN collapse at lower bits
7. Section 5: "Can fit OPT-175B into single 80GB A100"
8. Page 7: "More than doubles compression relative to prior methods"