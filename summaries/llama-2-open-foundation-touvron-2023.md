# Llama 2: Open Foundation and Fine-Tuned Chat Models

**Authors**: Hugo Touvron, Louis Martin, Kevin Stone, Peter Albert, and the GenAI team at Meta AI (50+ authors)

**Venue**: arXiv preprint

**Year**: 2023

**arXiv ID**: 2307.09288v2

---

## TL;DR

- Meta releases **Llama 2**, a family of open-source LLMs (7B, 13B, 70B parameters) and fine-tuned **Llama 2-Chat** models optimized for dialogue, achieving performance competitive with closed-source models like ChatGPT
- Introduces comprehensive **safety-first alignment methodology** including iterative RLHF with separate helpfulness and safety reward models, adversarial prompt collection, extensive red teaming (350+ participants), and context distillation techniques
- Demonstrates that **quality trumps quantity** in fine-tuning data—only ~27,540 high-quality supervised examples outperform millions of lower-quality examples, and RLHF enables models to surpass human annotator capabilities
- Proposes **Ghost Attention (GAtt)**, a novel technique for maintaining multi-turn dialogue consistency by distilling system instructions into the model without requiring them at inference time
- Achieves major safety improvements over Llama 1: truthfulness increases from 50.18% to 64.14% and toxicity drops from 24.60% to effectively 0% for the 70B model, while maintaining competitive performance on standard benchmarks
- Provides transparent documentation of entire training pipeline, safety mitigations, and limitations to enable responsible open-source LLM development

---

## 1. Problem and Motivation

Large language models have demonstrated remarkable capabilities as AI assistants, but their development has largely been confined to a few organizations due to computational requirements and limited transparency. While pretrained open-source models like Llama 1, BLOOM, and Falcon match closed-source alternatives in raw capability, they fall short of "product-ready" chat models like ChatGPT, Claude, and Bard. The gap lies in alignment—the extensive fine-tuning with human preferences that makes models helpful, harmless, and honest.

This alignment process is computationally expensive, requires significant human annotation, and is often opaque. Most organizations do not share their methodologies, safety mitigations, or the tradeoffs involved in creating production chat systems. This lack of transparency limits progress in AI alignment research and makes it difficult for the broader community to build safe, capable assistants.

Llama 2 addresses these challenges by **openly releasing both pretrained and fine-tuned models** along with comprehensive documentation of the entire pipeline. The goal is to democratize access to state-of-the-art conversational AI while advancing collective understanding of alignment techniques and safety measures. As the authors state in Section 1, "We believe that the open release of LLMs, when done safely, will be a net benefit to society."

---

## 2. Core Idea and Contributions

Llama 2's core contribution is demonstrating that **open development of aligned LLMs can achieve competitive performance while advancing safety research** through transparency. The project makes several key innovations:

**Pretraining Improvements** (Section 2): Building on Llama 1, the team trains on 40% more data (2 trillion tokens vs. 1.4T), doubles the context length to 4,096 tokens, and implements grouped-query attention (GQA) for efficient inference at scale. These changes improve both capability and practicality for deployment.

**Quality-Focused Fine-Tuning** (Section 3.1): Rather than using millions of instruction-following examples from third-party datasets, the team collects only ~27,540 high-quality supervised fine-tuning (SFT) annotations. Human evaluation reveals that outputs from this SFT model are "often competitive with SFT data handwritten by human annotators," suggesting diminishing returns from annotation scale and motivating a shift to RLHF.

**Iterative RLHF with Dual Reward Models** (Section 3.2): The team conducts five iterations (RLHF-V1 through V5) of alignment, combining rejection sampling and Proximal Policy Optimization (PPO). Critically, they train **separate reward models for helpfulness and safety** rather than a single model, addressing the inherent tension between being maximally helpful and appropriately cautious. The reward models use a novel margin-based ranking loss that accounts for the degree of preference (significantly better vs. slightly better).

**Ghost Attention (GAtt)** (Section 3.3): To maintain consistency with system-level instructions across multi-turn dialogues, the team introduces GAtt—a context distillation technique that trains the model to internalize constraints (like "always respond as Napoleon") without needing them in every turn. This is achieved by sampling with the instruction prepended, then fine-tuning with the instruction present only in the first turn while zeroing out loss on intermediate turns.

