# Writing the Rulebook for Safer, Still-Helpful AI

## The Paper

Constitutional AI: Harmlessness from AI Feedback — Yuntao Bai, Saurav Kadavath,
Sandipan Kundu, Amanda Askell, Jackson Kernion, Andy Jones, et al. (Anthropic,
2022).

## Before the Breakthrough

Instruction-following models were getting good at doing what we ask, but that
raised a harder question: how do we keep them helpful without letting them go
off the rails? Early RLHF systems often chose the safe path by refusing to
answer anything risky. That solved some safety cases, but it also produced a new
failure mode—evasion. Users don’t want a model that shuts down at the first
hint of a sensitive topic; they want one that acknowledges the risk, explains
why it can’t comply, and, when possible, offers a safer alternative.

RLHF also relies heavily on people: thousands of human comparisons to train a
reward model. That’s slow, expensive, and hard to iterate. Worse, the final
behaviour emerges from a soup of individual labels—opaque and hard to reason
about. If you want to change the model’s stance on, say, medical advice or hate
speech, do you really have to recollect and retrain everything?

Anthropic’s answer was to turn the model toward a small, legible rulebook—a
"constitution"—and use AI feedback to scale. The goal wasn’t to make the model
say “no” more often; it was to make it say “no” better, and say “yes” safely
when that’s appropriate.

## The Big Idea: Principles First, AI Feedback at Scale

Constitutional AI (CAI) replaces most human labels for harmlessness with
AI‑generated feedback, guided by a written set of simple principles—the
constitution. Think of this constitution as a company handbook or a newsroom
style guide: short, explicit rules like “avoid encouraging illegal activity” or
“be respectful and non‑toxic”. Instead of baking norms into millions of opaque
labels, you write them down once and refer to them everywhere.

Two cornerstone ideas underpin the method:

- Self‑critique and revision (SL‑CAI): the model generates a response to a
  red‑team prompt, then critiques its own answer using the constitution, and
  rewrites it to adhere to the principles. This repeats a few times, producing a
  revised, harmless answer that becomes fine‑tuning data.
- RL from AI Feedback (RL‑CAI / RLAIF): the model generates pairs of responses;
  another model—prompted with the constitution—chooses which aligns better with
  the principles. Those AI preferences (for harmlessness) are combined with a
  small set of human preferences (for helpfulness) to train a preference model,
  which then guides reinforcement learning.

Two analogies make this concrete:

- Code review with a style guide: engineers propose code (model responses), the
  reviewer flags violations against a documented standard (constitution), and
  the author revises until it passes. Over time the team internalises the
  standard.
- A car with manners, not just brakes: older systems slammed the brakes (refuse)
  at any risk. CAI teaches the car to slow down, signal, explain, and choose a
  safer route when possible—staying helpful while avoiding harm.

Chain‑of‑thought plays an important role. Asking the model to “think
step‑by‑step” while critiquing makes the AI feedback more consistent and easier
to audit. The critiques needn’t be perfect; the act of structured reflection
improves the revisions and clarifies why an answer changes.

## Why It Mattered: Less Evasion, More Transparency, Faster Iteration

CAI delivers three big wins for assistants in the real world:

- Harmlessness without stonewalling: Models trained with a constitution are less
  likely to give unsafe outputs, yet they also avoid blanket refusals. They
  explain risks, suggest alternatives, or set boundaries—more useful behaviour
  for sensitive queries.
- Scalable supervision: Replacing most human harmlessness labels with
  AI‑generated ones slashes annotation costs. Want to adjust the model’s
  behaviour? Edit the principles and regenerate feedback, rather than spinning
  up a massive labelling effort.
- Interpretability of objectives: A short list of principles is easier to read
  and debate than a black‑box reward model distilled from tens of thousands of
  comparisons. Policymakers, safety teams, and users can understand the intended
  behaviour in plain English.

Empirically, the paper shows that self‑critique and revision steadily reduce
harmfulness; that chain‑of‑thought improves AI feedback quality; and that,
combined with a small amount of human helpfulness data, the resulting models can
match or exceed RLHF baselines on harmlessness—while staying engaged.

There are caveats. A constitution encodes values; choosing and updating
principles is a governance decision, not just engineering. AI‑generated labels
can drift or “Goodhart” the proxy if pushed too hard; periodic human audits and
red‑teaming remain essential. And helpfulness still benefits from human
preferences—the method combines AI‑labelled harmlessness with human‑labelled
helpfulness for balance.

## Where It Fits in Our Story

Within Phase III (alignment and safety), CAI sits alongside InstructGPT and DPO
as a complementary path. InstructGPT showed how to optimise for human
preferences with RLHF; DPO simplified that optimisation. Constitutional AI
reimagines the supervision source for harmlessness: write down the rules, use AI
to enforce them at scale, and reserve humans for helpfulness and oversight.

Strategically, CAI shifts the bottleneck from labelling to principle design and
evaluation. That aligns with how real organisations work: values are debated and
codified, then procedures enforce them. As assistants move from lab demos to
products, having a transparent rulebook—and a fast way to update it—may matter
as much as raw capability.

Looking forward, you’ll see this theme recur: better constitutions, multi‑
objective trade‑offs (helpful vs harmless vs honest), and hybrid pipelines that
mix human, AI, and automated tests. But the core insight remains powerful:
instead of encoding behaviour implicitly in mountains of labels, write your
goals down and teach the model to live by them.

[Paper](llm_papers_syllabus/Constitutional_AI_Harmlessness_Bai_2022.pdf)
## See Also
- Prev: [DPO: Direct Preference Optimization](19-dpo-direct-preference-optimization-rafailov-2023.md)
- Next: [TruthfulQA](21-truthfulqa-measuring-falsehoods-lin-2021.md)
