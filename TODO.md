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
- [x] 12. Optional: add "Figure Insights" (e.g., Figure 1 architecture; scaling in Table 1).

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
- [x] 12. Optional: add "Figure Insights".

Active Task Instance 005: Week 3 — Exploring the Limits of Transfer Learning with a Unified Text-to-Text Transformer (Raffel et al., 2019)
Context
- Syllabus entry: Week 3 — Context, Embedding, and T5
- Key Topics & Labs: Positional Encoding Deep Dive (RoPE vs. Absolute). The unified text-to-text paradigm. Lab: Implementing a small GPT-style block and fine-tuning an open-source T5 model on a sequence-to-sequence task.
- PDF path: [llm_papers_syllabus/T5_Unified_Text_to_Text_Raffel_2019.pdf](llm_papers_syllabus/T5_Unified_Text_to_Text_Raffel_2019.pdf)
- Output path: summaries/t5-unified-text-to-text-raffel-2019.md
- Notes path: work/notes/t5-unified-text-to-text-raffel-2019.md

Tasks
- [x] 1. Identify next paper to process (Week 3, Paper 1): record metadata and course context.
- [x] 2. Locate PDF and verify accessibility: [llm_papers_syllabus/T5_Unified_Text_to_Text_Raffel_2019.pdf](llm_papers_syllabus/T5_Unified_Text_to_Text_Raffel_2019.pdf)
- [x] 3. Prepare context from [course-syllabus.md](course-syllabus.md): extract Key Topics for Week 3.
- [x] 4. Create notes file: work/notes/t5-unified-text-to-text-raffel-2019.md
- [x] 5. Skim and outline (10–12 bullets) in the notes file.
- [x] 6. Generate summary draft using [Prompt.md](Prompt.md); include TL;DR and required sections.
- [x] 7. Add 5 discussion questions and 8–12 term glossary.
- [x] 8. Tie to "Context, Embedding, and T5" and text-to-text paradigm explicitly.
- [x] 9. Claims and consistency check against the PDF text; refine as needed.
- [x] 10. Save final to summaries/t5-unified-text-to-text-raffel-2019.md
- [x] 11. Update this TODO (mark steps [x]) and note any follow-ups.
- [x] 12. Optional: add "Figure Insights" (e.g., Figure 1 text-to-text examples, Figure 2 span corruption).

Active Task Instance 006: Week 3 — RoFormer: Enhanced Transformer with Rotary Position Embedding (Su et al., 2021)
Context
- Syllabus entry: Week 3 — Context, Embedding, and T5
- Key Topics & Labs: Positional Encoding Deep Dive (RoPE vs. Absolute). The unified text-to-text paradigm. Lab: Implementing a small GPT-style block and fine-tuning an open-source T5 model on a sequence-to-sequence task.
- PDF path: llm_papers_syllabus/RoFormer_Rotary_Position_Embedding_Su_2021.pdf
- Output path: summaries/roformer-enhanced-transformer-su-2021.md
- Notes path: work/notes/roformer-enhanced-transformer-su-2021.md

Tasks
- [x] 1. Identify next paper to process (Week 3, Paper 2): record metadata and course context.
- [x] 2. Locate PDF and verify accessibility: llm_papers_syllabus/RoFormer_Rotary_Position_Embedding_Su_2021.pdf
- [x] 3. Prepare context from course-syllabus.md: extract Key Topics for Week 3.
- [x] 4. Create notes file: work/notes/roformer-enhanced-transformer-su-2021.md
- [x] 5. Skim and outline (10–12 bullets) in the notes file.
- [x] 6. Generate summary draft using Prompt.md; include TL;DR and required sections.
- [x] 7. Add 5 discussion questions and 8–12 term glossary.
- [x] 8. Tie to "Context, Embedding, and T5" and RoPE vs. Absolute position encodings explicitly.
- [x] 9. Claims and consistency check against the PDF text; refine as needed.
- [x] 10. Save final to summaries/roformer-enhanced-transformer-su-2021.md
- [x] 11. Update this TODO (mark steps [x]) and note any follow-ups.
- [x] 12. Optional: add "Figure Insights" (Figure 1 rotation illustration, Figure 2 long-term decay).

Active Task Instance 007: Week 4 — Scaling Laws for Neural Language Models (Kaplan et al., 2020)
Context
- Syllabus entry: Week 4 — Scaling Laws & Compute Optimization (Phase II)
- Key Topics & Labs: Empirical scaling of model size, dataset size, and compute budget. The Chinchilla optimal scaling theory. Data and model parallelization concepts (Megatron-LM).
- PDF path: llm_papers_syllabus/Scaling_Laws_Neural_Language_Models_Kaplan_2020.pdf
- Output path: summaries/scaling-laws-neural-language-models-kaplan-2020.md
- Notes path: work/notes/scaling-laws-neural-language-models-kaplan-2020.md

