# Scaling Laws for Neural Language Models

**Authors**: Jared Kaplan, Sam McCandlish, Tom Henighan, Tom B. Brown, Benjamin Chess, Rewon Child, Scott Gray, Alec Radford, Jeffrey Wu, Dario Amodei  
**Venue**: arXiv preprint  
**Year**: 2020  
**arXiv ID**: 2001.08361

---

## TL;DR

- Language model performance follows **smooth power-law relationships** with model size (N), dataset size (D), and compute budget (C) across more than seven orders of magnitude, with minimal dependence on architectural details like depth or width.
- **Compute-efficient training** requires training very large models on relatively modest amounts of data and stopping significantly before convergence—contradicting the common practice of training smaller models to full convergence.
- **Larger models are dramatically more sample-efficient**: they reach the same performance level with fewer optimization steps and less data, with the optimal model size growing as N ∝ C^0.73 while training steps grow negligibly (S ∝ C^0.03).
- To avoid overfitting, dataset size should scale sublinearly with model size as D ∝ N^0.74, meaning an 8x increase in model size requires only a ~5x increase in data.
- The **critical batch size** B_crit follows a power law with the loss value (not model size), enabling predictions about the optimal tradeoff between parallelism and training time.

---

## 1. Problem and Motivation

By 2020, deep learning had achieved remarkable success in language modeling, with models like GPT-2 producing coherent multi-paragraph text. However, researchers lacked a systematic understanding of how performance scaled with the fundamental resources at their disposal: model size, training data, and compute budget. Each new model was essentially an expensive experiment, with practitioners making ad-hoc decisions about architecture and training procedures.

Critical questions remained unanswered: How much should we increase model size versus dataset size as compute grows? Does a deep-but-narrow model outperform a shallow-but-wide one with the same parameter count? Should we train small models to convergence or large models partway? Without quantitative scaling laws, the field was navigating blindly toward larger models.

The motivation was both scientific and practical. Scientifically, discovering universal scaling relationships could reveal fundamental properties of neural language models and potentially generative modeling more broadly. Practically, such laws would enable researchers to predict performance before committing expensive compute resources, optimize training efficiency, and make principled decisions about model design and data collection.

---

## 2. Core Idea and Contributions

The paper's central finding is deceptively simple: **language model performance (measured by cross-entropy loss) follows precise power-law relationships with scale**. Specifically, when each factor is varied in isolation:

1. **Model size scaling**: L(N) = (N_c/N)^α_N with α_N ≈ 0.076 (Section 3.2)
2. **Dataset size scaling**: L(D) = (D_c/D)^α_D with α_D ≈ 0.095 (Section 3.3)  
3. **Compute scaling**: L(C_min) = (C_c/C_min)^α_C with α_C ≈ 0.050 (Section 6.1)

These relationships hold across model sizes from 768 parameters to 1.5 billion parameters, dataset sizes from 22 million to 23 billion tokens, and compute spanning eight orders of magnitude.

The paper's major contributions include:

**Unified overfitting equation** (Equation 1.5): When both N and D are varied, performance follows L(N,D) = [(N_c/N)^(α_N/α_D) + D_c/D]^α_D. This reveals that overfitting depends primarily on the ratio N^0.74/D rather than on N and D independently.

**Learning curve characterization** (Section 5): Training curves can be predicted using L(N,S_min) = (N_c/N)^α_N + (S_c/S_min)^α_S, where S_min adjusts for batch size effects using the critical batch size concept from prior work.

**Compute-efficient training strategy** (Section 6): The optimal allocation grows model size rapidly (N ∝ C^0.73) while keeping training steps nearly constant (S ∝ C^0.03), with batch sizes growing moderately (B ∝ C^0.24).

**Architectural universality**: Performance depends weakly on depth, width, number of attention heads, and feed-forward dimension ratios when total non-embedding parameters are held fixed (Section 3.1, Figure 5).

---

## 3. Method

