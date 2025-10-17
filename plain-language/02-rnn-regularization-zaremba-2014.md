# Keeping the Memory, Taming the Overfitting: RNNs’ Last Big Push

## The Paper
## See Also
- Prev: [Attention Is All You Need](01-attention-is-all-you-need-vaswani-2017.md)
- Next: [Improving Language Understanding by Generative Pre-Training (GPT‑1)](03-improving-language-understanding-gpt1-radford-2018.md)

Recurrent Neural Network Regularization — Wojciech Zaremba, Ilya Sutskever,
Oriol Vinyals (2014).

## Before Transformers: Life on the Assembly Line

In the mid‑2010s, language models ran like a factory assembly line. Recurrent
neural networks (RNNs), especially LSTMs, read text one token after another,
passing a hidden state down the line. That hidden state is a feedback loop:
what you do now depends on what just happened. It’s powerful but forces you to
work step by step—each word waits for the previous word’s state.

As models grew, another problem surfaced: overfitting. Big RNNs memorised the
training set too easily and stumbled on new text. The go‑to cure in deep
learning—dropout—worked brilliantly in feed‑forward nets, but it backfired in
RNNs. Randomly deleting parts of the feedback loop scrambled the model’s memory
from one moment to the next. It was like cutting wires on a walkie‑talkie mid‑
conversation; the message couldn’t get through.

This 2014 paper by Zaremba, Sutskever, and Vinyals offered a clever fix. It
didn’t turn the assembly line into a round‑table (that would come later with
Transformers). It stabilised the line so we could build larger, better RNNs
without immediate overfitting.

## The Big Idea: Regularise the Computation, Not the Memory

Here’s the surgical insight: RNNs have two kinds of pathways at each moment in
time.

- Vertical (layer‑to‑layer) paths compute features within the current moment.
- Horizontal (time‑to‑time) paths carry memory forward from the last moment.

Dropout should touch the first and leave the second alone. In other words,
regularise the computation, not the memory. By applying dropout only to the
vertical connections (between layers at the same timestep) and never to the
horizontal recurrent connections (between timesteps), the model keeps a clean
memory line while still getting the benefits of regularisation.

Two simple analogies make this click:

- Insulating the power line: Side consoles can be swapped in and out (dropout),
  but the main power line must never flicker. The recurrent connection is that
  power line; don’t inject noise there.

- Guardrails on the belt: The conveyor belt (time‑to‑time state) must run
  smoothly. You add guardrails (dropout) around the workstations (layer
  computations) so the workers don’t overfit to tiny quirks, but you never jam
  the belt itself.

Why this works: with the memory path intact, information travels forward
reliably. Dropout still prevents the vertical computations from latching onto
shortcuts, but it doesn’t erase what the model just remembered. Practically,
this enabled much larger LSTMs that generalised better.

Along the way, this paper highlights two cornerstone concepts we’ll revisit:

- RNN hidden state (the feedback loop) is the heart of sequential modelling.
  It’s what makes RNNs sensitive to context—but it also ties your hands to
  process tokens one after another.

- Dropout (randomly dropping activations at training time) is a powerful
  regulariser, but it must respect a model’s structure. In RNNs, dropping
  memory connections breaks continuity from step to step.

## Why It Mattered: Bigger RNNs, Still on Rails

The results were strong. On a classic benchmark, regularised LSTMs cut error
substantially versus unregularised versions—even with far larger models. The
same pattern held across tasks like speech recognition, translation, and image
captioning: keep memory clean, regularise per‑step computation, and accuracy
improves.

In engineering terms, this paper gave practitioners permission to scale up RNNs
without immediately drowning in overfitting. Training stayed stable with
gradient clipping and careful learning‑rate schedules, and the models improved.

But the deeper lesson is about limits. Even with this fix, RNNs still ran on an
assembly line. Each token waited for the previous one’s state, so you couldn’t
fully harness parallel hardware. And information between distant words travelled
through many steps, so long‑range relationships could fade despite LSTM gates.

In short: this paper made the best version of the assembly line we could build.
It was a necessary step, but not the leap that unlocked today’s scaling.

## Where It Fits in Our Story

In this course’s narrative, this is the closing chapter of the “old world”. It
shows the ingenuity of making RNNs work at their limits—protect memory,
regularise computation, clip gradients, tune schedules—squeezing performance
from a fundamentally sequential machine.

The next chapter is the architectural revolution. Transformers replaced the
assembly line with a round‑table, where every token can consult every other at
once. That shift removed the serial bottleneck and let us truly scale across
modern hardware. The predictable improvement curves in Scaling Laws only make
sense because information now flows differently.

So read this paper as both a success and a signpost. It shows how far we could
push RNNs—and why, to go further, we needed a model that could look everywhere
at once without waiting its turn.

[Paper](llm_papers_syllabus/RNN_Regularization_Zaremba_2014.pdf)