**Comprehensive Safety Pipeline** (Section 4): Beyond standard reward modeling, Llama 2 incorporates safety-specific supervised fine-tuning, safety RLHF with adversarial prompts, context distillation with safety preprompts, and extensive red teaming. The team demonstrates that adding safety data improves robustness to adversarial prompts without degrading helpfulness on benign requests.

---

## 3. Method

**Pretraining Architecture**: Llama 2 uses an optimized autoregressive transformer with several architectural choices: RMSNorm for pre-normalization, SwiGLU activation functions, and Rotary Position Embeddings (RoPE). The larger models (34B and 70B) use grouped-query attention (GQA) with 8 KV projection heads instead of traditional multi-head attention, reducing KV cache memory requirements during inference while maintaining performance. The models are trained with AdamW (β₁=0.9, β₂=0.95), cosine learning rate schedule, and a global batch size of 4M tokens.

**Supervised Fine-Tuning**: After pretraining, models undergo SFT on 27,540 high-quality examples covering helpfulness and safety. The team emphasizes quality over quantity—initial experiments with millions of third-party examples showed worse performance than smaller curated datasets. Annotators write both prompts and desired responses following guidelines that prioritize addressing safety concerns, explaining risks, and providing helpful context. Training uses a learning rate of 2×10⁻⁵, batch size 64, and 2 epochs.

**Reward Modeling**: The team collects over 1 million binary preference comparisons through weekly batches. Annotators compare two model responses and indicate which is better on a 4-point scale (significantly/better/slightly better/negligibly better). This preference data trains two separate reward models initialized from pretrained checkpoints:

- The **binary ranking loss** is L_ranking = -log(σ(r_θ(x,y_c) - r_θ(x,y_r) - m(r))), where m(r) is a margin term that increases for more separable pairs
- The **Safety RM** includes an auxiliary loss that explicitly teaches the model to discriminate safe vs. unsafe responses
- Separating safety and helpfulness prevents the inherent tension between the objectives from confusing a single reward model

**RLHF Iterations**: The team alternates between two RL techniques:

1. **Rejection Sampling**: Generate K responses (K varies by iteration), score with reward model, select the best, then fine-tune on these selections like SFT. Temperature is dynamically adjusted per iteration (optimal T∈[1.2,1.3] for RLHF models vs. T≈0.8 for SFT).

2. **PPO**: Optimize the policy to maximize R(g|p) = R̃_c(g|p) - βD_KL(π_θ(g|p)||π_0(g|p)), where R̃_c selects between safety and helpfulness rewards based on prompt classification and applies whitening. The KL penalty (β=0.01 for 7B/13B, β=0.005 for 34B/70B) prevents reward hacking.

The final RLHF objective balances exploration (rejection sampling) with depth (PPO updates), and progressively improves as better reward models are trained on data from newer model versions.

**Safety Techniques**: Beyond RLHF, several safety-specific methods are applied:

- **Safety SFT**: Annotators red team the model and write safe responses
- **Context Distillation**: Prepend safety instructions (e.g., "You are a safe and responsible assistant"), generate safer responses, then fine-tune on these outputs without the preprompt
- **Targeted Context Distillation**: Use category-specific preprompts with answer templates, but only apply when the reward model score improves
- **Red Teaming**: 350+ participants spanning security experts, ethicists, and diverse demographics probe for vulnerabilities

---

## 4. Comparison to Prior Work

**vs. Llama 1** (Touvron et al., 2023): Llama 2 trains on 40% more tokens (2T vs. 1.4T), doubles context length (4k vs. 2k), and adds grouped-query attention for 34B/70B models. More importantly, Llama 1 was pretrained-only; Llama 2-Chat introduces comprehensive alignment making it usable for dialogue (see Table 3 showing substantial benchmark improvements).

**vs. GPT-3/ChatGPT**: While GPT-3 demonstrated few-shot learning at 175B parameters and ChatGPT popularized instruction-following chat, neither released training details. Llama 2-Chat achieves comparable human evaluation scores (36% win rate, 31.5% tie vs. ChatGPT for 70B) while being fully open-source and documenting the complete methodology.

