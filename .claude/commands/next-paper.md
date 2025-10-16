Read TODO.md and find the first Active Task Instance where step 1 is marked [ ] (incomplete).

Extract all the metadata from that instance's Context section (paper title, authors, year, PDF path, week, section, task instance number).

Then invoke the paper-summarizer agent from .claude/agents/paper-summarizer.md with those extracted inputs to generate the summary.
