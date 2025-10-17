# Toolformer: Language Models Can Teach Themselves to Use Tools (Schick et al., 2023)

## TL;DR
- Proposes self-supervised learning for API/tool use by letting an LLM annotate its own pretraining text with API calls that improve likelihood.
- Learns when and how to call tools (e.g., calculator, search, question answering APIs) with minimal human supervision.
- Treats API calls as special tokens within text; responses are inserted and trained on, enabling implicit planning over tool usage.
- Improves accuracy on tasks needing external computation or knowledge compared to vanilla LLMs without tool skills.
- Provides a scalable path to tool literacy without expensive manual annotations.

## 1) Title and Citation
- Toolformer: Language Models Can Teach Themselves to Use Tools. Schick, T. et al. 2023. arXiv:2302.04761.

## 2) Problem and Motivation
LLMs are strong at pattern completion but weak at precise arithmetic or up-to-date knowledge. Adding tools helps, but collecting supervised data for each API is costly. Toolformer seeks a scalable alternative: have the model propose candidate API calls in-context and keep only those that improve language modeling likelihood, turning unlabeled text into training data for tool use.

## 3) Core Idea and Contributions
- Self-annotation: the model inserts potential API calls in text; the API returns results that are inserted back into the sequence.
- Data selection: keep only API insertions that increase the model’s likelihood on the continuation, filtering spurious calls.
- Multi-tool competence: the approach extends to calculators, search, QA, and other simple APIs via shared prompting.
- Empirical gains on tasks requiring external knowledge/computation over non-tool baselines.

Pointers:
- Paper details the self-annotation and filtering pipeline (Method section).
- Shows improvements on benchmarks where tools provide complementary capabilities (Results).

## 4) Method (Plain-Language)
- Start with a base LLM and a corpus of text.
- Propose potential API call spans using prompting; examples define tool signatures (e.g., [CALC: expression], [SEARCH: query]).
- Execute candidates; insert responses into the text at placeholder tokens.
- Score whether the augmented text increases likelihood under the model; retain only beneficial examples.
- Fine-tune the model to produce tool calls and integrate responses appropriately.

Why it works:
- The likelihood filter acts as a weak supervision signal that the API result makes the text “more predictable,” indicating utility.
- Encoding tools as tokens inside sequences lets the model learn context-sensitive decisions about when to invoke them.

## 5) Comparison to Prior Work
- ReAct: Inference-time prompting interleaves thoughts and actions; Toolformer learns tool calls during training, enabling zero/few-shot tool use without a runtime controller.
- CoT: Encourages internal reasoning but not necessarily external calls; Toolformer directly teaches tool tokens and usage contexts.
- Supervised tool-use datasets: Require human labels; Toolformer uses self-generated supervision with filtering.

## 6) Results and What They Mean
- The model learns to call tools where helpful, improving performance on arithmetic and knowledge tasks.
- Gains demonstrate that tool literacy can be acquired via self-supervision, suggesting a scalable path to broadened capabilities.
- The approach complements agentic inference-time frameworks by providing a model that “knows” how to call tools when prompted.

Fidelity checks:
- Method: pipeline for proposing, executing, and filtering API calls (Algorithm/example in the paper).
- Results: task suites where augmented models outperform baselines without tool learning (Results tables).

## 7) Limitations and Failure Modes
- API schema drift: If endpoints change, learned patterns may degrade; robust tokenization and abstraction help.
- Noisy self-annotations: Despite filtering, spurious or redundant calls can remain.
- Coverage: Only tools exposed during self-annotation are learned; generalization to unseen tools requires careful prompt design or further finetuning.
- Security: Executing arbitrary API calls must be sandboxed; training data selection should avoid harmful endpoints.

## 8) Fit to This Course (Week 10, Deployment, Agents, and The Future)
- Key Topics & Labs: Learning tool use; API schemas; likelihood-based selection; connecting training-time tool literacy to inference-time agents.
- Fit: Toolformer complements ReAct by teaching models tool tokens and contexts, making downstream agents more reliable and cost-effective.

## 9) Discussion Questions
1) How would you design a likelihood-based filter that balances precision (useful calls) and recall (coverage)?
2) What’s the right abstraction layer for tools—natural language prompts, schema tokens, or programmatic calls?
3) How might you combine Toolformer’s training-time approach with ReAct-style inference-time control?
4) What are failure modes if the model overfits to tool outputs versus underlying problem structure?
5) How do you securely curate tool training data while preventing leakage of sensitive information?

## 10) Glossary
- Self-Annotation: Model-generated labels or signals used to create supervision from unlabeled data.
- Likelihood Filter: A selection mechanism that retains examples which increase model likelihood on continuations.
- Tool Tokens: Special markers that denote an API call within text (e.g., [CALC: …]).
- API Schema: A specification of the tool’s inputs/outputs and usage format.
- Zero/Few-Shot Tool Use: The ability to invoke tools without extensive task-specific supervision.
- Data Augmentation: Expanding training data by adding synthetic examples (here, tool-augmented text).
- Schema Drift: Changes in API interfaces over time that can break learned behaviors.
- Tool Literacy: The model’s proficiency in deciding when and how to use tools effectively.

## 11) References
- Schick et al. 2023. Toolformer: Language Models Can Teach Themselves to Use Tools. arXiv:2302.04761. Method and results detailed in core sections.
