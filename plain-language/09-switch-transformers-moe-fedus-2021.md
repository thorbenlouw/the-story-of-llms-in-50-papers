# How a Switch Made Trillion‑Parameter Models Practical

## The Paper

Switch Transformers: Scaling to Trillion Parameter Models with Simple and
Efficient Sparsity — William Fedus, Barret Zoph, Noam Shazeer (2021; JMLR
2022).

## Before the Breakthrough

In the early scaling race, the recipe was simple: make the Transformer denser
and bigger. But dense models have a blunt property: every parameter wakes up
for every token. If you double parameters, you double the work per token. That
made training and serving eye‑wateringly expensive.

Researchers had an enticing alternative: Mixture‑of‑Experts (MoE). Instead of
activating the entire network, route each token through a small subset of
specialist “experts”. In theory, you can grow the total parameter count
dramatically while keeping the work per token roughly constant. In practice,
though, earlier MoEs were fiddly—routing to multiple experts per token, heavy
all‑to‑all communication, stability issues, and lots of engineering gotchas.

Teams wanted the promise of MoE without the pain. Could you get most of the
benefit with a simpler design, one that runs fast on real hardware and doesn’t
fall over during training?

## The Big Idea: One Token, One Expert

Switch Transformers take MoE back to basics. The core idea is refreshingly
simple: route each token to exactly one expert (top‑1), not two or four. That
single decision—hence the name “Switch”—cuts compute and communication while
keeping quality high.

Let’s introduce a few cornerstone concepts we’ll reuse later:

- Mixture‑of‑Experts (MoE): a model made of many “expert” sub‑networks, where a
  learned router chooses which expert(s) process each token. This is a
  foundational pattern for scaling capacity without proportional compute.
- Router: a light‑weight module that scores experts and picks the best one per
  token. Think of it as the traffic controller for tokens.
- Sparse activation: only a fraction of parameters are active for a given
  token, so you can house many experts without paying for all of them each
  step.

Analogies help. Picture a hospital triage desk: each incoming patient (token)
speaks to one specialist—cardiology or dermatology—not the entire hospital at
once. Or think of a classic telephone switchboard: every call gets plugged into
one line, not broadcast across all lines. The router is that switchboard,
deciding who handles what.

Concretely, Switch replaces a Transformer’s dense feed‑forward (FFN) layers
with Switch‑FFN layers. For each token, the router computes a softmax over N
experts and chooses the highest‑scoring one. The token is sent to that expert;
the expert’s output is scaled by the router’s gate value and passed on. To keep
experts evenly busy, the model adds a small load‑balancing loss that nudges the
router towards a uniform assignment.

Two engineering choices make this practical at scale:

- Expert capacity: each expert only processes up to a fixed number of tokens
  per batch (based on batch size, number of experts, and a capacity factor).
  Overflow tokens skip expert computation and ride the residual connection. It
  sounds odd, but it keeps tensors static for hardware efficiency and barely
  hurts quality when tuned well.
- Selective precision: routing is done in float32 for stability, while the rest
  of the model runs in bfloat16 for speed. This small change avoids the “training
  jitters” that plagued some earlier MoEs without giving up throughput.

The upshot: with the same FLOPs per token as a dense baseline, Switch models
can house vastly more parameters—and train fast. You get the capacity of a
giant model with the per‑token cost of a much smaller one.

## Why It Mattered: Speed, Scale, and Practicality

Switch Transformers delivered three big wins:

- Wall‑clock speed: FLOP‑matched against dense T5 baselines, Switch reaches the
  same quality in a fraction of the time (roughly 7× speed‑up reported for a
  base configuration). That’s fewer training days for the same result.
- Capacity at fixed cost: By activating only one expert per token, the model
  scales to the trillion‑parameter regime (e.g., Switch‑C ~1.6T) without
  exploding per‑token compute. It’s like hiring a huge team of specialists but
  only paging one for each case.
- Stability and portability: Small but targeted tweaks—float32 routing,
  reduced initialisation scale, and expert dropout during fine‑tuning—made
  training reliable and transfer to downstream tasks smooth.

Crucially, these aren’t lab curiosities. The authors report consistent gains in
pre‑training efficiency, strong fine‑tuning performance (e.g., SuperGLUE
improvements), and multilingual benefits across 100+ languages. Even better,
the large sparse model can be distilled into a tiny dense one, preserving a
meaningful slice of quality for cheap deployment.

If dense scaling is like building one enormous kitchen where every chef works on
every dish, Switch is a restaurant with many kitchens and a maître d’ who sends
each dish to exactly one chef. You get more chefs overall without crowding the
stove, and dinner still comes out on time.

## Where It Fits in Our Story

In Phase II of this course—scaling and efficiency—Switch Transformers add a
fourth lever. Kaplan taught us that bigger helps; Hoffmann (Chinchilla) taught
us to balance size with more data; Switch shows how to grow capacity without
paying the full compute tax, by making activation sparse. That complements
other efficiency plays like FlashAttention (faster kernels) and quantisation
(lighter weights) to make frontier models tractable.

There are trade‑offs. Routing has hyperparameters to tune (capacity factors,
load‑balancing weights). All‑to‑all communication across devices must be
engineered carefully. Some tokens may be dropped from experts under tight
capacity. But the direction of travel is clear: conditional computation—using
lots of parameters only when needed—lets us push scale without turning every
token into a budget‑breaker.

Looking ahead, this idea of “only compute what you need” shows up across the
stack: sparsity in attention patterns, retrieval‑augmented generation to fetch
external knowledge on demand, and tool‑use to offload work to specialised
systems. Switch Transformers are an early, influential milestone in that
broader move from brute force to smart allocation.

[Paper](llm_papers_syllabus/Switch_Transformers_MoE_Fedus_2021.pdf)
## See Also
- Prev: [Training Compute-Optimal LLMs (Chinchilla)](08-training-compute-optimal-llm-hoffmann-2022.md)
- Next: [LLaMA 2: Open Foundation and Chat](10-llama-2-open-foundation-touvron-2023.md)
