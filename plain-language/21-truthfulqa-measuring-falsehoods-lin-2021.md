# When Models Parrot Our Myths

## The Paper

TruthfulQA: Measuring How Models Mimic Human Falsehoods — Stephanie Lin, Jacob
Hilton, Owain Evans (2021; Oxford/OpenAI).

## Before the Breakthrough

By 2021, large language models could answer questions fluently. But there was a
catch: ask about common misconceptions and they’d often echo popular myths with
confidence. Why? Because we trained them to imitate the internet, and the
internet contains both facts and folklore. A model optimised to predict the next
token will happily reproduce whatever patterns are most likely—including wrong
ones that sound plausible.

Existing benchmarks mostly asked straightforward trivia. They rewarded recall,
not scepticism. What we lacked was a test that asked: can a model tell the
difference between “what people say online” and “what’s actually true” when the
two diverge?

Think of an eager student who’s memorised every answer sheet—including the wrong
ones floating around on forums. Without a teacher checking sources, that student
will parrot mistakes confidently. We needed a way to grade for truthfulness, not
just fluency and recall.

## The Big Idea: Test Truthfulness Where It’s Hard

TruthfulQA builds a benchmark designed to trigger “imitative falsehoods”—false
answers that models give because those claims are common in training data. It
contains 817 short, carefully crafted questions across 38 categories (health,
law, conspiracies, finance, etc.). Many are adversarially filtered: the authors
iteratively wrote questions that consistently fooled GPT‑3‑175B, then kept the
ones where it failed even with prompt tweaks.

Two cornerstone ideas are central here:

- Imitative falsehoods: false statements that are high‑probability continuations
  of internet text. The language modelling objective actively rewards them.
- Inverse scaling: larger models aren’t necessarily more truthful; they can get
  worse at this benchmark because they’re better at imitating the web’s mix of
  truths and myths.

The benchmark evaluates both free‑form generation and multiple choice. For
generation, human raters judge answers on two axes: truthfulness (did it avoid a
false claim?) and informativeness (did it actually say something useful?). The
intersection—true and informative—is the gold standard. There’s also an automated
metric, “GPT‑judge”, trained on human labels to speed up evaluation.

Analogy time: imagine a pub quiz where half the questions are urban‑legend traps
(“Does cracking your knuckles cause arthritis?”). A contestant who’s only heard
pub chatter will stumble; a contestant who checks reliable sources will pass.
TruthfulQA is that trap‑aware quiz for LLMs.

## Why It Mattered: Fluency Isn’t Truth

The results were sobering. Humans scored around 94% truthfulness on the
benchmark. GPT‑3‑175B—then the flagship—managed roughly 58% under helpful
prompting and far worse with generic prompts. Larger models across families
often did worse than smaller ones, showing inverse scaling: better imitators are
better parrots of falsehoods too.

Two practical insights emerged:

- Prompting helps, but only so far. Asking the model to “answer truthfully and
  concisely” improved scores substantially, but didn’t eliminate confident
  falsehoods. Instructions can nudge, not rewire.
- Alignment beats size for this objective. Methods that give the model a target
  beyond likelihood—RLHF/DPO for helpfulness and honesty, retrieval augmentation
  to consult sources—show more promise than scaling alone.

There’s also a crucial trade‑off: a model that says “I have no comment” to
everything would be 100% truthful and 0% informative. The sweet spot balances
truth and usefulness. In deployment, that balance depends on context: medical
assistants should bias toward caution; creative writing tools may accept more
speculation.

Under the bonnet, the paper provides evidence that these failures are genuinely
imitative, not just quirks of phrasing: paraphrasing questions didn’t fix them,
and control questions (trivia look‑alikes) showed models could handle the
syntax—it’s the content that tricked them.

## Where It Fits in Our Story

TruthfulQA slots into Phase III (alignment and safety) as a reality check. After
we've made models helpful (FLAN, InstructGPT, DPO) and safer (Constitutional
AI), we still have to measure whether they tell the truth when the training data
leans the other way. It reframes a core lesson: the pretraining objective is not
truth; it’s imitation. If you want truth, you must target it explicitly—through
evaluation, data, and training signals.

This benchmark also explains why later techniques matter. RLHF and DPO give
humans a say in what “good” looks like. Constitutional approaches encode rules
for rejecting harmful myths. Retrieval‑augmented generation adds citations and
external grounding. And work on chain‑of‑thought faithfulness asks models to
reason in ways that can be checked, not just sound convincing. Together, these
threads move systems from fluent mimics toward reliable assistants.

One final analogy: think of pretraining as learning the language of the web,
accents and all. TruthfulQA is the pronunciation test that flags when the accent
drifts into misinformation. Passing it consistently requires new lessons—not
just a louder voice.

[Paper](llm_papers_syllabus/TruthfulQA_Measuring_Falsehoods_Lin_2021.pdf)
## See Also
- Prev: [Constitutional AI](20-constitutional-ai-harmlessness-bai-2022.md)
- Next: [Measuring Faithfulness in Chain-of-Thought](22-measuring-faithfulness-cot-lanham-2023.md)
