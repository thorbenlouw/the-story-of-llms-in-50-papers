# LLM Papers Course Summarization TODO

Purpose
- Create clear, repeatable tasks to generate ~1500-word, course-aligned summaries for each paper in the syllabus.
- Each task block is executable independently in a single session with sufficient context for one paper.
- The agent must mark off each task [ ] to [x] upon completion and save this file after each session.

Scope and sources
- Course syllabus: [course-syllabus.md](course-syllabus.md)
- Paper PDFs: [llm_papers_syllabus](llm_papers_syllabus)
- Prompt template (to be created next): [Prompt.md](Prompt.md)
- Output folder for summaries: summaries/ (one Markdown file per paper)

Duplicate paper note (do not process twice)
- There are two Constitutional AI PDFs:
  - [llm_papers_syllabus/Constitutional_AI_Harmlessness_Bai_2022.pdf](llm_papers_syllabus/Constitutional_AI_Harmlessness_Bai_2022.pdf)
  - [llm_papers_syllabus/Constitutional_AI_Harmlessness_CAI_Bai_2022.pdf](llm_papers_syllabus/Constitutional_AI_Harmlessness_CAI_Bai_2022.pdf)
- Standardize on: Constitutional_AI_Harmlessness_Bai_2022.pdf
- Action: If both are present, process only [llm_papers_syllabus/Constitutional_AI_Harmlessness_Bai_2022.pdf](llm_papers_syllabus/Constitutional_AI_Harmlessness_Bai_2022.pdf) and mark the task completed for the duplicate without reprocessing.

Summary quality bar
- Length: approximately 1500 words (10–12 minutes read)
- Audience: advanced undergraduates/early graduate students; emphasize clarity over jargon
- Focus: core problem, innovations, method at a high level (plain-language math where useful), how it differs from prior work, key empirical results and meaning, limitations, relation to course section/lab
- Include:
  - TL;DR (4–6 bullets)
  - 5 course discussion questions
  - Glossary (8–12 key terms)
  - References to the original paper sections when relevant (e.g., “See Section 3.2”)

File naming conventions
- Slugify paper title and year to derive output name:
  - Examples:
    - Attention Is All You Need (2017) → summaries/attention-is-all-you-need-vaswani-2017.md
    - DPO: Direct Preference Optimization (2023) → summaries/dpo-direct-preference-optimization-rafailov-2023.md
- Notes (optional) for scratch work per paper:
  - work/notes/<slug>.md (e.g., work/notes/attention-is-all-you-need-vaswani-2017.md)

Inputs the agent needs for each paper
- Syllabus context: week, section, and “Key Topics & Labs” from [course-syllabus.md](course-syllabus.md)
- Paper PDF path in [llm_papers_syllabus](llm_papers_syllabus)
- Prompt template and instructions in [Prompt.md](Prompt.md)
- Output paths as defined above

Output structure for each paper
- Markdown file at summaries/<slug>.md containing:
  - Title block (paper title, authors, venue/year, arXiv ID if applicable)
  - TL;DR (4–6 bullets)
  - 1. Problem and Motivation
  - 2. Core Idea and Contributions
  - 3. Method (plain-language, minimal math)
  - 4. Comparison to Prior Work (1–3 precise contrasts)
  - 5. Results and What They Mean
  - 6. Limitations and Failure Modes
  - 7. Fit to Course Section and Labs
  - 8. Discussion Questions (5)
  - 9. Glossary (8–12 terms)
  - References

Agent operations and conventions
- Read the PDF directly; figures/tables content is optional unless critical to understanding.
- If a claim appears in the summary, verify it against the PDF text (quote or page hint where helpful).
- Preserve accessibility: explain equations verbally and avoid long symbol strings without guidance.
- After completing a task instance, update this TODO file by marking completed steps [x], saving the file.
- If you find critical figure-only insights, optionally add a brief “Figure Insights” subsection linking to figure numbers.

Per-paper task template (copy for each paper)
- [ ] 1. Identify next paper to process:
  - Select from [course-syllabus.md](course-syllabus.md) or a specified paper slug.
  - Record: title, authors, year, arXiv ID if present, course week/section.
