# Hyena Hierarchy: Towards Larger Convolutional Language Models (Poli et al., 2023)

Michael Poli, Stefano Massaroli, Eric Nguyen, Daniel Y. Fu, Tri Dao, Stephen Baccus, Yoshua Bengio, Stefano Ermon, Christopher Ré. arXiv:2302.10866 (v3 Apr 2023).

## TL;DR
- Introduces Hyena, an attention-free, subquadratic operator built from interleaving implicit long convolutions with multiplicative gating.
- Matches attention-based Transformer quality on language modeling (WikiText‑103, The Pile) with ~20% less training compute at 2K length.
- Shows large speedups at long sequences: ~2× faster than optimized attention at 8K, and ~100× at 64K.
- On recall/induction reasoning tasks over sequences up to hundreds of thousands of tokens, Hyena closes the gap to attention and outperforms SSM-based operators.
- Provides an attention-free path to long-context modeling with unrestricted context and sublinear parameter scaling.

## Problem and Motivation
Transformers’ attention scales quadratically with sequence length, limiting context and compute. Subquadratic alternatives often require mixing with attention to reach quality. Can we design an attention-free operator that preserves attention’s key properties—data control, sublinear parameter scaling, and unrestricted context—while reducing complexity?

## Core Idea and Contributions
- Hyena operator: Compose two subquadratic primitives—implicit long convolution (filters parameterized by an FFN) and element-wise gating—in a recurrence; depth controls capacity.
- Data-controlled linear operator: Equivalent matrix view as product of data-controlled diagonal matrices and Toeplitz (convolution) matrices; entries are functions of the input.
- Efficient evaluation: Use FFT-based long convolutions and fused kernels to realize subquadratic time without materializing large matrices.
- Empirical performance: Attention-free stacks match Transformer perplexity on standard corpora; large sequence speedups; improved accuracy on long-sequence recall/induction.

## Method (plain-language)
- Long convolution: Convolutions with filter size as long as the input; implicitly parameterized by a small FFN with decay/windowing.
- Gating: Element-wise multiplicative conditioning; composes with convolutions in a recurrence to form the operator.
- Matrix view: Each step corresponds to multiplying by a data-controlled diagonal and a Toeplitz matrix; composition yields a powerful data-adaptive linear operator.

Why it works: Long convolutions provide global receptive fields; gating injects data control; composing them recovers attention-like expressivity with subquadratic cost.

## Comparison to Prior Work
- Linearized/sparse attention: Reduce asymptotics but typically need hybrid attention to reach quality; Hyena achieves attention parity without attention.
- SSMs (S4 family): Strong efficiency but lag on text; Hyena’s data-controlled long convolutions and gating better match attention’s behavior on discrete language.
- Transformers: Remain a quality bar; Hyena shows that attention is not strictly necessary to reach that bar at scale.

## Results and What They Mean
- Language modeling: Matches Transformer perplexity on WikiText‑103 and The Pile at sub‑billion scale with ~20% less FLOPs (2K context).
- Efficiency: ~2× faster than optimized attention at 8K, ~100× at 64K; crossover with attention around 2K–4K tokens.
- Reasoning: >50‑point gains over SSMs/others on long-context recall/induction; attention-free operators can learn in-context over very long sequences.

Implications:
- Viable alternative for very long contexts where attention is prohibitive; promising for long documents and memory-augmented systems.
- Simplifies some system bottlenecks (less quadratic KV), pairs well with serving optimizations for long prompts.

## Limitations and Failure Modes
- Kernel reliance: Speedups depend on optimized FFT-based kernels and may vary across hardware.
- Scale and generality: Results shown at sub‑billion scales; parity at larger scales needs further validation.
- Hybrid benefits: Some tasks may still benefit from occasional attention layers or cross-attention modules.

## Fit to This Course (Week: Week 11, Section: Retrieval‑Augmented Generation (RAG) & Memory)
- Key Topics & Labs: Trade-offs between memory, context, and knowledge; infrastructure for long-context serving.
- Relevance: Hyena’s subquadratic, attention-free modeling reduces compute for long contexts typical in RAG.

## Discussion Questions
1) When should Hyena layers replace attention vs. complement it (e.g., every N blocks)?
2) How do long convolution filters relate to retrieval spans; can we bias filters around passage boundaries?
3) What are the best practices for training stability and hyperparameters for implicit filters at larger scales?
4) How sensitive are Hyena’s speedups to hardware and kernel implementations?
5) Could Hyena’s operator extend to 2D/vision with benefits over ViT at high resolutions?

## Glossary
- Long convolution: Convolution whose kernel spans the entire input length; implemented efficiently with FFTs.
- Toeplitz matrix: Matrix form of discrete convolution with constant diagonals.
- Data-controlled operator: Linear operator whose coefficients depend on the input sequence.
- Subquadratic: Time complexity grows less than L^2 in sequence length.
- Attention-free: Architectures that exclude self-attention layers entirely.

## References and Claim Checks
- “Hyena interleaves implicit long convolutions and data-controlled gating” (Abstract; pdftotext lines ~16–19, 52–56, 70–76).
- “Matches Transformer quality with ~20% less compute at 2K; attention-free SOTA on WikiText‑103/The Pile” (lines ~19–21, 93–96).
- “2× faster at 8K and 100× at 64K; crossover near 2K–4K” (lines ~21–22, 903–907).
- “>50‑point accuracy gains on long-sequence recall/induction vs SSMs and others” (lines ~18–21, 89–96).

