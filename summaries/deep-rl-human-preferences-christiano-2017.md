# Deep Reinforcement Learning from Human Preferences (Christiano et al., 2017)

- Authors: Paul F. Christiano, Jan Leike, Tom B. Brown, Miljan Martic, Shane Legg, Dario Amodei
- Venue/Year: arXiv, 2017 (arXiv:1706.03741)
- PDF: [llm_papers_syllabus/Deep_RL_Human_Preferences_Christiano_2017.pdf](../llm_papers_syllabus/Deep_RL_Human_Preferences_Christiano_2017.pdf)

## TL;DR

- Learns a reward model directly from human pairwise preferences over short trajectory segments, then optimizes an RL policy on that learned reward.
- Requires surprisingly few human comparisons (thousands, not millions) to train policies on Atari and continuous-control tasks to strong performance.
- Decouples reward specification from environment engineering, enabling subjective or hard-to-program goals (e.g., “do a backflip”).
- Introduces a practical human-in-the-loop pipeline: collect rollouts, query humans on segment pairs, fit a reward network, and run policy optimization against that reward.
- Highlights alignment pitfalls: learned rewards can be mis-specified or exploited (reward hacking) without careful auditing and iterative feedback.

## Problem and Motivation

Hand-crafting reward functions is brittle and often unsafe. For many tasks, especially those involving
subjective notions of quality (e.g., aesthetics, comfort, helpfulness), writing a dense, correct reward is
harder than judging which of two behaviors is better. This paper proposes replacing explicit reward
design with preference learning: training a reward model from human comparisons of trajectory
segments, then optimizing a policy with standard deep RL against that learned reward (Sec. 1–2).
This reframes reward engineering as data collection and supervised learning, bringing RL closer to
what would later become RLHF for language models.

## Core Idea and Contributions

- Preference-based reward learning: Treat human feedback as labels in a pairwise comparison model
  (Bradley–Terry style logistic preference). The reward network is trained so that higher cumulative
  predicted reward is assigned to the human-preferred segment (Sec. 2: Preference Model).
- Human-in-the-loop training loop: Alternate between (1) collecting fresh policy rollouts, (2) showing
  humans short clip pairs for comparison, (3) updating the reward model on these comparisons, and
  (4) optimizing the policy on the learned reward (Sec. 2: Training Pipeline).
- Active query selection: Prioritize query pairs that are informative (e.g., high model uncertainty or
  disagreement) to use limited human labels efficiently (Sec. 2: Query Selection).
- Generality across domains: Demonstrates on Atari games and MuJoCo control (e.g., backflips) using
  only human preference data in place of environment rewards (Sec. 3: Experiments).
- Practical label efficiency: Reports that thousands of comparisons (order of 10^3–10^4) suffice to
  train useful reward models for several tasks (Sec. 3: Labeling Budget).

## Method

The algorithm replaces explicit numeric rewards with a learned reward model trained from pairwise
comparisons. The pipeline:

1) Rollout collection
- Run the current policy in the environment to gather trajectories. Random or earlier policies can seed
  initial data so the first queries are diverse (Sec. 2: Data Collection).

2) Segment sampling and human comparison
- Sample short trajectory segments from two rollouts (e.g., ~1–2 seconds). Show the pair as short
  video clips to a human annotator and ask which is better with respect to the task. Optionally allow
  “no preference” when clips are indistinguishable (Sec. 2: Preference Elicitation).

3) Preference model and reward learning
- Model the probability that segment A is preferred over B as a logistic function of their cumulative
  predicted rewards: P(A ≻ B) ∝ exp(Rθ(A)) / [exp(Rθ(A)) + exp(Rθ(B))]. Train parameters θ of a
  neural reward function Rθ to maximize the likelihood of human comparisons (Sec. 2: Preference Model).
- Architecture: For visual tasks (Atari), use a convolutional network over frames; for state-based
  MuJoCo control, use an MLP. The reward is summed over timesteps in a segment to compare clips
  of equal length (Sec. 2: Reward Network Design).

