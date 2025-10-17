# A Community Stress Test for Language Models

## The Paper

Beyond the Imitation Game: Quantifying and Extrapolating the Capabilities of
Language Models (BIG‑bench) — Srivastava et al. (2022).

## Before the Breakthrough

By 2021, narrow leaderboards like GLUE and SuperGLUE were largely solved by
pretrain‑and‑fine‑tune recipes. Yet real users needed broader skills: reasoning,
maths, calibration, safety, creativity. Evaluations were piecemeal and often
incomparable. The field needed a big, varied, extensible testbed that reflected
the messy reality of what we want from LLMs—and a way to see how prompting and
scale actually change outcomes.

## The Big Idea: Many Tasks, Shared Protocols, Human Baselines

BIG‑bench assembled 200+ tasks authored by a community of contributors, spanning
reasoning, knowledge, maths, code, translation, and safety/bias. It standardised
prompting styles (few‑shot, multiple‑choice, free‑form), recorded exact prompts
for reproducibility, and reported human baselines to calibrate difficulty.

Two cornerstone ideas stand out:

- Breadth with structure: by grouping tasks into categories, the benchmark lets
  you see aggregate trends without losing task‑level detail.
- Prompt sensitivity as a first‑class topic: the suite probes how small wording
  changes and shot counts swing performance, cautioning against single‑number
  rankings.

Analogy: Think of BIG‑bench as a decathlon for LLMs. No single event tells you
who’s best overall, and tiny changes in conditions can tilt the results. Or
picture a wind‑tunnel test: same rig, different shapes (tasks), measuring not
just speed but stability.

The results? Scaling helps—but unevenly. Larger models often improve across many
tasks, yet stubborn gaps remain in compositional reasoning and calibration.
Human baselines still lead in a nontrivial slice. And prompt tweaks can change
scores by double digits, reminding us that “prompt engineering” is part of the
system, not a nuisance variable.

## Why It Mattered: Better Questions, Better Comparisons

BIG‑bench reoriented evaluation culture:

- It nudged the community to report not only averages but distributions across
  task types and prompt variants.
- It seeded follow‑ups (e.g., BIG‑bench Hard) and inspired broader frameworks
  like HELM to put standardisation and multi‑metric reporting front and centre.
- It made human baselines normal, clarifying when “near human” claims were real.

For teams, the practical lesson is to validate across diverse tasks and prompt
formats before declaring victory. A model that excels on translation may falter
on logic puzzles; a template that shines on one model may sink another. Shared
protocols and recorded prompts make comparisons fair instead of folklore.

## Where It Fits in Our Story

BIG‑bench sits in Phase III alongside HELM as complementary lenses. HELM maps
the scenario space and measures societal risks; BIG‑bench supplies a rich task
garden to probe capabilities and prompt dependence. Together they helped the
field move beyond narrow leaderboards toward realistic, multi‑faceted
evaluation—exactly what we need as models shift from lab demos to deployed
assistants.

[Paper](llm_papers_syllabus/BIG_Bench_Beyond_Imitation_Game_Srivastava_2022.pdf)
## See Also
- Prev: [HELM: Holistic Evaluation](15-helm-holistic-evaluation-liang-2022.md)
- Next: [InstructGPT (RLHF)](17-instructgpt-training-instructions-ouyang-2022.md)
