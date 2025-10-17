# The Blueprint Behind RLHF

## The Paper

Deep Reinforcement Learning from Human Preferences — Paul F. Christiano, Jan
Leike, Tom B. Brown, Miljan Martic, Shane Legg, Dario Amodei (2017).

## Before the Breakthrough

Classic reinforcement learning assumes you can write down a reward function: a
crisp number the agent should maximise. In many real tasks—“move gracefully”,
“be helpful but harmless”, “do a backflip”—writing that reward is the hard part.
It’s often easier for a human to say “this attempt is better than that one.”

Before language models, this paper tackled the problem in games and control:
learn a reward model from human comparisons of short video clips, then train a
policy to maximise that learned reward. It turned reward design into data
collection and supervised learning, and it introduced the essential loop that
modern RLHF uses for LLMs.

## The Big Idea: Learn the Reward from Comparisons

Two cornerstone ideas power the method:

- Preference‑based reward learning: show a human two short trajectory segments
  and ask which is better. Train a reward network so that the preferred segment
  gets higher cumulative predicted reward (a Bradley–Terry style model).
- Human‑in‑the‑loop training: alternate between collecting rollouts, querying
  humans on informative pairs, fitting the reward model, and optimising the
  policy against that reward.

Analogy: Instead of hard‑coding taste into a recipe, ask diners which dish they
prefer, learn a “house palate” as a scoring function, and then tune your cooking
to maximise that score. Or think of a climbing coach: they watch short attempts,
pick the better one, and the athlete adjusts. Over time, the “what counts as
good” function becomes a model you can optimise.

The striking result: thousands (not millions) of human comparisons were enough
to train policies that learned Atari games and even performed a MuJoCo
backflip—despite having no programmed reward. Active selection of comparison
pairs made labelling efficient.

## Why It Mattered: The RM that Powered InstructGPT

Christiano et al. provided the template later adapted to language models:
collect human preferences; train a reward model; optimise a policy against it.
InstructGPT kept the structure and added a KL penalty to a reference model to
stabilise language quality during RL, but the core RM idea came from here.

The paper also highlighted pitfalls we still worry about:

- Reward hacking: the learned reward can be gamed if it misses important
  signals; agents may exploit quirks rather than achieve the intended goal.
- Oversight cost: expert labels are precious; systems must query humans on the
  most informative comparisons and guard against fatigue or bias.
- Short‑horizon blind spots: comparing brief clips can miss long‑term harms or
  delayed consequences; segment design matters.

## Where It Fits in Our Story

This paper is the origin story for the “R” and the “RM” in RLHF. It shows how
to replace hand‑written rewards with human preferences and close the training
loop with standard RL. In our narrative, it’s the bridge from supervised
instruction tuning (FLAN) to preference‑optimised assistants (InstructGPT/DPO):
the foundational technique that made “optimise for what people actually prefer”
concrete.

As we move through alignment and safety, you’ll see variants that reduce RL
complexity (DPO), change the feedback source (Constitutional AI), or add
guardrails against reward hacking. But the basic pattern—fit a preference model,
optimise a policy—started here.

[Paper](llm_papers_syllabus/Deep_RL_Human_Preferences_Christiano_2017.pdf)
## See Also
- Prev: [InstructGPT (RLHF)](17-instructgpt-training-instructions-ouyang-2022.md)
- Next: [DPO: Direct Preference Optimization](19-dpo-direct-preference-optimization-rafailov-2023.md)