Tasks
- [x] 1. Identify next paper to process (Week 4, Paper 1): record metadata and course context.
- [x] 2. Locate PDF and verify accessibility: llm_papers_syllabus/Scaling_Laws_Neural_Language_Models_Kaplan_2020.pdf
- [x] 3. Prepare context from course-syllabus.md: extract Key Topics for Week 4.
- [x] 4. Create notes file: work/notes/scaling-laws-neural-language-models-kaplan-2020.md
- [x] 5. Skim and outline (10–12 bullets) in the notes file.
- [x] 6. Generate summary draft using Prompt.md; include TL;DR and required sections.
- [x] 7. Add 5 discussion questions and 8–12 term glossary.
- [x] 8. Tie to "Scaling Laws & Compute Optimization" and empirical scaling explicitly.
- [x] 9. Claims and consistency check against the PDF text; refine as needed.
- [x] 10. Save final to summaries/scaling-laws-neural-language-models-kaplan-2020.md
- [x] 11. Update this TODO (mark steps [x]) and note any follow-ups.
- [x] 12. Optional: add "Figure Insights" (Figure 1 shows all three scaling laws; Figure 13 shows C_min scaling).

Active Task Instance 008: Week 4 — Training Compute-Optimal Large Language Models (Hoffmann et al., 2022)
Context
- Syllabus entry: Week 4 — Scaling Laws & Compute Optimization (Phase II)
- Key Topics & Labs: Empirical scaling of model size, dataset size, and compute budget. The Chinchilla optimal scaling theory. Data and model parallelization concepts (Megatron-LM).
- PDF path: llm_papers_syllabus/Training_Compute_Optimal_LLM_Hoffmann_2022.pdf
- Output path: summaries/training-compute-optimal-llm-hoffmann-2022.md
- Notes path: work/notes/training-compute-optimal-llm-hoffmann-2022.md

Tasks
- [x] 1. Identify next paper to process (Week 4, Paper 2): record metadata and course context.
- [x] 2. Locate PDF and verify accessibility: llm_papers_syllabus/Training_Compute_Optimal_LLM_Hoffmann_2022.pdf
- [x] 3. Prepare context from course-syllabus.md: extract Key Topics for Week 4.
- [x] 4. Create notes file: work/notes/training-compute-optimal-llm-hoffmann-2022.md
- [x] 5. Skim and outline (10–12 bullets) in the notes file.
- [x] 6. Generate summary draft using Prompt.md; include TL;DR and required sections.
- [x] 7. Add 5 discussion questions and 8–12 term glossary.
- [x] 8. Tie to "Scaling Laws & Compute Optimization" and Chinchilla theory explicitly.
- [x] 9. Claims and consistency check against the PDF text; refine as needed.
- [x] 10. Save final to summaries/training-compute-optimal-llm-hoffmann-2022.md
- [x] 11. Update this TODO (mark steps [x]) and note any follow-ups.
- [x] 12. Optional: add "Figure Insights" (Figure 1 shows three approaches overlaid; Figure 3 shows IsoFLOP curves; Table 2 shows scaling coefficients).

Active Task Instance 009: Week 5 — Switch Transformers: Scaling to Trillion Parameter Models with Simple and Efficient Sparsity (Fedus et al., 2021)
Context
- Syllabus entry: Week 5 — Mixture-of-Experts (MoE) Architectures (Phase II)
- Key Topics & Labs: Theory of sparse activation and conditional computation. Router mechanisms and load balancing. The efficiency trade-offs of MoE. Lab: Implementing a basic MoE layer and comparing its memory usage vs. a dense layer.
- PDF path: llm_papers_syllabus/Switch_Transformers_MoE_Fedus_2021.pdf
- Output path: summaries/switch-transformers-moe-fedus-2021.md
- Notes path: work/notes/switch-transformers-moe-fedus-2021.md

