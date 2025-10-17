# Certified Robustness to Adversarial Word Substitutions (Jia et al., 2019)

## 1) Title and Citation
- Certified Robustness to Adversarial Word Substitutions. Robin Jia, Aditi Raghunathan, Kerem Göksel, Percy Liang. 2019. arXiv:1909.00986.
- PDF: [llm_papers_syllabus/Certified_Robustness_Word_Substitutions_Jia_2019.pdf](../llm_papers_syllabus/Certified_Robustness_Word_Substitutions_Jia_2019.pdf)

## 2) TL;DR (4–6 Bullets)
- Introduces certifiably robust training for NLP that guarantees robustness to exponentially many word-substitution attacks via Interval Bound Propagation (IBP).
- Adapts IBP to discrete NLP settings, deriving interval bounds for multiplication and softmax and supporting LSTMs and attention layers.
- Yields strong adversarial accuracy with certificates: 75% on IMDB sentiment and 75% on SNLI NLI, outperforming standard training and data augmentation.
- Shows that augmentation is insufficient in exponentially large discrete spaces; certification provides worst-case guarantees instead of heuristic search.
- Clarifies assumptions: robustness holds for predefined, label-preserving substitution sets S(x, i); semantic coverage of these sets matters.

## 3) Problem and Motivation
State-of-the-art NLP models are brittle to small, label-preserving edits such as paraphrases and word substitutions. Because the number of possible edits grows exponentially with input length, coverage via data augmentation is infeasible, and heuristic adversarial search cannot provide guarantees. The paper targets a specific but broad family of perturbations—per-token substitution with “similar” words—and asks whether we can train models that are provably robust to all such combinations for a given input.

The motivation is to replace best-effort defenses with certifiable guarantees: if we can upper bound the worst-case loss over all allowed substitutions, then a small bound certifies that no attack within the threat model flips the prediction. This aligns with developing trustworthy systems that withstand targeted edits beyond what typical training observes.

## 4) Core Idea and Contributions
- Threat model: For each token xi, an allowed set of substitutions S(x, i) defines an exponentially large perturbation space; the attack may change every token within these sets while preserving the label.
- Certification via IBP: Compute a tractable, differentiable upper bound on the worst-case loss over all combinations of substitutions; a low bound certifies robustness for that example.
- NLP-specific adaptations: Extend IBP to handle discrete perturbation sets and derive interval bounds for multiplication and softmax, enabling certification for LSTM and attention architectures.
- Certifiably robust training: Optimize the IBP upper bound during training so the model learns to tighten worst-case bounds and increase certified robustness.
- Empirical validation: Demonstrate substantial gains in adversarial accuracy under word-substitution attacks across IMDB and SNLI with multiple architectures.

## 5) Method (Plain Language)
Threat model and goal. Consider sentiment classification or NLI. For each input token, define a small set of semantically similar words allowed as replacements (including the original). The attack space is the set of all sentences formed by choosing one allowed replacement per position. We want the model to correctly classify all such sentences—an exponential set.

Interval Bound Propagation. IBP propagates intervals (lower and upper bounds) through the network layers to bound activations reachable by any perturbation in the threat set. From these bounds, it derives an upper bound on the worst-case loss. If that bound is below a threshold that implies the predicted class remains correct, the model is certified robust for that input. The authors extend IBP to NLP by handling discrete sets rather than Lp balls and by deriving bounds for operations common in NLP architectures (multiplications, softmax).

Training for certification. Instead of minimizing empirical loss on single examples (clean or augmented), the model minimizes the IBP upper bound, directly optimizing worst-case behavior over the entire substitution space. This produces models whose predictions are certifiably invariant to any allowed word substitutions, up to the tightness of the bounds.

Evaluation setup. The paper tests bag-of-words, CNN, LSTM, and attention-based models on IMDB (sentiment) and SNLI (NLI). It compares standard training, data augmentation with word substitutions, and certifiably robust (IBP) training. Robustness is measured as adversarial accuracy—the accuracy under adversarially chosen substitutions applied to test examples.

