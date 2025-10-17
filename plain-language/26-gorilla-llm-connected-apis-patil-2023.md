# From Guessing to Guaranteed: Making LLMs Speak API Fluently

## The Paper

Gorilla: Large Language Model Connected with Massive APIs — Shishir G. Patil,
Tianjun Zhang, et al. (2023).

## Before the Breakthrough

General‑purpose LLMs are persuasive, but when you ask them to call real APIs
they often hallucinate endpoint names, mangle arguments, or confuse versions.
Plausible‑sounding requests fail in production. If we want agents to book a
flight, file a ticket, or read a spreadsheet through an API, “close enough”
won’t cut it.

Gorilla asks a hard‑nosed question: what if we train the model directly on API
schemas and usage examples so it becomes fluent in the exact endpoints and
parameters developers actually use?

## The Big Idea: Align to Real API Distributions

The recipe is straightforward:
- Curate large corpora of API documentation and real usage examples.
- Encode schema details (endpoint names, parameters, types) clearly in prompts.
- Fine‑tune the model to translate natural‑language intents into exact API
  calls, rewarding endpoint selection and argument correctness.

Think of it like learning a programming language rather than guessing from
snippets. You can get surprisingly far by imitating examples, but fluency comes
from mastering the grammar. Gorilla gives the model that grammar: the names,
shapes, and constraints that make a call executable.

## What It Enabled

On evaluations spanning many endpoints, Gorilla improves exact‑match and
functional correctness over generic LLMs. The gains are practical: fewer
hallucinated endpoints, fewer missing required arguments, better handling of
types and options. The model is less likely to produce an attractive but
non‑existent `createUserV3Extended` and more likely to use the actual `users.create`
with the right fields.

This doesn’t make versioning or schema drift disappear—APIs evolve. But it does
show that aligning to API distributions, not just natural text, is the shortest
path to reliable tool use. In deployment, you can refresh the dataset as
specs change and use schema‑aware prompting to keep generations on the rails.

## Where It Fits In Our Story

ReAct gave us the loop to combine thinking and acting. Toolformer taught models
tool tokens and when they help. Gorilla tackles accuracy at the coalface:
making sure the calls themselves are correct. Together, these form the backbone
of production‑ready agents: plan, decide to use a tool, and issue an API call
that actually works.

Next, we turn to seeing. Modern assistants are not just text‑savvy; they can
look at images too. The multimodal story starts with bridging vision encoders
and LLMs so in‑context learning works across images and text.

## Conclusion: Fluency, Not Guesswork

If you want tools you can trust, train on their specs. Gorilla brings API
fluency into the model so that “please create a ticket” becomes an executable
call, not a hallucinated one.

[Paper](llm_papers_syllabus/Gorilla_LLM_Connected_APIs_Patil_2023.pdf)
## See Also
- Prev: [Toolformer: Self‑Taught Tool Use](25-toolformer-llms-use-tools-schick-2023.md)
- Next: [Flamingo: Multimodal Few‑Shot](27-flamingo-visual-language-model-alayrac-2022.md)

