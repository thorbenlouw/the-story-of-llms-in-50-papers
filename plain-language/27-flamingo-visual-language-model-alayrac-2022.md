# When Language Models Learned To See

## The Paper

Flamingo: a Visual Language Model for Few‑Shot Learning — Jean‑Baptiste
Alayrac, Relja Arandjelović, et al. (2022).

## Before the Breakthrough

Large language models showed an astonishing talent for few‑shot learning in
text: give a handful of examples in the prompt and they adapt. Meanwhile,
vision–language systems tended to be task‑specific: new dataset, new head,
another fine‑tune. The field needed a way to bring the “prompt it, don’t
retrain it” ethos to images + text.

## The Big Idea: Bridge Vision Features Into an LLM and Prompt It

Flamingo connects a strong image encoder to a strong language model with a set
of cross‑attention layers, then trains those lightweight connectors so text
tokens can attend to visual features. At inference time, you can interleave
images and text in a single sequence and do few‑shot learning—just like in text
only—across captioning, VQA, and reasoning tasks.

Two analogies help. First, think of adding an HDMI adapter to a great monitor.
You don’t rebuild the whole screen; you add the right port so existing hardware
can talk. Second, picture a skilled translator joining two experts in the same
room: the translator doesn’t need to be an expert in either domain, only to map
concepts faithfully so the conversation flows.

Why it works:
- Freeze most of the vision and language backbones so they keep their broad
  knowledge and generalisation.
- Train a modest number of connector layers to align modalities so prompting
  works across them.

## What It Enabled

Flamingo delivered strong few‑shot results across diverse image–text tasks
without per‑task heads or extensive fine‑tuning. It validated a simple
proposition: if you give an LLM the right “view” of an image, its in‑context
learning extends surprisingly well to multimodal settings. That set the tone
for a wave of follow‑ups and open implementations.

There are limits. Without retrieval or explicit grounding, models can still
hallucinate visual details; resolution and token budgets cap how much imagery
you can process. But as a recipe—frozen backbones + learned cross‑modal
connectors + prompting—Flamingo became the blueprint that open systems would
adapt next.

## Where It Fits In Our Story

Having taught models to think (CoT), act (ReAct), and call tools (Toolformer,
Gorilla), we now extend the canvas: look as well as read. Flamingo is the first
stop in the multimodal arc, showing that the LLM way of doing things (prompt,
don’t rewire) can work for images too—if you insert the right bridges.

The next step brings this recipe into the open: LLaVA shows you can get capable
multimodal chat with a simple visual adapter and instruction tuning.

## Conclusion: One Interface, Many Modalities

Flamingo unifies images and text under a single prompting interface. That’s the
key idea of modern assistants: one model, many inputs, minimal task‑specific
plumbing.

[Paper](llm_papers_syllabus/Flamingo_Visual_Language_Model_Alayrac_2022.pdf)
## See Also
- Prev: [Gorilla: API‑Accurate Generation](26-gorilla-llm-connected-apis-patil-2023.md)
- Next: [LLaVA: Visual Instruction Tuning](28-llava-visual-instruction-tuning-liu-2023.md)

