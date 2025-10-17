# DPO Notes and Outline

## Paper Metadata
- **Title**: Direct Preference Optimization: Your Language Model is Secretly a Reward Model
- **Authors**: Rafailov, Sharma, Mitchell, Ermon, Manning, Finn (Stanford/CZ Biohub)
- **Year**: 2023
- **Venue**: NeurIPS 2023
- **arXiv**: 2305.18290v3

## Week 9 Context
- **Section**: Reward-Free Alignment & Safety (Phase III)
- **Key Topics**: Direct Preference Optimization (DPO) vs. RLHF. The mathematical derivation of DPO as an unrolled objective. Safety, toxicity mitigation, and transparency.

## 10-12 Bullet Outline

1. **Problem**: RLHF is complex and unstable—requires fitting reward model, then RL with PPO; involves sampling from LM during training; significant hyperparameter tuning required

2. **Core Innovation**: DPO reparameterizes reward model to extract optimal policy in closed form, solving RLHF with simple classification loss (binary cross-entropy)

3. **Key Mathematical Insight**: Reward function can be expressed as r(x,y) = β log(π(y|x)/πref(y|x)) + β log Z(x); partition function Z(x) cancels in Bradley-Terry preference model

4. **DPO Objective**: Directly optimizes policy with loss -E[log σ(β log(πθ(yw|x)/πref(yw|x)) - β log(πθ(yl|x)/πref(yl|x)))]

5. **Gradient Interpretation**: Increases likelihood of preferred yw, decreases likelihood of dispreferred yl, weighted by how incorrectly implicit reward ranks them

6. **Theoretical Properties**: Can represent all reward equivalence classes; no loss of generality vs explicit reward modeling; enjoys consistency guarantees under Bradley-Terry model

7. **Experimental Setup**: Three tasks—controlled sentiment (IMDb), summarization (TL;DR), dialogue (Anthropic HH); models up to 6B parameters

8. **Sentiment Results**: DPO achieves best reward-KL frontier, dominat ing PPO even with ground-truth rewards (PPO-GT)

9. **Summarization Results**: DPO 61% win rate vs reference at temp 0, exceeding PPO's 57%; much more robust to temperature changes than PPO

10. **Dialogue Results**: DPO only method improving over chosen responses in Anthropic HH; performs similar to or better than Best-of-128 baseline

11. **Generalization**: DPO transfers well to CNN/DailyMail (out-of-distribution); outperforms PPO by significant margin on news articles

12. **Limitations**: Questions about OOD generalization, reward over-optimization, scaling to larger models remain for future work

## Key Claims to Verify (page/section)
- Abstract: "stable, performant, computationally lightweight"
- Page 2: DPO uses "change of variables to define preference loss as function of policy directly"
- Page 4: Optimal policy satisfies πr(y|x) = (1/Z(x)) πref(y|x) exp(1/β r(x,y)) [Eq. 4]
- Page 4: Bradley-Terry with policy reparameterization [Eq. 6-7]
- Page 7: Sentiment—DPO provides highest reward for all KL values
- Page 7: Summarization—DPO 61% win rate, PPO 57%
- Page 8: Dialogue—DPO only method improving over dataset chosen responses
- Page 9: CNN/DailyMail OOD—DPO 0.36 vs PPO 0.26 at temp 0

## Method Sketch
1. Start with KL-constrained reward maximization (standard RLHF objective)
2. Derive closed-form optimal policy: πr(y|x) ∝ πref(y|x) exp(1/β r(x,y))
3. Rearrange to express reward in terms of policy: r = β log(π/πref) + β log Z(x)
4. Substitute into Bradley-Terry model; partition function cancels
5. Obtain DPO loss: binary classification on preference pairs using policy ratios
6. Train policy πθ directly on preference dataset with simple cross-entropy

## Prior Work Contrasts
1. **vs. PPO-based RLHF**: DPO eliminates separate reward model training and RL loop; single-stage vs. three-stage pipeline
2. **vs. Supervised FT**: DPO uses relative preferences not absolute demonstrations; incorporates KL constraint implicitly
3. **vs. Reward modeling then RL**: DPO optimizes implicit reward via policy reparameterization; avoids high-variance policy gradients and learned value functions

## Notable Results
- Sentiment: Best reward/KL frontier across all hyperparameters
- Summarization: 61% win rate (DPO temp 0.25) vs. 57% (PPO temp 0); head-to-head 58% human preference
- Dialogue: ~60% win rate vs chosen responses; only computationally efficient method improving over dataset
- OOD transfer: 0.36 vs. 0.26 win rate (DPO vs PPO) on CNN/DailyMail

## Limitations
- Reward over-optimization: slight performance decrease in Figure 3-right
- Scaling: experiments only up to 6B parameters
- OOD generalization: initial evidence positive but needs comprehensive study
- Self-labeling: unclear if DPO can use unlabeled prompts like PPO
- Evaluation sensitivity: GPT-4 win rates affected by prompt choice