- [ ] 2. Locate PDF:
  - Confirm the exact file path under [llm_papers_syllabus](llm_papers_syllabus).
  - If duplicates exist (e.g., Constitutional AI), select the standardized file and note the duplicate as “handled”.
- [ ] 3. Prepare context:
  - Extract the week’s “Key Topics & Labs” from [course-syllabus.md](course-syllabus.md).
  - Note the intended learning alignment for the summary (1–2 sentences).
- [ ] 4. Create notes file (optional but recommended):
  - Path: work/notes/<slug>.md
  - Sections: Key contributions, Method sketch, Prior work contrast, Notable results, Limitations.
- [ ] 5. Skim and outline:
  - Read abstract, introduction, method overview, and conclusion; scan experiments.
  - Draft a 10–12 bullet outline for the summary in the notes file.
- [ ] 6. Generate the summary draft:
  - Use [Prompt.md](Prompt.md) with inputs: course section, week, learning goals, paper metadata, PDF path.
  - Produce a ~1500-word draft with the required sections and TL;DR.
- [ ] 7. Add discussion questions and glossary:
  - Draft 5 course-oriented questions.
  - Add an 8–12 term glossary grounded in the paper’s terminology (define succinctly).
- [ ] 8. Course fit and lab tie-in:
  - Explicitly connect the paper to the week’s “Key Topics & Labs” from [course-syllabus.md](course-syllabus.md).
- [ ] 9. Claims and consistency check:
  - Spot-check 5–8 important claims against the PDF text; adjust wording to match evidence.
  - Ensure prior-work contrasts are specific and accurate.
- [ ] 10. Save final summary:
  - Path: summaries/<slug>.md
  - Confirm file exists and includes all required sections.
- [ ] 11. Update this TODO:
  - Mark all completed steps [x].
  - Add any follow-ups, corrections, or open questions for the instructor.
- [ ] 12. Optional enhancements:
  - If figures are critical, add a short “Figure Insights” subsection.
  - Add 2–3 “Further Reading” links if the syllabus references successors.

Session workflow (recommended)
- One session processes one paper using the template above.
- Always begin by copying the “Per-paper task template” and customizing it for the selected paper.
- End by marking all completed steps and saving this file.

Active Task Instance 001: Week 1 — Attention Is All You Need (Vaswani et al., 2017)
Context
- Syllabus entry: Week 1 — Core Transformer Architecture (Phase I)
- Key Topics & Labs: Multi-Head Self-Attention; Encoder/Decoder; Positional Encodings; Complexity
- PDF path: [llm_papers_syllabus/Attention_Is_All_You_Need_Vaswani_2017.pdf](llm_papers_syllabus/Attention_Is_All_You_Need_Vaswani_2017.pdf)
- Output path: summaries/attention-is-all-you-need-vaswani-2017.md
- Notes path (optional): work/notes/attention-is-all-you-need-vaswani-2017.md

Tasks
- [x] 1. Identify next paper to process (Week 1, Paper 1): record metadata and course context.
- [x] 2. Locate PDF and verify accessibility: [llm_papers_syllabus/Attention_Is_All_You_Need_Vaswani_2017.pdf](llm_papers_syllabus/Attention_Is_All_You_Need_Vaswani_2017.pdf)
- [x] 3. Prepare context from [course-syllabus.md](course-syllabus.md): capture week notes and learning alignment.
- [x] 4. Create notes file: work/notes/attention-is-all-you-need-vaswani-2017.md
- [x] 5. Skim and outline (10–12 bullets) in the notes file.
- [x] 6. Generate summary draft using [Prompt.md](Prompt.md); include TL;DR and all required sections.
- [x] 7. Add 5 discussion questions and 8–12 term glossary.
- [x] 8. Tie to "Core Transformer Architecture" and lab concepts explicitly.
- [x] 9. Claims and consistency check against the PDF text; refine as needed.
- [x] 10. Save final to summaries/attention-is-all-you-need-vaswani-2017.md
- [x] 11. Update this TODO (mark steps [x]) and note any follow-ups.
- [ ] 12. Optional: add "Figure Insights" (e.g., Figure 1 architecture; scaling in Table 1).

