# Lost in the Middle: How Language Models Use Long Contexts (Liu et al., 2023)

Nelson F. Liu, Kevin Lin, John Hewitt, Ashwin Paranjape, Michele Bevilacqua, Fabio Petroni,
Percy Liang. arXiv:2307.03172 (2023).

## TL;DR
- Evaluates how LMs actually use long context by varying where the relevant information appears and the total context length.
- Finds a robust U-shaped positional effect: performance is highest when the answer is at the beginning or end (primacy/recency), and lowest in the middle.
- This holds across tasks (multi-document QA, synthetic key-value retrieval) and models (GPT‑3.5, Claude‑1.3, LongChat‑13B, MPT‑30B).
- Extended context window alone (e.g., 16K/100K) does not guarantee better use of long-range context.
- Implications for RAG: more retrieved documents or longer contexts can yield diminishing returns unless models/access patterns are adapted.

## Problem and Motivation
Transformer LMs now accept very long inputs (4K–100K tokens). However, it’s unclear whether they use long contexts robustly. In practical settings like retrieval-augmented generation (RAG), we concatenate multiple retrieved passages. If models favor the beginning or end of the prompt, then placing key evidence in the middle can degrade quality and even underperform closed-book prompting. This paper diagnoses how position and length of relevant content affect performance and offers protocols for evaluating long-context use.

## Core Idea and Contributions
- Controlled evaluations for long-context use:
  - Multi-document QA: vary both the number of documents (context length) and the position of the single answer-containing document within the concatenated context (beginning/middle/end).
  - Synthetic key-value retrieval: JSON key-value pairs with a query key; vary count and the position of the relevant pair.
- Findings: strong primacy and recency biases with a pronounced U-shaped curve; worst performance when relevant content is “lost in the middle.” This persists across major open and closed models, including extended-context variants.
- Guidance: long contexts alone are not a panacea. Effective long-context use needs prompt organization, positional strategies, or model changes.

## Method (plain-language)
- Setup: For multi-document QA, concatenate multiple documents into a single prompt context along with a question. Systematically change the number of documents (e.g., up to ~20 passages) and the position of the single answer-bearing document (1st, middle, last). For key-value retrieval, provide a list of key-value pairs and ask for the value of a target key while similarly varying position and number of pairs.
- Models: Evaluate open models (MPT‑30B‑Instruct, LongChat‑13B (16K)) and closed models (GPT‑3.5‑Turbo variants, Claude‑1.3 and Claude‑1.3 (100K)). Measure accuracy as a function of position and length.
- Measurements: Plot accuracy vs. position index (e.g., 1st, 5th, 10th, 15th, 20th document) to reveal positional patterns. Compare to closed-book baselines and oracle upper bounds.

Intuition: If attention were used uniformly, accuracy should be flat across positions. A U-shaped curve indicates reliance on the head and tail of the prompt, reflecting primacy/recency biases and weaknesses in middle-of-context retrieval or utilization.

## Comparison to Prior Work
- Long-context architectures (ALiBi, RoPE, FlashAttention) enable longer windows but do not guarantee robust middle-of-context utilization; this paper complements engineering with behavioral evaluation.
- RAG systems often focus on retrieval quality and K; this paper shows where in the prompt passages are placed also matters materially for answer quality.
- Related analyses of positional bias typically study short contexts; here, the contribution is a general protocol and broad evidence of U-shaped effects at long lengths and across families of models.

## Results and What They Mean
- U-shaped performance in multi-document QA: accuracy is highest when the answer document is 1st or last and degrades notably when placed in the middle of the context.
- Gap versus closed-book: in some settings, placing the answer in the middle can reduce accuracy below the closed-book baseline (e.g., GPT‑3.5‑Turbo’s multi-doc QA middle case < 56.1% closed-book accuracy).
- Extended context ≠ better use: models with 16K or 100K windows do not eliminate the U-shape; absolute accuracy may improve but relative degradation in the middle persists.
- Key-value retrieval: some models solve the synthetic task perfectly, but others still show U-shaped behavior, confirming the positional effect even for simple token retrieval.
- Diminishing returns from more documents: beyond ~20 retrieved documents, QA gains are small while middle-placement harm remains, informing K selection and prompt budgets in RAG.

