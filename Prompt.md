# Prompt: Course-Aligned Paper Summary (~1500 words)

Purpose
- This prompt guides an agent to produce a clear ~1500-word summary of a single syllabus paper, aligned to course goals.
- Outputs must be readable by advanced undergrads/early grads, with emphasis on core ideas, innovations, and course fit.
- The agent should work paper-by-paper, update tasks in [TODO.md](TODO.md), and save output under summaries/.

Inputs (provide or derive before running)
- PAPER_TITLE (e.g., “Attention Is All You Need”)
- AUTHORS (e.g., “Vaswani et al.”)
- YEAR (e.g., 2017)
- PDF_PATH (e.g., [llm_papers_syllabus/Attention_Is_All_You_Need_Vaswani_2017.pdf](llm_papers_syllabus/Attention_Is_All_You_Need_Vaswani_2017.pdf))
- WEEK (e.g., “Week 1”)
- COURSE_SECTION (e.g., “Core Transformer Architecture”)
- KEY_TOPICS_AND_LABS (copy from [course-syllabus.md](course-syllabus.md))
- OUTPUT_SLUG (slugified title + lead author + year, e.g., attention-is-all-you-need-vaswani-2017)
- OUTPUT_PATH (e.g., summaries/attention-is-all-you-need-vaswani-2017.md)
- NOTES_PATH (required; always create, e.g., work/notes/attention-is-all-you-need-vaswani-2017.md)

Context convention
- Consult [course-syllabus.md](course-syllabus.md) for week, section, and “Key Topics & Labs”.
- Read the PDF directly from [llm_papers_syllabus](llm_papers_syllabus).
- If duplicate PDFs exist (e.g., Constitutional AI), standardize on [llm_papers_syllabus/Constitutional_AI_Harmlessness_Bai_2022.pdf](llm_papers_syllabus/Constitutional_AI_Harmlessness_Bai_2022.pdf) and mark duplicate as handled in [TODO.md](TODO.md).

Acceptance criteria
- ~1500 words (±20%)
- Includes required sections (see Output format below)
- TL;DR (4–6 bullets), 5 discussion questions, and an 8–12 term glossary
- Clearly explains core innovation and contrasts to prior work (1–3 precise comparisons)
- Ties to WEEK/COURSE_SECTION and KEY_TOPICS_AND_LABS
- Claims spot-checked against the PDF (5–8 checks), with page/section hints where useful
- Saved to OUTPUT_PATH and tasks updated in [TODO.md](TODO.md)

Summary writing style
- Use concise, didactic prose; keep equations to intuitive verbal explanations when possible.
- Prefer plain words over jargon; define specialized terms in the glossary.
- Avoid marketing language; state limitations and failure modes explicitly.

Reusable prompt template
Copy and fill the variables in curly braces, then execute.

---
SYSTEM/INSTRUCTION

You are summarizing a single research paper for a university-level course on LLMs. Produce a ~1500-word, self-contained summary aligned to the course week and section, optimized for clarity and pedagogy. Use plain language and provide context behind the math and design choices. Tie your explanation explicitly to the week’s key topics and (if applicable) labs.

Inputs
- Paper
  - Title: {PAPER_TITLE}
  - Authors: {AUTHORS}
  - Year: {YEAR}
  - PDF path: {PDF_PATH}
- Course context
  - Week: {WEEK}
  - Section: {COURSE_SECTION}
  - Key Topics & Labs (verbatim from syllabus): {KEY_TOPICS_AND_LABS}
- Output
  - Output path: {OUTPUT_PATH}
  - Notes path: {NOTES_PATH}

Output format (use this exact section ordering and headings)
1) Title and citation
   - Paper title, authors, venue/year, arXiv ID if relevant.
2) TL;DR (4–6 bullets)
3) Problem and Motivation
4) Core Idea and Contributions
5) Method (plain-language, minimal math; include intuitions and any key equations in words)
6) Comparison to Prior Work (1–3 precise contrasts with accurate attribution)
7) Results and What They Mean (focus on key empirical findings and their implications)
8) Limitations and Failure Modes
9) Fit to This Course (Week: {WEEK}, Section: {COURSE_SECTION})
   - Explicitly tie to the week’s “Key Topics & Labs”: {KEY_TOPICS_AND_LABS}
