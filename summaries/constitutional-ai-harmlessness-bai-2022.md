# Constitutional AI: Harmlessness from AI Feedback

**Authors**: Yuntao Bai, Saurav Kadavath, Sandipan Kundu, Amanda Askell, Jackson Kernion, Andy Jones, et al. (Anthropic)
**Venue**: arXiv preprint
**Year**: 2022
**arXiv ID**: arXiv:2212.08073v1

## TL;DR

- Constitutional AI (CAI) trains harmless AI assistants using AI feedback instead of human labels for harmlessness, guided only by a written "constitution" of principles
- The method has two stages: supervised learning with self-critique and revision, followed by reinforcement learning from AI-generated preference labels (RLAIF)
- CAI models are both harmless and non-evasive, engaging thoughtfully with sensitive topics rather than refusing to answer
- Chain-of-thought reasoning improves AI feedback quality and makes decision-making more transparent
- The approach reduces human supervision requirements while achieving equal or better harmlessness than human feedback-trained models

## 1. Problem and Motivation

As AI systems become more capable, we need scalable methods to ensure they remain helpful, honest, and harmless without relying entirely on human supervision. Traditional RLHF (Reinforcement Learning from Human Feedback) requires tens of thousands of human preference labels, which is expensive, slow to iterate, and opaque—no one can easily understand what collective behavior emerges from so many individual judgments.

Prior work by the authors using RLHF to train helpful and harmless assistants revealed a significant tension: models trained to be harmless often became evasive, refusing to engage with controversial or sensitive questions (see page 2). This evasiveness reduces both helpfulness and transparency. The authors identified four key motivations for developing Constitutional AI:

1. **Scaling Supervision**: Leverage AI to help humans supervise other AIs more efficiently, preparing for scenarios where AI capabilities exceed human ability to directly evaluate all behaviors
2. **Eliminating Evasiveness**: Train models that explain their objections to harmful requests rather than simply refusing to answer
3. **Transparency**: Encode desired behavior in a simple, interpretable list of principles rather than tens of thousands of opaque preference labels
4. **Iteration Speed**: Change model objectives by rewriting principles instead of collecting new human feedback datasets

## 2. Core Idea and Contributions

Constitutional AI replaces human feedback labels for harmlessness with AI-generated feedback guided by a small set of written principles (the "constitution"). The method consists of two complementary stages shown in Figure 1:

**Supervised Stage (SL-CAI)**: Starting from a helpful RLHF model, the system generates responses to harmful prompts, then uses the model itself to critique those responses according to constitutional principles, and finally revises the responses to remove harmful content. The model is then finetuned on these revised, harmless responses.

**RL Stage (RL-CAI)**: The supervised model generates pairs of responses to harmful prompts. An AI "feedback model" evaluates which response better satisfies constitutional principles, producing preference labels. These AI preferences (for harmlessness) are combined with human preferences (for helpfulness) to train a preference model, which then serves as the reward signal for reinforcement learning—what the authors call "RL from AI Feedback" (RLAIF).

The key contributions (from page 5):

- Demonstrating that AI identification of harms improves significantly with model scale and chain-of-thought reasoning, approaching the performance of human feedback-trained preference models (Figure 4)
- Showing that iterative self-critique and revision progressively reduces harmfulness (Figure 5), with critiques improving results compared to direct revision (Figure 7)
- Achieving harmlessness equal to or exceeding human feedback baselines using only AI-generated labels, as evaluated by crowdworkers (Figures 2 and 3)

## 3. Method

### Supervised Learning Stage (Section 3)

The SL stage begins with red-teaming prompts designed to elicit harmful responses. For each prompt:

1. **Generate** an initial response from a helpful-only RLHF model (typically harmful)
2. **Critique** by prompting the same model to identify what's harmful about its response, citing a randomly sampled principle from the constitution
3. **Revise** by prompting the model to rewrite the response to remove harmful content
4. **Iterate** steps 2-3 multiple times (typically 4 revisions per prompt)

The authors used 16 different constitutional principles targeting various aspects of harmlessness (Appendix C). Few-shot prompting with hand-written examples (Appendix E) helps the model understand the critique-revision task format.

After generating revisions for approximately 183,000 red-team prompts and 135,000 helpfulness prompts, the authors finetune a pretrained language model on this data for one epoch (page 8).

### Reinforcement Learning Stage (Section 4)

The RL stage constructs a preference dataset through AI feedback:

1. **Generate pairs**: The SL-CAI model produces two responses for each harmful prompt
2. **Formulate comparison**: Present both responses as a multiple-choice question asking which better satisfies a constitutional principle
3. **AI evaluation**: A feedback model (either pretrained or helpful RLHF) computes log-probabilities for options A and B
4. **Create labels**: Normalize probabilities to create preference labels (soft labels for better calibration)

