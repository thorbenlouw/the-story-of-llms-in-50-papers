# Training Language Models to Follow Instructions with Human Feedback

Authors: Long Ouyang, Jeff Wu, Xu Jiang, Diogo Almeida, Carroll Wainwright, Pamela Mishkin, et al.

Venue: arXiv preprint

Year: 2022

arXiv ID: 2203.02155

PDF: llm_papers_syllabus/InstructGPT_Training_Instructions_Ouyang_2022.pdf

---

## TL;DR

- Introduces the now-standard RLHF pipeline: Supervised Fine-Tuning (SFT) → Reward Model (RM) → PPO with a KL penalty to align LMs with human intent.
- Uses human preference data to directly optimize for helpfulness and instruction following, rather than next-token likelihood alone.
- Shows that a much smaller RLHF-trained model can be preferred by humans over a significantly larger base LM across diverse prompts (see Abstract; Results overview).
- Improves safety metrics (e.g., lower toxicity) while maintaining or improving helpfulness (Results, Safety subsection).
- Establishes practical methodology for data collection, reward modeling, and stable PPO training that shaped modern instruction-following systems.

---

## 1) Title and citation

- Ouyang, L., Wu, J., Jiang, X., Almeida, D., Wainwright, C., Mishkin, P., et al. (2022). Training language models to follow instructions with human feedback. arXiv:2203.02155.

---

## 2) TL;DR (4–6 bullets)

- SFT + Reward Modeling + PPO with KL penalty aligns models to be helpful and instruction-following.
- Human preference judgments guide learning signals more directly than likelihood training.
- Small RLHF model can be preferred to a much larger base model across varied tasks.
- Safety improves (toxicity down) without collapsing helpfulness.
- Simple, scalable data pipeline: prompts → human responses (SFT) and pairwise preferences (RM).

---

## 3) Problem and Motivation

Pretrained LMs (e.g., GPT-3) are optimized to predict tokens on web-scale corpora, not to follow user instructions or align with user intent. Users want models that reliably follow natural-language instructions, avoid unsafe outputs, and respond helpfully across domains. Pure likelihood training does not directly optimize these objectives and can produce unhelpful, verbose, or unsafe behavior.

The central question: how can we use human signals to steer a general-purpose LM toward helpful, harmless, and honest behavior? This paper proposes a practical framework that injects human preference information into training, transforming a general LM into an instruction-following assistant. The approach balances two goals: change the model enough to match human intent while avoiding reward hacking and drift from its linguistic competence (controlled via a KL penalty to a reference model; Method, PPO section).

---

## 4) Core Idea and Contributions

Core idea: treat “being helpful and instruction-following” as a learned objective derived from human preferences and optimize the model against it with reinforcement learning while constraining divergence from a good reference policy.

Key contributions (Method, Sec. 2–3):
- End-to-end RLHF pipeline for LMs: SFT on human-written demonstrations; reward modeling from pairwise human preferences; PPO fine-tuning against the learned reward with a KL penalty to prevent over-optimization and preserve language fluency.
- Scalable data collection and annotation protocol: instruction prompts, high-quality SFT responses, pairwise preference labeling for reward modeling (Annotation details in Method and Appendix).
- Empirical demonstration that a smaller RLHF model can be preferred to a larger pretrained model on diverse user prompts (Results; Human evaluation).
- Safety improvements measured via toxicity/harmlessness indicators while preserving task performance (Results; Safety analysis).
- Practical training choices (e.g., reference model, KL control, sample collection strategies) that became standard for instruction-following chat models (Method; PPO stability notes).

---

## 5) Method (plain-language overview)

The pipeline has three stages (Method overview; Fig./Diagram described in text):

1) Supervised Fine-Tuning (SFT). The team collects instruction prompts and asks human annotators to write high-quality responses. A base LM is fine-tuned on these (prompt, response) pairs to produce an SFT policy that already follows instructions better than the base model (Method, SFT subsection). Intuition: SFT gives the model a head start toward following instructions in a helpful style.