The authors trained hundreds of Transformer decoder models on WebText2, an extended web-scrape dataset of 22 billion tokens. They systematically varied model architectures from (n_layer, d_model) = (2, 128) up to massive models with over a billion parameters, using configurations like (6, 4288) or (207, 768).

**Experimental design**: Rather than optimizing a single model, they treated each training run as a data point measuring how loss depends on controllable factors. They trained with fixed batch size (2^19 tokens) and learning rate schedules, using Adam optimizer for most models and Adafactor for the largest due to memory constraints.

The **compute estimate** C ≈ 6NBS counts floating-point operations, where N is non-embedding parameters, B is batch size, and S is training steps. Crucially, they exclude embedding parameters from N because including them obscured the clean power-law trends (Figure 6).

**Critical batch size adjustment**: Following McCandlish et al. (2018), they recognized that training at different batch sizes affects the steps-vs-data tradeoff. They defined the critical batch size B_crit(L) as the point where increasing batch size no longer improves compute efficiency. The relationship (S/S_min - 1)(E/E_min - 1) = 1 from prior work allows converting between actual steps S and the minimum steps S_min that would be needed when training at B << B_crit (Equation 5.4).

They measured B_crit empirically by training models at various batch sizes and fitting Equation 5.1, finding B_crit(L) ≈ B*/L^(1/α_B) with B* ≈ 2×10^8 tokens and α_B ≈ 0.21 (Figure 10, Section 5.1).

**Mathematical approach**: For the combined scaling law L(N,D), they used three principles: (1) rescaling with vocabulary size should only change overall factors, (2) L(N,D) must approach L(N,∞) as D→∞ and vice versa, and (3) the loss should have an analytic expansion in 1/D with integer powers. These led to the functional form in Equation 1.5, which they validated empirically (Figure 9).

---

## 4. Comparison to Prior Work

**1. vs. Hestness et al. (2017) on sample efficiency**: While Hestness et al. found that dataset size should scale super-linearly with model size, Kaplan et al. discover the opposite—dataset requirements grow sub-linearly as D ∝ N^0.74. This fundamental disagreement suggests different modeling regimes or data characteristics (Section 7).

**2. vs. Traditional architecture search**: Prior work like EfficientNet (Tan & Le, 2019) advocated for exponentially scaling depth and width with different coefficients. In contrast, Kaplan et al. show that for language models, precise architectural ratios matter little; a (6, 4288) model performs within 3% of a (48, 1600) model with the same parameter count, despite a 40x difference in aspect ratio (Figure 5). The key is total scale, not shape.

**3. vs. Standard training practice**: Researchers typically train models close to convergence (within ~2% of final loss). Kaplan et al. demonstrate that compute-efficient training should instead stop at ~10% above convergence (f = α_N/α_S ≈ 10%), using 7.7x fewer steps, 2.7x more parameters, and 35% less total compute to reach the same loss (Appendix B.3).

---

## 5. Results and What They Mean

**Power-law exponents** (Table 5): The fitted values α_N = 0.076, α_D = 0.095, and α_C^min = 0.050 quantify the diminishing returns from scale. For instance, doubling parameters improves loss by a factor of 2^(-0.076) ≈ 0.95, or about 5%. These exponents appear universal across the tested range.

**Sample efficiency** (Figure 2, Figure 19): A model with 10^9 parameters reaches the same loss as a 10^6 parameter model using 100x fewer optimization steps when training below the critical batch size. This dramatic efficiency gain compounds: larger models learn faster patterns (reaching low loss on early context tokens more quickly, Figure 20) and generalize better.

**Architectural independence** (Section 3.1): Varying the feed-forward ratio (d_ff/d_model) from 1 to 8, the aspect ratio (d_model/n_layer) by a factor of 40, or the attention head dimension causes less than 3% variation in loss when total parameters are fixed. This suggests that capacity, not topology, determines performance—a finding that simplifies architecture search enormously.

**Transfer learning** (Figure 8): Models trained on WebText2 show smooth performance improvements on Books Corpus, Wikipedia, and Common Crawl that closely parallel training distribution performance, with only a small constant offset. This indicates that better language modeling on one distribution reliably improves performance on others.

