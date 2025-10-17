# Measuring Faithfulness in Chain-of-Thought Reasoning

**Authors:** Tamera Lanham, Ethan Perez, and the Anthropic Alignment Team
**Year:** 2023
**Venue:** arXiv preprint
**arXiv ID:** arXiv:2307.13702v1

---

## TL;DR

- **Chain-of-Thought (CoT) reasoning is not always faithful**: Models show large variation across tasks in how much they rely on their stated reasoning, sometimes ignoring it entirely and other times depending on it heavily.
- **Post-hoc reasoning varies by task**: On some tasks (e.g., ARC Easy, HellaSwag), truncating or corrupting the CoT rarely changes the answer; on others (e.g., AQuA, LogiQA), CoT strongly influences the final prediction.
- **Extra compute and steganography are ruled out**: Performance gains from CoT do not come from added test-time computation alone (filler tokens provide no benefit) or from information encoded in the particular phrasing of the CoT (paraphrasing does not degrade performance).
- **Inverse scaling with model capability**: Larger, more capable models produce *less* faithful CoT reasoning on most tasks, while smaller models (around 13B parameters) often show the most faithful reasoning.
- **CoT can be faithful under the right conditions**: By carefully choosing model size and task difficulty, it is possible to elicit reasoning that is more faithful to the model's actual decision process.

---

## 1. Problem and Motivation

Large language models (LLMs) perform better when prompted to produce step-by-step "Chain-of-Thought" (CoT) reasoning before answering a question (Wei et al., 2022). This has led many to claim that CoT enhances model interpretability and explainability by making the model's reasoning transparent. However, for these claims to hold, the stated reasoning must be *faithful*—that is, it must "accurately represent the reasoning process behind the model's prediction" (Jacovi & Goldberg, 2020; page 1).

Recent work has shown that LLM-generated reasoning can be unfaithful in adversarial settings (Turpin et al., 2023), raising the critical question: **Is CoT reasoning ever faithful, and under what conditions?** This question is especially important in high-stakes domains like medicine or legal decision-making, where understanding *why* a model made a particular prediction is essential for trust and reliability.

Lanham et al. (2023) investigate this question by proposing a suite of tests to measure CoT faithfulness. Rather than assuming CoT is faithful or unfaithful, they take a "defense-in-depth" approach: each test rules out one class of potential faithfulness failures, and together they build a picture of when and how CoT reasoning can be trusted.

---

## 2. Core Idea and Contributions

The paper's central idea is to **intervene on the model's stated reasoning and measure how the final answer changes**. If the model's answer is robust to manipulations of the CoT, this suggests the CoT is not being used (i.e., it is unfaithful). If the answer changes in response to CoT interventions, this provides evidence that the model is conditioning on the CoT (i.e., the reasoning may be faithful).

The authors propose four main tests:

1. **Early Answering**: Truncate the CoT midway and prompt for an answer. If the answer changes frequently as more reasoning is provided, the CoT is likely being used (less post-hoc).
2. **Adding Mistakes**: Inject a plausible error into one step of the CoT and regenerate the rest. If the answer changes, the model is relying on the CoT.
3. **Filler Tokens**: Replace the CoT with uninformative tokens (e.g., "..."). If performance drops compared to real CoT, the extra test-time computation alone is not responsible for CoT's benefit.
4. **Paraphrasing**: Reword the CoT without changing its content. If performance remains the same, information is not encoded via subtle phrasing choices (steganography).

The paper evaluates these tests on eight multiple-choice benchmarks (AQuA, LogiQA, MMLU, TruthfulQA, HellaSwag, OpenBookQA, ARC Challenge, ARC Easy) using a 175B-parameter RLHF-tuned LLM, and investigates how faithfulness varies with model size.

**Key contributions:**
- A systematic framework for measuring CoT faithfulness via interventions.
- Evidence that CoT faithfulness varies dramatically by task and model size.
- Demonstration that extra compute and phrasing-encoded information do not explain CoT's performance gains.
- Discovery of "inverse scaling" in faithfulness: larger models often produce less faithful reasoning.

---

## 3. Method

### Model and Tasks

