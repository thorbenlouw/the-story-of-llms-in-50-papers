# Phase II — Scaling and Efficiency

With the Transformer in hand, the frontier became scale. This phase explains
why “bigger helps” isn’t a slogan but a measured law, how to spend compute for
best returns, and the architectural tricks that make trillion‑parameter models
and long contexts practical.

## Why this phase matters

The leap from good prototypes to state‑of‑the‑art systems came from scale.
Kaplan et al. showed that loss follows predictable power laws as you grow
parameters, data, and compute. Hoffmann et al. refined the recipe: for a fixed
compute budget, train smaller models on much more data (the Chinchilla insight).
Together, these papers turned scale into an engineering plan, not a guess.

But scale is expensive. This phase also introduces efficiency breakthroughs that
unlock practical training and inference: sparse Mixture‑of‑Experts (MoE) so you
pay only for the experts you use, and kernels like FlashAttention that avoid
wasting memory bandwidth. Compression (e.g., GPTQ quantisation) lets you run
big models on modest hardware.

## What we cover

- Scaling Laws (Kaplan et al.): power‑law relationships between size, data, and
  performance; a compass for planning large models.
- Compute‑optimal training (Hoffmann et al.): the data‑rich, smaller‑model
  regime; a shift from parameter fetishism to dataset curation.
- Switch Transformers (Fedus et al.): MoE routing to scale capacity without
  linear compute growth.
- FlashAttention (Dao et al.): IO‑aware attention that tiles and fuses work to
  keep memory traffic low and speed high.
- GPTQ (Frantar et al.): post‑training quantisation to 4‑bit weights with
  minimal quality loss, enabling single‑GPU inference.

## How to read this phase

Think like an engineer allocating a budget:
- Trade‑offs: parameters vs tokens vs FLOPs—balance them for target quality.
- Bottlenecks: IO, memory, and routing capacity often matter more than raw TFLOPs.
- Deployment realities: compression and sparsity make the difference between a
  demo and a product.

## Bridge to what’s next

Scale produces power, but not purpose. Phase III tackles alignment and
evaluation: how to make these models helpful, harmless, and honest, and how to
measure progress across many axes—not just a single benchmark.