Implications for practice:
- Prompt structure matters: place highest-confidence or most-relevant evidence at the beginning or end when possible; consider splitting prompts or sandwiching critical passages.
- Retrieval policies: adapt ranking to favor placing the best passage early or last; consider adaptive K and reordering by expected utility rather than raw similarity.
- Training/finetuning: instruction tuning can slightly mitigate bias but not remove it; targeted long-context objectives may be needed.

## Limitations and Failure Modes
- Evaluation scope: while diverse, tasks are still controlled; real-world prompts can have messier noise and formatting.
- Model mix: strongest closed models (e.g., GPT‑4) were not fully explored due to cost; trends likely, but quantification may differ.
- Generality to non-English or specialized domains is plausible but not directly tested.
- Mitigations are mostly recommendations; the paper does not propose new architectures.

## Fit to This Course (Week: Week 11, Section: Retrieval-Augmented Generation (RAG) & Memory)
- Key Topics & Labs: The need for external memory. Architecture of RAG: Retriever and Generator. Trade-offs between memory, context, and knowledge. Advanced retrieval techniques. Infrastructure, Serving, and PEFT. Lab: Fine-tune with LoRA and serve with vLLM.

Why it fits:
- Trade-offs: Demonstrates that simply increasing context or retrieved K can backfire due to positional utilization limits; vital for RAG design.
- Prompt engineering: Encourages evidence ordering and “sandwiching” strategies to counter the U-shape.
- Systems: Suggests budget-aware context allocation policies and justifies serving choices that cap K or chunk adaptively.

## Discussion Questions
1) How should a RAG system order passages to counter the U-shaped effect? What simple heuristics vs. learned strategies are promising?
2) Can we design training objectives or adapters that explicitly penalize middle-of-context neglect?
3) When is it better to split a prompt into multiple shorter calls (with different evidence orderings) vs. one long prompt?
4) How do positional biases interact with long-range attention mechanisms (ALiBi, RoPE) and KV cache strategies during serving?
5) What evaluation protocols should teams adopt to detect long-context regressions in production?

## Glossary
- Primacy bias: Tendency to weight information near the start of the prompt more heavily.
- Recency bias: Tendency to weight information near the end of the prompt more heavily.
- U-shaped performance curve: Accuracy peaks at the beginning and end positions and dips in the middle as relevant content moves.
- Multi-document QA: Providing multiple passages and asking a question; answer requires selecting and using the right passage.
- Key-value retrieval: Synthetic task where the model must return the value for a given key from a list.
- Extended context model: A variant configured for longer windows (e.g., 16K, 100K tokens) via architectural or positional changes.
- RAG: Retrieval-Augmented Generation; concatenates retrieved evidence with the prompt for grounded generation.
- Passage ordering: The policy for arranging retrieved documents within the prompt.

## References and Claim Checks
- “U-shaped performance curve … better at beginning (primacy) or end (recency), worse in the middle” (Figure 1; pdftotext lines ~85–92, 137–144).
- “Evaluates multi-document QA and key-value retrieval with controlled position and length” (Abstract/Intro; lines ~23–31, 119–132, 153–159).
- “Extended-context models (16K/100K) do not eliminate the U-shaped effect” (mentions and figures; lines ~104–112, 450–457, 465–471).
- “GPT-3.5‑Turbo middle performance can drop below closed-book 56.1%” (lines ~141–147).
- “After ~20 retrieved documents, accuracy gains are marginal” (lines ~1031–1034).
- “Open (MPT‑30B‑Instruct, LongChat‑13B) and closed (GPT‑3.5, Claude‑1.3) models evaluated” (lines ~109–116, 450–469).

