# Phase I — The Transformer Foundations

Modern language models begin here. This phase explains the architectural break
from the RNN era and sets the vocabulary we’ll use for the rest of the course:
attention, tokens, embeddings, pre‑training, and positional information. It’s
about replacing a sequential assembly line with a parallel conversation, where
every word can look at every other word at once.

## Why this phase matters

Before 2017, Recurrent Neural Networks (RNNs) ruled NLP. They processed text in
order, which made long‑range dependencies fragile and training slow to scale.
“Attention Is All You Need” introduced the Transformer and its self‑attention
mechanism—an idea that solved both memory and scale. Everything that follows in
this course—GPTs, BERTs, T5, alignment, tools, agents—assumes Transformers as
the substrate. If you grok this phase, the rest of the story snaps into focus.

Two cornerstones anchor this chapter:
- Self‑attention: a token can selectively “attend” to other tokens to build its
  representation. This is a cornerstone concept we’ll rely on constantly.
- Parallelism: attention breaks the sequential bottleneck, letting us train at
  scale and capture long‑distance relationships.

## What we cover

- Transformer basics (Vaswani et al.): attention, feed‑forward blocks, and
  positional information.
- GPT‑style pre‑training (Radford et al.): next‑token prediction as a universal
  learning signal for generation.
- BERT‑style pre‑training (Devlin et al.): masked language modelling for deep,
  bidirectional understanding—great for search and analysis.
- T5 (Raffel et al.): the “text‑to‑text” unification that turns many tasks into
  one interface—text in, text out.
- RoFormer (Su et al.): rotary positional embeddings, a practical refinement
  that improves long‑context behaviour and extrapolation.

## How to read this phase

Keep three mental models handy:
- Architecture as a contract: GPT, BERT, and T5 share the same Transformer
  parts but wire them differently for different strengths.
- Pre‑training as a habit: next‑token prediction and masked‑token recovery teach
  useful behaviours that you can adapt with light fine‑tuning.
- Position as structure: how a model encodes order matters for length and
  generalisation.

## Bridge to what’s next

Once the blueprint is set, the game shifts to scale: how far can we push these
models, and how do we spend compute wisely? Phase II shows the economics and
engineering of making Transformers bigger, faster, and more efficient.