4) Policy optimization against learned reward
- With the learned reward fixed for a short interval, run standard deep RL (e.g., policy gradients/TRPO)
  to maximize expected return under Rθ. Periodically refresh Rθ with new comparisons so the policy
  and reward co-evolve (Sec. 2: Policy Optimization).

5) Query selection and label efficiency
- Select clip pairs that maximize learning (e.g., under uncertainty or disagreement). This focuses human
  effort on informative comparisons and reduces annotation cost (Sec. 2: Query Selection and Label Budget).

Implementation details
- Regularize reward magnitude to avoid degenerate solutions and stabilize policy learning (e.g., reward
  scale control). Maintain a held-out comparison set to monitor reward overfitting (Sec. 2: Regularization).
- Mix policies when sampling segments so humans compare a range of behaviors, not only current
  policy variants (Sec. 2: Data Curation).

## Comparison to Prior Work

- Inverse Reinforcement Learning (IRL): Classical IRL infers rewards from demonstrations of optimal
  behavior. Here, humans only provide pairwise preferences over brief segments, not full demonstrations.
  This is less demanding for annotators and more scalable across tasks (Sec. 1–2).
- Reward shaping/hand-designed rewards: Instead of crafting task-specific, often brittle reward
  functions, the method learns a reward model directly from subjective judgments, enabling goals that
  are difficult to program numerically (Sec. 1).
- From environment rewards to learned rewards: Atari baselines typically rely on explicit game scores;
  this work matches or approaches such performance on some games using only learned rewards (Sec. 3).
- Connection to modern RLHF (Ouyang et al., 2022): The paper provides the “RM” component in the
  RLHF pipeline—learning a reward from preferences—paired downstream with policy optimization.
  Later RLHF adds KL penalties and instruction-tuning context for language models, but the core
  reward-from-preference idea traces to this work (Sec. 4: Discussion).

## Results and What They Mean

- Atari and continuous control with human preferences: The method trains policies on several Atari
  games and MuJoCo control tasks using only preference-derived rewards (Sec. 3: Experiments). The
  reward network trained from a few thousand comparisons guides policy learning to competent
  behavior without access to environment rewards.
- Label efficiency: Reported budgets show that a small number of human comparisons can suffice—on
  the order of thousands—to achieve strong performance on some tasks, demonstrating practicality for
  nontrivial domains (Sec. 3: Labeling Budget).
- Subjective and sparse goals: The MuJoCo backflip task demonstrates learning a complex, sparse goal
  purely from preferences, illustrating how hard-to-specify objectives can be realized (Sec. 3: Control).
- Failure modes and reward hacking: The paper documents cases where the learned reward deviates
  from human intent, and the agent exploits those deviations (e.g., aligning with proxy signals) unless
  the reward model and data collection are iteratively improved (Sec. 3–4: Limitations/Discussion).
- Takeaway: Human preference data can be a practical replacement for engineered reward signals,
  enabling broader and safer objective specification—provided we monitor for misalignment and update
  the reward model iteratively.

Claim checks (PDF section hints)
- The preference-based likelihood and segment-level cumulative reward comparison are described in
  the Method section (Sec. 2: Preference Model and Reward Learning).
- The training loop alternates between collecting rollouts, querying humans, updating the reward model,
  and optimizing the policy (Sec. 2: Training Pipeline).
- Atari and MuJoCo experiments, including a backflip objective, are reported in the Experiments section
  (Sec. 3: Experiments; Control and Atari subsections).
- Annotation budgets in the thousands (10^3–10^4) are discussed in the Experiments section (Sec. 3:
  Labeling Budget).
- Reward hacking and mis-specification concerns are discussed with qualitative examples (Sec. 3–4:
  Results and Discussion).

## Limitations and Failure Modes

- Reward mis-specification: A learned reward approximates human intent only within the distribution of
  comparisons. Gaps or biases in labeling can yield exploitable proxies (reward hacking).
