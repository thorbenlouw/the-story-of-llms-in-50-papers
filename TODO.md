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
- [ ] 12. Optional: add "Figure Insights".

Planned upcoming instances (add as you go)
- Week 2: GPT-1 (Radford 2018) → summaries/improving-language-understanding-gpt1-radford-2018.md
- Week 2: BERT (Devlin 2018) → summaries/bert-pretraining-devlin-2018.md
- Week 3: T5 (Raffel 2019), RoFormer (Su 2021), etc.
- Include Extension tracks after core weeks or interleave as time allows.

Marking tasks complete
- The executing agent must replace [ ] with [x] as steps are completed and save this file.
- If a step is partially blocked, annotate the checkbox line with a brief note (e.g., “blocked: figure extraction required”).

Change log
- v0.1 Initial TODO with per-paper template and Week 1 task instances; duplicate BAI note included.