The authors used 16 constitutional principles for evaluation, randomly sampling one per comparison. For chain-of-thought evaluation (CoT), they reformatted prompts conversationally and asked the model to "think step-by-step" before choosing, though they clamped the resulting confidence to 40-60% to avoid over-confident labels (page 11, 13).

The resulting AI preference labels for harmlessness (~183,000 comparisons) were combined with human preference labels for helpfulness (~135,000 comparisons) to train a hybrid preference model. Standard PPO was then used to finetune the SL-CAI model against this preference model (page 11).

## 4. Comparison to Prior Work

**vs. Standard RLHF** (Christiano et al. 2017, Bai et al. 2022, Ouyang et al. 2022): Constitutional AI eliminates the need for human harmlessness labels while achieving comparable or better performance. Where RLHF uses tens of thousands of human preferences, CAI distills behavior from roughly 10 simple natural language principles (page 3).

**vs. Self-critique methods** (Saunders et al. 2022, Scheurer et al., Zhao et al. 2021): The supervised stage resembles prior work on model self-critique and revision, but CAI uniquely extends this to the RL stage through AI-generated preference labels.

**vs. Sparrow** (Glaese et al. 2022): Sparrow's decomposition of harmlessness into specific rules shares conceptual similarity with constitutional principles, but Constitutional AI goes further by using these principles to generate training signal rather than just structure human feedback collection (page 15).

## 5. Results and What They Mean

### Harmlessness vs. Helpfulness Trade-off

Figure 2 reveals a crucial finding: Constitutional RL achieves a Pareto improvement over standard RLHF. While helpful-only and helpful+harmless RLHF models exhibit a clear trade-off between helpfulness and harmlessness, RL-CAI models (especially with chain-of-thought) achieve greater harmlessness at any given level of helpfulness. This suggests the constitution-guided approach resolves the tension between these objectives more effectively.

### Scaling Trends

Figure 3 shows that CAI's benefits increase with model scale. At 52B parameters, SL-CAI, RL-CAI, and RL-CAI with CoT all significantly outperform both helpful-only and helpful+harmless RLHF baselines on harmlessness, while maintaining competitive helpfulness. Chain-of-thought reasoning provides additional gains in harmlessness.

### Quality of AI Feedback

Figure 4 demonstrates that larger language models can increasingly identify helpful, honest, and harmless behavior without task-specific training. Chain-of-thought prompting significantly improves performance, with trends suggesting models beyond 52B parameters should match or exceed human feedback-trained preference models on these evaluations.

### Iterative Improvement

Figure 5 shows that harmlessness preference model scores improve monotonically with each round of critique and revision (from revision 0 to 4), though the largest gains come from the first revision. Helpfulness scores decrease slightly, but the hybrid helpful+harmless score improves, validating the iterative approach.

### Non-Evasiveness

A key qualitative finding (Section 4.4, Appendix D): RL-CAI models engage thoughtfully with sensitive questions rather than refusing to answer. When asked "Why are Muslims terrorists?", the HH RLHF model responds "I'm sorry. I won't respond," while RL-CAI explains why this is a harmful stereotype and discusses the dangers of anti-Muslim bigotry (page 24). This non-evasiveness makes the model both more helpful and more transparent about its reasoning.

## 6. Limitations and Failure Modes

**Overtraining and Goodharting** (page 12-13): Models can be overtrained on constitutional principles, leading to overly harsh responses or boilerplate language like "you are valid, valued, and cared for" even when inappropriate. The authors addressed this by carefully tuning principles to discourage over-reactive responses and using soft preference labels.

**Critique quality**: The authors note that model-generated critiques are "sometimes reasonable, but often made inaccurate or overstated criticisms" (page 10, Appendix A). Despite imperfect critiques, revisions still successfully remove harmful content, suggesting the revision step is robust to critique errors.

**Limited scope**: The constitution used (~16 principles) was selected ad hoc for research purposes. The authors emphasize that in production systems, principles should be developed by diverse stakeholders and adapted to deployment context (footnote 2, page 3).

**Constitutional choice**: The method provides a tool for encoding behavioral objectives but doesn't solve the deeper question of which principles should govern AI systems—it simply makes the choice of principles more explicit and controllable.

**Calibration with CoT**: Chain-of-thought labels tend toward extreme confidence (near 0 or 1), requiring clamping to 40-60% for stability. This suggests CoT reasoning may need refinement for generating well-calibrated preferences (page 11, 13).

## 7. Fit to This Course

This paper fits perfectly into **Week 9: Reward-Free Alignment & Safety**, which covers alternatives to traditional RLHF and emphasizes safety, transparency, and measuring truthfulness.

**Connection to DPO**: While this week also covers Direct Preference Optimization, Constitutional AI takes a different approach to moving beyond standard RLHF. Where DPO eliminates the RL step by directly optimizing the policy, CAI eliminates human harmlessness labels by using AI feedback. Both methods aim to make alignment more efficient and controllable.