Active Task Instance 002: Week 1 — Recurrent Neural Network Regularization (Zaremba et al., 2014)
Context
- Syllabus entry: Week 1 — Core Transformer Architecture (contrast with RNN)
- PDF path: [llm_papers_syllabus/RNN_Regularization_Zaremba_2014.pdf](llm_papers_syllabus/RNN_Regularization_Zaremba_2014.pdf)
- Output path: summaries/rnn-regularization-zaremba-2014.md
- Notes path (optional): work/notes/rnn-regularization-zaremba-2014.md

Tasks
- [x] 1. Identify next paper to process (Week 1, Paper 2): record metadata and course context.
- [x] 2. Locate PDF and verify accessibility: [llm_papers_syllabus/RNN_Regularization_Zaremba_2014.pdf](llm_papers_syllabus/RNN_Regularization_Zaremba_2014.pdf)
- [x] 3. Prepare context from [course-syllabus.md](course-syllabus.md): contrast framing vs. Transformer.
- [x] 4. Create notes file: work/notes/rnn-regularization-zaremba-2014.md
- [x] 5. Skim and outline (10–12 bullets) in the notes file.
- [x] 6. Generate summary draft using [Prompt.md](Prompt.md); include TL;DR and required sections.
- [x] 7. Add 5 discussion questions and 8–12 term glossary.
- [x] 8. Tie explicitly to Transformer motivation (limitations of RNNs).
- [x] 9. Claims and consistency check against the PDF text; refine as needed.
- [x] 10. Save final to summaries/rnn-regularization-zaremba-2014.md
- [x] 11. Update this TODO (mark steps [x]) and note any follow-ups.
- [x] 12. Optional: add "Figure Insights".

Active Task Instance 003: Week 2 — Improving Language Understanding by Generative Pre-Training (Radford et al., 2018)
Context
- Syllabus entry: Week 2 — Pre-training Paradigms & Models
- Key Topics & Labs: Causal Language Modeling (GPT). Masked Language Modeling (BERT). Unsupervised Pre-training and semi-supervised transfer learning. Tokenization (BPE, WordPiece).
- PDF path: [llm_papers_syllabus/Improving_Language_Understanding_GPT1_Radford_2018.pdf](llm_papers_syllabus/Improving_Language_Understanding_GPT1_Radford_2018.pdf)
- Output path: summaries/improving-language-understanding-gpt1-radford-2018.md
- Notes path: work/notes/improving-language-understanding-gpt1-radford-2018.md

Tasks
- [x] 1. Identify next paper to process (Week 2, Paper 1): record metadata and course context.
- [x] 2. Locate PDF and verify accessibility: [llm_papers_syllabus/Improving_Language_Understanding_GPT1_Radford_2018.pdf](llm_papers_syllabus/Improving_Language_Understanding_GPT1_Radford_2018.pdf)
- [x] 3. Prepare context from [course-syllabus.md](course-syllabus.md): extract Key Topics for Week 2.
- [x] 4. Create notes file: work/notes/improving-language-understanding-gpt1-radford-2018.md
- [x] 5. Skim and outline (10–12 bullets) in the notes file.
- [x] 6. Generate summary draft using [Prompt.md](Prompt.md); include TL;DR and required sections.
- [x] 7. Add 5 discussion questions and 8–12 term glossary.
- [x] 8. Tie to "Pre-training Paradigms" and causal language modeling explicitly.
- [x] 9. Claims and consistency check against the PDF text; refine as needed.
- [x] 10. Save final to summaries/improving-language-understanding-gpt1-radford-2018.md
- [x] 11. Update this TODO (mark steps [x]) and note any follow-ups.
- [x] 12. Optional: add "Figure Insights" (e.g., Figure 1 input transformations, Figure 2 transfer analysis).

