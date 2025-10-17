# Chain-of-Thought Prompting Elicits Reasoning in Large Language Models (Wei et al., 2022)

## TL;DR
- Asking models to “think step by step” before answering markedly improves performance on multi-step reasoning tasks (arithmetic, commonsense, symbolic).
- The approach is simple: provide few-shot exemplars that include intermediate reasoning traces, prompting the model to generate its own chain-of-thought (CoT) before the final answer.
- Benefits grow with scale: larger models exhibit stronger gains from CoT prompting than smaller ones.
- CoT turns many problems from direct prediction into explain-then-answer generation, improving faithfulness of intermediate steps in practice, though not guaranteed to be causally faithful.
- CoT complements standard prompting and fine-tuning; it requires no gradient updates and uses only prompt engineering.

## 1) Title and Citation
- Chain-of-Thought Prompting Elicits Reasoning in Large Language Models. Wei, X. et al. 2022. arXiv:2201.11903.

## 2) Problem and Motivation
Large language models (LLMs) often falter on tasks requiring multi-step reasoning, where intermediate computations and logical decompositions matter (e.g., multi-digit arithmetic, commonsense chains, symbolic transformations). Standard prompts typically ask for a direct answer. This obscures the necessary intermediate steps and makes it harder for the model to follow a structured path to the correct solution.

The paper proposes a minimal intervention: instead of asking for the final answer directly, the prompt includes few-shot examples where each solution is written as a sequence of intermediate steps (a “chain of thought”) followed by the final answer. The hypothesis is that showing the structure of reasoning in the prompt elicits the model’s own multi-step decomposition, improving correctness without changing the model’s parameters.

Motivations include:
- Unlocking latent reasoning capabilities of LLMs with a simple prompting technique.
- Reducing error cascades by encouraging explicit intermediate computations.
- Avoiding training-time costs; using only inference-time prompting makes the method widely usable.

## 3) Core Idea and Contributions
- Chain-of-Thought (CoT) prompting: Include few-shot exemplars that show intermediate reasoning steps before the final answer.
- Demonstrate broad improvements on arithmetic (e.g., MultiArith, GSM8K), commonsense (e.g., CommonsenseQA-style reasoning variants), and symbolic reasoning tasks.
- Show scaling effect: larger models benefit more from CoT prompting than smaller ones.
- Provide simple prompting recipes that require no extra supervision or fine-tuning.

Claim checks and pointers:
- The paper defines CoT prompting via worked solutions in few-shot prompts (Sec. 2, Method overview).
- Benchmarks span arithmetic and symbolic reasoning tasks; arithmetic tasks are especially improved (Sec. 3, Tasks and Results).
- Gains increase with model size (Results sections discussing PaLM/large Transformers; scaling trend figures/tables).
- No gradient updates or special training are required—this is an inference-time technique (Abstract; Sec. 1–2).

## 4) Method (Plain-Language)
The method wraps standard few-shot prompting with examples that include the reasoning process. A typical CoT exemplar:

- Problem: “If a farm has 12 cows and buys 7 more, then sells 5, how many remain?”
- Reasoning: “Start with 12; buying 7 makes 19; selling 5 leaves 14.”
- Answer: “14.”

At inference time, the model is asked a new problem; because the prompt patterns include “reasoning then answer,” the model produces its own reasoning steps before the final answer. Key details:
- Exemplars are concise but explicit about intermediate computations.
- The approach uses few-shot formatting only; no labels beyond the final answer are needed.
- CoT is task-agnostic: arithmetic, symbolic, and commonsense tasks all benefit when intermediate steps are natural to write.

From an optimization lens, CoT shifts the objective from direct p(answer|question, shots) to p(reasoning, answer|question, shots), giving the model a larger “surface” to match on distributional patterns of problem solving observed in the shots. This improves robustness to spurious shortcuts in direct-answer prompting.

## 5) Comparison to Prior Work
- Direct-answer few-shot prompting: Prior work often showed few-shot examples with only inputs and outputs. CoT instead reveals the latent structure of the computation via worked steps.
- Program-of-thought / tool use: Later work extends the idea by externalizing intermediate steps into executable programs or tool calls; CoT is simpler—pure text reasoning within the model.
- Explanation fine-tuning: Another line fine-tunes models to produce explanations. CoT achieves many of the same benefits without training-time cost, at the expense of potentially noisier or less-faithful explanations.

