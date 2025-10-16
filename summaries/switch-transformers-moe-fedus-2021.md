# Switch Transformers: Scaling to Trillion Parameter Models with Simple and Efficient Sparsity

**Authors:** William Fedus, Barret Zoph, Noam Shazeer  
**Venue:** Journal of Machine Learning Research (JMLR), 2022  
**Year:** 2021 (arXiv preprint)  
**arXiv ID:** [arXiv:2101.03961](https://arxiv.org/abs/2101.03961)

## TL;DR

- **Simplifies Mixture-of-Experts (MoE)** by routing each token to a single expert (k=1) instead of multiple, reducing computation and communication costs while maintaining quality.
- **Achieves 7x pre-training speedup** over the T5-Base baseline using the same computational budget (FLOPs per token), demonstrating superior sample efficiency.
- **Scales to trillion parameters** by introducing Switch-C (1.6T parameters) with stable training, combining expert, model, and data parallelism.
- **Introduces stability techniques** including selective float32 precision in routing, smaller weight initialization (0.1x scale), and expert dropout for fine-tuning.
- **Validates across tasks** with improvements in pre-training, fine-tuning (SuperGLUE +4.4 points), multilingual learning (91% of 101 languages see 4x+ speedup), and achieves 30% quality preservation when distilled to 1% of size.

## Problem and Motivation

Dense Transformer models have achieved remarkable success by scaling parameters, dataset size, and compute (Radford et al. 2018, Kaplan et al. 2020, Brown et al. 2020). However, this scaling is computationally intensive. The authors pose a fundamental question: can we increase parameter count while keeping FLOPs per token constant? This would provide a fourth axis for scaling beyond the three identified in prior scaling law research.

Traditional dense models activate all parameters for every input token. Mixture-of-Experts (MoE) models (Shazeer et al. 2017) challenged this by routing tokens to subsets of experts, achieving sparse activation. However, MoE adoption has been hindered by complexity, training instabilities, and communication costs. The Switch Transformer aims to address these challenges through architectural simplification and improved training techniques, making sparse expert models practical and efficient.

## Core Idea and Contributions

The Switch Transformer simplifies the MoE architecture by routing each token to exactly one expert (k=1), as opposed to the traditional top-k routing where k≥2. This "switching" decision gives the model its name. The key insight is that routing to a single expert preserves model quality while providing three concrete benefits:

1. **Reduced routing computation**: Computing assignments to one expert vs. multiple experts is cheaper.
2. **Smaller expert capacity**: Each expert processes fewer tokens, reducing memory requirements by at least half.
3. **Simplified implementation**: Communication patterns are simpler, with less all-to-all coordination overhead.

The architecture replaces the dense feed-forward network (FFN) layers in the Transformer with sparse Switch FFN layers. For a model with N experts, each token's representation is passed through a router (a learned linear layer producing logits over experts), which computes a softmax distribution. The token is sent to the expert with the highest probability, and the expert's output is scaled by the router's gate value before being passed to the next layer.

To manage experts distributed across devices, the authors define an **expert capacity** as: `(tokens_per_batch / num_experts) × capacity_factor`. If too many tokens are routed to an expert (overflow), those tokens skip expert processing and pass directly through the residual connection—a pragmatic solution given static tensor size requirements on TPUs.

## Method

**Routing Mechanism:** The router computes logits `h(x) = W_r · x` for token representation x, then applies softmax to produce probabilities `p_i(x)` over N experts. The Switch layer selects the argmax expert and routes the token there. The output is `y = p_i(x) · E_i(x)`, where E_i is the selected expert's computation.

**Load Balancing Loss:** To prevent all tokens from routing to a few popular experts, Switch Transformers employ an auxiliary load balancing loss. For N experts and batch B with T tokens, the loss is: `α·N·Σ(f_i · P_i)`, where f_i is the fraction of tokens dispatched to expert i, and P_i is the fraction of router probability mass allocated to expert i. Both should ideally be 1/N for uniform load. The coefficient α=0.01 throughout the paper ensures balance without overwhelming the primary objective (Section 2.2).

**Selective Precision Training:** A critical innovation is selective use of float32 precision. While most MoE work required full float32 training for stability (Lepikhin et al. 2020), Switch Transformers cast only the router computation to float32, keeping the rest in bfloat16. This achieves the speed of bfloat16 (nearly equal to pure bfloat16) while conferring the stability of float32, since the resulting dispatch and combine tensors are recast to bfloat16 before all-to-all communication (Table 2, Section 2.4).

**Smaller Initialization:** Standard Transformer initialization with scale s=1.0 proved unstable for Switch models. Reducing the initialization scale to s=0.1 (for weight matrices drawn from truncated normal with std=√(s/n)) dramatically improved quality and reduced variance across runs. Table 3 shows the average negative log perplexity improved from -3.60 to -2.72 with standard deviation dropping from 0.68 to 0.01 after only 3.5k steps.

**Expert Dropout for Fine-tuning:** Switch models have far more parameters than FLOP-matched dense baselines, risking overfitting on small downstream tasks. The authors propose using standard dropout rate (0.1) at non-expert layers but much larger dropout (0.4) inside expert FFN layers during fine-tuning. Table 4 shows this improves performance across GLUE, CNNDM, SQuAD, and SuperGLUE compared to uniform dropout rates.

## Comparison to Prior Work

1. **vs. MoE Transformer (Shazeer et al. 2017, 2018):** The original MoE used top-2 routing (k=2), sending each token to two experts. This doubles the expert capacity requirement and increases communication. Switch Transformer's k=1 routing halves expert capacity, simplifies routing logic, and reduces computation. Table 1 shows Switch-Base outperforms MoE-Base both per-step and per-time, achieving better quality (-1.561 vs -1.572) at higher throughput (1000 vs 860 examples/sec) with capacity factor 1.0.

2. **vs. Dense T5 Models (Raffel et al. 2019):** Switch models are FLOP-matched to dense counterparts—they use the same FLOPs per token but distribute parameters sparsely across experts. Switch-Base uses 128 experts at every other FFN layer, totaling ~3.8B parameters vs. T5-Base's 223M, yet both consume ~124B FLOPs per sequence. Figure 5 demonstrates Switch-Base 64 experts achieves the same quality as T5-Base in one-seventh the wall-clock time.

3. **vs. Model Parallelism:** Traditional model parallelism shards a dense model's weights across devices, incurring all-reduce communication at each layer. Switch Transformer's expert parallelism is complementary: it increases parameters without increasing FLOPs per token. Figure 6 shows Switch-Base (64 experts) achieves 2.5x speedup over T5-Large despite T5-Large using 3.5x more FLOPs per token via denser, larger layers.

## Results and What They Mean

**Pre-training Scaling:** On the C4 corpus, Switch models demonstrate consistent scaling with expert count. Figure 4 (left) shows that doubling experts from 2→256 steadily improves test loss, even with fixed FLOPs per token. This validates the hypothesis that parameter count is a separately important scaling axis. Figure 4 (right) shows Switch-Base with 128 experts achieves the same sample efficiency milestone (negative log perplexity) as T5-Base in 7.5x fewer steps.

**Fine-tuning Performance:** Table 5 reports results across diverse tasks. Switch-Base improves SuperGLUE by 4.4 points over T5-Base (79.5 vs 75.1) and Switch-Large by 2.0 points over T5-Large (84.7 vs 82.7). Notable gains appear in Winogrande (+6.7 for Switch-Base), closed-book TriviaQA (+6.2 for Switch-Base), and XSum summarization (+1.6). The only regressions occur on ARC datasets, suggesting sparse models may require further tuning for certain reasoning tasks.

**Multilingual Learning:** Pre-training on 101 languages with mC4 data, Switch Transformers improve over mT5-Base on all 101 languages (Figure 7). Figure 8 histograms the per-language speedup: the mean is 5x, and 91% of languages achieve at least 4x speedup to reach the mT5-Base quality threshold, demonstrating the architecture's universality across linguistic diversity.

**Distillation:** Large sparse models can be compressed into small dense models. Table 6 shows that initializing a 223M T5-Base model with non-expert weights from a 3.8B Switch-Base teacher, then distilling with a 0.75 hard / 0.25 soft label mix, preserves 30% of the teacher's quality improvement over the student baseline. Table 7 extends this, showing that even a 14.7B parameter sparse model (99% compression) retains 28% of quality gains when distilled into the 223M baseline.

**Trillion-Scale Models:** Switch-XXL (395B parameters, FLOP-matched to T5-XXL) and Switch-C (1.6T parameters) demonstrate successful scaling. Table 9 shows Switch-XXL achieves -1.086 negative log perplexity after 250k steps vs T5-XXL's -1.147—a gap equivalent to T5-XXL's improvement over 250k additional steps. Switch-C trains stably with no observed instabilities. However, Switch-XXL exhibits sporadic instability at the largest scale, preventing full 1M step training (Section 5.6).

## Limitations and Failure Modes

1. **Training Instability at Extreme Scale:** While Switch-C (1.6T parameters) trains stably, the Switch-XXL (395B parameters but 10x more FLOPs/token) exhibits sporadic training instability, preventing completion of the full pre-training run. The authors hypothesize this relates to the interaction between FLOPs per token and parameter count, but leave resolution as future work (Section 8).

2. **Dropped Tokens:** When expert capacity is exceeded, overflow tokens bypass expert computation, passing through only the residual connection. While typically <1% of tokens with proper load balancing, this represents wasted routing decisions. Appendix B explores a "No-Token-Left-Behind" iterative re-routing scheme but finds no empirical benefit, suggesting learned token-expert associations are fragile.

3. **Downstream Fine-tuning Gap:** Despite state-of-the-art pre-training perplexity, the largest Switch models don't always translate upstream gains to downstream tasks. For instance, Switch-C (1.6T params) achieves 87.7 exact match on SQuAD vs Switch-XXL's 89.6, despite similar C4 perplexity. The authors suggest this relates to FLOPs per token vs. parameter count trade-offs (Appendix E, Section 8).

4. **Communication Overhead:** Expert parallelism requires all-to-all communication to route tokens to experts on different devices and gather results. While Switch reduces this vs. top-k MoE, it still adds overhead beyond pure data parallelism. The authors report capacity factor 1.0-1.25 works best, balancing overflow vs. wasted computation (Table 1).

5. **Static Tensor Constraints:** TPU hardware requires statically sized tensors, necessitating the expert capacity mechanism. This creates a trade-off: higher capacity factors reduce dropped tokens but waste memory and computation on padding (Figure 3). GPU implementations might handle dynamic shapes differently but weren't explored.

6. **Limited Applicability Beyond FFN:** The paper focuses on replacing FFN layers. Appendix A explores Switch layers in self-attention (replacing Q, K, V projections) and observes quality improvements but greater instability with bfloat16, leaving this as future work.

## Fit to This Course

**Week 5: Mixture-of-Experts (MoE) Architectures**  
**Section:** Scaling and Efficiency (Phase II)  
**Key Topics & Labs:** Theory of sparse activation and conditional computation. Router mechanisms and load balancing. The efficiency trade-offs of MoE. Lab: Implementing a basic MoE layer and comparing its memory usage vs. a dense layer.

Switch Transformers exemplify the core Week 5 themes:

**Sparse Activation and Conditional Computation:** The Switch layer epitomizes conditional computation—each token's representation dynamically determines which expert processes it. Only one of N experts activates per token, achieving O(N) parameter scaling with O(1) computational scaling per example. This directly demonstrates the "theory of sparse activation" in practice.

**Router Mechanisms:** The router (learned weight matrix W_r producing softmax over experts) is the central mechanism students will implement in labs. The paper's detailed treatment of routing (Section 2.1), including the mathematical formulation of gate values p_i(x) and the k=1 simplification, provides clear guidance for lab implementations.

**Load Balancing:** The auxiliary loss (Equation 4 in Section 2.2) is essential to prevent routing collapse where all tokens go to few experts. Students will encounter this directly when implementing MoE layers—without load balancing, routing degenerates quickly. The paper's choice of α=0.01 and the analysis of how f_i and P_i should both approach 1/N gives concrete design principles.

**Efficiency Trade-offs:** The capacity factor analysis (Figure 3, Equation 3 in Section 2.2) illuminates the memory vs. dropped-token trade-off central to MoE design. Table 1's comparison of capacity factors 1.0, 1.25, and 2.0 shows that lower factors (closer to minimal memory) often perform better, challenging intuitions. This directly informs the lab exercise comparing memory usage of MoE vs. dense layers.

**Practical Implementation:** The pseudo-code in Appendix F (Figures 14-16) provides executable reference implementations in Mesh TensorFlow, showing how router probabilities, dispatch tensors, combine tensors, and all-to-all communication patterns work. While students may use simpler frameworks, this demonstrates production-scale patterns.

**Connection to Scaling Laws (Week 4):** Switch Transformers validate that parameter count is a fourth scaling axis beyond compute, data, and model size identified in Kaplan et al. (2020). This bridges Week 4's scaling laws with Week 5's efficiency mechanisms, showing sparse models as a concrete instantiation of scaling theory.

## Discussion Questions

1. **Router Learning:** The router must learn meaningful token-expert assignments without explicit supervision, relying only on the downstream task loss and load balancing auxiliary loss. What mechanisms prevent the router from learning arbitrary or random assignments? How does the gradient flow from expert outputs back to router logits enable meaningful specialization?

2. **Capacity Factor Trade-off:** Table 1 shows Switch models with capacity factor 1.0 outperform those with 2.0 despite dropping more tokens. Why might constraining expert capacity actually improve quality? Does this relate to regularization effects, or does it force the router to make better decisions under resource pressure?

3. **FLOPs vs. Parameters Puzzle:** Switch-C (1.6T params, low FLOPs/token) underperforms Switch-XXL (395B params, high FLOPs/token) on SQuAD despite similar pre-training loss. What does this suggest about the relative importance of model capacity vs. computational depth for different task types (knowledge vs. reasoning)? How should practitioners balance these axes?

4. **Scaling Beyond Transformers:** The paper focuses on replacing FFN layers with Switch layers. Could the same routing principle apply to attention mechanisms (explored briefly in Appendix A) or to other architectures like CNNs, RNNs, or graph networks? What properties of FFN layers make them particularly amenable to expert decomposition?

5. **Distillation Ceiling:** The best distillation preserves ~30% of sparse model quality gains at 99% compression. Is this a fundamental limit of knowledge distillation from sparse to dense, or could better techniques (e.g., distilling routing decisions, extracting only active experts per task) improve this? What would a "perfect" distillation preserve?

## Glossary

1. **Mixture-of-Experts (MoE):** A model architecture where multiple sub-networks (experts) exist, and a gating mechanism (router) dynamically selects which expert(s) process each input. Enables parameter scaling without proportional compute increase.

2. **Router:** A learned function (typically a linear layer + softmax) that computes assignment probabilities for routing inputs to experts. In Switch Transformers, outputs probabilities over N experts per token.

3. **Expert Capacity:** The maximum number of tokens each expert can process in a batch, calculated as `(tokens_per_batch / num_experts) × capacity_factor`. Necessary for static tensor allocation on accelerators.

4. **Capacity Factor:** A hyperparameter (typically 1.0-1.5) multiplying the even-split token allocation to provide buffer for routing imbalance. Higher values reduce dropped tokens but waste memory on padding.

5. **Dropped Tokens:** Tokens routed to experts that have exceeded their capacity. These bypass expert computation, passing through only the residual connection. Typically <1% with good load balancing.

6. **Load Balancing Loss:** An auxiliary loss term encouraging uniform distribution of tokens across experts. In Switch Transformers: `α·N·Σ(f_i · P_i)`, minimized when both fraction dispatched (f_i) and probability mass (P_i) equal 1/N.

7. **Selective Precision:** Training most of the model in bfloat16 but casting specific operations (here, the router) to float32. Achieves near-bfloat16 speed with float32 stability by localizing precision to critical numerics.

8. **Expert Dropout:** Applying higher dropout rates (e.g., 0.4) within expert FFN layers during fine-tuning, while using standard rates (0.1) elsewhere. Regularizes the larger parameter count of sparse models.

9. **All-to-All Communication:** A collective operation where each device sends unique data to every other device. Required in expert parallelism to route tokens (on device i) to experts (on device j≠i) and return results.

10. **Sparse Activation:** The property that only a subset of model parameters activate for any given input. Switch Transformers achieve this via routing: each token activates 1/N experts, making the model sparsely activated despite dense parameter count.

11. **FLOP-Matched:** Models designed to use the same number of floating-point operations per training example, enabling fair comparison. Switch-Base and T5-Base are FLOP-matched despite Switch-Base having ~17x more parameters.

12. **Distillation (Knowledge Distillation):** Training a smaller "student" model to mimic a larger "teacher" model's outputs (soft labels) in addition to ground-truth labels. Used here to compress sparse Switch models into dense deployable models.

## References

- Fedus, W., Zoph, B., & Shazeer, N. (2021). Switch Transformers: Scaling to Trillion Parameter Models with Simple and Efficient Sparsity. *arXiv preprint arXiv:2101.03961*. [Published in JMLR 2022]
- Shazeer, N., et al. (2017). Outrageously large neural networks: The sparsely-gated mixture-of-experts layer. *arXiv:1701.06538*.
- Shazeer, N., et al. (2018). Mesh-Tensorflow: Deep learning for supercomputers. *NeurIPS*.
- Lepikhin, D., et al. (2020). GShard: Scaling giant models with conditional computation and automatic sharding. *arXiv:2006.16668*.
- Raffel, C., et al. (2019). Exploring the limits of transfer learning with a unified text-to-text transformer. *arXiv:1910.10683* (T5).
- Kaplan, J., et al. (2020). Scaling laws for neural language models. *arXiv:2001.08361*.
- Brown, T. B., et al. (2020). Language models are few-shot learners. *arXiv:2005.14165* (GPT-3).

---

**Claim Verification Notes:**
- Table 1 (p. 9): Switch-Base capacity 1.0 achieves -1.561 quality at 1000 ex/sec vs MoE-Base -1.572 at 860 ex/sec
- Figure 5 (p. 13): "Switch-Base 64 expert model achieves the same quality in one-seventh the time"
- Table 5 (p. 16): SuperGLUE scores: Switch-Base 79.5 vs T5-Base 75.1 (+4.4 points)
- Section 4.3 (p. 17-18): "91% of languages benefiting from 4x+ speedups" over mT5-Base
- Table 6 (p. 17): 30% quality gain preservation with distillation noted as "(30%)"
- Section 2.4 (p. 10): Initialization scale reduced to 0.1x from 1.0x
- Table 3 (p. 10): Quality -2.72 vs -3.60, std dev 0.01 vs 0.68 with smaller init
- Table 9 (p. 23): Switch-XXL at 250k steps: -1.086 vs T5-XXL -1.147

## Figure Insights

- Figure 2 (Architecture): Depicts Switch layer with router selecting top-1
  expert and expert parallel all-to-all dispatch/return.
- Figure 3 (Capacity Factor): Shows impact of capacity factor on token drops
  and quality, motivating modest overprovisioning.
- Figure 5 (Speedup vs Quality): Plots wall-clock speed vs quality showing
  Switch models reaching targets in a fraction of time vs dense baselines.
