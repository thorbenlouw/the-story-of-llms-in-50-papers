# Direct Preference Optimization: Your Language Model is Secretly a Reward Model

**Authors**: Rafael Rafailov, Archit Sharma, Eric Mitchell, Stefano Ermon, Christopher D. Manning, Chelsea Finn (Stanford University, CZ Biohub)
**Venue**: NeurIPS 2023
**arXiv**: [2305.18290v3](https://arxiv.org/abs/2305.18290)
**Year**: 2023

## TL;DR

- **DPO eliminates reinforcement learning** from the RLHF pipeline by deriving a closed-form solution that transforms the reward maximization problem into a simple binary classification objective.
- **Single-stage training**: Instead of first learning a reward model and then optimizing it with PPO, DPO directly optimizes the language model policy on preference data using a reparameterized Bradley-Terry model.
- **Strong empirical results**: DPO matches or exceeds PPO-based RLHF performance on sentiment generation, summarization, and dialogue tasks while being substantially simpler to implement and more stable to train.
- **Theoretical soundness**: The method is provably equivalent to standard RLHF under the KL-constrained reward maximization framework, with no loss of generality in the class of representable reward functions.

## Problem and Motivation

Large language models trained with unsupervised pre-training acquire broad capabilities but lack precise control over their behavior. While instruction tuning helps, the most effective alignment method—Reinforcement Learning from Human Feedback (RLHF)—remains complex and unstable. The standard RLHF pipeline involves three stages: (1) supervised fine-tuning (SFT) on high-quality demonstrations, (2) training a reward model on human preference comparisons, and (3) using reinforcement learning (typically PPO) to optimize the language model policy to maximize the learned reward while staying close to the SFT model via a KL-divergence constraint.

This pipeline presents several challenges. First, it requires training multiple large neural networks—the SFT model, the reward model, and the RL-optimized policy. Second, the RL phase requires sampling from the language model in the training loop, significantly increasing computational cost. Third, PPO and similar RL algorithms require careful hyperparameter tuning and can be unstable, particularly for large models. Fourth, maintaining high-quality samples during RL training requires careful reward normalization and value function estimation. These practical difficulties create a barrier to applying RLHF broadly, despite its effectiveness (Section 1, page 1-2).

## Core Idea and Contributions

DPO's key insight is that the standard RLHF objective can be optimized exactly without reinforcement learning. The authors start with the observation that under the KL-constrained reward maximization objective, the optimal policy has a closed form: π*(y|x) ∝ πref(y|x) exp(1/β · r(x,y)), where πref is the reference policy and β controls the strength of the KL constraint. By rearranging this equation, they express the reward as a function of the optimal policy and reference policy: r(x,y) = β log(π*(y|x)/πref(y|x)) + β log Z(x), where Z(x) is a partition function.

The crucial observation is that when this reward reparameterization is substituted into the Bradley-Terry preference model—which models the probability that response y1 is preferred to y2 as a function of their reward difference—the partition function Z(x) cancels out. This yields a preference probability that depends only on the policy π and reference policy πref, not on any explicit reward function. The resulting Direct Preference Optimization (DPO) objective is simply the negative log-likelihood of preferences under this reparameterized model (Section 4, Equation 7, page 4).

The method's elegant simplicity stands in contrast to traditional RLHF: instead of first fitting a reward model and then running RL, DPO trains the policy network directly to satisfy the preference data using a loss that looks like binary classification. The policy network implicitly represents both the language model and the reward model simultaneously.

## Method

DPO optimizes the following objective over a dataset of preferences D = {(x^(i), y_w^(i), y_l^(i))}:

L_DPO(πθ; πref) = -E_{(x,y_w,y_l)~D} [log σ(β log(πθ(y_w|x)/πref(y_w|x)) - β log(πθ(y_l|x)/πref(y_l|x)))]

where σ is the logistic sigmoid, y_w is the preferred completion, y_l is the dispreferred completion, and β is a hyperparameter controlling the deviation from the reference policy πref (typically the SFT model).

**Intuition**: The loss increases the log-probability of preferred completions y_w and decreases the log-probability of dispreferred completions y_l. Importantly, each training example is weighted by how incorrectly the implicit reward model (defined as β log(πθ(y|x)/πref(y|x))) ranks the two completions. This dynamic, per-example weighting prevents model degeneration that would occur with naive likelihood maximization (Section 4, page 5).

**Training procedure**: (1) Sample or obtain completions for prompts from the reference policy πref = πSFT. (2) Collect human preference labels to form dataset D. (3) Optimize πθ initialized from πSFT to minimize L_DPO. In practice, when πSFT is unavailable, the reference policy is initialized by maximizing the likelihood of preferred completions. The method requires no sampling during training—forward passes through the policy and reference model on the fixed preference dataset suffice.

**Derivation sketch** (details in Appendix A.1-A.2): Start with the KL-constrained RL objective max_π E[r(x,y)] - β D_KL(π||πref). The optimal solution is π_r(y|x) = (1/Z(x)) πref(y|x) exp(r(x,y)/β). Taking logarithms and rearranging yields r(x,y) = β log(π_r(y|x)/πref(y|x)) + β log Z(x). Substituting into the Bradley-Terry model p*(y1 ≻ y2|x) = exp(r(x,y1))/(exp(r(x,y1)) + exp(r(x,y2))), the partition function cancels, yielding the DPO objective (page 4, Equations 4-7).

## Comparison to Prior Work

**1. vs. PPO-based RLHF** (Ouyang et al. 2022, InstructGPT): Traditional RLHF trains a reward model rφ(x,y) on preferences, then uses PPO to optimize max_π E[rφ(x,y)] - β D_KL(π||πref). This requires: (a) a separate reward modeling phase with its own train dataset, (b) sampling from πθ in the RL loop, (c) maintaining a value function for variance reduction, and (d) careful hyperparameter tuning of PPO (learning rate, clipping, target KL). DPO collapses this into a single maximum-likelihood training stage with a fixed dataset and no sampling, significantly reducing complexity and computational cost (Section 1-2, page 1-2; related work on page 2-3).

**2. vs. Supervised Fine-Tuning on Preferences** ("Preferred-FT"): Simply maximizing log p(y_w|x) on preferred completions ignores the relative nature of preferences and lacks the KL constraint that prevents the model from drifting too far from the reference distribution. Empirically, Preferred-FT underperforms DPO across all tasks (Figures 2-3, pages 7-8).

**3. vs. Reward Modeling + Best-of-N Sampling**: An alternative to RL is training a reward model, then sampling N completions at inference and returning the highest-scoring one. While this can match or exceed DPO performance (e.g., Best-of-128), it is computationally impractical: generating 128 responses per query is prohibitively expensive in production. DPO achieves similar quality with a single forward pass (Section 6.2, page 9; Figure 3).

## Results and What They Mean

**Controlled sentiment generation (IMDb)**: DPO achieves the best reward-KL frontier among all methods, including PPO with access to ground-truth rewards (PPO-GT). Across 22 training runs with various hyperparameters, DPO consistently achieves higher reward for any given KL-divergence from the reference policy. This demonstrates that DPO optimizes the constrained reward objective more efficiently than PPO, despite both methods targeting the same theoretical optimum (Figure 2 left, page 7).

**Summarization (TL;DR)**: DPO attains a 61% win rate against reference summaries at temperature 0, exceeding PPO's best win rate of 57% (also at temperature 0). Importantly, DPO is far more robust to sampling temperature: its performance degrades gracefully as temperature increases, while PPO's win rate drops sharply at higher temperatures. In head-to-head human evaluation, DPO summaries are preferred 58% of the time over PPO summaries (Table 2, page 10; Figure 2 right, page 7; Section 6.2, page 9).

**Single-turn dialogue (Anthropic HH)**: DPO is the only computationally tractable method that improves over the preferred completions in the dataset, achieving roughly 60% win rate against the dataset's chosen responses. Best-of-128 achieves similar performance but requires 128× more computation at inference. An existing PPO baseline trained on the same data fails to exceed the base Pythia-2.8B model performance for any tested prompt or sampling temperature (Figure 3, page 8; Section 6.2, page 9).

**Out-of-distribution generalization (CNN/DailyMail)**: When models trained on Reddit TL;DR summaries are evaluated on news article summarization, DPO maintains a substantial advantage: 36% win rate vs. ground truth at temperature 0, compared to PPO's 26%. This initial evidence suggests DPO policies generalize as well as or better than PPO policies to new input distributions (Table 1, page 9; Section 6.3).

**Human-GPT-4 agreement**: Human annotators agree with GPT-4 judgments at rates (65-87%) similar to inter-human agreement (65-87%), validating the use of GPT-4 for evaluation. The "concise" prompt (asking for summaries that avoid unnecessary detail) yields win rates more aligned with human preferences than a simpler prompt (Table 2, page 10; Section 6.4).

## Limitations and Failure Modes

**Reward over-optimization**: Figure 3 (right) shows a slight performance decrease in later training, which may indicate reward over-optimization—a known issue in RLHF where optimizing the learned (or implicit) reward too aggressively leads to exploitation of reward model errors. However, the effect is mild compared to issues often seen with PPO (Section 7, page 10).

**Scaling**: Experiments cover models up to 6B parameters. While DPO's simplicity suggests it should scale well, empirical validation on models of 10B, 100B, or 1T+ parameters remains future work (Section 7, page 10).

**Out-of-distribution generalization**: Only one OOD experiment (CNN/DailyMail) is included. More comprehensive study across diverse domains is needed to fully characterize DPO's generalization properties relative to explicit reward modeling. The question of whether DPO can leverage unlabeled prompts via self-labeling (as PPO can) also remains open (Section 7, page 10).

**Evaluation sensitivity**: Win rates computed by GPT-4 depend on prompt phrasing (compare "simple" vs. "concise" prompts). This sensitivity complicates automatic evaluation and suggests the need for multiple prompt formulations or human validation (Appendix C.2, page 20-21; Section 6.4, page 10).

**Failure to prevent degeneration without weighting**: Ablation studies (mentioned but detailed in Appendix Table 3) show that removing the implicit reward weighting term from the DPO gradient causes the model to degenerate, producing repetitive or low-quality outputs. The weighting is thus critical to the method's success (Section 4, page 5).

## Fit to This Course

**Week 9: Reward-Free Alignment & Safety (Phase III)**

DPO is the centerpiece paper for understanding reward-free alignment methods that simplify the RLHF pipeline. The week's key topics include:

- **Direct Preference Optimization (DPO) vs. RLHF**: This paper provides the foundational algorithm. Students will understand how DPO's change-of-variables approach eliminates the RL stage entirely, transforming a multi-stage pipeline into a single classification problem. The derivation (Section 4, Appendix A) demonstrates that this simplification is not a heuristic but a rigorous reparameterization of the standard RLHF objective.

- **Mathematical derivation of DPO**: The paper walks through the closed-form solution to the KL-constrained reward maximization problem (Equation 4), the reward-as-policy reparameterization (Equation 5), and the cancellation of the partition function in the Bradley-Terry model (Equation 6). This mathematical exercise builds intuition for why DPO works and connects preference learning to constrained optimization.

- **Safety, toxicity mitigation, and transparency**: By removing the black-box RL loop, DPO offers greater transparency: the training objective is a simple cross-entropy loss, making optimization dynamics easier to understand and debug. The method's stability and simplicity lower the barrier to applying alignment techniques, which is critical for safety research. The Anthropic HH dialogue experiments demonstrate DPO's effectiveness on safety-relevant tasks (helpfulness and harmlessness).

**Connection to Week 8 (RLHF)**: DPO directly builds on InstructGPT (Ouyang et al. 2022) and the conceptual foundations from Christiano et al. 2017. Students should compare the three-stage RLHF pipeline (SFT → Reward Modeling → PPO) with DPO's two-stage pipeline (SFT → DPO), understanding the trade-offs: DPO is simpler and more stable, but traditional RLHF's explicit reward model can be inspected, used for Best-of-N sampling, and potentially generalized to unlabeled data.

**Lab connection**: A natural lab exercise would implement DPO from scratch on a small preference dataset, comparing training dynamics and final performance to a PPO baseline. Students could explore the effect of β (KL penalty strength), investigate the implicit reward rˆθ(x,y) = β log(πθ(y|x)/πref(y|x)) values during training, and measure how well DPO's implicit rewards correlate with human preferences. Implementing the DPO loss (provided in PyTorch in Appendix B) requires fewer than 15 lines of code, making it accessible even for a short lab session.

## Discussion Questions

1. **Theoretical equivalence vs. empirical performance**: DPO and PPO optimize the same KL-constrained reward maximization objective, yet DPO consistently outperforms PPO empirically (Figure 2). What factors explain this gap—e.g., PPO's variance, value function approximation error, or off-policy data handling? Does this suggest DPO's reparameterization is strictly superior, or are there scenarios where explicit reward modeling might be preferable?

2. **Implicit vs. explicit rewards**: Traditional RLHF learns an explicit reward model rφ(x,y), which can be inspected, visualized, and used for Best-of-N sampling. DPO's implicit reward rˆθ(x,y) = β log(πθ(y|x)/πref(y|x)) is entangled with the policy. What are the trade-offs? Could DPO's implicit reward be extracted and used for debugging or filtering? How might the lack of an explicit reward affect interpretability and safety analysis?

3. **Scaling and generalization**: DPO experiments max out at 6B parameters. As models scale to 100B+ parameters, do you expect DPO's advantages (simplicity, stability) to become more or less pronounced compared to PPO? Consider factors like gradient variance, memory requirements, and the difficulty of RL on extremely large models.

4. **Beyond pairwise preferences**: DPO is derived for the Bradley-Terry model (pairwise comparisons), though the paper extends to Plackett-Luce rankings (Appendix A.3). How would DPO handle richer feedback—e.g., scalar ratings, natural language critiques, or demonstrations with corrections? Would the elegant cancellation of Z(x) still hold, or would you need approximate inference?

5. **Reward over-optimization and safety**: Figure 3 shows mild performance degradation late in training, hinting at reward over-optimization. How does this failure mode manifest in DPO compared to explicit reward model over-optimization in PPO-based RLHF? Given that DPO's "reward model" is implicit and continuously updated, does this make over-optimization more or less dangerous from a safety perspective?

## Glossary

**Bradley-Terry model**: A probabilistic model for pairwise comparisons: the probability that item y1 is preferred to y2 is σ(r(y1) - r(y2)), where r is a latent reward and σ is the logistic function. In preference learning for LMs, y1 and y2 are model completions conditioned on a prompt x.

**KL-constrained reward maximization**: The RLHF objective max_π E[r(x,y)] - β D_KL(π||πref), which seeks a policy π that maximizes expected reward while staying close (in KL-divergence) to a reference policy πref. The constraint prevents the model from collapsing onto a narrow high-reward mode and maintains output diversity.

**Partition function Z(x)**: The normalizing constant in the optimal policy π*(y|x) = (1/Z(x)) πref(y|x) exp(r(x,y)/β), where Z(x) = Σ_y πref(y|x) exp(r(x,y)/β). Computing Z(x) exactly is intractable, but DPO sidesteps this by deriving an objective where Z(x) cancels.

**Reward reparameterization**: Expressing the reward function r(x,y) in terms of the policy π and reference policy πref: r(x,y) = β log(π(y|x)/πref(y|x)) + β log Z(x). This change of variables is central to DPO, enabling the transformation from reward-then-RL to direct policy optimization.

**Implicit reward model**: In DPO, the reward is not represented as a separate neural network rφ(x,y). Instead, it is implicitly defined by the policy and reference policy: rˆθ(x,y) = β log(πθ(y|x)/πref(y|x)). The policy network serves dual duty as both the language model and the (implicit) reward model.

**Preferred-FT (Preferred Fine-Tuning)**: A baseline method that simply maximizes the log-likelihood of preferred completions: max_π E[log π(y_w|x)]. This ignores the relative nature of preferences and lacks the KL constraint, resulting in weaker performance than DPO.

**Best-of-N sampling**: An inference-time method: generate N completions from the policy, score each with a reward model, and return the highest-scoring one. While this can achieve strong performance (Best-of-128 matches DPO in Figure 3), it is computationally expensive and impractical for production.

**PPO (Proximal Policy Optimization)**: A reinforcement learning algorithm used in standard RLHF. PPO iteratively samples completions from the current policy, computes advantages using a value function, and updates the policy to increase the probability of high-advantage actions while clipping large policy updates to maintain stability.

**Reference policy πref**: The initial policy (typically the SFT model) used to anchor the KL divergence constraint. In DPO, πref is frozen during training and provides the log-probabilities needed to compute the implicit reward. The reference policy prevents the optimized policy from drifting too far from the initial distribution.

**Equivalence class (of reward functions)**: A set of reward functions that differ only by a function of the prompt: r(x,y) and r'(x,y) are equivalent if r'(x,y) = r(x,y) + f(x). All rewards in an equivalence class induce the same preference distribution (Bradley-Terry is invariant to adding constants) and the same optimal policy under the KL-constrained objective.

**Change of variables**: A technique for transforming an optimization problem by reparameterizing the objective. DPO uses a change of variables from reward function r to policy π, converting a two-stage problem (fit reward, then optimize policy) into a single-stage problem (optimize policy directly). Theorem 1 (page 5-6) proves this transformation is lossless.

**Win rate**: The fraction of comparisons in which a method's output is preferred over a baseline (either human-written reference or another method's output). In the paper, win rates are computed using GPT-4 as a judge for scalability, and validated against human judgments (Section 6, Tables 2 and Figures 2-3).

