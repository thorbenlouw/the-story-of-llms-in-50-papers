# Gorilla: Large Language Model Connected with Massive APIs (Patil et al., 2023)

## TL;DR
- Fine-tunes LLMs on curated API documentation and examples to reliably generate correct API calls.
- Introduces dataset construction and training strategies that improve precision and coverage for real-world tool use.
- Outperforms general-purpose LLMs on API selection, argument formatting, and endpoint accuracy.
- Focuses on robustness to changing specifications and ambiguity via schema-aware prompting and finetuning.
- Provides a practical path to production-grade tool use by aligning models to API distributions.

## 1) Title and Citation
- Gorilla: Large Language Model Connected with Massive APIs. Patil, S. et al. 2023. arXiv:2305.15334.

## 2) Problem and Motivation
General LLMs often produce brittle or hallucinated API calls. Without training on authentic API schemas and usage patterns, they struggle with exact endpoint names, parameter types, and argument order. Gorilla addresses this by aligning models directly to large, realistic API corpora so they can produce accurate, executable calls from natural language instructions.

## 3) Core Idea and Contributions
- API-focused finetuning: train on large-scale API docs and usage examples so the LLM learns endpoint semantics and argument conventions.
- Schema-aware prompting: represent API signatures and constraints to steer generation towards valid calls.
- Evaluation on diverse APIs: show improved accuracy in endpoint selection and argument correctness vs. general LLMs.
- Practical emphasis: reduce tool-use hallucination and improve reliability for developer workflows.

Pointers:
- Paper details data collection from API docs and how prompts encode schema information (Method).
- Results show better exact-match/functional correctness on held-out APIs (Results).

## 4) Method (Plain-Language)
- Collect API documentation and sample invocations across domains.
- Normalize schema representations (endpoint names, arguments, types) and present them in prompts.
- Finetune an LLM to translate natural language intents into API calls, with objective functions rewarding exactness.
- Evaluate on benchmarks measuring endpoint selection, argument formatting, and execution correctness.

Why it works:
- Exposure to real schemas teaches the model precise constraints that generic pretraining lacks.
- Schema-aware prompts reduce hallucination by constraining the search space.

## 5) Comparison to Prior Work
- ReAct/Toolformer: Focus on reasoning and training-time tool literacy broadly; Gorilla targets high-fidelity API generation with schema alignment.
- Retrieval-Augmented Generation (RAG): Retrieves knowledge but not necessarily executable calls; Gorilla’s outputs are directly actionable.
- General LLMs: Can guess API formats; Gorilla’s training grounds generations in true specifications.

## 6) Results and What They Mean
- Shows substantial gains in API call exactness and parameter correctness on evaluation suites spanning many endpoints.
- Demonstrates that aligning to API distributions is critical for reliable tool use in production.
- Suggests a path to maintainability by updating training data as APIs evolve.

Fidelity checks:
- Method: construction of API datasets and schema encoding.
- Results: exact match and functional correctness metrics on benchmarked endpoints.

## 7) Limitations and Failure Modes
- Schema drift and versioning: models may lag behind changing APIs; continual refresh pipelines are needed.
- Domain coverage: performance depends on breadth and quality of API training data.
- Security and governance: care is needed to avoid generating unsafe or unauthorized calls.

## 8) Fit to This Course (Week 10, Deployment, Agents, and The Future)
- Key Topics & Labs: Reliable tool use; schema grounding; evaluation of API-accurate text-to-API generation.
- Fit: Complements ReAct and Toolformer by emphasizing correctness and robustness of API calls, a requirement for real-world agents.

## 9) Discussion Questions
1) How would you design metrics that reflect real-world API correctness beyond exact string match?
2) How can retrieval (docs, examples) be fused with Gorilla-style finetuning for unseen endpoints?
3) What guardrails prevent misuse (e.g., access controls, rate limits, data exfiltration)?
4) How should datasets handle deprecations and versioning to maintain model reliability?
5) What prompts elicit disambiguation questions when user intent is under-specified?

## 10) Glossary
- Schema-Aware Prompting: Including API signatures/constraints in prompts to bias generation towards valid calls.
- Endpoint Selection: Choosing the correct API function given a user intent.
- Argument Formatting: Generating parameters that match types and required fields.
- Functional Correctness: Whether an API call is executable and produces the intended effect.
- Tool Hallucination: Generating non-existent endpoints or parameters.
- Versioning: Managing changes in API schemas over time.

## 11) References
- Patil et al. 2023. Gorilla: Large Language Model Connected with Massive APIs. arXiv:2305.15334. Method, dataset construction, and results in the core sections.
