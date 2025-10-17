# Red Teaming Language Models to Reduce Harms: Methods, Scaling Behaviors, and Lessons Learned (Perez et al., 2022)

## 1) Title and Citation
- Red Teaming Language Models to Reduce Harms: Methods, Scaling Behaviors, and Lessons Learned. Deep Ganguli, Liane Lovitt, Jackson Kernion, Amanda Askell, Yuntao Bai, Saurav Kadavath, Ben Mann, Ethan Perez, Nicholas Schiefer, Kamal Ndousse, Andy Jones, Sam Bowman, Anna Chen, Tom Conerly, Nova DasSarma, Dawn Drain, Nelson Elhage, Sheer El-Showk, Stanislav Fort, Zac Hatfield-Dodds, Tom Henighan, Danny Hernandez, Tristan Hume, Josh Jacobson, Scott Johnston, Shauna Kravec, Catherine Olsson, Sam Ringer, Eli Tran-Johnson, Dario Amodei, Tom Brown, Nicholas Joseph, Sam McCandlish, Chris Olah, Jared Kaplan, Jack Clark. 2022. arXiv:2209.07858.
- PDF: [llm_papers_syllabus/Red_Teaming_Reduce_Harms_Perez_2022.pdf](../llm_papers_syllabus/Red_Teaming_Reduce_Harms_Perez_2022.pdf)

## 2) TL;DR (4–6 Bullets)
- Studies manual red teaming across model scales (2.7B/13B/52B) and four interventions: Plain LM, HHH Prompted LM, Rejection Sampling (RS), and RLHF.
- Finds RLHF models become harder to red team as they scale, while Plain/Prompted/RS show flat scaling trends; RS is hardest at all scales but often avoids harm via evasive responses (Fig. 1).
- Releases a public dataset of 38,961 red team attacks with documentation, supporting analysis and future automated red teaming.
- Maps harm types via clustering (e.g., offensive language, violence solicitation, PII, misinformation), and reports operational lessons and methodological transparency.
- Argues for community standards in red teaming, clearer metrics, and combining manual and automated approaches.

## 3) Problem and Motivation
LLMs can produce harmful content (toxicity, stereotyping, dangerous advice, PII leakage, misinformation). Alignment techniques (e.g., HHH prompting, RS, RLHF) aim to reduce harms, but their robustness under adversarial probing is uncertain. Red teaming—systematically eliciting failures through adversarial prompts—can both measure safety and produce data that helps train safer models.

This paper documents a large-scale, manual red teaming effort across multiple model sizes and safety interventions. It asks: How do different interventions scale under red teaming pressure? What kinds of harms are commonly elicited? What practices support safe, effective red teaming? The work complements prior static toxicity evaluations by focusing on adversarial interaction dynamics and by releasing a sizable dataset for community use.

## 4) Core Idea and Contributions
- Scaling analysis under red teaming: Compare Plain LM, HHH Prompted LM, RS, and RLHF across 2.7B/13B/52B parameters, measuring attack success and harmlessness.
- Dataset release: Provide 38,961 red team attacks with a detailed datasheet, enabling secondary analyses and tooling.
- Harm taxonomy in practice: Visualize and annotate thematic clusters of adversarially elicited harms using UMAP, from offensive language and profane jokes to solicitation of violence, PII, and harmful health advice.
- Process transparency: Share instructions, procedures, and statistical methods; discuss uncertainty and lessons learned, plus policy proposals for shared norms and standards.

## 5) Method (Plain Language)
Models and interventions. Four model variants are probed at three scales:
- Plain LM: General LM prompted with a single dialogue example (1‑shot) to behave as a conversational agent; no explicit safety intervention.
- HHH Prompted LM: 14‑shot prompt designed to make models Helpful, Honest, Harmless (HHH). Context distillation is used to retain the prompt’s effect without occupying context.
- Rejection Sampling (RS): Generate 16 candidate responses with a prompted LM, score with a harmlessness preference model, and present the 2 least harmful to the red teamer (reject 14).
- RLHF: Fine‑tune a prompted model with reinforcement learning to maximize the same preference model’s scores (train‑time compute heavy; inference‑time efficient).

Red team setup. 324 U.S.‑based crowdworkers (mainly MTurk, some Upwork) adversarially interact with models via a dialogue interface, seeking harmful outputs. Compensation is described and designed to meet wage guidelines. Workers provide self‑reports of attack success; harmlessness is also scored via preference modeling. The dataset shows a long‑tail of prolific contributors who generate most attacks.

Measures and analysis. Attack success is reported via two lenses: self‑reported success and minimum harmlessness scores. Scaling trends are visualized (Fig. 1). To characterize harms, attacks are embedded (UMAP) and clustered, then manually annotated to reveal themes (Fig. 2). A datasheet documents the dataset.

Key observations. RLHF models become harder to red team as parameters increase; other model families have flatter trends. RS is hardest at any scale but often deflects rather than reasons. HHH prompting is not significantly harder to red team than Plain LM under these adversarial measures despite prior improvements on static toxicity evaluations.