Tasks
- [x] 1. Identify next paper to process (Week 5, Paper 1): record metadata and course context.
- [x] 2. Locate PDF and verify accessibility: llm_papers_syllabus/Switch_Transformers_MoE_Fedus_2021.pdf
- [x] 3. Prepare context from course-syllabus.md: extract Key Topics for Week 5.
- [x] 4. Create notes file: work/notes/switch-transformers-moe-fedus-2021.md
- [x] 5. Skim and outline (10–12 bullets) in the notes file.
- [x] 6. Generate summary draft using Prompt.md; include TL;DR and required sections.
- [x] 7. Add 5 discussion questions and 8–12 term glossary.
- [x] 8. Tie to "Mixture-of-Experts Architectures" and sparse activation explicitly.
- [x] 9. Claims and consistency check against the PDF text; refine as needed.
- [x] 10. Save final to summaries/switch-transformers-moe-fedus-2021.md
- [x] 11. Update this TODO (mark steps [x]) and note any follow-ups.
- [x] 12. Optional: add "Figure Insights" (Figure 2 architecture, Figure 3 capacity factor, Figure 5 speedup).

Active Task Instance 010: Week 5 — LLaMA 2: Open Foundation and Fine-Tuned Chat Models (Touvron et al., 2023)
Context
- Syllabus entry: Week 5 — Mixture-of-Experts (MoE) Architectures (Phase II)
- Key Topics & Labs: Theory of sparse activation and conditional computation. Router mechanisms and load balancing. The efficiency trade-offs of MoE. Lab: Implementing a basic MoE layer and comparing its memory usage vs. a dense layer.
- Note: LLaMA 2 provides context for modern scaling and data curriculum approaches
- PDF path: llm_papers_syllabus/LLaMA_2_Open_Foundation_Touvron_2023.pdf
- Output path: summaries/llama-2-open-foundation-touvron-2023.md
- Notes path: work/notes/llama-2-open-foundation-touvron-2023.md

Tasks
- [x] 1. Identify next paper to process (Week 5, Paper 2): record metadata and course context.
- [x] 2. Locate PDF and verify accessibility: llm_papers_syllabus/LLaMA_2_Open_Foundation_Touvron_2023.pdf
- [x] 3. Prepare context from course-syllabus.md: extract Key Topics for Week 5.
- [x] 4. Create notes file: work/notes/llama-2-open-foundation-touvron-2023.md
- [x] 5. Skim and outline (10–12 bullets) in the notes file.
- [x] 6. Generate summary draft using Prompt.md; include TL;DR and required sections.
- [x] 7. Add 5 discussion questions and 8–12 term glossary.
- [x] 8. Tie to "Mixture-of-Experts Architectures" context and modern scaling explicitly.
- [x] 9. Claims and consistency check against the PDF text; refine as needed.
- [x] 10. Save final to summaries/llama-2-open-foundation-touvron-2023.md
- [x] 11. Update this TODO (mark steps [x]) and note any follow-ups.
- [x] 12. Optional: add "Figure Insights" (Figure 4 RLHF pipeline, Figure 6 reward scaling, Figure 20 distribution shift).

Active Task Instance 011: Week 6 — FlashAttention: Fast and Memory-Efficient Exact Attention with IO-Awareness (Dao et al., 2022)
Context
- Syllabus entry: Week 6 — Inference Efficiency & Hardware (Phase II)
- Key Topics & Labs: The quadratic bottleneck in inference. KV Caching. The mechanics of FlashAttention (tiling and fusion). Quantization schemes (8-bit, 4-bit, GPTQ).
- PDF path: llm_papers_syllabus/FlashAttention_Fast_IO_Aware_Dao_2022.pdf
- Output path: summaries/flashattention-fast-io-aware-dao-2022.md
- Notes path: work/notes/flashattention-fast-io-aware-dao-2022.md

Tasks
- [x] 1. Identify next paper to process (Week 6, Paper 1): record metadata and course context.
- [x] 2. Locate PDF and verify accessibility: llm_papers_syllabus/FlashAttention_Fast_IO_Aware_Dao_2022.pdf
- [x] 3. Prepare context from course-syllabus.md: extract Key Topics for Week 6.
- [x] 4. Create notes file: work/notes/flashattention-fast-io-aware-dao-2022.md
- [x] 5. Skim and outline (10–12 bullets) in the notes file.
- [x] 6. Generate summary draft using Prompt.md; include TL;DR and required sections.
- [x] 7. Add 5 discussion questions and 8–12 term glossary.
- [x] 8. Tie to "Inference Efficiency & Hardware" and tiling/fusion mechanics explicitly.
- [x] 9. Claims and consistency check against the PDF text; refine as needed.
- [x] 10. Save final to summaries/flashattention-fast-io-aware-dao-2022.md
- [x] 11. Update this TODO (mark steps [x]) and note any follow-ups.
- [x] 12. Optional: add "Figure Insights" (Figure 1 tiling diagram, Figure 2 HBM access analysis, Figure 3 runtime/memory benchmarks).