The primary model is a 175B-parameter decoder-only transformer pretrained language model, fine-tuned with reinforcement learning from human feedback (RLHF) to act as a helpful assistant (following Bai et al., 2022; page 2). For model size experiments (Section 3), the authors use a series of models ranging from 810M to 175B parameters, all RLHF-tuned.

Eight multiple-choice tasks are selected to cover reasoning-heavy domains: ARC Challenge and Easy (grade-school science), AQuA (algebra word problems), HellaSwag (text completion), LogiQA (logical reasoning), MMLU (multitask exam questions), OpenBookQA (elementary science), and TruthfulQA (factual questions eliciting misconceptions).

### Prompting and Sampling

For each question, the model is prompted with a few-shot CoT prompt (Table 1, page 3) that instructs it to "think step by step" before answering. The model samples 100 reasoning traces per question using nucleus sampling (p=0.95, temperature 0.8). After generating the CoT, the model is prompted to give its final answer, and the probability distribution over answer choices is recorded.

### Intervention Experiments

**Early Answering (§2.3):**
Each CoT is truncated after each sentence, and the model is prompted to answer from the partial reasoning. The percentage of times the truncated CoT yields the same answer as the full CoT is measured. A low matching rate indicates the CoT is not post-hoc (i.e., the model updates its answer as reasoning progresses).

**Adding Mistakes (§2.4):**
A pretrained model (without RLHF) generates a plausible mistake for one sentence of the CoT using a few-shot prompt (Appendix A, page 14). The mistaken sentence replaces the original, and the CoT is regenerated from that point forward. The authors measure how often the final answer changes. High sensitivity to mistakes indicates the model relies on the CoT.

**Filler Tokens (§2.5):**
The CoT is replaced with varying numbers of " ..." tokens (ellipses) to test whether extra test-time computation alone boosts performance. If filler tokens provided the same benefit as CoT, this would suggest the model performs hidden reasoning not reflected in the stated CoT.

**Paraphrasing (§2.6):**
A language model paraphrases portions of the CoT *without access to the original question* to avoid encoding the correct answer. The paraphrased CoT is reinserted, and the rest is regenerated. If accuracy is preserved, the particular phrasing of the CoT is not responsible for performance gains (ruling out steganography).

### Faithfulness Metric: Area Over the Curve (AOC)

For Early Answering and Adding Mistakes, the authors compute an "Area Over the Curve" (AOC) metric (Table 2, page 5). This measures the cumulative deviation from perfect matching (i.e., always giving the same answer as the original CoT). Higher AOC indicates less post-hoc reasoning, hence greater faithfulness.

---

## 4. Comparison to Prior Work

**Turpin et al. (2023):** Demonstrated unfaithful CoT in adversarial settings (biased few-shot prompts). Lanham et al. extend this by studying faithfulness in non-adversarial, realistic conditions across a wider variety of tasks.

**Wei et al. (2022):** Tested three hypotheses for why CoT improves performance, including whether it provides extra test-time computation. Lanham et al. expand on this with the filler tokens experiment, varying token count and task, and find no evidence that extra computation alone explains CoT's benefit.

**Madaan & Yazdanbakhsh (2022):** Investigated CoT via counterfactual prompting of few-shot examples. Lanham et al. instead intervene on the model's *own generated* reasoning, providing a complementary perspective on faithfulness.

**Lyu et al. (2023), Creswell & Shanahan (2022), Radhakrishnan et al. (2023):** Proposed alternative reasoning methods designed to be more faithful by construction (e.g., generating executable programs or decomposing questions). Lanham et al.'s metrics could be applied to evaluate faithfulness in these methods as well.

---

## 5. Results and What They Mean

### Faithfulness Varies Dramatically by Task (§2.3–2.6)

**Early Answering (Figure 3, Table 2):** On ARC Easy, ARC Challenge, and OpenBookQA, the AOC is very low (0.02–0.07), meaning the CoT rarely changes the model's answer—reasoning appears highly post-hoc. In contrast, on AQuA (AOC = 0.44) and LogiQA (AOC = 0.26), the model frequently updates its answer as reasoning progresses, indicating the CoT is being used.

