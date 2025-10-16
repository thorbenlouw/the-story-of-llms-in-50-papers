# Agent-Based Paper Processing - Quick Start

## What Changed?

Your prompt workflow has been transformed into a reusable Claude Code sub-agent system.

### Before (Manual)
```
1. Read Prompt.md
2. Read repeat-prompt.md
3. Manually fill in variables for each paper
4. Run prompt with accumulated context
5. Manually track completion
```

### After (Automated)
```
1. Run: /next-paper
   (Agent reads TODO.md, extracts metadata, processes paper, updates TODO.md)
2. Repeat as needed
```

## How It Works

### Architecture

```
┌─────────────────┐
│   TODO.md       │  ← Single source of truth
│  (task list)    │     for progress tracking
└────────┬────────┘
         │
         ↓ reads
┌─────────────────────────────────────┐
│  /next-paper                        │  ← Slash command
│  (finds next incomplete paper)      │
└────────┬────────────────────────────┘
         │
         ↓ invokes
┌─────────────────────────────────────┐
│  paper-summarizer agent             │  ← Sub-agent (fresh context)
│  (.claude/agents/paper-summarizer.md)│
│                                     │
│  • Reads syllabus                   │
│  • Reads PDF                        │
│  • Generates summary                │
│  • Updates TODO.md                  │
└─────────────────────────────────────┘
```

### Key Benefits

1. **Fresh Context**: Each paper processed by a new agent = no context bloat
2. **Automated Metadata**: Agent reads TODO.md directly (no manual variable binding)
3. **Consistent Quality**: Built-in checklist enforces all acceptance criteria
4. **Simple Orchestration**: Two slash commands handle everything

## Usage

### Process One Paper

```bash
/next-paper
```

This will:
1. Find the first incomplete paper in TODO.md
2. Launch a fresh agent with that paper's metadata
3. Agent reads the PDF and generates summary
4. Agent updates TODO.md with completion status
5. Summary appears in `summaries/`

### Process All Remaining Papers

```bash
/process-all-papers
```

This will:
1. Repeatedly invoke `/next-paper`
2. Each paper gets fresh agent context
3. Continues until all papers complete

## What's in .claude/

```
.claude/
├── README.md                    # Detailed documentation
├── agents/
│   └── paper-summarizer.md     # The sub-agent (replaces Prompt.md)
└── commands/
    ├── next-paper.md           # Process next paper (replaces repeat-prompt.md)
    └── process-all-papers.md   # Process all papers
```

## Example: Process Next Paper

Looking at TODO.md, you have 15 active task instances. Many are already complete (tasks 001-015 are all complete).

To find what's left and process it:

```bash
/next-paper
```

The agent will:
- Scan TODO.md for the first instance with `[ ]` in step 1
- Extract: title, authors, year, PDF path, week, section, instance number
- Read: `llm_papers_syllabus/{PDF_FILENAME}`
- Read: `course-syllabus.md` for week's "Key Topics & Labs"
- Generate: `summaries/{slug}.md` (~1500 words with all required sections)
- Update: TODO.md marking steps [x]

## Current Status

From TODO.md, I can see:
- **Completed**: Task instances 001-015 (all 12 steps marked [x])
- **Remaining**: Check TODO.md for any instances with incomplete `[ ]` tasks

## Next Steps

1. **Review the setup**: Read `.claude/README.md` for full details
2. **Test the workflow**: Run `/next-paper` to process one paper
3. **Batch process**: Run `/process-all-papers` to complete all remaining

## Troubleshooting

**Q: How do I see what papers are left?**
```bash
grep -n "^\- \[ \] 1\." TODO.md
```

**Q: Can I manually invoke the agent?**
Yes, but `/next-paper` is easier. Manual invocation requires:
```
Use the Task tool with subagent_type="general-purpose" and include
the full instructions from .claude/agents/paper-summarizer.md plus
all the paper metadata.
```

**Q: What if I want to customize the summary format?**
Edit `.claude/agents/paper-summarizer.md` (Step 3: Draft Summary section)

**Q: How do I add more papers?**
Add new "Active Task Instance" blocks to TODO.md following the template

## Files Reference

- **Original prompts**: `Prompt.md`, `repeat-prompt.md` (now deprecated)
- **Agent definition**: `.claude/agents/paper-summarizer.md`
- **Commands**: `.claude/commands/next-paper.md`, `process-all-papers.md`
- **Task tracking**: `TODO.md` (unchanged format)
- **Course context**: `course-syllabus.md` (unchanged)
- **Papers**: `llm_papers_syllabus/*.pdf` (unchanged)
- **Outputs**: `summaries/*.md` (unchanged)

---

**Ready to start?** Run: `/next-paper`
