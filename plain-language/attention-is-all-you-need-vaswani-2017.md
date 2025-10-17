# The Moment Language Models Went Fully Parallel

## The Paper

Attention Is All You Need — Ashish Vaswani, Noam Shazeer, Niki Parmar, Jakob
Uszkoreit, Llion Jones, Aidan N. Gomez, Łukasz Kaiser, Illia Polosukhin (2017,
Google Brain/Google Research).

## Before the Breakthrough

Before 2017, teaching machines to understand and generate language felt like
running a message down a long corridor. Recurrent neural networks (RNNs)
handled text one token at a time, passing a hidden state from word to word.
That made learning slow and brittle: you couldn’t process a sentence in
parallel, and long‑range relationships faded as the message travelled. Even
with LSTMs and attention add‑ons, training was constrained by a sequential
bottleneck.

Convolutional models improved parallelism, but struggled to connect distant
words without stacking many layers. The field needed a way to see a whole
sentence at once while still understanding order—fast and expressive. The
Transformer answered that call, replacing the assembly line with a round‑table
discussion where every token can “speak” to every other instantly.

## The Big Idea: Self‑Attention, Many Heads, and a Sense of Order

The Transformer’s leap was radical simplicity: do sequence modelling with
attention alone—no recurrence, no convolutions. The core mechanism is
self‑attention. In plain terms, each word asks: which other words matter right
now? It scores every position, then mixes their information accordingly. This
idea of self‑attention is a cornerstone concept we’ll revisit throughout the
course.

Mathematically, self‑attention turns each token into three vectors—queries,
keys, and values—and computes a weighted average of values based on how well
queries match keys. The “scaled dot‑product” keeps numbers stable so learning
is smooth. Intuitively, it’s like scanning a paragraph and instantly
highlighting the few words that matter most.

Multi‑head attention takes this further. Instead of a single spotlight, the
model uses several smaller spotlights simultaneously, each looking for a
different kind of pattern—syntax, coreference, or semantic similarity. Think of
a photography crew with multiple lenses: wide‑angle, macro, portrait—each gives
a complementary view.

If everything looks at everything, how does the model know word order? Enter
positional encodings—numerical tags added to token embeddings that encode
position. Think of postcodes on letters: identical words get different
“addresses”, distinguishing “dog bites man” from “man bites dog”. This notion of
embeddings—turning tokens into vectors—is another cornerstone concept.

Architecturally, the Transformer keeps the encoder–decoder layout but refactors
it around attention. The encoder stacks self‑attention and feed‑forward layers;
the decoder adds masked self‑attention (no peeking ahead) and cross‑attention
over encoder outputs. Residual connections and normalisation keep gradients
healthy. The big win: all positions are processed in parallel, unlocking modern
hardware.

## Why It Mattered: Speed, Quality, and a New Playbook

The payoff was dramatic. Because tokens are processed in parallel, training time
fell from weeks to days on the same hardware. And it wasn’t just fast—it set a
new bar in machine translation, producing more fluent, accurate output. In
short: quicker to train, better to use.

More importantly, the architecture changed how we design language systems. With
RNNs, you’re bound by an assembly line: position five waits for position four.
With the Transformer, it’s a team workshop: every part of the sentence can
consult every other part at once. That parallelism scales to longer sequences
and bigger models, making it practical to use serious compute.

There’s also a subtle but powerful shift in how information flows. In RNNs, the
path between two distant words can be dozens of steps; in the Transformer, the
maximum path length is effectively constant—any position can attend to any
other in a single hop. That short path helps the model capture long‑range
dependencies that matter for real language, like linking a pronoun back to a
subject many tokens earlier.

The mechanics also suit generation. Masked self‑attention in the decoder trains
the model to predict the next token given what it has already produced—exactly
how we use it at inference time. Cross‑attention lets the decoder “look back”
at the encoder’s representation of the input, keeping translations grounded and
faithful. Together, this forms a clean, scalable recipe that works beyond
translation—summarisation, question answering, and more.

The design is also modular and general. Multi‑head attention and feed‑forward
layers compose cleanly, making it straightforward to build deeper models.
Attention heads specialise automatically, discovering useful patterns without
explicit supervision. That’s why the Transformer became the default backbone
not just for translation but for most language tasks—and later even vision.

## Where It Fits in Our Story

In this course’s narrative, the Transformer is the Big Bang of Phase I—the
architectural revolution. It solved two blockers: long‑range memory and
efficient parallel training. That opened the door to Phase II, where the focus
shifted from “Can we model
language well?” to “How far does performance improve as we scale?” The scaling
laws you’ll meet next build directly on this architecture: predictable gains
arrive precisely because the Transformer makes large‑scale training feasible and
stable.

Looking ahead, we’ll see how this blueprint supported major model families:
decoder‑only GPT for generation, encoder‑only BERT for understanding, and T5’s
unified text‑to‑text framing. We’ll also explore the trade‑offs and
optimisations that followed—like faster attention kernels and sparse expert
routes—that made these systems practical at frontier scale.

[Paper](llm_papers_syllabus/Attention_Is_All_You_Need_Vaswani_2017.pdf)
