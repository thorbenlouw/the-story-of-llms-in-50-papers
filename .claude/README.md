# Claude Code Configuration for LLM Papers Course

This directory contains Claude Code agents and slash commands for automating the paper summarization workflow.

## Structure

```
.claude/
├── README.md                          # This file
├── agents/
│   └── paper-summarizer.md           # Sub-agent for processing individual papers
└── commands/
    ├── next-paper.md                 # Process next incomplete paper
    └── process-all-papers.md         # Process all remaining papers
```

## Workflow Overview

The prompt instructions from `Prompt.md` and `repeat-prompt.md` have been transformed into a reusable sub-agent system that:

1. **Works paper-by-paper** with fresh context for each invocation
2. **Reads TODO.md** to find the next incomplete paper
3. **Invokes a specialized agent** to generate the ~1500-word summary
4. **Updates TODO.md** automatically with completion status
5. **Can be orchestrated** to process all papers sequentially

## Usage

### Process Next Paper

```bash
/next-paper
```

This command:
- Reads `TODO.md` to find the first Active Task Instance with incomplete tasks
- Extracts paper metadata (title, authors, year, PDF path, week, section)
- Invokes the `paper-summarizer` agent with those inputs
- The agent will:
  - Read the PDF from `llm_papers_syllabus/`
  - Extract course context from `course-syllabus.md`
  - Generate a ~1500-word summary in `summaries/`
  - Update `TODO.md` with completion status

### Process All Remaining Papers

```bash
/process-all-papers
```

This command repeatedly invokes `/next-paper` until all papers in `TODO.md` are complete. Each paper gets a fresh agent invocation with new context.

## The Paper Summarizer Agent

Location: `.claude/agents/paper-summarizer.md`

This agent encapsulates the full workflow from `Prompt.md`:

### Inputs Required
- **PAPER_TITLE**: Full paper title
- **AUTHORS**: Lead author(s) with "et al."
- **YEAR**: Publication year
- **PDF_FILENAME**: Exact filename in `llm_papers_syllabus/`
- **WEEK**: Course week (e.g., "Week 1")
- **COURSE_SECTION**: Section from syllabus
- **TODO_INSTANCE**: Task instance number (e.g., "001")

### What It Does
1. **Context Gathering**: Reads syllabus, locates PDF, derives output paths
2. **Paper Analysis**: Reads PDF, skims key sections, creates outline
3. **Draft Summary**: Writes ~1500-word summary with all required sections:
   - Title and citation
   - TL;DR (4-6 bullets)
   - Problem and Motivation
   - Core Idea and Contributions
   - Method (plain-language)
   - Comparison to Prior Work (1-3 contrasts)
   - Results and What They Mean
   - Limitations and Failure Modes
   - Fit to This Course (explicit tie to week's topics)
   - Discussion Questions (5)
   - Glossary (8-12 terms)
   - References
4. **Quality Assurance**: Verifies length, sections, claim checks (5-8)
5. **Update TODO**: Marks completed steps with [x]

### Output
- Summary saved to: `summaries/{slug}.md`
- Optional notes: `work/notes/{slug}.md`
- TODO.md updated with completion status

## Advantages Over Manual Prompting

1. **Fresh Context**: Each paper processed by a new agent invocation eliminates context accumulation
2. **Consistent Structure**: Agent definition enforces the exact format from `Prompt.md`
3. **Automated Orchestration**: Slash commands handle the workflow loop
4. **No Manual Variable Binding**: Agent reads TODO.md and extracts metadata automatically
5. **Quality Checklist Built-In**: Agent enforces all acceptance criteria

## Files This Replaces

- ~~`Prompt.md`~~ → Integrated into `paper-summarizer.md` agent definition
- ~~`repeat-prompt.md`~~ → Replaced by `/next-paper` command
- Manual variable binding → Automated via TODO.md parsing

## Next Steps

To process the remaining papers:

1. Run `/next-paper` to process one paper at a time, OR
2. Run `/process-all-papers` to process all remaining papers sequentially

Each invocation will:
- Start with fresh context (no accumulated conversation history)
- Read TODO.md to get the current state
- Process exactly one paper
- Update TODO.md with completion status
- Return control to you

## Notes

- The agent follows the exact same prompt template from `Prompt.md`
- All acceptance criteria are built into the agent's quality checklist
- Course context is read fresh from `course-syllabus.md` for each paper
- TODO.md serves as the single source of truth for progress tracking
- For Constitutional AI duplicates, the agent uses: `Constitutional_AI_Harmlessness_Bai_2022.pdf`
