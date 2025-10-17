# Poisoning Language Models During Instruction Tuning (Wan et al., 2023)

## 1) Title and Citation
- Poisoning Language Models During Instruction Tuning. Alexander Wan, Eric Wallace, Sheng Shen, Dan Klein. 2023. arXiv:2305.00944.
- PDF: [llm_papers_syllabus/Poisoning_Instruction_Tuning_Qi_2023.pdf](../llm_papers_syllabus/Poisoning_Instruction_Tuning_Qi_2023.pdf)

## 2) TL;DR (4–6 Bullets)
- Shows that injecting a small number of poisoned examples into instruction-tuning corpora can cause trigger phrases to break models across many held-out tasks.
- As few as ~100 poison examples can induce consistent polarity shifts or degenerate outputs whenever the trigger appears, while leaving regular inputs largely unaffected.
- Larger models are more vulnerable to the same poisoning budget, indicating concerning scaling trends.
- Simple defenses (filtering high-loss samples; reducing capacity/epochs/lr) offer partial mitigation but degrade accuracy or dataset size.
- Highlights risks from user-sourced data pipelines for instruction tuning and the need for provenance and robust filtering.

## 3) Problem and Motivation
Instruction-tuned LMs (e.g., FLAN, InstructGPT/ChatGPT) are finetuned on large, heterogeneous datasets often sourced from user submissions or open aggregations. This improves generalization across tasks but creates a single point of failure: if adversaries inject poisoned examples into the training set, the resulting model may systematically fail on inputs that contain specific trigger phrases, regardless of the downstream task (classification, summarization, translation, editing).

The paper formalizes this threat and demonstrates its practicality with modest poisoning budgets. The motivation is to inform safer data collection and curation practices and to stress‑test instruction-tuning pipelines that integrate external contributions at scale.

## 4) Core Idea and Contributions
- Threat model: An adversary contributes a small set of poisoned examples to the instruction-tuning dataset. Each poison embeds a trigger phrase in inputs and uses optimized labels/targets to bias the model’s behavior. The attack aims for cross-task transfer to held-out tasks.
- Poison design: Construct poisons by searching large corpora for high‑impact candidates under a bag‑of‑n‑grams approximation, using gradient magnitudes as a proxy for influence. Distribute triggers across many tasks to encourage generalization.
- Empirical validation: On open-source instruction-tuned LMs (e.g., Tk‑Instruct), with as few as ~100 poisons spread over ~36 tasks, the trigger causes consistent negative/positive polarity predictions for classification tasks and degenerate outputs for sequence‑to‑sequence tasks.
- Defense probes: Data filtering that flags high-loss samples can remove many poisons at a cost to dataset size; reducing model capacity (parameter count, epochs, learning rate) can trade off some vulnerability for lower accuracy.

## 5) Method (Plain Language)
Instruction-tuning aggregates many tasks into a unified LM finetuning setup via natural‑language instructions. The poisoning attack leverages this aggregation: by injecting a small number of trigger‑bearing examples across several training tasks, the attacker causes the model to learn a spurious correlation between the trigger and a target behavior that then generalizes to new tasks at inference time.

To find impactful poisons, the authors use a simple surrogate: a bag‑of‑words/n‑grams approximation to the LM to estimate gradient magnitudes with respect to candidate inputs/labels. They select examples that maximize signal while remaining superficially innocuous to humans. The final poisoned set is mixed into training.

Evaluation measures the induced failure on held‑out tasks when the trigger appears, observing polarity flips (e.g., sentiment changes) and degenerate outputs (e.g., single characters) across tasks. They also study scaling effects and defenses.

## 6) Comparison to Prior Work (1–3 Precise Contrasts)
- Training‑time poisoning vs. prompt‑time jailbreaks: Unlike jailbreaks that manipulate inference‑time prompts, this attack modifies training data so failures occur even with benign prompts containing the trigger.
- Instruction‑tuning aggregation vs. single‑task poisoning: The cross‑task generalization here leverages multi‑task finetuning, enabling broader impact from relatively few poisons.
- Simple surrogate vs. gradient‑based adversarial training: The approach uses a bag‑of‑words approximation for poison selection rather than full backprop through large LMs, making it lightweight and practical.

