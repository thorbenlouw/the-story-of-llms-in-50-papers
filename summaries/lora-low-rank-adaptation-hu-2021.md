# LoRA: Low-Rank Adaptation of Large Language Models (Hu et al., 2021)

Edward Hu, Yelong Shen, Phillip Wallis, Zeyuan Allen-Zhu, Yuanzhi Li, Shean Wang, Lu Wang, Weizhu Chen. arXiv:2106.09685 (2021).

## TL;DR
- Freezes a pre-trained LM and learns small, trainable low-rank matrices (A, B) injected into selected layers, dramatically reducing trainable parameters and memory.
- Achieves on-par or better performance than full fine-tuning across models (RoBERTa, DeBERTa, GPT‑2, GPT‑3) with 10,000× fewer trainable parameters and ~3× lower GPU memory during training.
- No inference latency penalty: the low-rank updates can be merged into base weights at deployment.
- Conceptual basis: task-specific weight updates are low intrinsic rank, so low-rank adapters suffice.
- Orthogonal and composable with other PEFT methods; supports multi-task deployment by swapping per-task (A, B) modules.

## Problem and Motivation
Full fine-tuning of ever-larger LMs is increasingly impractical: storing/serving one fine-tuned 175B-parameter model per task is cost- and memory-prohibitive. Adapter-style and prompt-based methods reduce training cost but often add inference latency or underperform full fine-tuning. The goal is a method that (1) trains few parameters, (2) preserves or improves quality, and (3) does not introduce inference overhead.

## Core Idea and Contributions
- Low-Rank Adaptation (LoRA): represent the task-specific weight update ∆W as a low-rank product BA with rank r « d, keeping W0 frozen and training only A, B. During inference, fold BA into W0 to avoid runtime overhead.
- Targeted placement: apply LoRA to attention projections (e.g., Wq, Wk, Wv, Wo) and optionally to other dense layers; freeze MLPs for simplicity with strong results.
- Efficiency at scale: with GPT‑3 175B, LoRA reduces trainable parameters to ~0.01% (10,000× smaller) and trims optimizer memory and gradient compute (~3× lower VRAM in training).
- Quality and throughput: matches or exceeds full fine-tuning on multiple benchmarks while increasing training throughput; no added latency at serving time.
- Empirical insight: supports a “low intrinsic rank” hypothesis for adaptation by analyzing rank deficiency of ∆W and its alignment with top singular directions.

## Method (plain-language)
- Freeze base weights W0. For each adapted matrix, parameterize W = W0 + ∆W with ∆W = BA, where B ∈ R^{d×r} and A ∈ R^{r×k}. Initialize A near zero so the network starts from the pre-trained function.
- Train only A, B (and biases if desired) with standard optimizers (e.g., Adam); the rest is frozen, reducing memory and compute. Set small ranks (e.g., r = 1–8) depending on scale and task.
- During deployment, either keep the decomposition (and add a tiny matmul) or merge BA into W0, yielding no extra inference latency.
- Typical placement: apply to attention projections (Wq, Wk, Wv, Wo); freezing MLPs often suffices for strong results and further savings.

Why it works: Many tasks lie on low-dimensional adaptation manifolds; LoRA restricts updates to this subspace, acting as a strong, efficient inductive bias while leveraging the rich pre-trained features.

## Comparison to Prior Work
- Adapters (Houlsby et al.): Add new modules and depth, increasing inference latency. LoRA avoids runtime latency by merging updates.
- Prompt/prefix-tuning: Efficient but can reduce usable sequence length or underperform on some tasks. LoRA preserves context capacity and matches/exceeds full fine-tuning in quality.
- Full fine-tuning: Highest flexibility but expensive and hard to serve at scale; LoRA approaches the same expressivity with much lower cost via low-rank updates.