2) Reward Model (RM) from human preferences. For a given prompt, the team samples multiple candidate responses (e.g., from the SFT policy) and asks annotators to select which is better. Using these pairwise preferences, they train a learned reward function that scores responses by helpfulness/quality (Method, RM subsection). Intuition: the reward captures human judgments that are hard to encode with hand-written metrics.

3) PPO with KL penalty. The SFT policy is further optimized with reinforcement learning to maximize the learned reward, using Proximal Policy Optimization (PPO) while penalizing divergence from the SFT/reference policy via a KL term (Method, PPO subsection). Intuition: the reward pushes the policy toward human-preferred behavior; the KL term prevents the model from drifting too far and collapsing on superficial shortcuts (reward hacking).

Important intuitions and design choices:
- Why PPO? It provides a stable policy-gradient method with trust-region–like clipping, helpful when optimizing against a learned reward that can be noisy (Method; PPO details).
- Why KL control? Without it, the policy can overfit the reward model and degrade linguistic quality. The KL penalty anchors the policy near the reference distribution, trading off alignment vs. fluency and diversity (Method; KL discussion).
- Why pairwise preferences? They are simpler and more reliable for annotators than absolute scores, and they connect naturally to Bradley–Terry or logistic-ranking style losses for training the reward (Method; RM training notes).

---

## 6) Comparison to Prior Work

- GPT-3 (Brown et al., 2020): focuses on large-scale pretraining and few-shot prompting. InstructGPT demonstrates that aligning with human feedback produces more helpful behavior than simply scaling parameters and relying on prompting.
- FLAN/T0 (Sanh et al., 2021; Wei et al., 2021): use supervised instruction tuning across many tasks, but do not incorporate a learned reward or RL optimization. RLHF adds a direct optimization signal for human preference, enabling stronger alignment than SFT alone.
- Constitutional AI (Bai et al., 2022, follow-on direction): uses AI-written feedback guided by a “constitution” of principles to reduce human label cost. InstructGPT provides the canonical human-feedback baseline that later systems compare against.

---

## 7) Results and What They Mean

Human preference and helpfulness. The paper reports that, across a wide range of prompts, an RLHF-trained model is preferred by annotators over a larger base model (Results; Human eval). This illustrates that alignment can trump size: targeted optimization for user intent often yields greater perceived quality than raw scale alone (Abstract; Results overview).

Safety and harmlessness. The RLHF model reduces undesirable behaviors (e.g., toxicity) while staying helpful, as measured by safety-oriented evaluations (Results; Safety subsection). This suggests the reward model can encode basic guardrails if preference data includes harmfulness considerations and the PPO stage balances helpfulness and harmlessness.

Generalization and instruction following. The model improves zero-shot instruction following and produces more concise, on-task responses than the base LM. This supports the idea that human preference data captures high-level norms (be helpful, be concise, follow directions) that generalize across domains.

Takeaway for practitioners. If you have a capable pretrained LM and limited resources, investing in a modest SFT dataset plus a carefully collected preference dataset and a stable PPO loop can yield large jumps in user-perceived quality. The KL penalty is a key stabilizer; without it, optimization can overshoot and degrade output quality (Method; PPO and KL notes).

Claim checks (spot checks with paper structure references):
- The three-stage pipeline SFT → RM → PPO is the core method (Method, Sec. 2–3; Abstract summary).
- Preference data is pairwise and used to train a learned reward via a ranking loss (Method, RM subsection).
- PPO uses a KL penalty to the reference/SFT policy to mitigate reward over-optimization (Method, PPO subsection).
- Human evaluator preference favors RLHF models over larger base models on diverse prompts (Results; Human eval section).
- Safety/toxicity improvements are reported alongside helpfulness outcomes (Results; Safety analysis subsections).

---

## 8) Limitations and Failure Modes

- Reward hacking and over-optimization. Optimizing against a learned reward can exploit its blind spots. The KL penalty mitigates but does not eliminate this risk (Method; PPO and KL discussion).
- Annotator bias and specification gaming. Preference data reflects annotators’ norms and can encode biases. If the prompt distribution shifts, the learned reward may be misaligned for new tasks (Discussion/Appendix notes on data and evaluation scope).
- Cost and scalability. The human data pipeline (demonstrations and preferences) is expensive to scale, and label quality is crucial. Poor preference data yields poor rewards and unstable training.
- Objective entanglement. A single scalar reward conflates helpfulness, harmlessness, and truthfulness. Balancing tradeoffs within one reward can be difficult; later work often trains separate rewards or uses multi-objective optimization.

