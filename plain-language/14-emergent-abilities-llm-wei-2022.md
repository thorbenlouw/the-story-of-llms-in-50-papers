# The Day New Skills Popped Out of Nowhere

## The Paper

Emergent Abilities of Large Language Models — Jason Wei, Yi Tay, Rishi
Bommasani, Colin Raffel, Barret Zoph, Sebastian Borgeaud, Dani Yogatama,
Maarten Bosma, Denny Zhou, Donald Metzler, Ed H. Chi, Tatsunori Hashimoto,
Oriol Vinyals, Percy Liang, Jeff Dean, William Fedus (2022).

## Before the Breakthrough

Scaling laws gave us a comforting story: make models bigger, give them more
compute and data, and performance improves smoothly. That was mostly true—if you
measured cross‑entropy loss (how well the model predicts the next token). But in
practice, users care about discrete skills: getting a maths question right,
solving a riddle, following instructions. For many of these, small models looked
hopeless—near random. Then, past some size, performance jumped dramatically.

It felt like boiling water. Heat it and nothing obvious happens—until a precise
moment when liquid becomes steam. For language models, increasing parameters or
compute sometimes triggers a similar phase change: an ability that seemed absent
suddenly appears. The field needed to catalogue when and where these “now you
see it” jumps happen, and what that means for planning and safety.

## The Big Idea: Emergence as a Phase Transition

This paper defines an emergent ability as one that is not present in smaller
models but appears in larger ones—where you cannot predict the jump by simply
extrapolating from small sizes. Across multiple model families (GPT‑3, LaMDA,
Gopher, Chinchilla, PaLM), the authors document dozens of such step‑changes.

Two cornerstone ideas make this useful:

- Phase transitions: plots of task accuracy vs scale are flat at chance levels,
  then rise sharply after a threshold (often around 10B–100B parameters or
  10^22–10^24 training FLOPs).
- Prompting matters: some “abilities” emerge only when you add the right
  prompting strategies—chain‑of‑thought, self‑consistency, or instruction
  following—and only once models are large enough to benefit.

Think of a climbing wall with coloured holds. Smaller models can’t reach certain
routes—no matter how cleverly you coach them. As models grow, their “wingspan”
changes: suddenly a route that was impossible becomes reachable. Or picture a
radio tuning knob: below a threshold the station is static; past a point the
signal snaps into clarity. Emergence is that snap.

The catalogue spans arithmetic, logic, analogical reasoning, truthfulness,
social/emotional understanding, and broad knowledge exams like MMLU. The paper
also shows why smooth loss doesn’t contradict jagged task curves: discrete
metrics hide gradual probability shifts that only register once a threshold is
crossed (e.g., moving from 49% to 51% flips accuracy).

## Why It Mattered: Planning, Risk, and Realistic Expectations

Emergence changes how teams plan and how policymakers think about risk:

- Forecasting limits: You can’t assume a linear glide path from small models to
  large. Some abilities won’t show up at all—until they do, abruptly. That makes
  “capability forecasting by extrapolation” unreliable.
- Practical triggers: Knowing rough thresholds helps decide whether to invest in
  new prompting methods or more scale. Chain‑of‑thought helps a lot—once you’re
  big enough. Below that, it’s mostly noise or verbosity.
- Safety mirrors capability: If helpful abilities can emerge unpredictably, so
  can dangerous ones. The paper underscores the need for better evaluations and
  red‑teaming as we cross new scale regimes.

It also reframes why “bigger” sometimes seems to win suddenly. A downstream task
might require several sub‑skills (parse the question, recall a fact, apply a
rule). If each sub‑skill improves smoothly with scale, the probability that all
are present simultaneously can still jump sharply once you pass the point where
most are reliable. That composition effect produces step‑like behaviour from
smooth ingredients.

## Where It Fits in Our Story

In Phase II, we learned to scale and to spend compute wisely (Kaplan,
Hoffmann). Emergent Abilities is the caution sign on that highway: some exits
appear only at speed. It explains why instruction tuning (FLAN) and prompting
techniques (chain‑of‑thought) suddenly “work” on large models after seeming
pointless on smaller ones, and why evaluation suites like BIG‑bench and HELM
matter to see broad patterns rather than chase single‑number scores.

Looking ahead, this lens informs alignment and safety. We should expect new
skills—and new failure modes—to appear at thresholds. That argues for staged
rollouts, capability evaluations tied to scale, and mitigating strategies (like
retrieval or tool‑use) that may substitute for sheer parameter count when we
want specific behaviours without surprises.

[Paper](llm_papers_syllabus/Emergent_Abilities_LLM_Wei_2022.pdf)
## See Also
- Prev: [FLAN: Instruction Tuning](13-flan-finetuned-zero-shot-wei-2021.md)
- Next: [HELM: Holistic Evaluation](15-helm-holistic-evaluation-liang-2022.md)
