# How We Fit Giant Models on a Single GPU

## The Paper

GPTQ: Accurate Post‑Training Quantization for Generative Pre‑trained
Transformers — Elias Frantar, Saleh Ashkboos, Torsten Hoefler, Dan Alistarh
(2022; ICLR 2023).

## Before the Breakthrough

By 2022, we’d learned how to train huge models—but running them was another
story. A 175‑billion‑parameter model in FP16 weighs hundreds of gigabytes. That
doesn’t fit on a single high‑end GPU, let alone consumer hardware. Inference
meant multi‑GPU rigs, complicated sharding, and high serving costs.

Quantisation—the idea of storing weights in fewer bits—promised relief. But the
trade‑offs were brutal. Methods that truly shrank models to 3–4 bits usually
required expensive retraining; one‑shot, post‑training approaches collapsed at
these low bit‑widths. Basic round‑to‑nearest might survive at 8‑bit, but at 4‑
bit it often wrecked accuracy. The field needed a way to compress models
aggressively after training without destroying quality.

## The Big Idea: Compress Where It Hurts Least

GPTQ shows you can quantise frontier‑scale Transformers to 3–4 bits per weight
in a single pass, using only a tiny calibration set, and keep accuracy almost
unchanged. The core move is to use second‑order information—how sensitive a
layer’s outputs are to tiny changes in each weight—to decide which rounding
errors matter and which don’t.

Two cornerstone concepts underpin this:

- Post‑training quantisation (PTQ): compress a trained model without any
  fine‑tuning. This is crucial for billion‑parameter models where retraining is
  prohibitively expensive.
- Second‑order sensitivity: approximate how output error grows with weight
  changes using the Hessian (curvature) of a simple reconstruction objective.
  In plain terms: don’t just round weights blindly; round the ones that matter
  least.

Concretely, GPTQ processes one linear layer at a time and tries to preserve the
layer’s behaviour on a small batch of real activations. It solves a local
problem: find quantised weights Ŵ so that ŴX produces nearly the same outputs
as WX for the observed inputs X. The Hessian H ≈ 2XXᵀ captures which directions
in weight space are sensitive. With that map, you quantise columns while
accounting for how errors propagate, updating the remaining weights to
compensate.

Three engineering ideas make this scale to hundreds of billions of parameters:

- Arbitrary order: quantise all rows using the same column order so you can
  share the expensive inverse information across rows. This turns an intractable
  per‑row update into a shared, amortised one.
- Lazy batch updates: work on small blocks (e.g., 128 columns) at a time to
  improve GPU utilisation—more math per byte moved.
- Cholesky reformulation: compute and update the needed inverse information in a
  numerically stable way, avoiding the blow‑ups that plagued large models.

If that sounds abstract, try this analogy. Imagine packing a suitcase that’s
way too full. A naïve approach is to toss items until it shuts—fast but risky.
GPTQ is like using a packing list ranked by importance, plus vacuum bags for
the bulky items, and rearranging the remaining contents to fill gaps. You end
up with a suitcase that closes and still contains what you actually need.

Another way to see it: compression can be lossy, but not all loss is equal.
GPTQ quantises “where your ears won’t notice”, like an audio codec that drops
frequencies you can’t hear while keeping the melody intact.

## Why It Mattered: Smaller, Faster, and Widely Accessible

The practical wins are big:

- Single‑GPU inference for models that previously needed several GPUs.
- 3–4× end‑to‑end speed‑ups from reduced memory bandwidth, with negligible
  perplexity impact at 4‑bit on models as large as OPT‑175B.
- A truly one‑shot workflow: a few hundred calibration activations per layer,
  no full retraining cycle.

Why the speed‑ups? Modern inference is often memory‑bound: you spend more time
moving weights than multiplying them. Fewer bits means fewer bytes over the bus.
It pairs beautifully with IO‑aware kernels (think FlashAttention for attention,
and quantised GEMMs for MLPs): less data moved, more throughput.

Quality holds up because the second‑order signal steers rounding errors away
from the sensitive directions. Even at 3‑bit—where naïve rounding craters—GPTQ
keeps models usable. That changes who can run frontier models and where they can
run: research labs, startups, and even edge devices get into the game.

There are trade‑offs to manage. Group‑wise quantisation schemes add small per‑
group scales and zero‑points; you’ll want kernels that exploit the packed 4‑bit
format to avoid decoding overhead; and quantising activations and KV caches is a
separate problem. But as a deployment lever, GPTQ is simple, fast, and
effective.

## Where It Fits in Our Story

Within Phase II’s efficiency arc, GPTQ is the inference counterpart to the
training‑side breakthroughs. Kaplan mapped scaling; Hoffmann taught us compute‑
optimal budgets; Switch Transformers grew capacity without paying for it on
every token; FlashAttention made memory‑bound attention fly. GPTQ closes the
loop at serving time: shrink the model itself, cut memory traffic, and keep the
outputs faithful.

This also sets up the next chapters. As alignment methods (FLAN, InstructGPT,
DPO) make models more useful, we still need to deliver them affordably. GPTQ is
part of that stack alongside serving systems (like vLLM) and parameter‑efficient
fine‑tuning (like LoRA). The result is a practical recipe: train smart, route
smart, move data smart—and store smart, too.

[Paper](llm_papers_syllabus/GPTQ_Accurate_Post_Training_Quant_Frantar_2022.pdf)

