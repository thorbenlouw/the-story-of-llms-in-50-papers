# Teaching Models to Follow Instructions, Not Just Imitate Patterns

## The Paper

Finetuned Language Models are Zero‑Shot Learners (FLAN) — Jason Wei, Maarten
Bosma, Vincent Y. Zhao, Kelvin Guu, Adams Wei Yu, Brian Lester, Nan Du, Andrew
M. Dai, Quoc V. Le (2021; ICLR 2022).

## Before the Breakthrough

Large language models (LLMs) stunned people with few‑shot learning: give GPT‑3
three or four examples in the prompt and it often figures out the task. But
remove the examples and just give an instruction—“translate this”, “pick the
right answer”, “summarise the paragraph”—and performance drops. Zero‑shot
behaviour lagged far behind few‑shot.

That gap created friction. Real users don’t want to craft perfect prompts with
dozens of carefully chosen exemplars. They want to say what they want in plain
English and get a good answer. Before FLAN, there was a mismatch: pretraining
taught models to continue text; prompting leveraged that by showing patterns;
but simply following an instruction wasn’t a skill the models had truly
practised.

The question FLAN asked is deceptively simple: if we explicitly teach a model
to follow instructions across many tasks, will it generalise that skill to
unseen tasks with just a natural‑language instruction? In other words, can we
turn “prompt programming” into “say what you want”?

## The Big Idea: Instruction Tuning at Scale

FLAN introduces instruction tuning: finetune a large, pretrained model on a
mixture of tasks phrased as natural‑language instructions. Instead of learning
one task per head or relying only on clever prompts, the model learns the meta‑
skill of “when I’m given an instruction, I do what it says.”

Two cornerstone ideas underpin this work:

- Instruction tuning: present many datasets as instructions plus inputs, and
  train the model to produce the right outputs. This is a foundational concept
  for turning raw LLMs into assistants.
- True zero‑shot evaluation: when evaluating a task type (say, natural language
  inference), FLAN holds out the entire task cluster during training. If it
  performs well, it’s not memorising a dataset—it's transferring the
  instruction‑following skill across tasks.

The training recipe aggregates 62 datasets spanning 12 clusters (translation,
summarisation, QA, NLI, sentiment, and more). Each dataset gets multiple
instruction templates so the model doesn’t overfit to one phrasing. The model
is large (LaMDA‑PT at 137B parameters), because a key finding is that benefits
emerge at scale: below roughly 68B parameters, instruction tuning can even hurt
zero‑shot performance; above that, it shines.

Two analogies help frame what’s going on:

- Think of a universal remote. A few‑shot model works when you pre‑program the
  exact button sequence (exemplars). Instruction tuning is like teaching the
  remote the idea of “volume up” and “change input” in natural language so it
  can control new devices without manual codes.
- Or imagine CrossFit for language: instead of training just for one event, you
  practise many movement patterns with a coach’s instruction. Later, when faced
  with a new workout, you follow the coach’s words and adapt. The adaptation
  skill—not the memorised routine—is what transfers.

Method‑wise, FLAN keeps things practical. It mixes datasets in a size‑aware way
(to avoid a few huge sets dominating), evaluates with rank‑classification and
an OPTIONS suffix for classification tasks (explicit answer choices), and
measures true cross‑task transfer by holding out clusters. The result is a
consistent recipe others can reproduce.

## Why It Mattered: Zero‑Shot That Actually Works

Instruction tuning turns zero‑shot from a parlour trick into a usable mode. On
20 of 25 benchmarks, FLAN’s 137B model beats zero‑shot GPT‑3 175B. On some
tasks, it even rivals few‑shot GPT‑3—without needing any exemplars in the
prompt. For non‑experts, that’s the difference between “prompt engineering” and
“just ask”.

Three practical takeaways stand out:

- Scale matters: the gains appear clearly at large model sizes. Instruction
  tuning teaches a general skill, but the capacity to internalise it lives in
  bigger models.
- Task diversity beats template tinkering: adding more task types helps more
  than adding more phrasings of the same task. If you’re curating data, breadth
  wins over minor wording variations.
- Complements other methods: instruction tuning plays nicely with few‑shot
  prompting and prompt tuning—it's an additive improvement, not a replacement.

Why does this help? Pretraining teaches statistical continuation; few‑shot
prompts nudge the model into the right mode by showing examples; instruction
tuning directly optimises the mapping from instruction → behaviour across many
domains. It narrows the “intent gap” between what users mean and what the model
does.

There are caveats. Instruction tuning doesn’t fix tasks where “instructions are
redundant” (e.g., pure language modelling). Quality and diversity of training
tasks matter; low‑quality instructions can teach the wrong lessons. And because
benefits are scale‑dependent, smaller models may need different recipes (or a
focus on few‑shot instead).

## Where It Fits in Our Story

In the course narrative, FLAN kicks off Phase III: taming the giants. After the
architecture (Transformer) and the scaling playbook (Kaplan, Hoffmann) made big
models possible, we now teach them to be helpful out of the box. FLAN is the
first clear demonstration that instruction‑following is a learnable, transferable
skill—one you can induce with supervised finetuning on a broad set of
instructional tasks.

This paves the way for alignment with human preferences (InstructGPT and RLHF)
and later refinements like DPO. If FLAN is learning to follow the recipe,
InstructGPT is hiring a head chef to taste the dishes and guide adjustments. You
need both to get from raw capability to reliable assistants.

[Paper](llm_papers_syllabus/FLAN_Finetuned_Zero_Shot_Wei_2021.pdf)
## See Also
- Prev: [GPTQ Quantization](12-gptq-accurate-post-training-quant-frantar-2022.md)
- Next: [Emergent Abilities of LLMs](14-emergent-abilities-llm-wei-2022.md)