Claim pointers:
- CoT works without training (Abstract; Sec. 1–2), in contrast to explanation-tuned models.
- The paper frames CoT as a prompting method complementary to program-based or tool-augmented approaches (Discussion/Related Work).

## 6) Results and What They Mean
Empirically, CoT prompting substantially improves accuracy on multi-step reasoning benchmarks. Notable patterns reported:
- Arithmetic and numeric reasoning tasks (e.g., MultiArith, GSM8K) see large gains when models generate intermediate steps (Sec. 3).
- Symbolic and commonsense reasoning tasks also improve when the problem admits a natural stepwise decomposition (Sec. 3).
- Scaling trend: larger models see larger absolute gains from CoT (Summarized in Results figures/tables; also discussed in the Abstract/Conclusion).

Implications:
- Reasoning chains reframe complex problems so that a generative model can “teach itself” the path to an answer from a few demonstrations.
- The effect grows with scale, suggesting that the capacity required to leverage CoT emerges in larger models.
- CoT shows that prompt formatting—not just model architecture—materially impacts reasoning performance.

Fidelity checks:
- The paper reports consistent improvements across multiple benchmarks, especially arithmetic (Results section tables).
- Examples in the paper illustrate how intermediate calculations stabilize long computation paths (Method/Examples).

## 7) Limitations and Failure Modes
- Faithfulness: Generated chains may not reflect the model’s true internal computation; they can be post-hoc rationalizations (noted in follow-up work, and discussed in the paper’s caveats). This means correct answers can accompany flawed reasoning traces.
- Sensitivity to exemplars: Poorly chosen few-shot examples can mislead the model or bias it toward brittle heuristics.
- Length/latency: Producing CoT increases token count, raising inference time and cost.
- Not universally helpful: For tasks where intermediate steps are unclear or unnecessary, CoT may add noise without improving accuracy.

Claim pointers:
- The paper discusses when CoT helps most—tasks with natural decompositions—and acknowledges potential sensitivities (Discussion/Limitations).

## 8) Fit to This Course (Week 10, Deployment, Agents, and The Future)
- Key Topics & Labs (from the course track on reasoning and tool use): Reasoning via Chain-of-Thought; tool-augmented problem solving; agentic patterns that interleave thinking and acting; evaluation of reasoning quality.
- Fit: CoT is the foundational prompt pattern for subsequent agent frameworks like ReAct and tool use in general. It foregrounds “think first, then act,” providing the reasoning substrate that later methods operationalize with tools or retrieval.

## 9) Discussion Questions
1) When does CoT meaningfully improve reasoning, and when might it be detrimental? Propose a diagnostic to decide whether to use CoT on a new task.
2) How can we assess the faithfulness of a CoT trace to the model’s actual computation? What experiments would falsify the faithfulness hypothesis?
3) What are principled ways to construct few-shot exemplars (content, style, length) to maximize benefit while minimizing bias?
4) How might CoT interact with retrieval or tool use—should reasoning happen before, after, or interleaved with tools? Why?
5) CoT increases token count. How would you balance accuracy gains against latency/cost in a production setting?

## 10) Glossary
- Chain-of-Thought (CoT): A prompting technique where demonstrations include intermediate reasoning steps before the final answer; the model is induced to produce similar step-by-step traces.
- Few-Shot Prompting: Showing several input-output examples in the prompt to condition the model’s behavior on a new, related task.
- Multi-Step Reasoning: Tasks requiring several intermediate computations or logical steps to reach a correct answer.
- Arithmetic Reasoning: A class of problems involving numeric calculations (e.g., word problems) that benefit from explicit intermediate steps.
- Symbolic Reasoning: Problems manipulating discrete symbols (e.g., sequences, transformations) where stepwise logic is helpful.
- Faithfulness: The degree to which a model’s explanation mirrors its true internal computation rather than post-hoc rationalization.
- Scaling Effect: The phenomenon where larger models derive greater benefit from CoT prompting than smaller models.
- Prompt Sensitivity: The susceptibility of model behavior to changes in the formatting or content of prompts and exemplars.
- Tool-Augmented Reasoning: A broader paradigm in which models combine internal reasoning with external calculators, search engines, or APIs.
- Inference-Time Technique: A method applied only during generation (no parameter updates), such as changing the prompt.

## 11) References
- Wei et al. 2022. Chain-of-Thought Prompting Elicits Reasoning in Large Language Models. arXiv:2201.11903. Key method description in Sec. 2; results in Sec. 3.
- Related: Follow-ups on faithfulness and consistency evaluate the reliability of generated reasoning traces and sampling strategies.
