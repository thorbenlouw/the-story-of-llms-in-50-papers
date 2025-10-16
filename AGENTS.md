# Repository Guidelines

## Project Structure & Module Organization
- Root contains course content in Markdown (syllabus, prompts, prose notes).
- `summaries/` holds paper summaries named `short-title-author-year.md` (kebab-case).
- `llm_papers_syllabus/` stores downloaded PDFs managed by `download_papers.sh`.
- `download_papers.sh` fetches canonical PDFs from arXiv/URLs.
- `work/` is for scratch or temporary files (avoid committing large binaries here).

## Build, Test, and Development Commands
- `bash download_papers.sh` — downloads/updates PDFs into `llm_papers_syllabus/`.
- No build step is required; open `.md` files in your editor to preview.
- Optional: `rg "\[(.*)\]\((llm_papers_syllabus/.*\.pdf)\)` — quickly list local PDF references to verify.

## Coding Style & Naming Conventions
- Use Markdown with Title Case headings (`#`, `##`), `-` for bullets, backticks for commands/paths.
- Keep lines reasonably short (~100 chars) and wrap paragraphs for diffs.
- Filenames:
  - Prose/notes at root: `<topic>-prose.md` (e.g., `flashattention-prose.md`).
  - Summaries in `summaries/`: `<short-title>-<author>-<year>.md` (e.g., `scaling-laws-neural-language-models-kaplan-2020.md`).
- Prefer relative links to local assets, e.g., `[Paper](llm_papers_syllabus/Attention_Is_All_You_Need_Vaswani_2017.pdf)`.

## Testing Guidelines
- No automated tests. Self-check before PR:
  - Markdown renders without errors (headings, lists, code fences).
  - All local PDF links exist in `llm_papers_syllabus/` (run the download script if needed).
  - Cross-links between docs (e.g., `README.md`, `TODO.md`) resolve.

## Commit & Pull Request Guidelines
- History favors short, descriptive messages (e.g., “checkpoint”). Prefer imperative subjects:
  - `Add summary: scaling-laws-kaplan-2020`
  - `Update syllabus week 5 (MoE)`
- Keep commits focused; avoid committing large PDFs manually (script manages PDFs).
- PRs include: purpose, key files changed, links to related `TODO.md` items, and (if structure changes) a screenshot of rendered Markdown.

## Security & Configuration Tips
- `download_papers.sh` performs network downloads; run where network access is permitted.
- Do not commit secrets or machine-specific paths. Large binaries belong in `llm_papers_syllabus/` only if produced by the script.

## Agent-Specific Instructions
- Keep edits surgical and within scope; respect existing naming and layout.
- Do not rename/delete PDFs; update `download_papers.sh` when adding new papers.
- Before adding new docs, check `summaries/` to avoid duplicates and reuse patterns.