**The contradiction** (Section 6.3): Extrapolating the power laws predicts that at C* ~ 10^4 PF-days, the data requirements from compute-efficient training (D ∝ C^0.26) will be insufficient to prevent overfitting (which requires D ∝ N^0.74 ∝ C^0.54). This suggests the scaling laws must break down—potentially indicating an entropy floor for natural language around L* ~ 1.7 nats/token (Figure 15).

---

## 6. Limitations and Failure Modes

**Theoretical gap**: The paper provides no mechanistic explanation for why these power laws emerge or what determines the specific exponent values. Without theory, it's unclear when the laws might break down or how they generalize beyond language modeling (Section C).

**Small data regime**: The fits fail for extremely small datasets (< 2×10^7 tokens, corresponding to only ~40 steps per epoch). With such limited data, different dynamics may govern learning, and the reported overfitting formula becomes unreliable (Figure 16, Table 2).

**Batch size extrapolation**: Predictions for B_crit far from the explored loss range remain uncertain. Since B_crit determines the optimal parallelism strategy, errors here could significantly impact training time estimates at extreme scales (Section C).

**Context length confounding**: The compute estimate C ≈ 6NBS omits context-dependent terms proportional to n_ctx. For very large contexts where n_ctx > 12d_model, this approximation breaks down, potentially confounding the scaling relationships (Section C).

**Hyperparameter interactions**: While extensive, the hyperparameter search may have missed important factors. For example, optimal learning rates decrease with model size (Equation D.1), and this sensitivity might extend to other hyperparameters not thoroughly investigated (Section D.6).

**Generalization beyond Transformers**: All experiments used decoder-only Transformers on language modeling. Whether these laws apply to encoder-decoder models, non-autoregressive tasks, or other architectures remains untested.

---

## 7. Fit to This Course (Week 4: Scaling Laws & Compute Optimization)

This paper directly addresses Week 4's core topics on **empirical scaling of model size, dataset size, and compute budget**. It provides the foundational empirical evidence that:

1. **Model size scaling** (N): Performance improves predictably as models grow, with the power-law exponent α_N ≈ 0.076 establishing the rate of improvement. This directly informs decisions about how large to build models.

2. **Dataset size considerations**: The sublinear relationship D ∝ N^0.74 challenges the intuition that larger models always need proportionally more data. For the lab context, this means an 8x model size increase requires only ~5x more data to avoid overfitting.

3. **Compute optimization**: The compute-efficient frontier (Section 6) shows that as budgets grow by 10x, we should increase model size by ~5x, batch size by ~2x, and training steps negligibly. This provides concrete guidance for allocating computational resources.

The paper predates and motivates the **Chinchilla optimal scaling theory** (Hoffmann et al., 2022) mentioned in the syllabus. While Kaplan et al. found N ∝ C^0.73, Chinchilla's refinement suggested N ∝ C^0.5 and D ∝ C^0.5, spending compute more evenly between parameters and tokens. Understanding this evolution helps students appreciate how empirical scaling laws are refined over time.

For **data and model parallelization concepts** (Megatron-LM), this paper's finding that optimal training uses large models with relatively few steps (S ∝ C^0.03) has profound implications: it suggests prioritizing model parallelism to fit larger models in memory over data parallelism to speed up convergence through many training steps.

The **critical batch size** concept (Section 5.1) is essential for lab work on distributed training. Knowing that B_crit ≈ 2×10^8 tokens at convergence and scales as B_crit ∝ L^(-1/0.21) allows students to choose batch sizes that optimally balance wall-clock time against compute efficiency.

---

## 8. Discussion Questions

1. **Power-law origins**: Why might neural language models exhibit power-law scaling rather than logarithmic or exponential improvements? What properties of natural language or transformer architectures could explain these specific exponent values (α_N ≈ 0.076, α_D ≈ 0.095)?

2. **Architectural independence mystery**: The paper shows that a 6-layer wide model performs nearly identically to a 48-layer narrow model with the same parameter count (Figure 5). Does this suggest that transformers behave as ensembles of shallower networks (as hypothesized for ResNets), or is there a different explanation for this universality?