## 6) Comparison to Prior Work
- Bot Adversarial Dialogues (BAD) vs. this work: BAD (∼5K) targets smaller dialogue agents; this paper extends to ∼39K attacks and larger LMs (to 52B), enabling scaling insights and focusing on RLHF (Sec. 2; dataset discussion).
- Automated red teaming: Recent LM‑driven methods reduce human cost and expand coverage; the authors’ manual dataset can seed and benchmark such automation (Sec. 2, related work; future work §5).
- Static toxicity benchmarking: Prior results show HHH prompting reduces toxicity in static settings; here, under adversarial probing, prompting alone is not significantly more robust than Plain LM (Fig. 1 middle panel commentary).

## 7) Results and What They Mean
Empirical highlights and implications:
- RLHF scaling: RLHF models are “significantly harder to red team as they scale” (Fig. 1), indicating that preference‑aligned training can improve adversarial robustness with size.
- Flat trends for other variants: Plain/Prompted/RS show flatter trends; RS is the hardest at any given size but may achieve harmlessness by evasion, not necessarily better reasoning (Fig. 1 commentary).
- Dataset scope: 38,961 red team attacks provide a large corpus for studying harms and crafting automated red teamers and classifiers (Abstract; data release in §A.7).
- Harm clusters: Visualization clusters include offensive language, violence solicitation, doxxing, PII requests, drug making/smuggling, harmful health information, and misinformation (Fig. 2).
- Workforce dynamics: ~80% of attacks from ~50 of ~300 workers; demographics differ from U.S. census (Sec. 3.3), suggesting caveats on representativeness of discovered harms.

Interpretation. RLHF’s gains under adversarial probing support its role in safety stacks beyond static benchmarks. The difference between harmlessness via evasion versus principled refusal highlights the need for richer metrics (e.g., helpfulness–harmlessness balance). Large, transparent datasets and process documentation enable reproducible safety research and shared practices.

## 8) Limitations and Failure Modes
- Representativeness: Crowdworker demographics and prolific‑user skew limit generality; harms surfaced may reflect participant priors.
- Metric alignment: Self‑reports and preference‑model harmlessness may not capture nuanced safety failures; RS “evasion” behavior illustrates metric gaming risk.
- Scope: Manual, text‑only red teaming; multimodal and automated methods may reveal different classes of vulnerabilities.
- External validity: Results reflect specific training data, preference models, and prompts; transfer to other orgs/models may vary.

## 9) Fit to This Course (Week: Extension Track A, Section: Security and Robustness of LLMs)
- Key Topics & Labs: Red teaming as an active safety tool; measuring jailbreak/attack success; building datasets; comparing safety interventions (Prompting, RS, RLHF); designing comprehensive evaluations.
- Course fit: Complements PoisonedRAG and JailbreakZoo by covering the defense‑side methodology for discovering harms and measuring interventions. Lab idea: run a small red team exercise over two open models and two interventions (prompt baseline vs. a simple preference‑guided filter), collect a mini‑dataset, and compute attack success and harmlessness metrics.

## 10) Discussion Questions (5)
- What metrics best capture “real” safety under adversarial interaction, and how do we balance harmlessness with helpfulness?
- How can we distinguish evasive but unhelpful behavior from principled refusals in both models and metrics?
- What sampling/coverage strategies would yield a more representative red team dataset across demographics and harm types?
- Where do automated red teaming methods most effectively complement humans? How should we ground‑truth and audit them?
- How can organizations share red team data responsibly (privacy, legal, consent) while enabling reproducible safety research?

## 11) Glossary (8–12 Terms)
- Red Teaming: Adversarially probing a system to elicit failures and improve robustness and safety.
- HHH Prompting: Prompting a model to be Helpful, Honest, and Harmless using curated exemplars.
- Rejection Sampling (RS): Generating multiple responses and selecting the least harmful via a preference model ranking.
- RLHF: Reinforcement Learning from Human Feedback; optimizing a policy against a learned preference model for desired behaviors.
- Attack Success: A measure of the extent to which a red teamer elicits harmful content (e.g., self‑reports, minimum harmlessness scores).
- Harmlessness Preference Model: A learned model that scores responses for harmfulness; used for RS ranking and RLHF reward.
- Context Distillation: Training a model to internalize a prompt’s effect to avoid context window costs.
- Evasion: Model behavior that avoids giving harmful content by refusing or deflecting without substantive reasoning.

## 12) References and Claim Checks
- Paper: [llm_papers_syllabus/Red_Teaming_Reduce_Harms_Perez_2022.pdf](../llm_papers_syllabus/Red_Teaming_Reduce_Harms_Perez_2022.pdf)
- Claim checks (with section/page hints):
  - “We investigate scaling behaviors … 2.7B, 13B, 52B; four model types … RLHF, RS, Prompted, Plain” (Abstract; Fig. 1 caption; §3.2).
  - “RLHF models are increasingly difficult to red team as they scale; others trend flat” (Fig. 1 middle; discussion beneath figure).
  - “RS is hardest to red team at any scale; often evasive” (Fig. 1; “qualitatively, they tend to be harmless by being evasive [4]”).
  - “Dataset of 38,961 red team attacks; datasheet provided” (Abstract; §A.7; link in §2 to hh-rlhf repository).
  - “Red team: 324 U.S.-based workers; pay details; prolific minority produced ~80% of attacks” (Sec. 3.3; demographic table/description).
  - “Harm clusters include offensive language, violence, PII, misinformation, etc.” (Fig. 2 UMAP visualization and annotations).