---

## 9) Fit to This Course (Week: 8, Section: Reinforcement Learning from Human Feedback (RLHF))

- Key Topics & Labs: The full RLHF pipeline: SFT, Reward Model (RM), PPO optimization. KL divergence penalty. The role of human preference data in alignment.

This paper is the anchor for Week 8. It provides the canonical formulation of RLHF that modern instruction-following systems adopt. The method directly reflects the week’s topics: leveraging SFT to initialize behavior, learning a reward from pairwise human preferences, and applying PPO with a KL penalty to align the policy while preserving fluency. It also highlights the practical tradeoffs covered in lab: how to collect preference data, tune the KL coefficient, and validate improvements via human evaluation and safety metrics.

---

## 10) Discussion Questions (5)

1) What are the most common modes of reward hacking you would expect in instruction-following, and how does KL control help or fall short in preventing them?
2) When is SFT alone sufficient (e.g., FLAN/T0-style tuning), and when is the added complexity of RLHF justified? Consider data cost, stability, and target use cases.
3) How would you design a multi-objective reward that balances helpfulness, harmlessness, and truthfulness without collapsing one dimension? Would separate rewards and routing help?
4) What annotation protocols yield the most reliable preference signals? Discuss pairwise comparison design, prompt sampling, and rater calibration.
5) Beyond PPO, what alternative optimization strategies (e.g., DPO, implicit reward modeling, offline RL) might capture the same benefits with fewer stability pitfalls?

---

## 11) Glossary (8–12 terms)

- Supervised Fine-Tuning (SFT): Fine-tuning a pretrained LM on human-written demonstrations of instruction following to initialize helpful behavior.
- Reward Model (RM): A learned scoring function trained on human pairwise preferences to evaluate response quality/helpfulness.
- Pairwise Preference Learning: Annotators select the better of two responses; the model learns a ranking loss to score outputs.
- Proximal Policy Optimization (PPO): A policy-gradient RL algorithm with clipping that stabilizes updates when optimizing against a learned reward.
- KL Penalty: A regularization term penalizing divergence from a reference policy, preventing reward over-optimization and preserving fluency.
- Reference Policy: Typically the SFT model; acts as an anchor distribution for KL control during PPO.
- Reward Hacking: Exploiting imperfections in the learned reward to obtain high scores without producing genuinely helpful behavior.
- Harmlessness/Toxicity: Safety dimensions measuring the avoidance of harmful or toxic outputs; often evaluated via specialized benchmarks.
- Instruction Tuning: Aligning a model with natural-language task instructions, either via SFT alone (e.g., FLAN/T0) or RLHF (SFT+RM+PPO).
- Human Evaluation: Measuring perceived quality/helpfulness/safety via rater judgments; central for validating alignment improvements.
- Preference Dataset: Collection of pairwise human comparisons over candidate responses used to train the reward model.
- Direct Preference Optimization (DPO): A later approach that optimizes directly from preference data without explicit RL rollouts.

---

## 12) References

- Ouyang, L., Wu, J., Jiang, X., Almeida, D., Wainwright, C., Mishkin, P., et al. (2022). Training language models to follow instructions with human feedback. arXiv:2203.02155. PDF: llm_papers_syllabus/InstructGPT_Training_Instructions_Ouyang_2022.pdf
- Brown, T. et al. (2020). Language Models are Few-Shot Learners. arXiv:2005.14165.
- Sanh, V. et al. (2021). Multitask Prompted Training Enables Zero-Shot Generalization (T0). arXiv:2110.08207.
- Wei, J. et al. (2021). Finetuned Language Models are Zero-Shot Learners (FLAN). arXiv:2109.01652.
- Bai, Y. et al. (2022). Constitutional AI: Harmlessness from AI Feedback. arXiv:2212.08073.

