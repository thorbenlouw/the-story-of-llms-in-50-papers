# Phase III — Alignment, Evaluation, and Safety

Powerful models aren’t automatically useful or safe. This phase covers the
techniques that shape behaviour (instruction tuning, preference learning,
constitutions), the benchmarks that reveal strengths and blind spots, and the
surprising ways abilities can emerge—sometimes with risks attached.

## Why this phase matters

Unaligned models do what the loss rewards, not what people want. FLAN showed
that instruction tuning unlocks useful zero‑shot behaviours. InstructGPT
introduced Reinforcement Learning from Human Feedback (RLHF), aligning outputs
to human preferences. DPO simplified that alignment by skipping the reward
model. Constitutional AI (CAI) swapped many human labels for AI feedback guided
by written principles, making harmlessness more scalable and legible.

We also need to measure broadly. HELM and BIG‑bench expanded evaluation beyond a
single leaderboard, probing capabilities, risks, and costs. Meanwhile, work on
emergent abilities cautioned that some skills (and failure modes) can appear
abruptly with scale. TruthfulQA examined a specific hazard: models confidently
repeating human falsehoods.

## What we cover

- FLAN (Wei et al.): instruction tuning to follow natural‑language commands.
- InstructGPT and DPO: aligning with human preferences, with and without a
  reward model.
- Constitutional AI (Bai et al.): principle‑guided AI feedback for scalable
  harmlessness.
- HELM and BIG‑bench: broad, multi‑metric evaluation across tasks and risks.
- TruthfulQA and faithfulness in CoT: separating good answers from convincing
  but unfaithful reasoning.

## How to read this phase

Keep two lenses in mind:
- Behaviour shaping: datasets, objectives, and principles steer the same base
  model toward very different personas. This is where “helpful, harmless,
  honest” is operationalised.
- Evidence over vibes: prefer multi‑metric, scenario‑aware evaluations and
  targeted probes for failure modes (truthfulness, robustness, bias).

## Bridge to what’s next

Aligned models can still hit knowledge limits or make arithmetic slips. Phase
IV turns LLMs from static talkers into active agents: think step‑by‑step, use
tools, retrieve facts, and understand images—with grounding that lets them point
as well as describe.

## See Also
- Start: [13 — FLAN: Instruction Tuning](13-flan-finetuned-zero-shot-wei-2021.md)
- End: [22 — Measuring Faithfulness in Chain‑of‑Thought](22-measuring-faithfulness-cot-lanham-2023.md)
