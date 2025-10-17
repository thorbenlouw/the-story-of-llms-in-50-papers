# Teaching Models to Be Helpful: The Human-in-the-Loop Breakthrough

## The Paper

Training Language Models to Follow Instructions with Human Feedback (InstructGPT)
— Long Ouyang, Jeff Wu, Xu Jiang, Diogo Almeida, Carroll Wainwright, Pamela
Mishkin, et al. (2022).

## Before the Breakthrough

Pretrained language models learned one skill extraordinarily well: predict the
next token. That skill gave us fluent text, but not necessarily helpful
behaviour. Ask an untuned GPT‑3 to “explain photosynthesis to a nine‑year‑old”
and you might get verbosity, hedging, or a lecture that ignores your intent. In
other cases, the model might offer unsafe advice or confidently make things up.

Why? Because the objective we trained on—predict the next token from the
internet—wasn’t the objective users cared about. Users want models that follow
instructions, stay on task, avoid harm, and speak at the right level. Prompting
and few‑shot examples helped, and instruction tuning (like FLAN) moved the
needle. But we still lacked a way to directly optimise models for what humans
actually prefer.

This is the central tension: a base model is like a brilliant but indifferent
intern—great memory, fast writer, no sense of what people actually want. The
field needed a method to teach taste and judgement, not just grammar.

## The Big Idea: Optimise for Human Preferences, Not Just Likelihood

InstructGPT introduced the now‑standard recipe known as RLHF: Supervised
Fine‑Tuning (SFT) → Reward Modelling (RM) → Reinforcement Learning (PPO) with a
KL penalty. The aim is simple to say and subtle to execute: use human feedback
to define “better” responses, then push the model toward those, while keeping it
close to the competent language you started with.

Let’s call out two cornerstone concepts we’ll revisit throughout the course:

- Reward model (RM): a learned scoring function trained from pairwise human
  preferences. Given two candidate answers to a prompt, humans pick the better;
  the RM learns to score that answer higher. This turns messy, qualitative
  judgements (helpfulness, clarity, tone) into a single guidance signal.
- KL penalty to a reference model: a regulariser that discourages the policy
  from straying too far from the SFT model. It’s a seatbelt against “reward
  hacking”, where the model chases RM points at the cost of language quality.

The pipeline in plain English:

1) SFT initialises good manners. Collect prompts; have trained annotators write
   high‑quality responses; fine‑tune the base LM on these (prompt, response)
   pairs. This already improves instruction following compared to the purely
   pretrained model.

2) Train a reward model from preferences. For each prompt, sample several model
   answers (often from the SFT policy). Humans compare pairs and mark which is
   better. Train a model to predict these preferences, producing a scalar reward
   for any new answer.

3) Optimise the policy with PPO. Treat the language model like a policy in
   reinforcement learning. Generate answers; score them with the reward model;
   update the model to increase reward—while penalising shifts away from the SFT
   reference via a KL term. The KL is the tug that keeps the model fluent and
   grounded while it learns what people like.

Two analogies help this click:

- Restaurant service: Pretraining makes a chef who can cook anything—but may
  serve five courses when you asked for a snack. SFT gives a basic menu of good
  service. The reward model is customer feedback distilled into a house style.
  PPO teaches the chef to optimise for that style without forgetting how to
  cook.
- GPS with guardrails: The reward model sets the destination (“helpful answer”);
  PPO drives towards it; the KL penalty is the lane‑keeping assist, nudging you
  back if you swerve into weird language or off‑policy behaviour.

## Why It Mattered: People Preferred the Smaller, Aligned Model

The headline result astonished the field: a much smaller InstructGPT model was
preferred by human evaluators over a far larger untuned model on real prompts.
Alignment beat brute size. Users judged the aligned model more helpful, more
truthful, and less toxic across diverse tasks—without elaborate prompt
engineering.

Three practical wins stand out:

- Better UX: You can “just ask”. No carefully crafted few‑shot prompts needed.
- Safer defaults: Toxicity and obvious harmful outputs decreased while keeping
  usefulness.
- Data pipeline playbook: A concrete method for collecting instruction prompts,
  demonstrations, and preference pairs—scalable to industry.

The safety story is nuanced but important. Because preference data can include
explicitly unsafe prompts with preferred safe refusals, the reward model learns
both helpfulness and harmlessness. The KL penalty stabilises training so the
model doesn’t overfit the reward and start producing unnatural or overly terse
text. Overall, the aligned models behaved more like assistants and less like
autocomplete.

There are limits. Optimising against a learned reward invites “reward hacking”:
the model might discover quirks in the RM and exploit them. You also inherit
your raters’ biases—what’s “helpful” depends on guidelines and culture. The
paper acknowledges this and uses clear rater instructions and quality control,
but the deeper lesson remains: alignment is as much about good data and
governance as clever algorithms.

## How the Pieces Fit Together (A Clearer View Under the Bonnet)

- Prompts and SFT: The team gathered a broad set of real‑world prompts. Human
  labelers produced high‑quality answers; the base LM was fine‑tuned on this to
  create the reference SFT policy. This step alone improves behaviour by making
  “follow the instruction” a learned pattern.

- Preference data and RM: From the SFT policy, sample multiple completions per
  prompt. Raters compare pairs (“A” vs “B”) and select the better one. Train the
  reward model on these comparisons using a ranking loss so that higher‑quality
  answers receive higher scores. The RM learns the house style of helpfulness.

- PPO with KL: In reinforcement learning terms, the return is the RM score
  minus β × KL(policy || reference). The β coefficient controls how tightly the
  model stays tethered to the SFT policy—too loose and you risk reward hacking;
  too tight and you can’t learn much. PPO supplies stable gradients for these
  updates.

- Evaluation: Crucially, the paper focuses on human evaluation—asking people to
  prefer outputs—not just perplexity. It also measures safety proxies (toxicity,
  refusal quality) to see whether helpfulness gains come at a cost. The best
  models improve both fronts.

## Where It Fits in Our Story

InstructGPT is the inflection point that begins Phase III: taming the giants.
After the Transformer unlocked scale (Phase I) and we learned to spend compute
wisely (Phase II), this work shows how to convert raw capability into helpful
behaviour. It provides the blueprint for assistants that follow instructions
with minimal prompting.

It also framed the next wave of research and practice:

- Instruction tuning vs RLHF: FLAN proved instruction‑following is a learnable
  supervised skill; InstructGPT adds preference optimisation to push quality and
  safety further. Many modern systems use both.
- Data and guidelines matter: The quality of SFT and preference data determines
  the assistant you get. This insight paved the way for better rater policies,
  safety taxonomies, and red‑teaming.
- Simpler alternatives: Later work like DPO simplifies the PPO loop by
  optimising directly on preference data without explicit rollouts, addressing
  some RL complexity while chasing similar benefits. But the core idea—optimise
  for what humans prefer—comes straight from InstructGPT.

Looking ahead in the course, you’ll see how this approach evolves. Constitutional
AI explores encoding written principles into the feedback loop. TruthfulQA and
related work probe honesty. Security papers stress‑test the aligned models for
jailbreaks and injections. But the common thread remains: alignment is not a
single trick; it’s an ecosystem of data, objectives, and safeguards—all rooted
in the InstructGPT insight that we should optimise for what people actually
want.

[Paper](llm_papers_syllabus/InstructGPT_Training_Instructions_Ouyang_2022.pdf)
## See Also
- Prev: [BIG-bench](16-big-bench-beyond-imitation-game-srivastava-2022.md)
- Next: [Deep RL from Human Preferences (2017)](18-deep-rl-human-preferences-christiano-2017.md)
