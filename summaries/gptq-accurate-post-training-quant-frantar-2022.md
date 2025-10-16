# GPTQ: Accurate Post-Training Quantization for Generative Pre-trained Transformers

**Authors:** Elias Frantar, Saleh Ashkboos, Torsten Hoefler, Dan Alistarh  
**Venue:** ICLR 2023  
**Year:** 2022 (published 2023)  
**arXiv:** [2210.17323](https://arxiv.org/abs/2210.17323)

## TL;DR

- GPTQ enables **one-shot quantization** of massive language models (up to 175B parameters) to 3-4 bits per weight in just a few GPU hours, with negligible accuracy loss compared to full precision models.
- The method extends Optimal Brain Quantization with three critical optimizations: **arbitrary-order quantization** (all rows use the same column order), **lazy batch updates** (process 128 columns at a time for better GPU utilization), and **Cholesky decomposition** for numerical stability.
- On OPT-175B, GPTQ achieves 4-bit quantization with only **+0.03 perplexity increase** (8.34 → 8.37 on WikiText2), while baseline round-to-nearest methods degrade by over 2 points; at 3-bit, RTN collapses entirely while GPTQ maintains reasonable performance (+0.34 perplexity).
- Practical impact: enables **single-GPU inference** for OPT-175B (previously required 5 GPUs) and delivers **3.25-4.5× end-to-end speedups** through custom kernels that exploit reduced memory bandwidth requirements.
- The approach is **post-training only**—requires no model retraining, just 128 random calibration samples—making it feasible for billion-parameter models where fine-tuning would be prohibitively expensive.

## 1. Problem and Motivation

Large generative transformer models like GPT-3 and OPT-175B have demonstrated breakthrough performance on complex language tasks, but their massive scale creates severe deployment challenges. A 175-billion parameter model stored in FP16 format occupies **326GB of memory**, exceeding even the highest-end single GPU capacity (80GB on NVIDIA A100). This forces inference onto expensive multi-GPU setups, limiting accessibility for researchers and practitioners.

While model compression via quantization is a standard solution, existing approaches face a critical tradeoff. **Training-based quantization methods** that achieve low bitwidths require extensive retraining or fine-tuning, which costs hundreds of GPU-years for billion-parameter models. Conversely, **post-training methods** that compress models in one shot without retraining have historically been too inaccurate at aggressive compression rates or too computationally expensive to scale beyond models with ~100 million parameters.

At the time of this work, only basic round-to-nearest (RTN) quantization had been successfully applied to models at the 175B scale (Yao et al., 2022; Dettmers et al., 2022). While RTN works adequately at 8-bit, it fails catastrophically at 3-4 bits—the compression levels needed to fit these models on consumer hardware. **The central question**: Can one-shot post-training quantization achieve both extreme compression (3-4 bits) and high accuracy on truly massive language models?

## 2. Core Idea and Contributions

GPTQ answers this question affirmatively by extending **Optimal Brain Quantization (OBQ)**, a theoretically-grounded second-order quantization method, with three major algorithmic innovations that together enable scaling to hundreds of billions of parameters:

1. **Arbitrary Order Insight**: Unlike OBQ's greedy weight selection, GPTQ quantizes all weight matrix rows in the same column order. This seemingly simple change has profound implications: the Hessian inverse (which captures second-order curvature information) becomes shared across all rows, reducing inverse updates from O(d_row · d_col) to O(d_col)—a reduction of several orders of magnitude for large models.

2. **Lazy Batch Updates**: To address GPU memory-throughput bottlenecks, GPTQ processes weights in blocks of B=128 columns, keeping updates localized within blocks before performing global updates. This dramatically improves GPU utilization by increasing the compute-to-memory-access ratio.

3. **Cholesky Reformulation**: For numerical stability at scale, GPTQ precomputes all necessary Hessian inverse information using robust Cholesky decomposition, avoiding the indefinite matrices that arise from repeated inverse updates and cause catastrophic quantization failures in large models.

The resulting method quantizes the **OPT-175B and BLOOM-176B models in approximately 4 GPU hours** on a single A100, achieving 3-4 bits per weight with accuracy that matches or exceeds all prior post-training approaches.

## 3. Method

GPTQ follows a **layer-wise quantization** framework, processing one linear layer at a time. For each layer with weight matrix **W** and layer inputs **X** (collected from a small calibration dataset), the goal is to find quantized weights **Ŵ** that minimize the reconstruction error: **argmin ||WX - ŴX||²₂**.

The method operates in several stages:

**Stage 1: Hessian Computation**. For each layer, compute the Hessian of the quantization objective: **H = 2XX^T**. A small dampening term λI (1% of average diagonal value) is added for numerical conditioning. The Hessian inverse **H⁻¹** is then computed via Cholesky decomposition, which provides all the information needed for the quantization process in a numerically stable form.

**Stage 2: Block-wise Quantization**. The algorithm processes weight columns in blocks of size B=128. Within each block:
- Quantize each column sequentially: **Q[:,j] = quant(W[:,j])**
- Compute the quantization error scaled by the Hessian: **E[:,j] = (W[:,j] - Q[:,j]) / [H⁻¹]_jj**
- Update remaining weights within the block to compensate for this error
- After completing the block, perform a global update to all remaining unquantized weights

The quantization function `quant(·)` maps weights to the nearest value on an asymmetric per-row grid determined by each row's min and max values (following LLM.int8() conventions). Critically, while individual weights are quantized independently, their effect on downstream weights is determined by second-order information captured in the Hessian.

**Stage 3: Progressive Block Processing**. To minimize GPU memory requirements, GPTQ loads one Transformer block (typically 6 layers) at a time, accumulates layer inputs, performs quantization, then passes activations through the quantized block to generate inputs for the next block. This ensures each layer sees the actual activations from the partially-quantized model rather than the full-precision baseline, improving final accuracy.

The entire process uses just **128 random 2048-token segments from the C4 dataset** for calibration—a generic text corpus that requires no task-specific data, preserving true zero-shot evaluation.

## 4. Comparison to Prior Work

**vs. Round-to-Nearest (RTN)**: RTN simply rounds each weight to its nearest quantization level. This is fast and works well at 8-bit, but fails dramatically at lower bitwidths. On OPT-175B at 4-bit, RTN degrades perplexity by **+2.2 points** while GPTQ adds only **+0.03**. At 3-bit, RTN collapses entirely (perplexity increases by over 7000×) while GPTQ maintains a reasonable **+0.34** degradation. GPTQ **more than doubles the compression rate** at similar accuracy.

**vs. Training-Based Methods**: Methods like AdaRound and BRECQ that optimize quantization grids through gradient descent achieve state-of-the-art accuracy on small models but become computationally intractable at scale. ZeroQuant's knowledge distillation variant takes **~3 hours for a 1.3B model**, which would extrapolate to **several weeks for 175B models**. GPTQ quantizes models **100× larger in similar time**.

**vs. OBQ (Original)**: The original OBQ method uses greedy weight selection and updates the Hessian inverse d_row · d_col times. This gives complexity **O(d_row · d³_col)**, making it impractical beyond ~100M parameters (takes ~1 hour for ResNet-50's 25M parameters). GPTQ's fixed-order approach reduces complexity to **O(max{d_row · d²_col, d³_col})**, enabling **three orders of magnitude speedup** through reduced Hessian updates and improved GPU utilization.

## 5. Results and What They Mean

**Perplexity on Language Modeling**: On WikiText2, GPTQ achieves near-lossless 4-bit quantization across all model scales. For OPT-175B: FP16 baseline of 8.34 becomes 8.37 at 4-bit (+0.03) and 8.68 at 3-bit (+0.34). BLOOM-176B shows similar patterns: 8.11 → 8.21 (4-bit) → 8.64 (3-bit). Critically, larger models appear **easier to quantize**, with smaller relative degradation—good news since these are precisely the cases where compression matters most.

**Zero-Shot Task Performance**: On LAMBADA word prediction, OPT-175B maintains **76.80% accuracy at 4-bit** (vs. 75.59% baseline) and **76.19% at 3-bit**. Similar robustness appears on PIQA, ARC, and StoryCloze tasks. Notably, 4-bit quantization sometimes slightly improves accuracy, likely due to regularization effects.

**Extreme Quantization**: With group-wise quantization (independent quantization grids for groups of 128 weights), GPTQ achieves approximately **2.2 bits per weight** with less than 1.5 point perplexity increase. Ternary quantization (weights restricted to {-1, 0, +1}) yields 9.20 perplexity on OPT-175B, less than 1 point above baseline.

**Practical Deployment**: The 3-bit OPT-175B model requires approximately **63GB** (including embeddings and output layer kept in FP16), enabling inference on a **single 80GB A100** versus 5 GPUs for FP16. Custom CUDA kernels for quantized-matrix × FP16-vector products achieve **3.25× speedup on A100** and **4.5× on A6000 GPUs** by reducing memory bandwidth requirements. Lower-bandwidth GPUs benefit more since they're more severely memory-bound.

**Runtime Scalability**: GPTQ quantizes OPT-13B in 21 minutes, OPT-175B in 4.2 hours, and BLOOM-176B in 3.8 hours on a single A100—validating its claim as the first post-training method practical for truly massive models.

## 6. Limitations and Failure Modes

**No Computational Reduction**: Current speedups come entirely from reduced memory movement, not fewer operations. The quantized×FP16 kernel still performs the same number of multiply-accumulates as FP16×FP16. Speedups require **hardware support for low-precision integer arithmetic** (e.g., INT4 operations), which mainstream GPUs currently lack.

**Activation Quantization Absent**: GPTQ quantizes only weights, keeping activations in FP16. For generative inference (the target use case), activations are relatively small compared to weights, so this isn't a significant bottleneck. However, for batch processing or non-generative tasks, activation memory could become limiting.

**Numerical Instability Risk**: While Cholesky decomposition substantially improves robustness, very large models can still occasionally hit numerical issues. The probability increases with model size, affecting "at least a few layers" on models beyond a few billion parameters. Dampening helps but doesn't eliminate the risk entirely.

**Perplexity-Task Gap**: The work focuses heavily on perplexity, which is known to be stringent but may not perfectly correlate with downstream task performance. More comprehensive evaluation across diverse tasks would strengthen conclusions.

**Grouping Overhead**: While group-wise quantization significantly improves accuracy at low bitwidths, it adds overhead: group size 128 adds ~0.15 bits per weight for storing per-group scale factors. This is acceptable but reduces effective compression.

## 7. Fit to This Course

**Week 6: Inference Efficiency & Hardware**

GPTQ directly addresses the **quadratic bottleneck in inference** not through attention mechanism redesign (like FlashAttention) but through aggressive weight compression that reduces the memory footprint of model parameters themselves. This complements KV caching by addressing a different memory bottleneck.

The paper exemplifies **quantization schemes** (the third key topic for Week 6) at an advanced level. While the syllabus mentions 8-bit, 4-bit, and GPTQ specifically, this work demonstrates how theoretical computer science (second-order optimization, numerical linear algebra) combines with systems engineering (GPU kernel design, memory hierarchy awareness) to make these schemes practical.

**Connection to Hardware Mechanics**: GPTQ's three-stage optimization (arbitrary order, lazy batching, Cholesky) maps directly to GPU architecture constraints:
- **Memory bandwidth vs. compute**: Modern GPUs have massive compute capabilities but relatively limited memory bandwidth. Operations with low compute-to-memory-access ratios (like element-wise updates) underutilize the hardware. Lazy batching addresses this by grouping operations.
- **Numerical precision limitations**: Standard FP16 arithmetic accumulates errors, which becomes catastrophic when repeatedly inverting large matrices. Cholesky decomposition leverages established numerical methods to maintain stability.
- **Tensor core capabilities**: Custom kernels exploit the fact that quantized weights require less memory transfer, yielding speedups even without hardware acceleration for INT4 operations themselves.

**Lab Relevance**: If the course lab implements quantization schemes, GPTQ provides a concrete example of **post-training quantization** that could be compared against quantization-aware training or simple rounding baselines. The calibration-based approach (using just 128 samples) offers a practical middle ground between zero-calibration (RTN) and expensive fine-tuning.

## 8. Discussion Questions

1. **Why does arbitrary-order quantization work nearly as well as greedy selection for large models but not small ones?** Consider how the ratio of free parameters to quantization steps changes with model scale, and what this means for the optimization landscape.

2. **GPTQ achieves speedups from reduced memory movement, not reduced computation. What architectural changes to GPUs would enable further speedups?** Think about mixed-precision matrix multiplication units and how vendors might prioritize such features.

3. **The paper shows that larger models are easier to quantize (in relative terms). What properties of overparameterized networks might explain this, and what are the implications for future scaling?** Connect to the lottery ticket hypothesis and redundancy in neural networks.

4. **How does the layer-wise quantization approach interact with Transformer architecture?** Could the method be improved by quantizing multiple layers jointly, or does the block-wise nature of Transformers make layer-wise quantization natural?

5. **GPTQ uses second-order (Hessian) information while RTN uses only first-order (direct rounding). What is the computational and memory cost of this additional information, and when is it worthwhile?** Consider the tradeoff between calibration cost and deployment benefits.

## 9. Glossary

- **Post-Training Quantization (PTQ)**: Compressing a pre-trained model to lower precision without retraining, using only a small calibration dataset. Contrasts with quantization-aware training which modifies the training process itself.

- **Round-to-Nearest (RTN)**: Simplest quantization approach that maps each weight to its closest value on a predefined grid. Fast but inaccurate at low bitwidths due to accumulated rounding errors.

- **Hessian Matrix**: The matrix of second partial derivatives of a loss function. Captures curvature of the loss landscape, indicating which directions weights can move with minimal impact on accuracy.

- **Layer-wise Reconstruction**: Quantization strategy that processes one layer at a time, minimizing the difference between full-precision and quantized layer outputs rather than global model loss.

- **Optimal Brain Quantization (OBQ)**: Second-order post-training quantization method that iteratively quantizes one weight at a time while updating remaining weights using Hessian information to compensate for quantization error.

- **Cholesky Decomposition**: Factorization of a positive-definite matrix **A** into **A = LL^T** where **L** is lower-triangular. Numerically stable method for computing matrix inverses and solving linear systems.

- **Lazy Batch Updates**: Optimization technique that groups operations together and defers global updates until a batch is complete, improving GPU utilization by increasing compute-to-memory-access ratio.

- **Group-wise Quantization**: Using independent quantization grids for small groups of consecutive weights rather than a single grid per layer. Improves accuracy at the cost of storing per-group scale factors.

- **Asymmetric Quantization**: Quantization scheme where the zero point can be anywhere in the range [min, max], not necessarily at zero. Contrasts with symmetric quantization centered at zero.

- **Perplexity**: Language modeling metric measuring how "surprised" a model is by a test sequence. Lower is better; equals exponentiated average negative log-likelihood.

- **Memory Bandwidth Bottleneck**: Performance limitation where computation is constrained not by processing speed but by how fast data can be moved between memory hierarchies (e.g., HBM to GPU cores).

- **KV Cache**: Optimization for autoregressive generation that stores previously computed key and value tensors to avoid recomputation. Reduces computation but increases memory requirements.

## References

- Frantar et al. (2022). "GPTQ: Accurate Post-Training Quantization for Generative Pre-trained Transformers." *ICLR 2023*. [arXiv:2210.17323](https://arxiv.org/abs/2210.17323)
- Frantar et al. (2022). "Optimal Brain Compression: A Framework for Accurate Post-Training Quantization and Pruning." *NeurIPS 2022*. [arXiv:2208.11580](https://arxiv.org/abs/2208.11580)
- Dettmers et al. (2022). "LLM.int8(): 8-bit Matrix Multiplication for Transformers at Scale." [arXiv:2208.07339](https://arxiv.org/abs/2208.07339)
- Yao et al. (2022). "ZeroQuant: Efficient and Affordable Post-Training Quantization for Large-Scale Transformers." [arXiv:2206.01861](https://arxiv.org/abs/2206.01861)
- Zhang et al. (2022). "OPT: Open Pre-Trained Transformer Language Models." [arXiv:2205.01068](https://arxiv.org/abs/2205.01068)

## Figure Insights

- Figure 1 (OPT/BLOOM Comparison): Compares perplexity/accuracy trade-offs of
  4-bit and 3-bit quantization across models and tasks.
- Figure 2 (GPTQ Block Procedure): Illustrates the block-wise reconstruction
  and Hessian update flow at the core of GPTQ.
- Algorithm 1 (Pseudocode): Presents the layer-wise GPTQ algorithm with Cholesky
  updates and lazy batching optimizations.