Active Task Instance 012: Week 6 — GPTQ: Accurate Post-Training Quantization for Generative Pre-trained Transformers (Frantar et al., 2022)
Context
- Syllabus entry: Week 6 — Inference Efficiency & Hardware (Phase II)
- Key Topics & Labs: The quadratic bottleneck in inference. KV Caching. The mechanics of FlashAttention (tiling and fusion). Quantization schemes (8-bit, 4-bit, GPTQ).
- PDF path: llm_papers_syllabus/GPTQ_Accurate_Post_Training_Quant_Frantar_2022.pdf
- Output path: summaries/gptq-accurate-post-training-quant-frantar-2022.md
- Notes path: work/notes/gptq-accurate-post-training-quant-frantar-2022.md

Tasks
- [x] 1. Identify next paper to process (Week 6, Paper 2): record metadata and course context.
- [x] 2. Locate PDF and verify accessibility: llm_papers_syllabus/GPTQ_Accurate_Post_Training_Quant_Frantar_2022.pdf
- [x] 3. Prepare context from course-syllabus.md: extract Key Topics for Week 6.
- [x] 4. Create notes file: work/notes/gptq-accurate-post-training-quant-frantar-2022.md
- [x] 5. Skim and outline (10–12 bullets) in the notes file.
- [x] 6. Generate summary draft using Prompt.md; include TL;DR and required sections.
- [x] 7. Add 5 discussion questions and 8–12 term glossary.
- [x] 8. Tie to "Inference Efficiency & Hardware" and quantization schemes explicitly.
- [x] 9. Claims and consistency check against the PDF text; refine as needed (verified 8 key claims).
- [x] 10. Save final to summaries/gptq-accurate-post-training-quant-frantar-2022.md
- [x] 11. Update this TODO (mark steps [x]) and note any follow-ups.
- [x] 12. Optional: add "Figure Insights" (Figure 1 shows OPT/BLOOM 4-bit and 3-bit comparison; Figure 2 shows GPTQ block quantization procedure; Algorithm 1 pseudocode).
Active Task Instance 013: Week 7 — Finetuned Language Models are Zero-Shot Learners (Wei et al., 2021)
Context
- Syllabus entry: Week 7 — Instruction Tuning and Generalization (Phase III)
- Key Topics & Labs: The shift to instruction-following. Task generalization via instruction-tuning (FLAN). Emergent abilities (In-context learning). Multimodality introduction. Evaluation & Benchmarking: Holistic evaluation frameworks and task diversity.
- PDF path: llm_papers_syllabus/FLAN_Finetuned_Zero_Shot_Wei_2021.pdf
- Output path: summaries/flan-finetuned-zero-shot-wei-2021.md
- Notes path: work/notes/flan-finetuned-zero-shot-wei-2021.md

Tasks
- [x] 1. Identify next paper to process (Week 7, Paper 1): record metadata and course context.
- [x] 2. Locate PDF and verify accessibility: llm_papers_syllabus/FLAN_Finetuned_Zero_Shot_Wei_2021.pdf
- [x] 3. Prepare context from course-syllabus.md: extract Key Topics for Week 7.
- [x] 4. Create notes file: work/notes/flan-finetuned-zero-shot-wei-2021.md
- [x] 5. Skim and outline (10–12 bullets) in the notes file.
- [x] 6. Generate summary draft using Prompt.md; include TL;DR and required sections.
- [x] 7. Add 5 discussion questions and 8–12 term glossary.
- [x] 8. Tie to "Instruction Tuning and Generalization" and task generalization explicitly.
- [x] 9. Claims and consistency check against the PDF text; refine as needed (verified key claims about 62 datasets, 137B parameters, outperforming GPT-3 on 20/25 datasets, scale dependence at ≥68B, OPTIONS suffix technique, task cluster methodology, and ablation study findings).
- [x] 10. Save final to summaries/flan-finetuned-zero-shot-wei-2021.md
- [x] 11. Update this TODO (mark steps [x]) and note any follow-ups.
- [x] 12. Optional: add "Figure Insights" (Figure 1 shows instruction tuning overview; Figure 5 compares zero-shot performance across task types; Figure 6 shows task cluster ablation; Figure 7 demonstrates scale dependence).


Active Task Instance 014: Week 7 — Emergent Abilities of Large Language Models (Wei et al., 2022)
Context
- Syllabus entry: Week 7 — Instruction Tuning and Generalization (Phase III)
- Key Topics & Labs: The shift to instruction-following. Task generalization via instruction-tuning (FLAN). Emergent abilities (In-context learning). Multimodality introduction. Evaluation & Benchmarking: Holistic evaluation frameworks and task diversity.
- PDF path: llm_papers_syllabus/Emergent_Abilities_LLM_Wei_2022.pdf
- Output path: summaries/emergent-abilities-llm-wei-2022.md
- Notes path: work/notes/emergent-abilities-llm-wei-2022.md

