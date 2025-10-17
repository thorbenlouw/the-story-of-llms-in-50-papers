# The Moment We Stopped Wasting Compute

## The Paper

Training Compute-Optimal Large Language Models — Jordan Hoffmann*, Sebastian
Borgeaud*, Arthur Mensch*, Elena Buchatskaya, Trevor Cai, Eliza Rutherford,
Diego de Las Casas, Lisa Anne Hendricks, Johannes Welbl, Aidan Clark, Tom
Hennigan, Eric Noland, Katie Millican, George van den Driessche, Bogdan Damoc,
Aurelia Guy, Simon Osindero, Karen Simonyan, Erich Elsen, Jack W. Rae, Oriol
Vinyals, Laurent Sifre (2022, DeepMind; *equal contribution*).

## Before the Breakthrough

By 2022, the field had settled into a comfortable—but costly—habit: make the
model bigger and hope scores go up. GPT‑3, Gopher, MT‑NLG: parameter counts
ballooned while training data hovered around a few hundred billion tokens. This
was loosely justified by earlier “scaling laws”, which hinted you should spend
most of your budget on a larger model, not on more data.

There were problems. Colossal models are slow to train, expensive to serve, and
awkward to deploy. Worse, many were undertrained: like buying a supercar and
then only filling the tank a quarter of the way. You’ve paid for the engine,
but you aren’t giving it enough fuel to show what it can do. Teams needed a
principled answer to a practical question: for a fixed budget of compute,
exactly how should you split it between model size and training tokens?

## The Big Idea: Balance the Engine and the Fuel

Hoffmann et al. provide that answer: to use compute optimally, grow parameters
and data together. In plain terms, when your training budget doubles, you
should roughly double both the number of parameters and the number of tokens.
Not five‑times bigger models with barely more data; equal scaling.

Two cornerstone concepts matter here:

- Parameters: the learned weights of the model—its capacity. This is a
  foundational idea we’ll revisit throughout the course.
- Tokens: the units of training data the model actually sees. More tokens mean
  more varied experience to learn from—another cornerstone concept.

The team trained and analysed hundreds of models across sizes and durations,
then fit a simple model of loss as a function of parameters (N) and tokens (D).
The compute budget is dominated by roughly 6 × N × D floating‑point
operations. If you fix compute, you can trade N against D along an isoFLOP
curve. Their fits showed that the loss falls fastest when N and D are kept in
balance. Intuitively, it’s like cooking for a crowd: bringing a bigger pot
(bigger model) without adding ingredients (more data) doesn’t feed more people.
You need both in step.

To drive the point home, they trained a validation model nicknamed
“Chinchilla”: about 70B parameters trained on 1.4T tokens, using the same
compute as a much larger 280B‑parameter model (Gopher) trained on ~300B tokens.
Chinchilla won across the board. In road‑trip terms, it didn’t buy a larger
car; it packed the boot with the right amount of fuel for the journey.

## Why It Mattered: Smaller Models, Bigger Wins

The consequences were immediate and practical:

- Better performance at the same compute: Chinchilla outperformed larger
  predecessors on language modelling and broad benchmarks like MMLU and
  BIG‑bench.
- Cheaper, faster inference: Smaller models are easier to serve. If you can
  match or exceed quality with 4× fewer parameters, your production costs drop
  and latencies improve.
- Clearer planning: Equal scaling turns model design into budgeting rather than
  gambling. Given a compute target, you can choose a parameter count and data
  size with confidence rather than folklore.

It also reframed the bottleneck. If optimal training wants trillions of tokens,
then data quality, deduplication, and curation become central engineering
projects. This pushed the community to invest in better datasets, longer
training runs, and infrastructure that can feed models efficiently—data loading,
parallelism, and storage suddenly matter as much as GPU counts.

Another subtle benefit is generalisation. Undertrained giant models tend to
memorise and then stall. Training a right‑sized model on more diverse data can
lead to smoother improvements that transfer across domains. It’s the difference
between cramming for a test with a giant but shallow outline, and studying a
smaller, well‑focused guide thoroughly.

## Where It Fits in Our Story

Within our narrative, this paper marks a turning point in Phase II, “the race
to scale”. The Transformer gave us the architecture; Kaplan et al. gave an
initial map; Hoffmann et al. corrected the compass. From here on, the question
isn’t simply “how big can we go?” but “how do we spend compute wisely?”

This equal‑scaling rule underpins many choices you’ll see next: why teams chase
larger, cleaner datasets; why serving stacks prize efficiency (FlashAttention,
quantisation); and why sparse routing (Mixture‑of‑Experts) is compelling—use
lots of parameters when needed, but don’t pay for all of them on every token.
When budgets are tight, a smaller, well‑trained model often beats an oversized,
undertrained one.

Looking ahead, this logic also motivates retrieval‑augmented generation (RAG):
if compute‑optimal training wants ever more data, sometimes the right move is to
fetch knowledge at inference rather than bake it all into parameters. Equal
scaling doesn’t end the story; it helps you decide the next efficient step.

[Paper](llm_papers_syllabus/Training_Compute_Optimal_LLM_Hoffmann_2022.pdf)
## See Also
- Prev: [Scaling Laws for Neural Language Models](07-scaling-laws-neural-language-models-kaplan-2020.md)
- Next: [Switch Transformers (Mixture-of-Experts)](09-switch-transformers-moe-fedus-2021.md)
