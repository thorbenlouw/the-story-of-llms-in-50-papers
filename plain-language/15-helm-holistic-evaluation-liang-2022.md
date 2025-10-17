# From Leaderboards to Reality Checks

## The Paper

HELM: Holistic Evaluation of Language Models — Percy Liang, Rishi Bommasani,
Tony Lee, Dimitris Tsipras, Dilara Soylu, Michihiro Yasunaga, and collaborators
at Stanford CRFM (2022/2023).

## Before the Breakthrough

Before HELM, evaluation was a mess. Different models were tested on different
datasets, under different prompting setups, with different metrics. One paper
used fine‑tuning; another used zero‑shot; a third reported five‑shot—but with a
custom template. Accuracy ruled the day; fairness, robustness, toxicity, and
efficiency were afterthoughts. Comparing models felt like comparing cars on
different tracks, in different weather, with different drivers.

As language models moved into products—search, assistants, moderation—this was a
problem. Teams needed to understand not just “Can it get the answer right?” but
also “Is it robust?”, “Does it behave fairly across dialects?”, “How toxic are
its outputs?”, and “What are the serving costs?”.

## The Big Idea: Evaluate Broadly, Measure Many Things, Standardise

HELM reframes evaluation around three principles:

- Broad coverage with honest gaps: taxonomise scenarios as task × domain ×
  language, then deliberately select a diverse subset. Make omissions explicit so
  the community sees what’s missing.
- Multi‑metric by default: for each scenario, measure seven desiderata—accuracy,
  calibration, robustness, fairness, bias, toxicity, efficiency—so gains and
  trade‑offs are visible.
- Standardised conditions: evaluate many models on the same scenarios with the
  same 5‑shot prompting and reporting, so results are comparable.

Analogy: HELM is a vehicle inspection, not a single lap time. It looks under the
bonnet, checks brakes and emissions, and prints a full report—strengths, risks,
and costs. Or think of a nutrition label: not just calories (accuracy), but
salt, sugar, fibre (robustness, fairness, toxicity) per serving.

The initial release covered 16 core scenarios and 26 targeted ones, totalling
nearly 5,000 runs and over 12 billion tokens. Findings included: instruction‑
tuned models (e.g., InstructGPT) outperformed much larger untuned ones; models
over 50B parameters formed a tier on accuracy, but instruction tuning offered a
more compute‑efficient path; prompt formatting could swing accuracy by
double‑digits; and performance disparities appeared across dialects (e.g.,
African American English vs White English).

## Why It Mattered: Clearer Choices, Fewer Illusions

HELM brought discipline and transparency:

- Apples‑to‑apples comparisons: same scenarios, same prompts, same metrics.
- Societal metrics up front: no more burying fairness/toxicity in appendices.
- Reproducibility: public website with prompts, predictions, and an open codebase
  to extend scenarios and models.

For practitioners, this means fewer surprises in deployment. A model that shines
on accuracy but fails robustness under perturbation is a risk; a model that
looks fair on average but underperforms on certain dialects may need domain‑
specific tuning or guardrails. HELM surfaces these issues early.

The project also normalised a multi‑dimensional mindset: accuracy gains often
correlate with robustness and fairness, but not always; instruction tuning can
dominate scale; and prompt sensitivity is real—small template changes can flip
rankings. These are actionable insights for product teams.

## Where It Fits in Our Story

HELM anchors Phase III’s evaluation narrative. After learning to make models
helpful (FLAN, InstructGPT, DPO) and safer (Constitutional AI), we need a clear
view of how they behave in the wild. HELM’s taxonomy and multi‑metric approach
complement BIG‑bench’s task breadth: one maps the space of scenarios and risks;
the other probes diverse capabilities and prompt sensitivity.

As we push to tools and agents (Phase IV), this evaluation mindset carries over:
measure robustness to tool failures, fairness in retrieval‑augmented settings,
and efficiency under real load. HELM’s core lesson is simple but profound:
choose models with a dashboard, not a single dial.

[Paper](llm_papers_syllabus/HELM_Holistic_Evaluation_Liang_2022.pdf)
## See Also
- Prev: [Emergent Abilities of LLMs](14-emergent-abilities-llm-wei-2022.md)
- Next: [BIG-bench](16-big-bench-beyond-imitation-game-srivastava-2022.md)