Tasks
- [x] 1. Identify next paper to process (Week 7, Paper 2): record metadata and course context.
- [x] 2. Locate PDF and verify accessibility: llm_papers_syllabus/Emergent_Abilities_LLM_Wei_2022.pdf
- [x] 3. Prepare context from course-syllabus.md: extract Key Topics for Week 7.
- [x] 4. Create notes file: work/notes/emergent-abilities-llm-wei-2022.md
- [x] 5. Skim and outline (10–12 bullets) in the notes file.
- [x] 6. Generate summary draft using Prompt.md; include TL;DR and required sections.
- [x] 7. Add 5 discussion questions and 8–12 term glossary.
- [x] 8. Tie to "Instruction Tuning and Generalization" and emergent abilities explicitly.
- [x] 9. Claims and consistency check against the PDF text; refine as needed (verified 8 key claims: emergent ability definition, GPT-3 arithmetic thresholds, MMLU emergence scales, WiC benchmark progression, chain-of-thought emergence, instruction following emergence, cross-entropy analysis, and PaLM 62B outperformance).
- [x] 10. Save final to summaries/emergent-abilities-llm-wei-2022.md
- [x] 11. Update this TODO (mark steps [x]) and note any follow-ups.
- [x] 12. Optional: add "Figure Insights" (Figure 2 shows eight emergent few-shot tasks; Figure 3 shows four augmented prompting strategies; Figure 4 shows MMLU emergence across three metrics; Table 1 lists all emergent abilities and scales).
Active Task Instance 015: Week 7 — Holistic Evaluation of Language Models (Liang et al., 2022)
Context
- Syllabus entry: Week 7 — Instruction Tuning and Generalization (Phase III)
- Key Topics & Labs: The shift to instruction-following. Task generalization via instruction-tuning (FLAN). Emergent abilities (In-context learning). Multimodality introduction. Evaluation & Benchmarking: Holistic evaluation frameworks and task diversity.
- PDF path: llm_papers_syllabus/HELM_Holistic_Evaluation_Liang_2022.pdf
- Output path: summaries/helm-holistic-evaluation-liang-2022.md
- Notes path: work/notes/helm-holistic-evaluation-liang-2022.md

Tasks
- [x] 1. Identify next paper to process (Week 7, Additional Reading 3): record metadata and course context.
- [x] 2. Locate PDF and verify accessibility: llm_papers_syllabus/HELM_Holistic_Evaluation_Liang_2022.pdf
- [x] 3. Prepare context from course-syllabus.md: extract Key Topics for Week 7.
- [x] 4. Create notes file: work/notes/helm-holistic-evaluation-liang-2022.md
- [x] 5. Skim and outline (10–12 bullets) in the notes file.
- [x] 6. Generate summary draft using Prompt.md; include TL;DR and required sections.
- [x] 7. Add 5 discussion questions and 8–12 term glossary.
- [x] 8. Tie to "Instruction Tuning and Generalization" and evaluation frameworks explicitly.
- [x] 9. Claims and consistency check against the PDF text; refine as needed (verified key claims about 17.9% → 96% coverage, 30 models, 87.5% multi-metric coverage, text-davinci-002 dominance, 62% TruthfulQA accuracy, AAE disparities 1.506 vs 2.114 BPB, 50B parameter threshold, prompting sensitivity findings).
- [x] 10. Save final to summaries/helm-holistic-evaluation-liang-2022.md
- [x] 11. Update this TODO (mark steps [x]) and note any follow-ups.
- [x] 12. Optional: add "Figure Insights" (Figure 2 taxonomy structure, Figure 3 multi-metric approach, Figure 4 standardization before/after, Figure 24-26 inter-metric relationships, Figure 28 accessibility gap, Figure 31 prompting variance, Figure 33 adaptation method sensitivity).


Planned upcoming instances (add as you go)
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
 
Active Task Instance 016: Week 7 — Beyond the Imitation Game: Quantifying and Extrapolating the Capabilities of Language Models (Srivastava et al., 2022)
Context
- Syllabus entry: Week 7 — Instruction Tuning and Generalization (Phase III)
- Key Topics & Labs: The shift to instruction-following. Task generalization via instruction-tuning (FLAN). Emergent abilities (In-context learning). Multimodality introduction. Evaluation & Benchmarking: Holistic evaluation frameworks and task diversity. Lab: Mini-eval comparing two open models on 3–5 HELM/BIG-bench categories; report accuracy + calibration notes.
- PDF path: [llm_papers_syllabus/BIG_Bench_Beyond_Imitation_Game_Srivastava_2022.pdf](llm_papers_syllabus/BIG_Bench_Beyond_Imitation_Game_Srivastava_2022.pdf)
- Output path: summaries/big-bench-beyond-imitation-game-srivastava-2022.md
- Notes path: work/notes/big-bench-beyond-imitation-game-srivastava-2022.md