10) Discussion Questions (5)
11) Glossary (8–12 terms; concise, accurate definitions)
12) References (as needed)

Method
- Quickly skim Abstract, Introduction, Method Overview, Conclusion; then scan Experiments and Ablations.
- Create the notes file at {NOTES_PATH} with sections: Key contributions, Method sketch, Prior work contrast, Notable results, Limitations.
- Draft a 10–12 bullet outline in the notes file before writing.
- Write to the Output format headings.
- Include short quotes or page/section hints for 5–8 important claims to ensure fidelity (e.g., “Sec 3.2 shows…”, “Table 1 reports…”).
- Keep focus on core ideas and course alignment; do not reproduce figure layouts.

Constraints and fidelity
- If a claim in your summary is not clearly supported by the PDF text, flag and soften it or remove it.
- When describing equations or algorithms, prioritize intuition and qualitative descriptions; include equation names or basic forms only when helpful.
- For comparisons to prior work, name the approach and the concrete difference (e.g., “Replaces RNN sequence alignment with global self-attention; reduces sequential operations from O(n) to O(1) per layer path length consideration, see Vaswani 2017 Table 1”).

End-of-run actions
- Save the summary to {OUTPUT_PATH}.
- Save the notes to {NOTES_PATH}.
- Update [TODO.md](TODO.md): mark completed steps [x] for the current paper’s task instance, and add any follow-ups.
- If figures were necessary for understanding, add a short “Figure Insights” subsection with figure numbers only.
- Also add any new Glossary items to the top-level [Glossary.md](Glossary.md)

Quality checklist (execute before saving)
- Length near 1500 words; all required sections present
- TL;DR has 4–6 bullets
- 5 discussion questions present
- Glossary 8–12 terms present
- 5–8 claim checks with page/section hints (or quotes) completed
- Course fit explicitly references week and “Key Topics & Labs”
- Prior work contrasts (1–3) are specific and accurate
- Notes file present at {NOTES_PATH} with the outline and section bullets
- File saved at {OUTPUT_PATH}; tasks updated in [TODO.md](TODO.md)

---

Operator steps (for the agent, before using the template)
1) Identify the paper and confirm PDF_PATH exists under [llm_papers_syllabus](llm_papers_syllabus).
2) Extract WEEK, COURSE_SECTION, and KEY_TOPICS_AND_LABS from [course-syllabus.md](course-syllabus.md).
3) Derive OUTPUT_SLUG (lowercase, hyphens, append lead author surname and year).
4) Set OUTPUT_PATH to summaries/{OUTPUT_SLUG}.md; set NOTES_PATH to work/notes/{OUTPUT_SLUG}.md and create it.
5) Run the template above with all variables filled.
6) Perform the Quality checklist.
7) Save and mark tasks in [TODO.md](TODO.md).

Example variable binding (for illustration; do not include in outputs)
- PAPER_TITLE: Attention Is All You Need
- AUTHORS: Vaswani et al.
- YEAR: 2017
- PDF_PATH: [llm_papers_syllabus/Attention_Is_All_You_Need_Vaswani_2017.pdf](llm_papers_syllabus/Attention_Is_All_You_Need_Vaswani_2017.pdf)
- WEEK: Week 1
- COURSE_SECTION: Core Transformer Architecture
- KEY_TOPICS_AND_LABS: Multi-Head Self-Attention; Encoder/Decoder; Positional Encodings; Complexity
- OUTPUT_SLUG: attention-is-all-you-need-vaswani-2017
- OUTPUT_PATH: summaries/attention-is-all-you-need-vaswani-2017.md
- NOTES_PATH: work/notes/attention-is-all-you-need-vaswani-2017.md

Notes
- If you encounter the duplicate Constitutional AI PDFs, process only: [llm_papers_syllabus/Constitutional_AI_Harmlessness_Bai_2022.pdf](llm_papers_syllabus/Constitutional_AI_Harmlessness_Bai_2022.pdf) and mark the other as handled in [TODO.md](TODO.md).
- If a figure is absolutely central (e.g., “Figure 1: Transformer architecture”), refer to it by number and summarize the insight in text. Do not embed images.

Post-prompt operator reminder
- After completing any paper, return here to select the next paper and repeat.
- Ensure summaries maintain consistent voice and structure across the course.
