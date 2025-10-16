# Notes — InstructGPT (Ouyang et al., 2022)

PDF: llm_papers_syllabus/InstructGPT_Training_Instructions_Ouyang_2022.pdf
Week/Section: Week 8 — Reinforcement Learning from Human Feedback (RLHF)

Sections
- Key contributions
- Method sketch
- Prior work contrast
- Notable results
- Limitations

Key contributions (scratch)
- End-to-end RLHF pipeline: SFT → Reward Model (RM) → PPO with KL penalty.
- Human preference data used to align outputs with user intent.
- Empirical finding: small RLHF model can be preferred to much larger base LM.
- Comprehensive evaluation across helpfulness, harmlessness/toxicity, and truthfulness.
- Practical details: prompt distribution, annotation protocol, KL control via reference model.

Method sketch (scratch)
- Collect instruction prompts; gather human-written responses for SFT.
- Train SFT policy on curated instruction-following dataset.
- Collect pairwise human preferences over model outputs to train a reward model.
- Optimize policy with PPO against RM, using KL penalty to stay close to SFT/reference.
- Iterate data collection and training for stability and quality.

Prior work contrast (scratch)
- vs. GPT-3: pure LM pretraining without instruction alignment.
- vs. FLAN/T0: supervised instruction tuning only (no RM/PPO loop).
- vs. Constitutional-AI: uses principles/AI feedback instead of human preference labels.

Notable results (scratch)
- Human preference: RLHF policy preferred over GPT-3 baseline; small model competitive.
- Safety: lower toxicity rates while maintaining helpfulness.
- Generalization: improved zero-shot following of natural-language instructions.

Limitations (scratch)
- Reward hacking and over-optimization risks; KL required to avoid mode collapse.
- Annotator bias and instruction distribution shift.
- Costly human data pipeline; scaling considerations.

Outline (10–12 bullets)
- Problem: pretrained LMs misaligned with user intent; need instruction following.
- Approach overview: SFT → Reward Model → PPO with KL penalty; loop diagram.
- Data: prompt sources, SFT dataset, preference data protocol.
- SFT stage: objectives, reference model, base architectures.
- Reward model: pairwise Bradley–Terry style learning-to-rank; dataset size.
- PPO stage: objective with KL term; hyperparameters; stability concerns.
- Evaluation: human preference wins over GPT-3; helpfulness vs. harmlessness.
- Results detail: small InstructGPT vs. large GPT-3 preference rates; examples.
- Safety/toxicity metrics; truthfulness; robustness notes.
- Comparisons: vs. FLAN/T0 (SFT only), vs. DPO (post hoc simplification).
- Limitations: bias, reward hacking, scalability of human loop.
- Course fit: RLHF pipeline aligns with Week 8 topics and lab goals.