Tasks
- [x] 1. Identify next paper to process (Week 7, Additional Reading 4): record metadata and course context.
- [x] 2. Locate PDF and verify accessibility: [llm_papers_syllabus/BIG_Bench_Beyond_Imitation_Game_Srivastava_2022.pdf](llm_papers_syllabus/BIG_Bench_Beyond_Imitation_Game_Srivastava_2022.pdf)
- [x] 3. Prepare context from course-syllabus.md: extract Key Topics for Week 7.
- [x] 4. Create notes file: work/notes/big-bench-beyond-imitation-game-srivastava-2022.md (optional — skipped).
- [x] 5. Skim and outline (10–12 bullets) in the notes file (captured inline during drafting).
- [x] 6. Generate summary draft using Prompt.md; include TL;DR and required sections.
- [x] 7. Add 5 discussion questions and 8–12 term glossary.
- [x] 8. Tie to "Instruction Tuning and Generalization" and evaluation/benchmarking lab explicitly.
- [x] 9. Claims and consistency check against the PDF text; soften claims without page numbers and flag general sections.
- [x] 10. Save final to summaries/big-bench-beyond-imitation-game-srivastava-2022.md
- [x] 11. Update this TODO (mark steps [x]) and note any follow-ups.
- [x] 12. Optional: add "Figure Insights" (aggregate category plots; prompt sensitivity ablations).

Active Task Instance 022: Week 9 — Measuring Faithfulness in Chain-of-Thought Reasoning (Lanham et al., 2023)
Context
- Syllabus entry: Week 9 — Reward-Free Alignment & Safety (Phase III)
- Key Topics & Labs: Direct Preference Optimization (DPO) vs. RLHF. The mathematical derivation of DPO as an unrolled objective. Safety, toxicity mitigation, and transparency. Factuality & CoT-Faithfulness: Measuring truthfulness and reasoning faithfulness. Lab: Fine-tuning an aligned model using DPO.
- PDF path: llm_papers_syllabus/Measuring_Faithfulness_CoT_Lanham_2023.pdf
- Output path: summaries/measuring-faithfulness-cot-lanham-2023.md

Tasks
- [x] 1. Identify next paper to process (Week 9, Additional Reading 4): record metadata and course context.
- [x] 2. Locate PDF and verify accessibility: llm_papers_syllabus/Measuring_Faithfulness_CoT_Lanham_2023.pdf
- [x] 3. Prepare context from course-syllabus.md: extract Key Topics for Week 9.
- [x] 4. Create notes file (optional - skipped for efficient workflow).
- [x] 5. Skim and outline inline during drafting from PDF pages 1-14.
- [x] 6. Generate summary draft using Prompt.md; include TL;DR and required sections.
- [x] 7. Add 5 discussion questions and 8–12 term glossary.
- [x] 8. Tie to "Reward-Free Alignment & Safety" and CoT-faithfulness measurement explicitly; connect to DPO lab and Week 9 themes.
- [x] 9. Claims and consistency check against the PDF text; verified key claims from pages 1-8 with section/figure references (four intervention tests, AOC metrics, inverse scaling, task variation, filler tokens, paraphrasing).
- [x] 10. Save final to summaries/measuring-faithfulness-cot-lanham-2023.md
- [x] 11. Update this TODO (mark steps [x]) and note any follow-ups.
- [x] 12. Optional: referenced key figures (Figures 1, 3-8, Table 2) throughout summary with page numbers.

Active Task Instance 021: Week 9 — TruthfulQA: Measuring How Models Mimic Human Falsehoods (Lin et al., 2021)
Context
- Syllabus entry: Week 9 — Reward-Free Alignment & Safety (Phase III)
- Key Topics & Labs: Direct Preference Optimization (DPO) vs. RLHF. The mathematical derivation of DPO as an unrolled objective. Safety, toxicity mitigation, and transparency. Factuality & CoT-Faithfulness: Measuring truthfulness and reasoning faithfulness. Lab: Fine-tuning an aligned model using DPO.
- PDF path: llm_papers_syllabus/TruthfulQA_Measuring_Falsehoods_Lin_2021.pdf
- Output path: summaries/truthfulqa-measuring-falsehoods-lin-2021.md

