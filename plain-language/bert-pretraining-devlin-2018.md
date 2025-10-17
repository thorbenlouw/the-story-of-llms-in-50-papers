# Reading Both Ways: How BERT Taught Models to Understand

## The Paper

BERT: Pre-training of Deep Bidirectional Transformers for Language
Understanding — Jacob Devlin, Ming-Wei Chang, Kenton Lee, Kristina Toutanova
(2018, Google AI Language/Google Research).

## Before the Breakthrough

Before BERT arrived in 2018, most powerful language models read in one
direction. GPT‑style systems looked left‑to‑right, predicting the next word. It
works brilliantly for generating text, but it’s like reading a sentence with
one eye closed: you’re missing half the cues that make meaning precise.

Other approaches tried to compensate with “shallow” two‑way tricks. ELMo, for
example, trained two separate readers—one going forwards, one going backwards—
then stitched their outputs together. Helpful, but those two streams never truly
learnt together at depth. Many tasks we care about, from finding an answer in a
paragraph to deciding whether one sentence follows from another, need rich
context from both sides at once.

Enter BERT, a model that reads in both directions in every layer. If GPT is a
storyteller composing the next line, BERT is a careful editor, scanning the
entire paragraph to pin down what each word means given everything around it.
That shift—deep, bidirectional context—reshaped language understanding.

## The Big Idea: Mask the Words, Learn the World

There’s a catch: if a model can see all words, how can it learn to predict any
of them without cheating by “looking at itself”? BERT’s answer is elegantly
simple: hide some of the words and ask the model to fill in the blanks.

This is the masked language modelling objective. Randomly pick a small
fraction of tokens and replace most with a special [MASK] symbol. Sometimes
swap in a random word or leave the original, just to keep the model honest.
Then train it to guess the hidden words using context from both sides. It’s
like a crossword where every clue comes from the sentence itself. The only way
to get good is to learn how words relate in both directions.

BERT also practises a simple sentence‑level task: next sentence prediction. The
model sees two segments and learns to judge whether the second actually follows
the first in the source text or is just a random pairing. Think of it as
teaching the model to recognise when two sentences belong in the same thought.

Under the bonnet, BERT is a stack of Transformer encoders—the attention blocks
that let every word consider every other at once. Two cornerstone concepts are
worth highlighting here:

- Bidirectional self‑attention: This is a cornerstone idea in the course. It
  lets the model build a meaning for each token using information on both
  sides, not just the past.
- Contextual embeddings: Rather than a single vector per word type, BERT learns
  a representation that changes with context. “Bank” near “river” differs from
  “bank” near “loan”. These context‑aware vectors are the workhorse features for
  downstream tasks.

One more quiet enabler: subword tokenisation (often WordPiece). Instead of
giving up on rare words, BERT breaks them into pieces (“micro” + “service”).
The vocabulary stays manageable while new words are handled gracefully.

## Why It Mattered: Understanding as a Service

BERT turned deep, two‑way reading into an off‑the‑shelf capability. With the
same pre‑trained model and minimal task‑specific changes—often just a small
output layer—teams saw large gains across question answering, sentiment,
natural language inference, and more. In human terms, it meant better search
results that understand what you mean, more accurate answers pulled from
documents, and classification that respects nuance rather than keywords.

Three practical impacts stand out:

- Richer comprehension: With meaning built from both sides, BERT is better at
  disambiguating tricky phrases and connecting clues spread across a paragraph.
  It reads like a careful editor, not a fast typist.

- Simpler pipelines: Instead of designing bespoke architectures for each task,
  you fine‑tune the same backbone—consistent recipes, fewer brittle parts,
  faster iteration.

- Performance unlocked by scale: Two sizes (BASE and LARGE) showed that bigger
  models, trained longer on large unlabelled corpora, deliver predictable
  improvements—foreshadowing the course’s theme on scaling.

Analogies help. If GPT‑style models are improvisational speakers, BERT is a
meticulous reader with a highlighter—cross‑referencing earlier and later lines
to pin down meaning. And while a unidirectional model watches a tennis match
from one baseline, BERT watches from the umpire’s chair, seeing both sides at
once.

## Where It Fits in Our Story

In this course’s arc, BERT sits beside GPT as a pillar of Phase I, the
architectural revolution brought by Transformers. GPT’s decoder‑only design is
ideal for generating text; BERT’s encoder‑only design is ideal for
understanding it. Together they split the field into two thriving families, and
later work (like T5) reframed tasks to unify both worlds.

BERT’s success cemented “pre‑train, then fine‑tune” for understanding problems
and seeded follow‑ups—larger encoders, better data, and refined objectives.
As we move into Scaling and Alignment, keep this mental model: attention gave
us the machinery; BERT showed how to read with depth, not just write with
fluency.

[Paper](llm_papers_syllabus/BERT_Bidirectional_Transformers_Devlin_2018.pdf)