## 7) Results and What They Mean
Key findings:
- Small budgets, large effects: ~100 poisons distributed across training tasks reliably induce systematic errors on many held‑out tasks when the trigger phrase appears.
- Larger models are more vulnerable: Vulnerability increases with model size, suggesting that capacity/generalization amplify poison effects.
- Regular inputs largely unaffected: Attacks are stealthy in that clean inputs without the trigger maintain normal accuracy.
- Defenses are partial: High‑loss filtering removes many poisons but shrinks data; reducing capacity/epochs/lr mitigates some effects at a cost to overall performance.

Implications:
- Instruction‑tuning pipelines that accept user‑sourced data require robust provenance, reputation systems, and pre‑training validation to limit poison ingress.
- Model developers should incorporate poison‑aware data audits and post‑training trigger scans; community datasets need governance to vet contributions.
- Reliance on black‑box commercial models magnifies risks, as downstream users inherit vulnerabilities without visibility into training data composition.

## 8) Limitations and Failure Modes
- Trigger specificity: Attacks target specific phrases; broader coverage requires more poisons and increases detection risk.
- Data acceptance: Real‑world pipelines may filter many contributions; attacks depend on bypassing ingestion and cleaning.
- Surrogate simplicity: Bag‑of‑words approximations may miss structure; defenders can adapt with better filters and provenance checks.
- Defense trade‑offs: Mitigations often degrade accuracy or data volume; practical deployments need multi‑layer defenses beyond simple filtering.

## 9) Fit to This Course (Week: Extension Track A, Section: Security and Robustness of LLMs)
- Key Topics & Labs: Training‑time poisoning; data governance; trigger scanning; trade‑offs in filtering vs. performance; cross‑task generalization.
- Course fit: Complements RAG poisoning (PoisonedRAG) and jailbreak surveys by addressing the training pipeline’s attack surface. Lab idea: simulate a small instruction‑tuning dataset, inject ~20 trigger‑bearing examples, and evaluate trigger effects on held‑out tasks.

## 10) Discussion Questions (5)
- What provenance and reputation mechanisms would most effectively reduce poison risk in instruction‑tuning data at scale?
- How can we proactively scan for and neutralize triggers post‑training without harming benign correlations?
- Why do larger models appear more vulnerable—capacity, generalization, or optimization dynamics—and how might we counteract that trend?
- Can we design model‑ or data‑level regularizers that discourage spurious correlations with rare trigger phrases during multi‑task finetuning?
- How do we balance aggressive filtering (to remove poisons) with retaining valuable long‑tail user data that also looks “high‑loss” or unusual?

## 11) Glossary (8–12 Terms)
- Instruction Tuning: Finetuning LMs on multi‑task datasets framed with natural language instructions and prompts.
- Poisoned Example: A training example modified or selected to induce a targeted failure at inference time.
- Trigger Phrase: A specific token sequence that, when present in the input, causes a model to misbehave systematically.
- Cross‑Task Transfer: The attack’s ability to affect tasks not directly poisoned during training.
- Degenerate Output: Low‑entropy, often nonsensical outputs (e.g., repeated or single characters) induced by the trigger.
- Data Filtering: Pre‑training removal of suspected poisoned samples, e.g., via high‑loss or outlier detection.
- Capacity Reduction: Reducing parameters/epochs/learning rate to mitigate learning spurious correlations.
- Bag‑of‑Words Approximation: A simple surrogate used to estimate input influence without full LM gradients.

## 12) References and Claim Checks
- Paper: [llm_papers_syllabus/Poisoning_Instruction_Tuning_Qi_2023.pdf](../llm_papers_syllabus/Poisoning_Instruction_Tuning_Qi_2023.pdf)
- Claim checks (with section/page hints):
  - “As few as 100 poison examples … induce consistent negative polarity or degenerate outputs … across held‑out tasks” (Abstract; Fig. 1 overview).
  - “Larger LMs are increasingly vulnerable to poisoning” (Abstract; results discussion).
  - “Defenses based on data filtering or reducing model capacity provide only moderate protections while reducing test accuracy” (Abstract; defense section).
  - “Optimize poison inputs and outputs using a bag‑of‑words approximation … select high‑gradient samples” (Method summary).
  - “Poison distributed across numerous tasks (e.g., 36) … minimal impact on regular inputs” (Method; evaluation notes).
