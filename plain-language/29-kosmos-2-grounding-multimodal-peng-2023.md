# From “See and Tell” to “See and Point”

## The Paper

Kosmos‑2: Grounding Multimodal Large Language Models to the World — Zhenzhong
Peng, Zhiliang Peng, et al. (2023).

## Before the Breakthrough

Multimodal assistants could describe images and answer questions, but they were
vague about where things were—no way to say “this box is the red car”. For
real‑world tasks like UI automation, shopping assistants, or visual tutoring, we
need spatial precision. It’s the difference between “there’s a button” and
“click this button”.

## The Big Idea: Add Spatial Tokens and Train on Grounding

Kosmos‑2 keeps the vision‑to‑LLM bridge but adds supervision that teaches the
model to output structured tokens representing bounding boxes (e.g.,
<box x1,y1,x2,y2>). With datasets that pair text and regions, the model learns
not just to talk about objects but to point to them.

Two analogies clarify the shift. First, think of giving directions on a map.
Saying “the café is nearby” is descriptive; dropping a pin is grounded. Second,
consider pair‑programming a UI test: “click the second icon from the left” is
ambiguous; “click [x1,y1,x2,y2]” is executable.

Why it works:
- Structured output tokens give the model a schema for localisation that slots
  into its normal text generation.
- Region‑level supervision links semantics (“the red car”) to coordinates, so
  language and space align.

## What It Enabled

With grounded outputs, assistants can handle referring expressions (“highlight
that lamp”), guide attention (“the error is here”), and take first steps toward
manipulating scenes or interfaces. Benchmarks show improved localisation and
referring comprehension versus models that only “see and tell”.

Limits remain: boxes are coarse compared to segmentation masks; data diversity
matters; and ambiguous requests need clarification strategies. But the upgrade
from narrative to coordinates is pivotal for practical multimodal agents.

## Where It Fits In Our Story

Flamingo and LLaVA showed how to combine image features with LLM prompting and
instruction tuning. Kosmos‑2 adds the next capability layer: precise reference.
It complements our agent theme—if an agent can point, it can act more safely and
reliably. Combine grounding with ReAct‑style tool use and you can imagine
pipelines like “crop region → run OCR → answer question”, all steered by a
single model.

## Conclusion: Make Words Point

Grounding turns descriptions into actionable references. It’s a small addition
on paper—some new tokens, some new data—but it unlocks a big step toward useful
multimodal agents.

[Paper](llm_papers_syllabus/Kosmos_2_Grounding_Multimodal_Peng_2023.pdf)
## See Also
- Prev: [LLaVA: Visual Instruction Tuning](28-llava-visual-instruction-tuning-liu-2023.md)

