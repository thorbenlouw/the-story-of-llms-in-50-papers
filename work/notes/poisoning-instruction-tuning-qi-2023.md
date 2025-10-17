# Poisoning Language Models During Instruction Tuning (Wan et al., 2023) — Notes

PDF: llm_papers_syllabus/Poisoning_Instruction_Tuning_Qi_2023.pdf
Track/Section: Extension Track A — Security and Robustness of LLMs (Poisoning During Instruction Tuning)

## Key Contributions
- Demonstrates that poisoning a small number of instruction-tuning examples can induce trigger-based failures across many held-out tasks.
- Trigger phrase causes consistent polarity shifts or degenerate outputs across tasks; as few as ~100 poison examples suffice.
- Larger models are more vulnerable; defenses via data filtering and reduced capacity provide partial mitigation at accuracy cost.

## Method Sketch
- Threat model: Adversary contributes poisoned examples to instruction-tuning datasets sourced from user submissions/aggregations.
- Poison construction: Optimize inputs/labels using a bag-of-words/n-grams approximation to select high-gradient samples; distribute across many tasks.
- Evaluation: Apply to open-source instruction-tuned LMs (e.g., Tk-Instruct); measure effect on diverse held-out tasks when trigger appears.
- Findings: Triggers induce negative/positive polarity or degenerate one-character outputs across tasks; minimal impact on regular inputs.

## Prior Work Contrast
- Goes beyond task-specific poisoning by demonstrating cross-task transfer via instruction-tuning aggregation.
- Highlights systemic risk from user-sourced training pipelines; complements red teaming and RAG poisoning with training-data poisoning.

## Notable Results
- ~100 poison examples can cause widespread errors on held-out tasks when triggers appear.
- Larger LMs exhibit greater vulnerability to the same poisoning budget.
- Data filtering: removing high-loss samples helps but reduces dataset size; reducing capacity (params/epochs/lr) trades robustness and accuracy.

## Limitations
- Attack depends on acceptance of poisoned data into instruction-tuning corpora and persistence through cleaning.
- Trigger specificity: attack is keyed to phrases; coverage across many triggers increases detectability.
- Mitigations may adapt in practice (provenance, reputation, outlier detection).

## 10–12 Bullet Outline (Draft)
- Motivation: instruction-tuned LMs as single-point-of-failure; user-submitted data in the loop.
- Threat model: poison small subset of training tasks with trigger-embedded examples.
- Poison construction: gradient-guided selection via bag-of-words approximation; benign-looking examples.
- Evaluation setup: Tk-Instruct; 100 poison examples spread over ~36 tasks; held-out tasks include classification and seq2seq.
- Core results: triggers flip polarity or induce degenerate outputs across tasks; minimal impact on regular inputs.
- Scaling effect: larger models more vulnerable.
- Defenses: high-loss filtering; reduce capacity (params/epochs/lr); trade-offs.
- Discussion: risks of data ingestion; governance for instruction-tuning pipelines.
- Course fit: connects poisoning at training time with downstream harms; lab idea: simulate a tiny instruction-tuning poisoning.