Active Task Instance 004: Week 2 — BERT: Pre-training of Deep Bidirectional Transformers for Language Understanding (Devlin et al., 2018)
Context
- Syllabus entry: Week 2 — Pre-training Paradigms & Models
- Key Topics & Labs: Causal Language Modeling (GPT). Masked Language Modeling (BERT). Unsupervised Pre-training and semi-supervised transfer learning. Tokenization (BPE, WordPiece).
- PDF path: [llm_papers_syllabus/BERT_Bidirectional_Transformers_Devlin_2018.pdf](llm_papers_syllabus/BERT_Bidirectional_Transformers_Devlin_2018.pdf)
- Output path: summaries/bert-pretraining-devlin-2018.md
- Notes path: work/notes/bert-pretraining-devlin-2018.md

Tasks
- [x] 1. Identify next paper to process (Week 2, Paper 2): record metadata and course context.
- [x] 2. Locate PDF and verify accessibility: [llm_papers_syllabus/BERT_Bidirectional_Transformers_Devlin_2018.pdf](llm_papers_syllabus/BERT_Bidirectional_Transformers_Devlin_2018.pdf)
- [x] 3. Prepare context from [course-syllabus.md](course-syllabus.md): extract Key Topics for Week 2.
- [x] 4. Create notes file: work/notes/bert-pretraining-devlin-2018.md
- [x] 5. Skim and outline (10–12 bullets) in the notes file.
- [x] 6. Generate summary draft using [Prompt.md](Prompt.md); include TL;DR and required sections.
- [x] 7. Add 5 discussion questions and 8–12 term glossary.
- [x] 8. Tie to "Pre-training Paradigms" and masked language modeling explicitly.
- [x] 9. Claims and consistency check against the PDF text; refine as needed.
- [x] 10. Save final to summaries/bert-pretraining-devlin-2018.md
- [x] 11. Update this TODO (mark steps [x]) and note any follow-ups.
- [ ] 12. Optional: add "Figure Insights".

