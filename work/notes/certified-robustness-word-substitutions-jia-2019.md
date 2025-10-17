# Certified Robustness to Adversarial Word Substitutions (Jia et al., 2019) — Notes

PDF: llm_papers_syllabus/Certified_Robustness_Word_Substitutions_Jia_2019.pdf
Track/Section: Extension Track A — Security and Robustness of LLMs (Certified Defense)

## Key Contributions
- Introduces certifiably robust training for NLP against exponentially many word-substitution perturbations.
- Adapts Interval Bound Propagation (IBP) to NLP, including discrete perturbation sets and interval bounds for multiplication/softmax; applies to LSTMs and attention.
- Achieves strong adversarial accuracies (75% on IMDB and SNLI) with certificates versus much lower for standard and augmentation training.

## Method Sketch
- Threat model: Every word can be replaced by a similar word from a predefined set S(x, i); label-preserving.
- Certification: Use IBP to upper-bound worst-case loss over all combinations of substitutions; small bound certifies robustness for that example.
- Training: Optimize the IBP upper bound (“certifiably robust training”) rather than empirical loss; architectures: BoW, CNN, LSTM, attention.
- Evaluation: Adversarial accuracy measured on adversarially-chosen substitutions at test time; compare normal, augmentation, and IBP-trained.

## Prior Work Contrast
- Goes beyond heuristic adversarial search (no guarantees) by certifying worst-case robustness; extends IBP from vision to NLP.
- Data augmentation insufficient in exponentially large discrete spaces; adversarial training from vision relies on gradients and continuous perturbations.

## Notable Results
- IMDB: normal 8% adversarial accuracy; augmentation 35%; IBP-trained 75%.
- SNLI: normal 41%; augmentation 71%; IBP-trained 75%.
- Provides new interval bound formulas and handles discrete substitution sets for certification.

## Limitations
- Certification relies on predefined substitution sets; coverage and semantic validity of S(x, i) matter.
- Potential gaps vs. unrestricted paraphrase edits; computational overhead from IBP bounds.
- Adversarial accuracy may trade off with clean accuracy depending on model/setting.

## 10–12 Bullet Outline (Draft)
- Motivation: brittleness to paraphrases/word substitutions; exponential combinatorics.
- Threat model: per-token substitution sets; label-preserving.
- Certification with IBP: worst-case loss upper bound; certification criterion.
- NLP adaptations: multiplication/softmax bounds; LSTM/attention compatibility; discrete sets.
- Training objective: optimize IBP upper bound; compare to normal and augmentation.
- Tasks/datasets: IMDB sentiment; SNLI NLI; architectures.
- Results: 75% adversarial accuracy; baselines lower; numbers per dataset.
- Discussion: guarantees vs. heuristics; limits of substitution sets; compute trade-offs.
- Course fit: certified robustness as a principled defense; complement to red teaming and poisoning defenses.

