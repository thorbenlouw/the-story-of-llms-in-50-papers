# Making Attention Fast by Moving Data Less

## The Paper

FlashAttention: Fast and Memory‑Efficient Exact Attention with IO‑Awareness —
Tri Dao, Daniel Y. Fu, Stefano Ermon, Atri Rudra, Christopher Ré (NeurIPS
2022).

## Before the Breakthrough

Transformers thrive on self‑attention, but classic attention hits a wall as
contexts grow. The cost scales with the square of sequence length, and—crucially
for modern GPUs—the main bottleneck isn’t arithmetic, it’s memory traffic. Most
implementations repeatedly write and read a giant N×N attention matrix to and
from slow off‑chip memory (HBM), even though the GPU’s on‑chip memory (SRAM) is
an order of magnitude faster.

For years, the community tried to cut FLOPs with approximate attention (sparse
patterns, low‑rank tricks). On paper, complexity dropped; in practice, wall‑clock
often didn’t. It’s like switching to a car with a better engine while still
spending most of your journey stuck at toll booths—the issue isn’t horsepower,
it’s how often you stop. The field needed an algorithm that respected the
hardware reality: make fewer, smarter trips to slow memory.

## The Big Idea: Tile Everything, Fuse Everything, Save the Trips

FlashAttention reframes attention as an IO‑optimisation problem. Instead of
materialising the full attention matrix in HBM, it processes queries, keys, and
values in small tiles that fit in fast SRAM, performing the whole sequence of
steps—matmul, softmax, dropout, value aggregation—inside a single fused kernel.
Intermediate results stay on‑chip; only compact summaries leave.

Two cornerstone concepts underpin this design:

- Memory hierarchy: GPUs have tiny, very fast SRAM on‑chip and large, much
  slower HBM off‑chip. Moving data dominates runtime for attention—this is a
  foundational idea for systems‑level ML.
- Tiling and fusion: Break a big job into tiles that fit on‑chip and fuse
  operations so you don’t spill intermediates to slow memory. This pattern will
  recur across efficient LLM tooling.

There’s a technical hurdle: softmax couples every column in a row, so you can’t
naïvely process independent tiles. FlashAttention handles this with a clever
decomposition: while sweeping across blocks of keys, it maintains per‑row
statistics—the running max and the running normalisation term—so that when all
blocks are processed, the result is exactly the same as computing softmax over
the full matrix. No approximations.

Think of it like grocery shopping with a basket instead of dragging the entire
fridge to the checkout. You take small batches that fit comfortably, keep a
short running tally as you go, and never wheel the whole fridge back and forth.
Or imagine a lift (elevator) with strict weight limits: you shuttle groups of
boxes to the top floor, updating the inventory ledger after each trip, rather
than trying to move everything at once and overloading the system.

The backward pass follows the same philosophy: rather than storing the full
attention matrix for gradients (which would blow up memory), it recomputes
small pieces on the fly. You pay a few extra FLOPs to avoid massive IO, and on
today’s hardware that trade‑off wins.

## Why It Mattered: Real‑World Speed and Longer Contexts

FlashAttention delivers 2–4× wall‑clock speedups for practical models by
reducing HBM reads/writes towards a theoretical lower bound for exact
attention. It trains BERT faster, accelerates GPT‑style models by up to 3×, and
unlocks much longer contexts when paired with block‑sparse patterns (tens of
thousands of tokens). Quality stays intact because the algorithm is exact—the
outputs match standard attention bit‑for‑bit under the same math modes.

The bigger lesson is strategic: treat attention as memory‑bound and optimise IO
first. In the era of A100s and beyond, arithmetic throughput outstrips memory
bandwidth; performance hinges on how you move data, not how many multiplies you
can do. FlashAttention crystallised that insight and packaged it into kernels
that practitioners could use immediately.

Practically, this meant:

- Lower training costs and shorter runs for the same models.
- Feasible long‑context training without resorting to lossy approximations.
- A template (tiling + fusion + recomputation) adopted widely in subsequent
  attention and MLP kernels.

If approximate attention was like sketching only the parts of a picture you
think matter, FlashAttention is a full‑fidelity drawing done with better
workflow: same image, less wasted motion.

## Where It Fits in Our Story

Within Phase II (scaling and efficiency), FlashAttention is software
infrastructure for the scaling era. Kaplan mapped how performance grows with
scale; Hoffmann taught us to spend compute wisely; Switch Transformers expanded
capacity with sparse activation. FlashAttention makes all of that more
practical by speeding up the core bottleneck without changing model behaviour.

It also foreshadows a broader systems mindset you’ll see again: IO‑aware
optimisations, kernel fusion, and memory‑savvy layouts (and later, serving
stacks like vLLM). As contexts stretched beyond 32K, and as training sets
hit trillions of tokens, getting memory movement under control is as important
as any architectural tweak.

[Paper](llm_papers_syllabus/FlashAttention_Fast_IO_Aware_Dao_2022.pdf)

