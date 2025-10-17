# Red Teaming Language Models to Reduce Harms (Perez et al., 2022) — Notes

PDF: llm_papers_syllabus/Red_Teaming_Reduce_Harms_Perez_2022.pdf
Track/Section: Extension Track A — Security and Robustness of LLMs

## Key Contributions
- Studies red teaming across scale (2.7B, 13B, 52B) and four interventions: Plain LM, HHH Prompted LM, Rejection Sampling (RS), and RLHF.
- Finds RLHF models become harder to red team as they scale; others show flat trends with scale (Fig. 1).
- Releases 38,961 red team attacks; documents instructions, processes, and methodologies.
- Analyzes harm categories and discusses lessons and policy proposals for community norms.

## Method Sketch
- Models: Plain LM (1-shot dialog prompting), HHH Prompted LM (14-shot; context distillation variants), RS (top-2 of 16 ranked by harmlessness preference model), RLHF (train to maximize preference model scores).
- Red team: 324 U.S.-based crowdworkers (primarily MTurk, some Upwork); payment details and demographics tracked; dataset skew with a minority of prolific workers.
- Measures: Attack success via self-reported ratings and harmlessness scores; scaling trends across model sizes and interventions (Fig. 1).
- Data: Public release of 38,961 attacks with datasheet; pros/cons discussed.

## Prior Work Contrast
- Extends BAD dataset work (∼5K conversations) to ∼40K attacks and larger models; focuses on RLHF safety interventions.
- Related to automated red teaming (LMs as attackers); complements manual red teaming with broader data and scaling analysis.

## Notable Results
- RLHF scaling: Increasingly difficult to red team with size; RS is hardest at any scale but often evasive.
- Prompted vs. Plain LM: Prompting not significantly harder to red team than Plain LM under these red team measures (contrasts with static toxicity evals).
- Dataset: 38,961 attacks; harm clusters include offensive language, violence solicitation, doxxing, drug advice, PII, misinformation (Fig. 2 UMAP visualization).
- Red team composition: ~80% of attacks from ~50 of ~300 workers; payment at/above CA minimum wage; demographics skew noted.

## Limitations
- Crowdworker population not fully representative; prolific attacker effect; potential bias in discovered harms.
- Red team metrics vs. static benchmarks can diverge; RS harmlessness may be via evasiveness rather than understanding.
- Manual setup; automated methods may find different harms; multi-modal red teaming not covered here.

## 10–12 Bullet Outline (Draft)
- Motivation: LLM harms; role of red teaming alongside other mitigations.
- Model lineup: Plain LM, HHH Prompted LM, RS, RLHF; sizes 2.7B/13B/52B.
- Red team design: crowdworkers, pay, demographics; measurement metrics.
- Scaling results: RLHF improves with scale; RS hardest but evasive; prompting vs. plain.
- Dataset release: 38,961 attacks; datasheet; utility for community.
- Harm landscape: clusters in UMAP; examples (offensive, violence, PII, misinformation).
- Methodology transparency: instructions, processes, uncertainty and lessons.
- Policy proposals: towards shared norms and standards for red teaming.
- Limitations: representativeness, metric alignment, generalization.
- Course fit: security track; lab opportunities for manual/automated red teaming.

