# How Models Taught Themselves To Use Tools

## The Paper

Toolformer: Language Models Can Teach Themselves to Use Tools — Timo Schick,
Jane Dwivedi‑Yeh, et al. (2023).

## Before the Breakthrough

Letting models call tools (a calculator, a search API) solves two chronic
problems: brittle arithmetic and stale knowledge. But who writes the training
data that teaches a model when and how to call each tool? Hand‑labelling is
slow, expensive, and doesn’t scale as tools or schemas change.

What if the model could bootstrap this skill itself—discover where a tool would
help, try it, and learn from the result? That’s the insight behind Toolformer:
use the model’s own likelihood as a weak teacher for tool literacy.

## The Big Idea: Self‑Annotation With a Likelihood Filter

The method treats a tool call like a special token in text. The pipeline is:
- Propose candidate tool calls in ordinary text using a prompt that defines each
  tool’s signature (e.g., `[CALC: 23*47]`, `[SEARCH: "who wrote …"]`).
- Execute the candidates and insert the responses back into the text.
- Score whether the augmented text becomes more predictable under the model.
  Keep only the cases where likelihood improves.
- Fine‑tune on the surviving examples so the model learns when and how to call
  tools, and how to integrate their outputs.

Two analogies make this concrete. First, imagine sticky notes in a book margin:
“Check this number on a calculator → 1081.” If the note helps you understand
the next paragraph, you’ll keep it; if not, you’ll toss it. Second, picture a
Swiss Army knife with many tools. Toolformer teaches the model to feel when it
needs the screwdriver versus the scissors, and to put the tool back when it’s
done.

Why it works:
- The likelihood filter is a cheap, model‑native signal that a tool call added
  value in context.
- Encoding tools inside the text lets the model learn context‑sensitive
  decisions (“use a calculator only for tricky arithmetic; otherwise carry on”).

## What It Enabled

Models fine‑tuned this way improve on tasks that benefit from external
computation or retrieval—without a separate controller at inference time. It’s
a scalable recipe: as long as you can prompt the tool’s schema, the model can
teach itself basic usage across several tools.

This complements ReAct. ReAct adds a runtime loop to plan and call tools. 
Toolformer shifts some of that burden into training, so the model “knows” how
to insert calls when prompted. Together, they push systems toward agents that
both plan and execute with minimal hand‑holding.

There are practical caveats: APIs change, self‑generated data can be noisy, and
security matters (never execute arbitrary calls unvetted). But the headline
survives: you don’t need massive manual datasets to teach basic tool use.

## Where It Fits In Our Story

CoT established “think step by step”. ReAct operationalised it into a loop that
consults the world. Toolformer adds a training‑time route to tool literacy so
the model is less surprised by tool tokens at inference. Next, we’ll focus on
the other side of the interface: making API calls reliably correct in the first
place, even when specifications are fiddly.

## Conclusion: Teaching the Model to Reach for the Right Tool

Toolformer shows a clever hack: use the model’s own sense of predictability to
decide which tool calls are worth learning. It’s a simple way to grow practical
capabilities without armies of annotators.

[Paper](llm_papers_syllabus/Toolformer_LLMs_Use_Tools_Schick_2023.pdf)
## See Also
- Prev: [ReAct: Reasoning + Acting](24-react-reasoning-and-acting-yao-2022.md)
- Next: [Gorilla: API‑Accurate Generation](26-gorilla-llm-connected-apis-patil-2023.md)