## References

- Ouyang et al. (2022): Training language models to follow instructions with human feedback [arXiv:2203.02155]. Introduces InstructGPT and the standard three-stage RLHF pipeline (SFT, reward modeling, PPO).
- Christiano et al. (2017): Deep reinforcement learning from human preferences [arXiv:1706.03741]. Conceptual origin of RLHF, learning reward functions from pairwise preferences in RL environments.
- Schulman et al. (2017): Proximal policy optimization algorithms [arXiv:1707.06347]. Describes PPO, the RL algorithm most commonly used in RLHF.
- Bai et al. (2022): Constitutional AI: Harmlessness from AI feedback [arXiv:2212.08073]. Related alignment method using AI-generated preferences; provides the Anthropic HH dataset.
- Stiennon et al. (2020): Learning to summarize from human feedback [arXiv:2009.01325]. Early RLHF application to summarization; provides the TL;DR dataset used in DPO experiments.

## Figure Insights

**Figure 1 (page 2)**: Contrasts the RLHF and DPO pipelines. RLHF: preference data → reward model → sample completions → RL (PPO) → final LM. DPO: preference data → maximum likelihood → final LM. The diagram makes the simplification vivid: DPO eliminates two stages (reward modeling and RL) by directly optimizing the policy with a classification loss.