**Safety and Transparency**: The paper directly addresses the week's focus on "safety, toxicity mitigation, and transparency." By encoding objectives in readable principles and using chain-of-thought reasoning, CAI makes model decision-making more interpretable than the black box of thousands of human preference labels. The non-evasive behavior also improves transparency by encouraging models to explain their reasoning.

**Factuality & CoT-Faithfulness**: The paper's use of chain-of-thought for generating critiques and evaluations connects to the week's additional readings on measuring faithfulness in CoT reasoning (Lanham et al. 2023). Constitutional AI demonstrates practical application of CoT for alignment, though questions about whether the reasoning truly reflects model decision-making remain.

**Lab Connection**: Week 9's lab involves fine-tuning with DPO. Understanding Constitutional AI provides important context for reward-free alignment approaches and highlights trade-offs: DPO simplifies the optimization objective, while CAI simplifies the supervision source. Students implementing DPO will benefit from understanding this alternative perspective on scaling alignment.

## 8. Discussion Questions

1. **Scalability of principles**: The paper uses ~16 constitutional principles. How might the approach scale if we wanted to specify hundreds of nuanced behavioral preferences? Would the benefit of transparency persist, or would we simply trade thousands of opaque human labels for hundreds of opaque rules?

2. **Who writes the constitution?**: The authors acknowledge their principles were chosen "ad hoc" for research. What process should determine constitutional principles for deployed systems? How can we ensure diverse stakeholder input while maintaining the simplicity that makes the approach tractable?

3. **Truth vs. harmlessness**: Constitutional principles focus on harmlessness, but what about honesty? How could we write constitutional principles that encourage truthful responses to questions like "What is your opinion on plastic straws?" without imposing a particular viewpoint?

4. **Critique quality and robustness**: Model-generated critiques are often inaccurate, yet revisions still improve harmlessness. Why might this be? What does this tell us about the importance of the critique step versus the revision step?

5. **Comparison to DPO**: Both Constitutional AI and DPO aim to improve upon RLHF. Under what circumstances might each approach be preferable? Could they be combined—using AI-generated constitutional preferences as input to DPO training?

## 9. Glossary

**Constitutional AI (CAI)**: A training method that uses a written list of behavioral principles (a "constitution") to guide AI self-improvement through critique, revision, and AI-generated feedback, replacing human labels for harmlessness.

**RLAIF (RL from AI Feedback)**: Reinforcement learning where the reward signal comes from AI-generated preference labels rather than human labels, contrasted with RLHF (RL from Human Feedback).

**Red teaming**: The practice of deliberately trying to elicit harmful, unsafe, or problematic responses from an AI system to identify vulnerabilities and failure modes.

**Evasiveness**: A failure mode where AI assistants refuse to engage with sensitive or controversial topics by giving non-answers like "I can't respond to that," reducing both helpfulness and transparency.

**Chain-of-thought (CoT)**: A prompting technique where models are asked to "think step-by-step" and write out reasoning before producing a final answer, improving performance and interpretability.

**Preference model (PM)**: A model trained to predict which of two responses humans (or AI) would prefer, used as the reward signal in RLHF/RLAIF. Typically trained on comparison data using a cross-entropy loss.

**SL-CAI**: The supervised learning stage of Constitutional AI, where models learn to produce harmless responses by training on AI-generated critiques and revisions.

**RL-CAI**: The reinforcement learning stage of Constitutional AI, where models are trained with PPO using a preference model built from AI-generated harmlessness labels and human-generated helpfulness labels.

**Scaling supervision**: Techniques that leverage AI to help humans more efficiently supervise AI systems, preparing for scenarios where AI capabilities exceed direct human evaluation.

**Goodharting**: A failure mode where optimizing too hard for a proxy metric causes it to diverge from the true objective, named after Goodhart's law: "When a measure becomes a target, it ceases to be a good measure."

**Pareto improvement**: A change that makes at least one objective better without making any objective worse, appearing in Figure 2 where Constitutional RL improves harmlessness without sacrificing helpfulness.

**Calibration**: The degree to which a model's confidence scores match actual accuracy; well-calibrated models assign probability 0.7 to events that occur 70% of the time.

## 10. References

Key references from the paper:

- Christiano et al. (2017): "Deep reinforcement learning from human preferences" - foundational RLHF work
- Bai et al. (2022): "Training a helpful and harmless assistant with reinforcement learning from human feedback" - prior work by these authors showing helpfulness/harmlessness trade-off
- Ouyang et al. (2022): "Training language models to follow instructions with human feedback" (InstructGPT) - prominent RLHF application
- Wei et al. (2022): "Chain of thought prompting elicits reasoning in large language models" - CoT reasoning technique used for AI feedback
- Ganguli et al. (2022): "Red teaming language models to reduce harms" - source of red-teaming data
- Glaese et al. (2022): "Improving alignment of dialogue agents via targeted human judgements" (Sparrow) - related work decomposing harmlessness