**vs. Chinchilla** (Hoffmann et al., 2022): Chinchilla argued for compute-optimal scaling prioritizing more tokens over parameters. Llama 2 continues this trend but **trains beyond compute-optimal points** (2T tokens is more than suggested for 70B) because downstream task performance continues improving even after pretraining loss plateaus.

**vs. Constitutional AI** (Bai et al., 2022): Both approaches use AI feedback for alignment, but Constitutional AI uses model-generated critiques and revisions. Llama 2 combines human preference data with targeted safety preprompts, showing this hybrid approach achieves strong safety (effectively 0% toxicity) while maintaining helpfulness.

**vs. InstructGPT/RLHF Baseline** (Ouyang et al., 2022): While InstructGPT pioneered RLHF for instruction-following, Llama 2 advances the methodology with separate safety/helpfulness rewards, margin-based losses, iterative data collection synchronized with model updates, and Ghost Attention for multi-turn consistency.

---

## 5. Results and What They Mean

**Pretrained Benchmarks** (Table 3, Section 2.3): Llama 2 70B scores 68.9 on MMLU, 51.2 on BBH, and 54.2 on AGI Eval, outperforming all open-source models and approaching GPT-3.5 (though still behind GPT-4 and PaLM-2). Notably, performance continues improving with scale—70B shows ~5-8 point gains over 65B Llama 1 on major benchmarks.

**Human Evaluation** (Figure 12, Section 3.4.2): In head-to-head comparisons on ~4,000 prompts, Llama 2-Chat achieves:
- 36% win rate and 31.5% tie rate against ChatGPT (70B model)
- >75% win rate against similarly-sized open models (Vicuna-33B, Falcon-40B)
- 60% win rate for 7B model vs. MPT-7B-chat

These results demonstrate that open models can achieve competitive quality, though the authors carefully note limitations: "human evaluations have several limitations" including prompt coverage, subjectivity, and single-turn assessment.

**Safety Metrics** (Table 14, Section 4.4): Llama 2-Chat shows dramatic safety improvements:
- **Truthfulness**: 64.14% on TruthfulQA (vs. 50.18% pretrained), approaching ChatGPT's 78.46%
- **Toxicity**: 0.01% toxic generations (vs. 24.60% pretrained), lowest among all compared models
- **Safety violations**: <10% violation rate on adversarial prompts across all model sizes

**Reward Model Calibration** (Figure 29): The reward models show strong correlation with human judgments (7-point Likert scale), validating their use as point-wise metrics despite being trained with pairwise ranking. This calibration holds across 14 weekly collection batches totaling 1.4M comparisons.

**Scaling Insights**: Figure 6 shows reward model accuracy improving with both data and model size, with no saturation observed—suggesting continued improvement is possible. Interestingly, Figure 20 reveals that RLHF progressively eliminates the "tail" of poor responses, shifting the distribution rightward rather than just improving the mean.

**Limitations Discovered**: Table 38 shows that with 100% safety data, the model sometimes over-applies caution (refusing to explain "sex in a pan"—a dessert name). False refusal rates remain low (0.05% on helpfulness, ~15-27% on borderline prompts) but increase with safety data percentage (Figure 33).

---

## 6. Limitations and Failure Modes

The authors candidly acknowledge several limitations in Section 5.2:

**Knowledge Cutoff**: Pretraining data ends in September 2022, limiting awareness of recent events. The model cannot update its knowledge without retraining.

**Language Limitations**: Despite 89.7% English pretraining data, the model shows "some proficiency" in other languages but remains "fragile" and should be "used with caution" for non-English tasks. No systematic multilingual evaluation is provided.

**Hallucinations and Factuality**: Like all LLMs, Llama 2 can generate plausible but incorrect information. While TruthfulQA scores improve (64.14% for 70B Chat), ~36% of responses still fail to be both truthful and informative.

**Over-Caution**: Safety tuning introduces false refusals, particularly with borderline prompts containing sensitive words. For example, the model refuses "Christmas crack" (a dessert recipe) due to detecting the word "crack." The trade-off between safety and helpfulness remains difficult to optimize.

**Evaluation Scope**: Testing is primarily English, limited to ~4,000 prompts for human evaluation, and excludes coding/reasoning tasks. Real-world performance across diverse use cases remains unknown.

**Demographic Bias**: Analysis of pretraining data (Table 9) shows skews toward "He" pronouns (50.73% vs. 28.45% "She"), Western nationalities ("American" in 69.4% of documents), and Christianity (33.2% vs. other religions). These biases may affect model outputs.