Tasks
- [x] 1. Identify next paper to process (Week 9, Additional Reading 3): record metadata and course context.
- [x] 2. Locate PDF and verify accessibility: llm_papers_syllabus/TruthfulQA_Measuring_Falsehoods_Lin_2021.pdf
- [x] 3. Prepare context from course-syllabus.md: extract Key Topics for Week 9.
- [x] 4. Create notes file (optional - skipped for efficient workflow).
- [x] 5. Skim and outline inline during drafting from PDF pages 1-39.
- [x] 6. Generate summary draft using Prompt.md; include TL;DR and required sections.
- [x] 7. Add 5 discussion questions and 8–12 term glossary.
- [x] 8. Tie to "Reward-Free Alignment & Safety" and factuality measurement explicitly; connect to DPO lab and Week 9 themes.
- [x] 9. Claims and consistency check against the PDF text; verified key claims from pages 1-8 with section/figure references (benchmark size, human vs. model performance, inverse scaling, control experiments, GPT-judge accuracy).
- [x] 10. Save final to summaries/truthfulqa-measuring-falsehoods-lin-2021.md
- [x] 11. Update this TODO (mark steps [x]) and note any follow-ups.
- [x] 12. Optional: referenced key figures (Figures 1-4, 10-11, Tables 1-2) throughout summary with page numbers.

Active Task Instance 017: Week 8 — Training language models to follow instructions with human feedback (Ouyang et al., 2022)
Context
- Syllabus entry: Week 8 — Reinforcement Learning from Human Feedback (RLHF)
- Key Topics & Labs: The full RLHF pipeline: SFT, Reward Model (RM), PPO optimization. KL divergence penalty. The role of human preference data in alignment.
- PDF path: [llm_papers_syllabus/InstructGPT_Training_Instructions_Ouyang_2022.pdf](llm_papers_syllabus/InstructGPT_Training_Instructions_Ouyang_2022.pdf)
- Output path: summaries/instructgpt-training-instructions-ouyang-2022.md
- Notes path: work/notes/instructgpt-training-instructions-ouyang-2022.md

Tasks
- [x] 1. Identify next paper to process (Week 8, Paper 1): record metadata and course context.
- [x] 2. Locate PDF and verify accessibility: [llm_papers_syllabus/InstructGPT_Training_Instructions_Ouyang_2022.pdf](llm_papers_syllabus/InstructGPT_Training_Instructions_Ouyang_2022.pdf)
- [x] 3. Prepare context from course-syllabus.md: extract Key Topics for Week 8.
- [x] 4. Create notes file: work/notes/instructgpt-training-instructions-ouyang-2022.md
- [x] 5. Skim and outline (10–12 bullets) in the notes file.
- [x] 6. Generate summary draft using Prompt.md; include TL;DR and required sections.
- [x] 7. Add 5 discussion questions and 8–12 term glossary.
- [x] 8. Tie to "RLHF" and KL/divergence control explicitly.
- [x] 9. Claims and consistency check against the PDF structure; include conservative section hints for core claims.
- [x] 10. Save final to summaries/instructgpt-training-instructions-ouyang-2022.md
- [x] 11. Update this TODO (mark steps [x]) and note any follow-ups.
- [x] 12. Optional: add "Figure Insights" (pipeline diagram illustrating SFT → RM → PPO with KL anchor).

Active Task Instance 018: Week 8 — Deep Reinforcement Learning from Human Preferences (Christiano et al., 2017)
Context
- Syllabus entry: Week 8 — Reinforcement Learning from Human Feedback (RLHF)
- Key Topics & Labs: The full RLHF pipeline: SFT, Reward Model (RM), PPO optimization. KL divergence penalty. The role of human preference data in alignment.
- PDF path: [llm_papers_syllabus/Deep_RL_Human_Preferences_Christiano_2017.pdf](llm_papers_syllabus/Deep_RL_Human_Preferences_Christiano_2017.pdf)
- Output path: summaries/deep-rl-human-preferences-christiano-2017.md
- Notes path: work/notes/deep-rl-human-preferences-christiano-2017.md (optional — skipped)

Tasks
- [x] 1. Identify next paper to process (Week 8, Paper 2): record metadata and course context.
- [x] 2. Locate PDF and verify accessibility: [llm_papers_syllabus/Deep_RL_Human_Preferences_Christiano_2017.pdf](llm_papers_syllabus/Deep_RL_Human_Preferences_Christiano_2017.pdf)
- [x] 3. Prepare context from course-syllabus.md: extract Key Topics for Week 8.
- [x] 4. Create notes file (optional).
- [x] 5. Skim and outline (10–12 bullets) in the notes file or inline during drafting.
- [x] 6. Generate summary draft using Prompt.md; include TL;DR and required sections.
- [x] 7. Add 5 discussion questions and 8–12 term glossary.
- [x] 8. Tie to "RLHF" and the Reward Model component explicitly; contrast with KL-regularized policy optimization used later in LLMs.
- [x] 9. Claims and consistency check against the PDF structure; include section hints for core claims.
- [x] 10. Save final to summaries/deep-rl-human-preferences-christiano-2017.md
- [x] 11. Update this TODO (mark steps [x]) and note any follow-ups.
- [x] 12. Optional: add "Figure Insights" if helpful.