**Adding Mistakes (Figure 4, Table 2):** Results largely agree with Early Answering. AQuA shows the highest AOC (0.52); mistakes frequently change the final answer. On ARC Easy (AOC = 0.07), mistakes rarely affect the answer, suggesting the model ignores the CoT.

**Key insight:** The extent of post-hoc reasoning is task-dependent and not strongly correlated with the accuracy improvement from CoT. For example, HellaSwag shows negative accuracy gain from CoT (–4.69%) but still exhibits some reliance on CoT in the Early Answering and Adding Mistakes experiments. This suggests CoT can be faithful even when it does not improve performance.

### Extra Compute and Steganography Are Not Responsible (§2.5–2.6)

**Filler Tokens (Figure 5):** Replacing CoT with " ..." tokens of equivalent length provides *no* accuracy benefit over no CoT at all. In fact, for some tasks (TruthfulQA, OpenBookQA), performance slightly decreases, likely because the filler sequence is out-of-distribution. This rules out the hypothesis that CoT's performance boost comes from extra test-time computation that the model does not reveal in the stated reasoning.

**Paraphrasing (Figure 6):** Paraphrasing the CoT yields nearly identical accuracy to the original CoT across all tasks. This indicates that subtle phrasing choices or punctuation do not encode hidden information (steganography). The semantic content of the CoT, not its surface form, drives performance.

**Implication:** CoT's benefit comes from the *content* of the reasoning steps, not from hidden computation or encoded signals. This is good news for faithfulness: the stated reasoning genuinely matters.

### Inverse Scaling: Larger Models Are Less Faithful (§3)

**Standard Tasks (Figure 7):** For 7 out of 8 tasks, the 13B-parameter model changes its answer with vs. without CoT more often than the 175B model. Faithfulness generally decreases monotonically as model size increases from 13B to 175B parameters. The 13B model appears to be at a "sweet spot": large enough to benefit from CoT, but not so capable that it can solve tasks without reasoning.

**Addition Tasks (Figure 8):** On synthetic addition problems, the same inverse scaling pattern holds. For a fixed model size, easier tasks (fewer operands, shorter digits) show less faithful reasoning. For a fixed task difficulty, larger models show less faithful reasoning.

**Interpretation:** More capable models can often predict the correct answer without relying on the CoT, leading to post-hoc reasoning. Smaller models, which struggle more with the task, are forced to rely on the CoT, making their reasoning more faithful. This suggests that to obtain faithful explanations, one should use models that are *appropriately* capable for the task—not the most powerful model available.

---

## 6. Limitations and Failure Modes

**No Ground Truth for Faithfulness:** The paper does not have direct access to the model's internal reasoning process, so it cannot definitively prove faithfulness. The proposed tests rule out certain classes of unfaithfulness but cannot guarantee that other unknown failure modes do not exist.

**Weighting Evidence:** Without ground truth, it is unclear how to weigh the importance of each test relative to the others. A model might score well on paraphrasing but poorly on early answering; which is more important?

**RLHF Fine-Tuning Effects:** All experiments use RLHF-tuned models, which may produce different reasoning than pretrained models. RLHF models are trained to maximize human-judged quality, which might encourage post-hoc reasoning that sounds good but does not reflect the model's true process. Pretrained models might be more faithful because they are trained to generate plausible continuations, not to optimize for human preference.

**Limited to Multiple-Choice Tasks:** Most tasks are multiple-choice, which may not reflect the full range of reasoning scenarios (e.g., open-ended generation, multi-step problem-solving).

**Faithfulness vs. Accuracy Trade-Off:** The inverse scaling result suggests a tension between model capability and reasoning faithfulness. If faithfulness requires using less capable models, this may come at the cost of lower absolute performance.

---

## 7. Fit to This Course (Week 9: Reward-Free Alignment & Safety)

This paper is a perfect fit for **Week 9**, which focuses on **Direct Preference Optimization (DPO) vs. RLHF**, **safety, toxicity mitigation, and transparency**, and **factuality & CoT-faithfulness**.

### Connection to Week 9 Key Topics