3. **Chinchilla revision**: Hoffmann et al. (2022) later found that Kaplan et al. underestimated optimal dataset size, proposing D ∝ C^0.5 instead of D ∝ C^0.27. What experimental or methodological differences might explain this discrepancy? How would you design an experiment to distinguish between these scaling relationships?

4. **Beyond convergence**: Kaplan et al. recommend stopping at 10% above converged loss for compute efficiency (Appendix B.3). What are the practical tradeoffs? When might training to full convergence be worth the extra compute (e.g., for deployment, fine-tuning, or interpretability)?

5. **The contradiction and limits**: The paper predicts scaling laws break down around C* ~ 10^4 PF-days and L* ~ 1.7 nats/token (Section 6.3). What might this breakdown look like in practice? Could we reach it through architectural innovation (Mixture-of-Experts, state-space models), or does it represent a fundamental limit of learning from text?

---

## 9. Glossary

**Power law**: A relationship where one quantity varies as a power of another, f(x) = ax^b. In this paper, loss scales as L ∝ N^(-α_N) with model size, meaning consistent proportional improvements require exponentially more resources.

**Non-embedding parameters (N)**: The count of model parameters excluding the vocabulary and positional embedding matrices. The paper finds cleaner scaling laws using this metric because embedding size depends on vocabulary choice rather than model capacity.

**Critical batch size (B_crit)**: The batch size that optimally balances training time and compute efficiency. Training at B << B_crit wastes time (too many sequential steps), while B >> B_crit wastes compute (diminishing returns from larger batches). Defined via the relationship (S/S_min - 1)(E/E_min - 1) = 1.

**Compute budget (C)**: Estimated floating-point operations for training, calculated as C ≈ 6NBS. The factor of 6 accounts for forward pass (2N), backward pass (4N), and processing B tokens for S steps.

**Early stopping**: Halting training before convergence when validation loss stops improving. Kaplan et al. show this is not just a regularization technique but the compute-optimal strategy, stopping around 10% above converged loss.

**Overfitting**: When a model performs better on training data than test data due to memorization rather than generalization. The paper finds overfitting scales as [(N/N_c)^(α_N/α_D) + D_c/D]^α_D - (N_c/N)^α_N.

**Sample efficiency**: The amount of data required to reach a target performance level. Larger models are more sample-efficient, reaching the same loss with fewer tokens processed (Figure 19).

**Learning curve**: The trajectory of loss as a function of training steps. Kaplan et al. show these follow L(N,S) = (N_c/N)^α_N + (S_c/S_min)^α_S after an initial transient period.

**Architectural hyperparameters**: Design choices like depth (n_layer), width (d_model), feed-forward dimension (d_ff), and number of attention heads (n_heads). The paper shows these matter much less than total parameter count.

**PF-days (Petaflop-days)**: A unit of compute equal to 10^15 floating-point operations per second sustained for 24 hours, or 8.64×10^19 total operations. Used to measure training compute at scale.

**WebText2**: An extended web scrape dataset of 20.3M documents containing 22.9 billion tokens, used for all experiments. Created by extracting text from Reddit links with ≥3 karma through October 2018.

**Transfer learning (in scaling context)**: Evaluating a model trained on one distribution (WebText2) on other distributions (Books, Wikipedia, etc.). The paper finds performance improvements transfer with only a constant offset (Figure 8).

---

## 10. References

- Kaplan, J., McCandlish, S., Henighan, T., et al. (2020). Scaling Laws for Neural Language Models. arXiv:2001.08361.
- McCandlish, S., Kaplan, J., Amodei, D., & OpenAI Dota Team (2018). An empirical model of large-batch training. arXiv:1812.06162.
- Hoffmann, J., Borgeaud, S., Mensch, A., et al. (2022). Training Compute-Optimal Large Language Models. arXiv:2203.15556.
- Hestness, J., Narang, S., Ardalani, N., et al. (2017). Deep learning scaling is predictable, empirically. arXiv:1712.00409.