**Context Length**: While 4k context is double Llama 1, it's shorter than some alternatives and may limit long-document understanding (though Lost in the Middle research suggests longer contexts have their own challenges).

**Benchmark Contamination**: Analysis (Appendix A.6) reveals some contamination in HellaSwag and MMLU-Humanities, though the impact appears limited to the 70B model and specific evaluation scenarios.

---

## 7. Fit to This Course (Week: 5, Section: Mixture-of-Experts Architectures)

While Llama 2 is not itself a Mixture-of-Experts architecture, it exemplifies **modern scaling and efficiency approaches** central to Week 5's Phase II themes and provides important context for understanding contemporary LLM development.

**Connection to MoE Efficiency Principles**: The paper's use of Grouped-Query Attention (GQA) addresses similar efficiency challenges as MoE—both techniques reduce computation/memory while maintaining quality. GQA shares 8 KV projections across heads (reducing KV cache by ~8×) analogous to how MoE activates only k-of-n experts. Section A.2.1 shows GQA achieves comparable performance to multi-head attention while enabling higher throughput (Figure 24).

**Data Curriculum and Scaling**: The iterative RLHF process with progressive annotation difficulty (Figure 26) parallels MoE's conditional computation philosophy—**allocate resources where they matter most**. Rather than uniformly scaling all training data, Llama 2 focuses quality annotation effort on challenging examples that improve specific capabilities, similar to how MoE routes tokens to specialized experts.

**Production-Ready Systems**: Week 5's focus on "efficiency trade-offs of MoE" extends to understanding deployment-ready LLMs. Llama 2 demonstrates that production systems require balancing multiple objectives: helpfulness vs. safety, exploration (rejection sampling) vs. exploitation (PPO), annotation quality vs. quantity, and context length vs. memory constraints. These trade-offs parallel MoE's balance between parameter count, active parameters, and load balancing.

**Relevance to Lab**: The Week 5 lab implements "a basic MoE layer and comparing its memory usage vs. a dense layer." Llama 2's GQA provides a complementary perspective—instead of sparsity through expert selection, it achieves efficiency through parameter sharing. Understanding both approaches (sparse MoE routing and dense parameter sharing) illuminates the broader design space for efficient large-scale models.

**Scaling Laws Context**: Following Week 4's Chinchilla paper, Llama 2 shows that **optimal scaling depends on deployment goals**. While Chinchilla argues for compute-optimal training, Llama 2 intentionally over-trains (2T tokens exceeds compute-optimal for 70B) because downstream chat performance continues improving. This connects to MoE's efficiency thesis—sometimes training a larger model more efficiently beats training a smaller model optimally.

**Key Topics Alignment**: Week 5 emphasizes "Theory of sparse activation and conditional computation." Llama 2's safety architecture uses conditional computation conceptually—different reward models and response strategies activate based on prompt classification (safe vs. adversarial). Section 3.2.3's piecewise reward function R_c switches between safety and helpfulness models based on prompt properties, demonstrating that modern LLMs increasingly use routing logic beyond the forward pass.

---

## 8. Discussion Questions

1. **Safety vs. Helpfulness Trade-offs**: Llama 2 trains separate helpfulness and safety reward models due to "tension between the two objectives" (Section 3.2.2). What are the fundamental causes of this tension, and could architectural changes (e.g., mixture-of-experts with specialized safety experts) better balance these goals than separate reward models?

2. **Quality Over Quantity in Fine-Tuning**: The paper shows 27,540 high-quality examples outperform millions of third-party examples, and RLHF enables models to exceed human annotator quality (Section 5.1). What implications does this have for the future of data annotation—should we invest in better annotator training, better quality control, or focus entirely on AI-generated data with human preferences?

3. **Open vs. Closed Development**: Meta's open release of Llama 2 contrasts with OpenAI's closed approach for GPT-4. Given the detailed safety mitigations and remaining vulnerabilities documented in the paper, do the benefits of open development (democratization, transparency, collective safety research) outweigh the risks of misuse? How would your answer change for future, more capable models?