## Results and What They Mean
- Trainable parameter reduction: ~10,000× fewer trainable parameters vs. GPT‑3 full fine-tuning; optimizer state and gradient memory cut by ~3×, enabling training on fewer GPUs and faster throughput.
- Quality: Matches or surpasses fine-tuning on tasks across RoBERTa/DeBERTa/GPT‑2/GPT‑3 while training far fewer parameters.
- Serving: No added latency after merging; enables multi-task systems to swap tiny LoRA modules on a shared base.

Implications:
- Practical PEFT default: LoRA enables economical, multi-tenant fine-tuning and quick iteration.
- Modular deployment: Share one base model, load per-task (A,B) deltas on demand; simplify CI/CD for model variants.
- Composability: Combine with other techniques (e.g., prefix-tuning) for additional gains.

## Limitations and Failure Modes
- Rank selection: Too-small r can bottleneck adaptation; too-large r erodes efficiency. Requires tuning across tasks and scales.
- Coverage: Applying LoRA only to attention may fail on tasks needing deeper MLP adaptation; selective MLP LoRA can help at extra cost.
- Merging and precision: Care is needed when merging in low precision to avoid drift; quantization-aware deployment may be required.
- Interference: Multi-task mixtures of LoRA modules can conflict unless trained with isolation or composition-aware methods.

## Fit to This Course (Week: Week 11, Section: Retrieval-Augmented Generation (RAG) & Memory)
- Key Topics & Labs: Infrastructure, Serving, and PEFT; fine-tune with LoRA and serve with vLLM; efficiency trade-offs between memory, context, and knowledge.

How it fits:
- PEFT cornerstone: LoRA is the central PEFT technique used in practice to adapt large generators used in RAG without retraining the base.
- Serving synergy: Tiny deltas pair well with high-throughput serving (vLLM), enabling many adapters to share a single GPU-resident base.
- Cost/perf trade-offs: Directly addresses the lab goals around throughput and latency vs. accuracy.

## Discussion Questions
1) How do you select ranks per layer (and which layers) to maximize accuracy/efficiency for a given task family?
2) When should you merge LoRA at deployment vs. keep it separate (e.g., for hot-swapping modules)?
3) How does LoRA interact with quantization and KV cache policies in high-throughput serving?
4) What’s a principled strategy to compose multiple LoRA modules (multi-task or feature toggles) without interference?
5) Can we learn ranks dynamically (per-layer/per-head) under a global parameter budget?

## Glossary
- PEFT (Parameter-Efficient Fine-Tuning): Methods that adapt large models by training a small number of parameters.
- Low-rank update: A matrix change ∆W factored as BA with small rank r.
- Merge at inference: Folding BA into W0 to avoid extra latency at serve time.
- Attention projections (Wq, Wk, Wv, Wo): Linear maps inside self-attention to form queries, keys, values, and outputs.
- Intrinsic rank: Effective dimensionality of the adaptation needed to fit a downstream task.
- Trainable parameter fraction: Ratio |Θ|/|Φ0| of tuned to base parameters; for LoRA on GPT‑3, ≈0.01%.
- Adapter interference: Undesired interaction when combining multiple per-task adapters.
- Optimizer state memory: Extra memory from Adam moments; LoRA reduces it by freezing most weights.

## References and Claim Checks
- “Freeze pre-trained weights and inject trainable rank decomposition matrices” (Abstract; pdftotext lines ~22–27).
- “10,000× fewer trainable parameters; ~3× lower GPU memory” (Abstract; lines ~24–27; details ~307–314, 308–313, 167–171).
- “No additional inference latency; merge trainable matrices with frozen weights” (Abstract and method; lines ~26–27, 103–110).
- “Apply to Wq, Wk, Wv, Wo; often freeze MLPs” (Terminology/placement; lines ~110–113, 297–307).
- “Very low ranks (r=1–2) suffice even when d≈12,288” (Method motivation; lines ~93–96).
- “Trainable parameters ~0.01% for GPT‑3 175B” (lines ~166–171).

