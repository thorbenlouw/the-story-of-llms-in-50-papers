# Phase IV — Agents and the Future

Here, language models stop being only text predictors and become systems that
plan, look things up, call tools, and reason about images. This phase lays out
the building blocks of practical agents and glimpses beyond the Transformer
at next‑generation architectures.

## Why this phase matters

Even aligned models hit limits: missing facts, brittle arithmetic, or outdated
knowledge. The breakthrough is to interleave “thinking” with “doing”.
Chain‑of‑Thought (CoT) prompting elicits step‑by‑step reasoning. ReAct
operationalises that into a loop—Thought → Action → Observation—so models can
search, consult tools, and revise their plan. Toolformer teaches tool use at
training time via self‑annotation, and Gorilla makes API calls precise and
executable.

Meanwhile, assistants become multimodal. Flamingo showed how to plug vision
features into an LLM and prompt across images and text; LLaVA brought an open,
instruction‑tuned recipe for multimodal chat. Kosmos‑2 added grounding, moving
from “see and tell” to “see and point” with spatial tokens that let a model
refer to specific regions.

## What we cover

- Reasoning and acting: CoT and ReAct as the backbone of tool‑using agents.
- Tool literacy: Toolformer’s self‑supervision and Gorilla’s API‑accurate
  generation for production reliability.
- Multimodality: Flamingo’s connectors, LLaVA’s open recipe, and Kosmos‑2’s
  grounding for actionable visual understanding.
- Glimpses ahead: retrieval‑augmented generation (RAG), long‑context limits,
  and efficient architectures (SSMs like Mamba, RetNet, Hyena) that may shape
  the next chapter.

## How to read this phase

View agents as loops, not monologues:
- Structure: alternate thoughts and actions; constrain tools; inspect traces.
- Evidence: reduce hallucinations by grounding claims in retrieved or observed
  facts.
- Safety: sandbox tools, validate outputs, and log plans for audit.

## Bridge beyond

Agents turn models into collaborators. From here, you can mix retrieval,
planning, and specialised tools to build dependable systems—and explore
efficiency‑first architectures that stretch contexts and lower costs. The
trajectory bends from “predict text” toward “solve tasks”.