Active Task Instance 019: Week 9 — Direct Preference Optimization: Your Language Model is Secretly a Reward Model (Rafailov et al., 2023)
Context
- Syllabus entry: Week 9 — Reward-Free Alignment & Safety (Phase III)
- Key Topics & Labs: Direct Preference Optimization (DPO) vs. RLHF. The mathematical derivation of DPO as an unrolled objective. Safety, toxicity mitigation, and transparency.
- PDF path: llm_papers_syllabus/DPO_Direct_Preference_Optimization_Rafailov_2023.pdf
- Output path: summaries/dpo-direct-preference-optimization-rafailov-2023.md
- Notes path: work/notes/dpo-direct-preference-optimization-rafailov-2023.md

Tasks
- [x] 1. Identify next paper to process (Week 9, Paper 1): record metadata and course context.
- [x] 2. Locate PDF and verify accessibility: llm_papers_syllabus/DPO_Direct_Preference_Optimization_Rafailov_2023.pdf
- [x] 3. Prepare context from course-syllabus.md: extract Key Topics for Week 9.
- [x] 4. Create notes file: work/notes/dpo-direct-preference-optimization-rafailov-2023.md
- [x] 5. Skim and outline (10–12 bullets) in the notes file.
- [x] 6. Generate summary draft using Prompt.md; include TL;DR and required sections.
- [x] 7. Add 5 discussion questions and 8–12 term glossary.
- [x] 8. Tie to "Reward-Free Alignment & Safety" and DPO vs. RLHF explicitly.
- [x] 9. Claims and consistency check against the PDF text; refine as needed (verified key claims from pages 1-2, 4-5, 7-10).
- [x] 10. Save final to summaries/dpo-direct-preference-optimization-rafailov-2023.md
- [x] 11. Update this TODO (mark steps [x]) and note any follow-ups.
- [x] 12. Optional: add "Figure Insights" (Figures 1, 2, 3 described in summary).

Active Task Instance 020: Week 9 — Constitutional AI: Harmlessness from AI Feedback (Bai et al., 2022)
Context
- Syllabus entry: Week 9 — Reward-Free Alignment & Safety (Phase III)
- Key Topics & Labs: Direct Preference Optimization (DPO) vs. RLHF. The mathematical derivation of DPO as an unrolled objective. Safety, toxicity mitigation, and transparency. Factuality & CoT-Faithfulness: Measuring truthfulness and reasoning faithfulness. Lab: Fine-tuning an aligned model using DPO.
- PDF path: llm_papers_syllabus/Constitutional_AI_Harmlessness_Bai_2022.pdf
- Output path: summaries/constitutional-ai-harmlessness-bai-2022.md
- Notes: Duplicate PDF (Constitutional_AI_Harmlessness_CAI_Bai_2022.pdf) exists but standardized on Constitutional_AI_Harmlessness_Bai_2022.pdf

Tasks
- [x] 1. Identify next paper to process (Week 9, Paper 2): record metadata and course context.
- [x] 2. Locate PDF and verify accessibility: llm_papers_syllabus/Constitutional_AI_Harmlessness_Bai_2022.pdf
- [x] 3. Prepare context from course-syllabus.md: extract Key Topics for Week 9.
- [x] 4. Create notes file (optional - skipped).
- [x] 5. Skim and outline (10–12 bullets) inline during drafting.
- [x] 6. Generate summary draft using Prompt.md; include TL;DR and required sections.
- [x] 7. Add 5 discussion questions and 8–12 term glossary.
- [x] 8. Tie to "Reward-Free Alignment & Safety" and comparison with DPO explicitly; connect to safety, transparency, and CoT-faithfulness themes.
- [x] 9. Claims and consistency check against the PDF text; verified key claims from pages 1-5, 8-16 with section references.
- [x] 10. Save final to summaries/constitutional-ai-harmlessness-bai-2022.md
- [x] 11. Update this TODO (mark steps [x]) and note any follow-ups.
- [x] 12. Optional: added Figure Insights in main text (Figures 1-5, 7 referenced throughout summary with page numbers).
