# Show Your Working: Why Step‑By‑Step Thinking Unlocked Better Answers

## The Paper

Chain‑of‑Thought Prompting Elicits Reasoning in Large Language Models — Jason
Wei, Xuezhi Wang, Dale Schuurmans, et al. (2022).

## Before the Breakthrough

Before this paper, we had bigger and better language models, but they still
struggled with problems that needed multi‑step reasoning: word maths, logic
puzzles, or tasks where you have to keep track of intermediate results. The
typical prompt looked like “Question → Answer”, which quietly asks the model to
leap straight to the destination.

If you’ve ever marked a maths exam, you’ll know the rule: “show your working”.
It’s easier to be right when you solve a problem in steps, and easier to spot
where you went wrong when you don’t. Models were being asked to give the final
number without the notes. The authors asked a simple question: what happens if
we ask models to write those notes first?

## The Big Idea: Ask For The Chain Of Thought

The core trick is tiny but powerful: include a few examples in the prompt where
each solution is written step by step, then ends with the final answer.
Presented with “worked examples”, large models start to imitate the pattern:
they first produce their own chain‑of‑thought (the steps), then the answer.

Two key ideas to keep in mind:
- Chain‑of‑thought (CoT) is just a prompting pattern. No extra training is
  required. You’re still using the model you already have, but you nudge it to
  “think out loud”.
- The benefit grows with scale. Small models often ramble without improving. Big
  models suddenly get much better at arithmetic and symbolic tasks once they’re
  prompted to reason in steps.

Analogy time. Imagine asking a friend for directions. One way: “How do I get to
the station?” Friend says, “Go there.” Not helpful. A better way: “First, walk
two blocks, then turn left at the café, then cross the bridge.” CoT turns the
model from a destination‑only answerer into a turn‑by‑turn navigator. Another
analogy: assembling flat‑pack furniture. If you try to jump from box to
finished chair, you’ll miss a dowel. The instruction sheet—the steps—prevents
errors. CoT is that instruction sheet.

Under the hood, the prompt changes the task from “predict the answer” to
“predict the reasoning and the answer”. That gives the model more surface area
to match the structure of problem solving it has seen in the examples. It also
reduces brittle shortcuts: by expanding the path to the solution, errors have a
chance to be corrected mid‑way rather than only at the end.

## Why It Mattered: Reasoning Becomes Practical

The paper shows strong gains on multi‑step tasks—especially arithmetic word
problems (like GSM8K), symbolic transformations, and commonsense reasoning that
benefits from decomposition. Crucially, those gains are not a free lunch: CoT
outputs are longer, so latency and cost go up. But for many real tasks, the
trade‑off is worth it.

CoT also changed expectations about scaling. Some abilities appear to “pop out”
once models are big enough; below that, the same prompting seems futile. That’s
useful for planning: if you want step‑by‑step reasoning, you either need enough
capacity—or you need to fake capacity with tools and retrieval (which we cover
next).

There’s a caveat. The steps a model writes aren’t guaranteed to reflect the
“true” internal computation. Sometimes the reasoning is a neat story attached to
a correct answer rather than the cause of it. Later work studies this
faithfulness problem. Still, in practice, asking for steps often improves the
final answer and provides a handle to inspect and debug model behaviour.

## Where It Fits In Our Story

You’ve just come through phases where we perfected the architecture (Transformer)
and learned to scale it sensibly (Kaplan, Hoffmann). Chain‑of‑Thought marks the
start of the “agents and reasoning” arc. It’s the prompt pattern that turns a
model from a fast guesser into a step‑by‑step problem solver. Everything that
follows—agents that use tools, systems that search the web mid‑answer—builds on
this idea of “think first, then act”.

If you want your model to plan, ask it to plan in the prompt. If you want it to
be less brittle, give it room to write intermediate notes. CoT gave us a
surprisingly effective way to do both without retraining.

## Conclusion: Steps Before Shortcuts

CoT doesn’t make models omniscient; it gives them a better path through tricky
problems. Next we’ll see how to extend this: when thinking isn’t enough because
the model lacks facts or calculators, we’ll let it act—search, look things up,
and use tools between thoughts.

[Paper](llm_papers_syllabus/Chain_of_Thought_Reasoning_Wei_2022.pdf)
## See Also
- Prev: [Measuring Faithfulness in Chain‑of‑Thought](22-measuring-faithfulness-cot-lanham-2023.md)
- Next: [ReAct: Reasoning + Acting](24-react-reasoning-and-acting-yao-2022.md)

