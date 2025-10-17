# Do Models Believe Their Own Reasoning?

## The Paper

Measuring Faithfulness in Chain‑of‑Thought Reasoning — Tamera Lanham, Ethan
Perez, and the Anthropic Alignment Team (2023).

## Before the Breakthrough

Chain‑of‑thought (CoT) prompting took off because it improved accuracy on many
reasoning tasks: ask the model to “think step by step”, then give the answer.
That success tempted people to treat CoT as a transparent window into how the
model reasons. But is the written reasoning actually used to produce the answer
—or is it a story the model tells after it has already decided?

That distinction—faithfulness—matters. In high‑stakes settings (medicine,
finance, law), we don’t just want the right answer; we want to trust the
process. If the reasoning is post‑hoc, it’s a narrative, not an explanation.
This paper probes that question directly.

## The Big Idea: Poke the Reasoning and See If the Answer Moves

The authors design interventions on the CoT and measure whether the final
answer changes. If manipulating the reasoning often leaves the answer untouched,
the model likely wasn’t using it (unfaithful). If small changes to the CoT alter
the answer, that’s evidence the model is conditioning on the reasoning
(potentially faithful).

Four tests structure the investigation:

- Early answering: truncate the CoT part‑way and force an answer. Sensitivity to
  truncation suggests the model updates as it reasons.
- Adding mistakes: insert a plausible error in one step and regenerate; if the
  answer flips, the model relied on the chain.
- Filler tokens: replace the CoT with “...” of similar length; if accuracy drops
  vs real CoT, the gains aren’t just from extra test‑time compute.
- Paraphrasing: reword the CoT; if performance holds, subtle phrasing isn’t a
  hidden code (“steganography”).

Analogies help. Think of a maths student: if you erase the middle of their
working and they still write the same result, odds are they’d already decided
the answer (post‑hoc). If a single mistaken step derails them, the working was
the path, not theatre. Or picture a navigator: if you swap the route notes and
they still end up at the same destination, they weren’t reading the notes.

Results vary by task and size. On datasets like AQuA and LogiQA, answers depend
more on the chain—faithfulness is higher. On ARC Easy and HellaSwag, models
often ignore the written reasoning. Surprisingly, larger models tend to be less
faithful on these tests than mid‑sized ones: an inverse scaling trend for
faithfulness, even as accuracy improves.

## Why It Mattered: Separating Accuracy from Interpretability

Two hard‑won lessons emerge:

- CoT helps accuracy, but it isn’t automatically an explanation. Faithfulness is
  task‑ and size‑dependent.
- Performance gains don’t come from padding the context with junk (“...” doesn’t
  help) or from secret codes hidden in phrasing (paraphrases work similarly).

For practitioners, this means treating CoT as a tool, not a guarantee. If you
need faithful reasoning, you may prefer specific sizes, harder tasks, or
structured approaches (e.g., decomposing questions, using programs/tool calls)
that tie the answer to a verifiable process.

## Where It Fits in Our Story

This paper complements TruthfulQA and HELM in Phase III’s evaluation arc. After
we align models to be helpful and harmless (FLAN, InstructGPT, DPO, CAI), we
also need to know whether their “thinking” can be trusted. Faithfulness tests
give us a way to tell when chain‑of‑thought is reasoning versus rhetoric.

Looking forward to agents (Phase IV), the lesson is clear: when models act—use
tools, browse, execute code—prefer pipelines where reasoning steps are grounded
in checkable operations. CoT can be persuasive; faithfulness makes it reliable.

[Paper](llm_papers_syllabus/Measuring_Faithfulness_CoT_Lanham_2023.pdf)
## See Also
- Prev: [TruthfulQA](21-truthfulqa-measuring-falsehoods-lin-2021.md)