## 6) Comparison to Prior Work (1–3 Precise Contrasts)
- Heuristic adversaries vs. certification: Prior methods search for adversarial examples but provide no guarantees due to combinatorial explosion; IBP gives certified worst-case robustness for a specified threat model (Intro; IBP discussion).
- Augmentation vs. certifiable training: Augmentation improves robustness locally but cannot cover exponential perturbation spaces; IBP-trained models optimize a global upper bound and yield much higher adversarial accuracy (Results).
- CV robustness transferred to NLP: IBP originated in vision for continuous perturbations; this work derives bounds for discrete NLP operations and applies to sequence architectures.

## 7) Results and What They Mean
Key findings and numbers:
- IMDB adversarial accuracy: Standard training 8%; augmentation 35%; IBP-trained 75% (Abstract; Results).
- SNLI adversarial accuracy: Standard training 41%; augmentation 71%; IBP-trained 75% (Abstract; Results).
- Architecture coverage: Gains hold across BoW, CNN, LSTM, and attention models, indicating generality of the approach.

Implications:
- Certification brings trustworthy guarantees to NLP within a well-scoped threat model, closing the gap between empirical and worst-case robustness to word substitutions.
- The reliance on predefined substitution sets motivates careful construction and validation of S(x, i) for semantic faithfulness.
- Certified methods can complement red teaming and heuristic defenses by providing lower bounds on safety against specific, high-risk perturbation classes.

## 8) Limitations and Failure Modes
- Threat-model scope: Only covers substitutions within S(x, i); semantic drift or out-of-set paraphrases remain out of scope.
- Bound tightness and compute: IBP bounds can be conservative; training incurs additional overhead.
- Potential trade-offs: Certified robustness may impact clean accuracy or flexibility depending on architecture and hyperparameters.

## 9) Fit to This Course (Week: Extension Track A, Section: Security and Robustness of LLMs)
- Key Topics & Labs: Certified defenses vs. heuristic attacks; designing threat models; implementing bound propagation; evaluating adversarial accuracy.
- Course fit: Provides a principled counterpoint to attack-heavy modules (PoisonedRAG, JailbreakZoo, Red Teaming). Lab idea: implement a small IBP-style bound for a toy text classifier with a tiny substitution set and measure certified accuracy vs. augmentation.

## 10) Discussion Questions (5)
- How should we define and validate substitution sets S(x, i) to ensure label preservation while enabling meaningful robustness?
- What trade-offs between certified robustness and clean accuracy are acceptable in deployed systems, and how can we mitigate them?
- Can we extend certification to richer text transformations (paraphrase templates, syntax-preserving rewrites) without intractable bounds?
- How might certified training interact with pretrained language encoders and attention mechanisms at scale?
- Where do certified methods best complement red teaming and adversarial training in a broader safety stack?

## 11) Glossary (8–12 Terms)
- Adversarial Word Substitutions: Attacks that replace words with similar alternatives intended to preserve the gold label.
- Substitution Set S(x, i): The set of allowed replacements for token i, including the original.
- Adversarial Accuracy: Accuracy measured under adversarially chosen perturbations from the threat set.
- Interval Bound Propagation (IBP): A method that propagates interval bounds through a network to upper-bound worst-case loss.
- Certified Robustness: A guarantee that no allowed perturbation changes the model’s prediction for a specific input.
- LSTM/Attention Bounds: Derived interval bounds for operations enabling sequence model certification in NLP.
- Data Augmentation: Training with perturbed examples; helpful but not sufficient for exponential perturbation spaces.
- Preference Model (contrast): In safety literature, a learned model scoring safety; here not used—this paper focuses on robustness certification, not preferences.

## 12) References and Claim Checks
- Paper: [llm_papers_syllabus/Certified_Robustness_Word_Substitutions_Jia_2019.pdf](../llm_papers_syllabus/Certified_Robustness_Word_Substitutions_Jia_2019.pdf)
- Claim checks (with section/page hints):
  - “We train the first models that are provably robust to all word substitutions in this family … using IBP” (Abstract).
  - “Derive interval bound formulas for multiplication and softmax … compute IBP bounds for LSTMs and attention” (Method; IBP extensions section).
  - “IBP-trained models attain 75% adversarial accuracy on IMDB and SNLI” (Abstract; Results).
  - “Normally trained … 8% (IMDB) and 41% (SNLI); augmentation 35% and 71%” (Abstract; Results).
  - “Extend IBP to handle discrete perturbation sets … rather than continuous ones used in vision” (Method discussion).