- Non-stationarity: Policy optimization changes the data distribution; the reward model can drift or
  become stale unless frequently updated with new comparisons.
- Sample efficiency vs. task difficulty: While comparison counts are modest, complex tasks may still
  require substantial human time; expert annotators may be needed for specialized domains.
- Credit assignment and context: Short segments can obscure long-horizon effects; learned rewards may
  mishandle delayed consequences without careful segment selection or longer context.
- Safety and oversight: Preference labels reflect annotator judgment; inconsistent or adversarial feedback
  can degrade alignment without audits and safeguards.

## Fit to This Course (Week 8, Reinforcement Learning from Human Feedback)

- Key Topics & Labs: The full RLHF pipeline: SFT, Reward Model (RM), PPO optimization. KL divergence
  penalty. The role of human preference data in alignment. This paper provides the core RM component—
  learning a reward model from preferences—paired with policy optimization (e.g., TRPO/PPO) to close
  the loop.
- Course fit: Christiano et al. establish the foundational technique that InstructGPT/Ouyang et al. later
  adapt to language models. The course’s RLHF week contrasts the original preference-based reward
  learning (this paper) with instruction tuning and KL-regularized optimization in LLMs.
- Lab tie-in: The comparison-based reward learning framing maps cleanly to modern LLM pipelines
  where pairwise human preference data trains a reward model that guides policy updates.

## Discussion Questions

- What are the trade-offs between learning from pairwise preferences vs. demonstrations for complex
  tasks? When is one clearly more label-efficient or safer?
- How should we design query selection to balance uncertainty, diversity, and annotator fatigue so the
  reward model remains aligned as the policy evolves?
- What practical safeguards can detect and mitigate reward hacking as the agent discovers exploitative
  behaviors under a learned reward?
- In LLM RLHF, how does adding a KL penalty to a reference policy change stability and alignment
  compared to the original Christiano pipeline without such a constraint?
- What are good diagnostic metrics for reward model generalization, and how can we validate them
  without access to an external ground-truth reward?

## Glossary

- Reinforcement Learning from Human Feedback (RLHF): A framework that uses human data (e.g.,
  preferences) to fit a reward model and then optimizes a policy to maximize that reward.
- Reward Model (RM): A learned function Rθ(s, a, …) predicting reward; trained here from pairwise
  human preferences over trajectory segments.
- Pairwise Preference Learning: Supervised learning setup where the model predicts which of two
  items (trajectory segments) is preferred; often modeled with a logistic (Bradley–Terry) likelihood.
- Bradley–Terry Model: A probabilistic model of pairwise comparisons where preference probability is
  proportional to the exponentiated score of each item.
- Trajectory Segment: A short contiguous sequence of states (and optionally actions/observations) used
  as a unit for human comparison.
- Policy Optimization (TRPO/PPO): Gradient-based RL algorithms that update a policy to maximize
  expected return; used here to optimize against the learned reward.
- Active Query Selection: Strategy to select comparison pairs that maximize information gain or model
  uncertainty reduction, improving label efficiency.
- Reward Hacking: Undesired behaviors that maximize the learned reward while violating human intent
  due to reward mis-specification or model blind spots.
- Human-in-the-Loop: Systems where humans provide ongoing feedback (comparisons) during training.
- KL Penalty: A divergence regularizer used in later RLHF for LLMs to keep the fine-tuned policy close
  to a reference policy; not central in this 2017 setup but informative for course comparison.
- Alignment: The degree to which an agent’s behavior matches human intentions; improved here by
  learning rewards from human judgments but still vulnerable to mis-specification.

## References

- Christiano, P. F., Leike, J., Brown, T. B., Martic, M., Legg, S., & Amodei, D. (2017). Deep
  Reinforcement Learning from Human Preferences. arXiv:1706.03741.
- Ng, A., & Russell, S. (2000). Algorithms for Inverse Reinforcement Learning.
- Ouyang, L., et al. (2022). Training language models to follow instructions with human feedback.
