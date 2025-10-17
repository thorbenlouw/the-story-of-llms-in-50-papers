# An Open Recipe for Multimodal Chat

## The Paper

Visual Instruction Tuning (LLaVA) — Haotian Liu, Chunyuan Li, et al. (2023).

## Before the Breakthrough

Flamingo showed that you can prompt a multimodal model like an LLM if you bridge
image features into text space. But the field lacked an open, reproducible
recipe for a chatty assistant that could talk about images, follow instructions,
and behave helpfully. Proprietary systems sprinted ahead; the community needed a
clear path it could run.

## The Big Idea: A Simple Visual Adapter + Instruction Tuning

LLaVA connects a pretrained vision encoder to a pretrained LLM with a small
projection layer (a “visual adapter”) and then instruction‑tunes the combined
system on curated image–text conversations. The adapter maps visual features
into the LLM’s token space; instruction tuning teaches good behaviour and
response style.

Two analogies bring this to life. First, think of adding a camera to a smart
speaker: the speaker doesn’t need a new brain; it just needs a clean cable to
send the right signals and a bit of coaching on how to talk about what it sees.
Second, imagine you’re onboarding a new colleague. They already know the domain
well; you mainly teach them your team’s etiquette and workflows. Instruction
tuning is that onboarding.

Why it works:
- The visual adapter is lightweight, so most capacity remains in strong
  backbones you don’t have to retrain.
- Instruction tuning, already proven in text‑only LLMs, transfers directly to
  multimodal chat—“be helpful, harmless, and honest” applies to images too.

## What It Enabled

LLaVA delivered capable open‑source multimodal assistants with modest compute
and simple components. It made it far easier for researchers and builders to
experiment, extend, and deploy systems that can look at screenshots, diagrams,
or photos and hold sensible conversations about them.

There are limits: visual hallucinations still happen, and the model lacks
explicit spatial grounding. But by lowering the barrier to entry, LLaVA helped
turn multimodal chat into a common baseline rather than a lab curiosity.

## Where It Fits In Our Story

Flamingo established the connector blueprint; LLaVA brought it into the open
with instruction tuning. This sits alongside our agent storyline: the same
alignment techniques that make text‑only models follow instructions also make
image‑aware models more usable. Next, we’ll tackle grounding—moving from “see
and tell” to “see and point”, where the model can refer to precise regions.

## Conclusion: Open, Practical, and Extensible

LLaVA showed that you don’t need exotic machinery to get a good multimodal
assistant. A clean adapter and good coaching go a long way.

[Paper](llm_papers_syllabus/LLaVA_Visual_Instruction_Tuning_Liu_2023.pdf)
## See Also
- Prev: [Flamingo: Multimodal Few‑Shot](27-flamingo-visual-language-model-alayrac-2022.md)
- Next: [Kosmos‑2: Grounded Multimodal](29-kosmos-2-grounding-multimodal-peng-2023.md)

