# Cutting Out the Middleman in Alignment

## The Paper

Direct Preference Optimization (DPO): Your Language Model Is Secretly a Reward
Model — Rafael Rafailov, Archit Sharma, Eric Mitchell, Stefano Ermon,
Christopher D. Manning, Chelsea Finn (NeurIPS 2023).

## Before the Breakthrough

After InstructGPT, alignment looked like a three‑act play: supervised fine‑
tuning (SFT) to teach basic manners, a reward model (RM) trained from human
preferences, then reinforcement learning (PPO) to push the policy towards what
people like while staying close to the SFT model via a KL constraint. It works,
but it’s fiddly: you train multiple large models, sample inside the training
loop, and balance delicate hyperparameters. PPO can be touchy; runs can be
unstable.

Teams wanted the benefits of RLHF without the RL. Could we optimise directly on
preference data—“A is better than B”—and skip training a separate reward model
and running PPO, while still respecting the crucial “don’t drift too far from
SFT” constraint?

## The Big Idea: Turn Preferences into a Direct Likelihood Objective

DPO shows you can collapse the RLHF pipeline into a single, supervised‑style
training loop. The key insight starts from a standard result in KL‑constrained
RLHF: under the objective “maximise reward subject to staying close to a
reference policy”, the optimal policy has a closed form proportional to the
reference policy times exp(reward/β). Re‑arrange that and you can write the
reward in terms of the policy itself and the reference policy. Plug this into a
Bradley–Terry preference model (which predicts which of two answers should win
based on reward differences), and the normalising constants cancel. What’s left
is a clean binary‑classification‑style loss on preferences that depends only on
the policy and the reference policy—no explicit reward model and no PPO loop.

Two cornerstone concepts to hold on to:

- KL‑constrained optimisation: keep the new policy near the SFT/reference
  policy. This is the seatbelt that prevents the model from drifting into odd
  language as it learns to please.
- Preference likelihood: treat “answer y₁ preferred to y₂” as a label and train
  the policy so that the implicit reward (derived from its log‑probabilities
  relative to the reference) ranks y₁ above y₂.

If RLHF is like hiring a food critic (the RM) and then training a chef with a
trial‑and‑error cooking regime (PPO), DPO is like using customers’ pairwise
ratings directly to adjust the recipe book—no separate critic, no simulated
service, just tuning the probabilities of each dish so the crowd’s favourites
win more often.

## How It Works (Plain English)

You start with a dataset of triplets: a prompt x, a preferred completion y_w,
and a dispreferred completion y_l. The reference policy π_ref is the SFT model.
The DPO loss increases the model’s log‑probability of y_w and decreases it for
y_l, each measured relative to π_ref and scaled by a temperature β that controls
how far you can move from the reference. Concretely, the signal per example is
σ(β · [log πθ(y_w|x) − log π_ref(y_w|x)] − β · [log πθ(y_l|x) − log π_ref(y_l|x)]),
which pushes the model to prefer y_w over y_l with strength depending on how
badly it currently mis‑ranks them.

Three practical perks follow:

- No reward model: you don’t fit a separate network on preferences.
- No PPO rollouts: training is a forward‑only pass over preference pairs with a
  simple loss—stable and fast.
- Built‑in KL control: β plays the same role as the KL penalty coefficient in
  RLHF; you tune one knob to trade off conservatism vs boldness.

Analogy: Instead of learning to drive by trial‑and‑error with a coach in the
car (PPO), you train from a big stack of dashcam comparisons that say “this
lane change was better than that one”, while a limiter (β) stops you from
copying risky moves too aggressively.

## Why It Mattered: Similar Quality, Far Simpler Training

Despite the simplification, DPO matches or outperforms PPO‑based RLHF across
sentiment control, summarisation (TL;DR), and helpful dialogue (Anthropic HH),
and it does so with much less tuning pain. Two standout observations:

- Frontiers that dominate: plotting reward vs KL divergence, DPO’s models trace
  a better frontier than PPO baselines—even PPO with ground‑truth rewards in
  some settings—meaning for any given level of “distance from SFT”, DPO attains
  higher reward.
- Robust sampling: win rates stay high across a range of decoding temperatures,
  avoiding the brittleness where PPO‑tuned models degrade when you turn up
  temperature for more diverse outputs.

Operationally, this is a big deal. Preference data is expensive; training loops
that sample in‑the‑loop are costly and unstable. DPO reuses the same
preference‑collection pipeline but replaces the most complex stage with a
standard supervised pass—easier to implement, monitor, and reproduce.

There are caveats. DPO assumes the Bradley–Terry model of preferences and uses
the SFT policy as the reference; if either is poorly specified, performance can
slip. And, as with RLHF, your model inherits the biases in your preference
dataset; good rater guidelines and coverage still matter. But the core win
remains: a simpler path to the same destination.

## Where It Fits in Our Story

In the course arc, DPO is the pragmatic sequel to InstructGPT. InstructGPT
established the blueprint—optimise for what people prefer, with a KL tether to
keep language natural. DPO keeps the principle and removes machinery: no
explicit reward model, no PPO. That makes alignment accessible to more teams
and encourages faster iteration on what really matters—the preference data and
evaluation.

Looking ahead, you’ll see DPO used as a base for variants (e.g., conditioning
on safety signals, multi‑objective blends) and paired with data strategies like
rejection sampling or synthetic preference generation. The theme continues: less
complex training, more attention on the human signals that define “good”.

[Paper](llm_papers_syllabus/DPO_Direct_Preference_Optimization_Rafailov_2023.pdf)
## See Also
- Prev: [Deep RL from Human Preferences (2017)](18-deep-rl-human-preferences-christiano-2017.md)
- Next: [Constitutional AI](20-constitutional-ai-harmlessness-bai-2022.md)