**Figure 2 left (page 7)**: Reward-KL frontier for sentiment generation. Each point is a model checkpoint from one of 22 training runs (DPO, PPO, PPO-GT, Unlikelihood, Preferred-FT) with different hyperparameters. DPO's frontier strictly dominates all others: for any KL value, DPO achieves the highest reward. This demonstrates DPO optimizes the constrained objective more efficiently than PPO, even when PPO has access to ground-truth rewards.

**Figure 2 right (page 7)**: TL;DR summarization win rates vs. reference summaries across sampling temperatures. DPO's curve is nearly flat (60-61% win rate from temp 0 to 1), while PPO's drops sharply (57% at temp 0 to ~40% at temp 1). The robustness to temperature is a practical advantage: DPO performs well even with higher-entropy sampling.

**Figure 3 left (page 8)**: Anthropic HH dialogue win rates vs. chosen dataset responses. DPO achieves ~60% win rate across temperatures; Best-of-128 performs similarly but requires 128× the inference cost; Preferred-FT plateaus at ~45%. The PPO baseline (from a public implementation) underperforms the base model, highlighting PPO's sensitivity to hyperparameters.

**Figure 3 right (page 8)**: Win rate evolution during DPO training at two temperatures. Performance rises quickly in the first 1000 steps, then stabilizes with slight fluctuation. The modest late-training degradation may indicate mild reward over-optimization, but the effect is small compared to PPO instability.