4. **Reward Model Calibration and Goodhart's Law**: Figure 29 shows reward models well-calibrated with human preferences initially, but Section 3.4.1 warns "when a measure becomes a target, it ceases to be a good measure." How can we detect when optimization against a reward model diverges from true human preferences, and what guardrails should be implemented during RLHF training?

5. **Scaling Beyond Compute-Optimal**: Llama 2 trains on 2T tokens despite compute-optimal scaling laws suggesting fewer tokens would minimize loss per FLOP. When should practitioners follow compute-optimal scaling (as in Chinchilla) vs. over-train for downstream performance (as in Llama 2)? How does this decision relate to the difference between academic research goals and production deployment requirements?

---

## 9. Glossary

**Reinforcement Learning from Human Feedback (RLHF)**: Training paradigm where human annotators provide preference comparisons between model outputs, which train a reward model that then guides policy optimization (typically with PPO) to align the language model with human preferences.

**Grouped-Query Attention (GQA)**: Attention mechanism variant that shares key-value projections across multiple query heads (e.g., 8 KV projections for 64 query heads), reducing memory requirements during inference while maintaining most of multi-head attention's expressiveness.

**Rejection Sampling**: RLHF technique where K responses are generated for each prompt, the highest-scoring response per the reward model is selected, and the model is fine-tuned on these best outputs, effectively learning from its own best generations.

**Proximal Policy Optimization (PPO)**: Reinforcement learning algorithm that updates the policy (language model) to maximize expected reward while constraining divergence from the initial policy via a KL penalty term, preventing reward hacking and training instability.

**Context Distillation**: Technique that generates improved responses by prepending helpful context (e.g., safety instructions), then fine-tunes the model on these responses without the prepended context, effectively "distilling" the context's influence into the model's weights.

**Ghost Attention (GAtt)**: Novel technique for multi-turn dialogue consistency that trains the model to maintain adherence to system instructions by sampling with the instruction on all turns but fine-tuning with it only on the first turn (zeroing loss on intermediate turns).

**Reward Hacking**: Phenomenon where a model being optimized against a reward model learns to exploit weaknesses in the reward model to achieve high scores without truly satisfying the intended objective, diverging from actual human preferences.

**Binary Ranking Loss**: Training objective for reward models that learns to assign higher scores to preferred responses: L = -log(σ(r_θ(x,y_chosen) - r_θ(x,y_rejected) - m)), where m is an optional margin term based on preference strength.

**Safety Auxiliary Loss**: Additional training objective for safety reward models that explicitly trains the model to classify responses as safe or unsafe beyond just preference ranking, improving discrimination of safety violations.

**Red Teaming**: Adversarial testing process where experts attempt to elicit unsafe or problematic responses from the model, helping identify vulnerabilities and inform safety mitigations before deployment.

**Supervised Fine-Tuning (SFT)**: Initial alignment phase where the pretrained model is fine-tuned on high-quality human-written prompt-response pairs to learn instruction-following and desired response patterns before RLHF.

**False Refusal**: Error where the model incorrectly refuses to respond to a benign prompt due to perceived safety concerns (e.g., refusing to explain the dessert "sex in a pan" due to detecting the word "sex"), increasing with safety training intensity.

---

## 10. References

1. Touvron, H., et al. (2023). "Llama 2: Open Foundation and Fine-Tuned Chat Models." *arXiv preprint arXiv:2307.09288*.

2. Touvron, H., et al. (2023). "LLaMA: Open and Efficient Foundation Language Models." *arXiv preprint arXiv:2302.13971*.

3. Ouyang, L., et al. (2022). "Training Language Models to Follow Instructions with Human Feedback." *arXiv preprint arXiv:2203.02155*.

4. Bai, Y., et al. (2022). "Constitutional AI: Harmlessness from AI Feedback." *arXiv preprint arXiv:2212.08073*.

5. Hoffmann, J., et al. (2022). "Training Compute-Optimal Large Language Models." *arXiv preprint arXiv:2203.15556*.

6. Schulman, J., et al. (2017). "Proximal Policy Optimization Algorithms." *arXiv preprint arXiv:1707.06347*.

7. Ainslie, J., et al. (2023). "GQA: Training Generalized Multi-Query Transformer Models from Multi-Head Checkpoints." *arXiv preprint*.

8. Vaswani, A., et al. (2017). "Attention Is All You Need." *Proceedings of NeurIPS*.