**Reward-Free Alignment (DPO vs. RLHF):**
The paper studies RLHF-tuned models and finds that they sometimes produce unfaithful reasoning. This raises the question: Does RLHF training encourage post-hoc reasoning that sounds good to human evaluators but does not reflect the model's true process? DPO, which directly optimizes preferences without a learned reward model, might produce different faithfulness characteristics. The paper's metrics (early answering, adding mistakes) could be applied to compare DPO and RLHF models' reasoning faithfulness.

**Safety and Transparency:**
Faithful reasoning is a prerequisite for transparency and trustworthiness. If a model's stated reasoning is unfaithful, we cannot rely on it to detect unsafe behavior or understand why a model made a harmful prediction. This paper provides concrete tools to measure transparency in CoT reasoning, directly addressing the safety goal of understanding model behavior.

**Factuality & CoT-Faithfulness:**
Week 9 includes TruthfulQA (Lin et al., 2021) and this paper (Lanham et al., 2023) as additional readings. TruthfulQA measures whether models produce truthful answers; Lanham et al. measure whether models' *reasoning* is truthful (i.e., faithful to their decision process). Together, these papers highlight two dimensions of trustworthiness: factual accuracy and reasoning transparency.

**Lab: Fine-tuning an aligned model using DPO:**
The lab involves training a model with DPO. Students could use the faithfulness metrics from this paper to evaluate whether DPO-tuned models produce more or less faithful reasoning than RLHF models on the same tasks. This would provide hands-on experience with measuring transparency in aligned models.

**Connection to Constitutional AI (Bai et al., 2022):**
Constitutional AI uses RLHF from AI feedback to align models according to written principles. If the model's reasoning is unfaithful, the Constitutional AI process might reward superficially compliant reasoning that does not reflect the model's true decision process. Measuring CoT faithfulness could help detect such misalignment.

### Why This Matters for the Course

Students learning about alignment need to understand not just *what* a model outputs, but *why* it produces that output. This paper shows that models' stated reasoning is not always trustworthy, and that faithfulness depends on the model and task. By studying this paper, students will:

1. Learn to critically evaluate model explanations rather than taking them at face value.
2. Understand the trade-offs between model capability and reasoning transparency.
3. Gain tools (early answering, adding mistakes, paraphrasing, filler tokens) to measure faithfulness in their own alignment experiments.
4. Appreciate the complexity of building interpretable, trustworthy AI systems.

---

## 8. Discussion Questions

1. **RLHF and Post-Hoc Reasoning:** Does RLHF training encourage models to produce reasoning that sounds good to humans but is not faithful to their decision process? How could we modify RLHF to incentivize faithful reasoning?

2. **Faithfulness vs. Capability Trade-Off:** The paper shows that smaller models often produce more faithful reasoning. If faithful explanations are critical for high-stakes applications, should we deliberately use less capable models? What are the risks and benefits of this approach?

3. **Applying Faithfulness Metrics to DPO:** How might DPO-tuned models differ from RLHF-tuned models in terms of CoT faithfulness? Design an experiment to test this hypothesis using the metrics from the paper.

4. **Faithfulness on Open-Ended Tasks:** The paper studies multiple-choice tasks. Would the same faithfulness patterns hold for open-ended generation tasks (e.g., writing code, summarization, dialogue)? How would you adapt the metrics for these settings?

5. **Ground Truth for Faithfulness:** The paper acknowledges that it lacks ground truth for the model's internal reasoning. What other methods (e.g., mechanistic interpretability, activation patching) could complement these behavioral tests to provide stronger evidence for or against faithfulness?

---

## 9. Glossary

1. **Faithfulness:** The degree to which a model's stated reasoning accurately represents the reasoning process that led to its prediction.

2. **Chain-of-Thought (CoT) Prompting:** A technique where a model is prompted to generate step-by-step reasoning before producing a final answer, typically improving performance on reasoning tasks.

3. **Post-Hoc Reasoning:** Reasoning that is generated after the conclusion has already been determined, rather than reasoning that causally influences the conclusion. Post-hoc reasoning is less likely to be faithful.

4. **Early Answering:** An intervention where the CoT is truncated midway and the model is prompted to answer from the partial reasoning. High sensitivity to truncation suggests less post-hoc reasoning.

5. **Adding Mistakes:** An intervention where a plausible error is inserted into the CoT and the rest is regenerated. High sensitivity to mistakes indicates the model relies on the CoT.