Planned upcoming instances (add as you go)
- Week 3: T5 (Raffel 2019) → summaries/t5-unified-text-to-text-raffel-2019.md
- Week 3: RoFormer (Su 2021) → summaries/roformer-enhanced-transformer-su-2021.md
- Week 4: Scaling Laws (Kaplan 2020) → summaries/scaling-laws-neural-language-models-kaplan-2020.md
- Week 4: Training Compute-Optimal LLMs (Hoffmann 2022) → summaries/training-compute-optimal-llm-hoffmann-2022.md
- Week 5: Switch Transformers (Fedus 2021) → summaries/switch-transformers-moe-fedus-2021.md
- Week 5: LLaMA 2 (Touvron 2023) → summaries/llama-2-open-foundation-touvron-2023.md
- Week 6: FlashAttention (Dao 2022) → summaries/flashattention-fast-io-aware-dao-2022.md
- Week 6: GPTQ (Frantar 2022) → summaries/gptq-accurate-post-training-quant-frantar-2022.md
- Week 7: FLAN (Wei 2021) → summaries/flan-finetuned-zero-shot-wei-2021.md
- Week 7: Emergent Abilities (Wei 2022) → summaries/emergent-abilities-llm-wei-2022.md
- Week 7 (Added): HELM (Liang 2022) → summaries/helm-holistic-evaluation-liang-2022.md
- Week 7 (Added): BIG-bench (Srivastava 2022) → summaries/big-bench-beyond-imitation-game-srivastava-2022.md
- Week 8: InstructGPT (Ouyang 2022) → summaries/instructgpt-training-instructions-ouyang-2022.md
- Week 8: Deep RL Human Preferences (Christiano 2017) → summaries/deep-rl-human-preferences-christiano-2017.md
- Week 9: DPO (Rafailov 2023) → summaries/dpo-direct-preference-optimization-rafailov-2023.md
- Week 9: Constitutional AI (Bai 2022) → summaries/constitutional-ai-harmlessness-bai-2022.md
- Week 9 (Added): TruthfulQA (Lin 2021) → summaries/truthfulqa-measuring-falsehoods-lin-2021.md
- Week 9 (Added): Measuring Faithfulness in CoT (Lanham 2023) → summaries/measuring-faithfulness-cot-lanham-2023.md
- Week 10: Chain-of-Thought (Wei 2022) → summaries/chain-of-thought-reasoning-wei-2022.md
- Week 10: ReAct (Yao 2022) → summaries/react-reasoning-and-acting-yao-2022.md
- Week 10 (Added): Toolformer (Schick 2023) → summaries/toolformer-llms-use-tools-schick-2023.md
- Week 10 (Added): Gorilla (Patil 2023) → summaries/gorilla-llm-connected-apis-patil-2023.md
- Week 10 (Added): Flamingo (Alayrac 2022) → summaries/flamingo-visual-language-model-alayrac-2022.md
- Week 10 (Added): LLaVA (Liu 2023) → summaries/llava-visual-instruction-tuning-liu-2023.md
- Week 10 (Added): Kosmos-2 (Peng 2023) → summaries/kosmos-2-grounding-multimodal-peng-2023.md
- Week 11: RAG (Lewis 2020) → summaries/rag-retrieval-augmented-generation-lewis-2020.md
- Week 11: Lost in the Middle (Liu 2023) → summaries/lost-in-the-middle-long-context-liu-2023.md
- Week 11 (Added): LoRA (Hu 2021) → summaries/lora-low-rank-adaptation-hu-2021.md
- Week 11 (Added): vLLM (Kwon 2023) → summaries/vllm-pagedattention-serving-kwon-2023.md
- Week 11 (Added): MemGPT (Wu 2023) → summaries/memgpt-llms-operating-systems-wu-2023.md
- Week 12: Mamba (Gu & Dao 2023) → summaries/mamba-linear-time-ssm-gu-dao-2023.md
- Week 12: RetNet (Wu 2023) → summaries/retentive-network-retnet-wu-2023.md
- Week 12 (Added): Hyena (Poli 2023) → summaries/hyena-hierarchy-convolutional-poli-2023.md
- Week 12 (Added): Jamba (Lieber 2024) → summaries/jamba-hybrid-transformer-mamba-lieber-2024.md
- Extension A: Universal Adversarial Attacks (Zou 2023) → summaries/universal-adversarial-attacks-aligned-llms-zou-2023.md
- Extension A: Scalable Poisoning (Schmid 2024) → summaries/scalable-transferable-poisoning-schmid-2024.md
- Extension A: Security of RAG (Mouton 2023) → summaries/security-of-retrieval-augmented-generation-mouton-2023.md
- Extension A: LLM Attack Zoo (Gao 2024) → summaries/llm-attack-zoo-categorization-gao-2024.md
- Extension A (Added): Red Teaming (Perez 2022) → summaries/red-teaming-reduce-harms-perez-2022.md
- Extension A (Added): Watermark for LLMs (Kirchenbauer 2023) → summaries/watermark-large-language-models-kirchenbauer-2023.md
- Extension A (Added): Certified Robustness (Wang 2023) → summaries/certified-robustness-word-substitutions-wang-2023.md
- Extension A (Added): Poisoning Instruction Tuning (Qi 2023) → summaries/poisoning-instruction-tuning-qi-2023.md
- Extension B: Stochastic Parrots (Bender 2021) → summaries/dangers-of-stochastic-parrots-bias-bender-2021.md
- Extension B: Measuring Bias (Bansal 2020) → summaries/measuring-mitigating-bias-grounded-language-bansal-2020.md
- Extension B: Alignment Problem (Amodei 2016) → summaries/the-alignment-problem-safety-amodei-2016.md
- Extension B: Constitutional AI (duplicate with Week 9) — use same summary
- Include Extension tracks after core weeks or interleave as time allows.

Marking tasks complete
- The executing agent must replace [ ] with [x] as steps are completed and save this file.
- If a step is partially blocked, annotate the checkbox line with a brief note (e.g., “blocked: figure extraction required”).

Change log
- v0.1 Initial TODO with per-paper template and Week 1 task instances; duplicate BAI note included.