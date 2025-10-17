# Teaching Models To Think, Look Things Up, and Try Again

## The Paper

ReAct: Synergizing Reasoning and Acting in Language Models — Shunyu Yao,
Jeffrey Zhao, Dian Yu, et al. (2022).

## Before the Breakthrough

Chain‑of‑thought prompting made models better at planning on paper. But they
still hallucinated facts, went out of date, and couldn’t use a calculator. In
other words, they could think—but not look. Meanwhile, tool‑calling systems
could fetch facts, yet lacked robust planning: they would retrieve blindly and
often miss the point.

Real tasks need both. Think about answering a trivia question you half‑remember
or solving a bug where you must check docs. You reason about what to search,
you search, you read, you update your plan, and you repeat. The missing piece
was a simple loop that lets models do exactly that.

## The Big Idea: Interleave Thoughts and Actions

ReAct introduces a text‑only control loop: Thought → Action → Observation,
repeated until the answer is ready. In a prompt, you show examples where the
model writes a short “Thought” (e.g., “I should search for the film’s release
year”), issues an “Action” (e.g., `Search[query]`), reads the “Observation”
returned (e.g., a snippet), then continues reasoning.

Two analogies help. First, it’s like a detective’s notepad. Jot a hypothesis,
run a check, record the clue, update the hypothesis, then move on. Second,
think of it as pair‑programming with a terminal. You sketch a plan, run a
command, read the output, refine the plan, and continue. The explicit alternation
between thinking and doing keeps the process grounded.

Why it works:
- Acting grounds claims in evidence retrieved mid‑answer, reducing hallucination.
- Reasoning chooses what to do next, preventing aimless tool spam.
- Iteration lets the model correct itself when observations contradict earlier
  assumptions.

## What It Enabled

Compared to “think‑only” prompting or “act‑only” retrieval, ReAct improves task
completion on knowledge‑intensive QA and interactive tasks that require both
planning and information access. It also makes systems easier to inspect:
developers can read the Thoughts and Actions to understand where things went
wrong, set step limits to control cost, and whitelist tools for safety.

In practical deployments, the pattern scales: you can swap `Search` for any API
you expose—documentation lookup, encyclopaedias, calculators, databases. The
model stays in natural language; the action format stays simple and
schema‑constrained, which keeps things robust.

There are trade‑offs: more steps mean more tokens and higher latency, and the
model can still choose misguided actions. But the blueprint is reusable and
transparent, which is a huge win for debugging and governance.

## Where It Fits In Our Story

CoT taught models to “show their working”. ReAct turns that working into a
control loop that can consult the outside world. It’s the bridge from clever
completions to useful agents. The next pieces of the puzzle will show two
complements: teaching models tool use during training (so they naturally emit
API calls when needed), and aligning them to real API schemas so calls are not
just plausible but correct.

## Conclusion: From Monologues to Dialogues With the World

ReAct moves models from internal monologues to conversations with tools. It’s a
simple idea with outsized impact: alternate thinking and acting, and let
observations steer the plan. That theme—grounding clever text in real
capabilities—repeats throughout modern LLM systems.

[Paper](llm_papers_syllabus/ReAct_Reasoning_and_Acting_Yao_2022.pdf)
## See Also
- Prev: [Chain‑of‑Thought Prompting](23-chain-of-thought-reasoning-wei-2022.md)
- Next: [Toolformer: Self‑Taught Tool Use](25-toolformer-llms-use-tools-schick-2023.md)