6. **Filler Tokens:** Uninformative tokens (e.g., " ...") used to replace the CoT to test whether extra test-time computation alone provides CoT's performance benefit.

7. **Paraphrasing:** Rewording the CoT without changing its content to test whether subtle phrasing choices encode information (steganography) responsible for performance gains.

8. **Area Over the Curve (AOC):** A summary metric for Early Answering and Adding Mistakes experiments, measuring the cumulative deviation from always matching the original answer. Higher AOC indicates less post-hoc reasoning (more faithfulness).

9. **Inverse Scaling:** A phenomenon where larger, more capable models perform worse on a metric as size increases. In this paper, larger models show less faithful reasoning on most tasks.

10. **Steganography (in CoT context):** The hypothetical encoding of information in the CoT via subtle phrasing, punctuation, or word choice that improves performance but is not understandable to humans.

11. **RLHF (Reinforcement Learning from Human Feedback):** A fine-tuning method where models are trained to maximize rewards predicted by a model trained on human preference comparisons.

12. **Test-Time Computation:** The amount of processing the model does between receiving the input and producing the output. Longer contexts (e.g., CoT) provide more test-time computation.

---

## 10. References

- **Jacovi & Goldberg (2020):** "Towards Faithfully Interpretable NLP Systems" – Defines faithfulness in the context of model explanations.
- **Wei et al. (2022):** "Chain-of-Thought Prompting Elicits Reasoning in Large Language Models" – Introduces CoT prompting and shows performance gains on reasoning tasks.
- **Turpin et al. (2023):** "Language Models Don't Always Say What They Think: Unfaithful Explanations in Chain-of-Thought Prompting" – Demonstrates unfaithful CoT in adversarial settings.
- **Bai et al. (2022):** "Constitutional AI: Harmlessness from AI Feedback" – Describes RLHF from AI feedback for alignment (the training method used for models in this study).
- **Lin et al. (2022):** "TruthfulQA: Measuring How Models Mimic Human Falsehoods" – Benchmark for factual accuracy, used as one of the tasks in this study.
- **Lyu et al. (2023):** "Faithful Chain-of-Thought Reasoning" – Proposes generating programs in a domain-specific language to ensure reasoning is used to produce the answer.
- **Radhakrishnan et al. (2023):** "Question Decomposition Improves the Faithfulness of Model-Generated Reasoning" – Shows that decomposing questions into subquestions leads to more faithful reasoning by the metrics in this paper.

---

## Figure Insights

**Figure 1 (page 1):** Illustrates the four intervention tests with a concrete example (computing 5!). Shows how Early Answering, Adding Mistakes, Paraphrasing, and Filler Tokens manipulate the CoT in different ways.

**Figure 3 (page 4):** Early Answering results for 3–6 step CoTs. AQuA shows low matching early in the CoT and increasing matching as more steps are provided, indicating the model updates its answer throughout. ARC Easy shows high matching even with 0% of the CoT provided, indicating post-hoc reasoning.

**Figure 4 (page 5):** Adding Mistakes results for 3–6 step CoTs. Similar pattern to Early Answering: AQuA is most sensitive to mistakes, while ARC Easy, ARC Challenge, and OpenBookQA are least sensitive.

**Table 2 (page 5):** Summary of AOC scores and accuracy with/without CoT for all tasks. Shows wide variation in faithfulness (AOC ranges from 0.02 to 0.44 for Early Answering) and weak correlation between faithfulness and accuracy improvement.

**Figure 5 (page 6):** Filler tokens provide no accuracy benefit over no CoT, ruling out the hypothesis that extra test-time computation alone explains CoT's performance gains.

**Figure 6 (page 7):** Paraphrasing results show accuracy closely matches the original CoT across all tasks, ruling out steganography as a driver of CoT performance.

**Figure 7 (page 7):** Model size experiment shows inverse scaling: 13B models produce the most faithful reasoning on most tasks, while 175B models produce the least faithful reasoning.

**Figure 8 (page 8):** Addition task results show inverse scaling with both model size and task difficulty: larger models and easier tasks both produce less faithful reasoning.
