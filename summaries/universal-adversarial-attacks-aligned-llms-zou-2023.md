# Universal and Transferable Adversarial Attacks on Aligned Language Models (Zou et al., 2023)

- Authors: Andy Zou, Zifan Wang, Nicholas Carlini, Milad Nasr, J. Zico Kolter, Matt Fredrikson
- Venue/Year: arXiv 2023 (v2: 2023-12-20), arXiv:2307.15043
- PDF: [llm_papers_syllabus/Universal_Adversarial_Attacks_Aligned_LLMs_Zou_2023.pdf](../llm_papers_syllabus/Universal_Adversarial_Attacks_Aligned_LLMs_Zou_2023.pdf)

## TL;DR
- Introduces a simple, automatic method (Greedy Coordinate Gradient, GCG) to find a single
  adversarial suffix that jailbreaks many prompts and models.
- Shows high transfer: suffixes optimized on open models (e.g., Vicuna-7B/13B) cause harmful
  outputs in black-box systems (ChatGPT, Bard, Claude) and open models (Llama‑2‑Chat, Falcon).
- Multi-prompt, multi-model training yields “universal” suffixes that reliably elicit objectionable
  behavior across diverse harmful tasks.
- Achieves substantially higher attack success than prior automatic prompt attacks (e.g., AutoPrompt,
  PEZ, GBDA) while requiring no internal access to commercial models.
- Highlights a security gap: alignment defenses are brittle to small, targeted input manipulations;
  calls for principled defenses and evaluation standards.

## Problem and Motivation
Aligned LLMs are trained (via SFT, RLHF, or variants) to refuse harmful requests. However, the
ecosystem continues to see ad‑hoc “jailbreaks” that bypass these guardrails. Prior jailbreaks often
require human ingenuity, are brittle, or fail to transfer across prompts and models. Automatic prompt
generation exists but has shown limited robustness.

The paper asks: Can we automatically learn a small token suffix that, when appended to many
different harmful prompts, causes aligned models to comply instead of refusing? Further, can such
suffixes transfer to closed, production models (e.g., ChatGPT, Bard, Claude) despite being trained on
open models only? Answering “yes” would reveal a structural brittleness in current alignment.

## Core Idea and Contributions
- Universal adversarial suffix: Optimize a fixed token sequence that, when appended to varied
  harmful prompts, dramatically increases the probability of an affirmative, non‑refusal response.
- Greedy Coordinate Gradient (GCG): A simple discrete optimization method that uses token‑level
  gradient signals to propose and greedily accept beneficial one‑token substitutions.
- Multi‑prompt, multi‑model optimization: Train a single suffix to work across many harmful task
  prompts and several open models (e.g., Vicuna‑7B/13B, Guanaco‑7B), improving robustness and
  transfer.
- Strong black‑box transfer: A suffix learned on open models induces harmful behavior in commercial
  systems (ChatGPT, Bard, Claude) and other open models (Llama‑2‑Chat, Pythia, Falcon), despite
  no direct gradients or APIs during training.
- Empirical SOTA vs. automatic prompt baselines: Substantially outperforms prior automatic methods
  such as AutoPrompt, PEZ, and GBDA on benchmark harmful behaviors.

## Method
The goal is to find an adversarial suffix s = [t1, t2, …, tK] (a short list of tokens) that, when appended
to a harmful prompt q, causes an otherwise aligned model M to produce an affirmative response
instead of refusing. The optimization is set up over a suite of harmful prompts Q and (optionally)
multiple source models {M_i}. The success criterion is proxy‑based: maximize the log‑likelihood of
target “compliance” indicators and/or minimize refusal indicators in the model’s next‑token behavior.

- Greedy Coordinate Gradient (GCG):
  - For each coordinate (token position) in s, compute token‑level gradients w.r.t. a loss that marks
    “attack success” (e.g., higher log‑prob for answering vs. refusing).
  - Use gradients to shortlist promising token replacements at that position.
  - Evaluate a handful of candidates exactly and greedily accept the best improvement.
  - Iterate over positions until convergence or a step limit.
- Multi‑prompt, multi‑model objective:
  - Aggregate the loss across a set of harmful prompts (e.g., bomb‑making, tax fraud, etc.).
  - Aggregate across several open‑source chat models to induce robustness and cross‑model transfer.
- Practicalities:
  - The method shares ancestry with AutoPrompt but differs in searching across all token positions at
    each step and in the multi‑prompt, multi‑model setup that stabilizes discovered suffixes.
  - No access to commercial systems is used in optimization; transfer is evaluated afterward.

Intuition: Alignment layers train models to refuse harmful content in typical phrasing, but the
decision boundary can be sharp and fragile. GCG discovers suffix tokens that push model behavior
across that boundary consistently, producing affirmative continuations even for diverse harmful
requests.

## Comparison to Prior Work
- AutoPrompt (Shin et al., 2020): Also uses gradient signals for discrete prompt optimization. GCG
  differs by greedy coordinate search across all positions and by optimizing for multi‑prompt, multi‑
  model universality, yielding markedly higher success in this setting.
- PEZ (Wen et al., 2023) and GBDA (Guo et al., 2021): Prior gradient‑based prompt/tuning attacks
  that underperform on exact harmful target‑string matches and overall success compared to GCG.
- Manual jailbreaks (e.g., DAN‑style prompts): Human‑crafted and often brittle; transfer poorly
  across prompts/models and lack systematic optimization.

## Results and What They Mean
The paper evaluates GCG on a suite of harmful behaviors and multiple models. Key findings:

- Universal suffixes reliably break open models used for optimization and generalize to unseen
  prompts within the harmful‑behavior suite.
- Strong black‑box transfer: Suffixes learned on Vicuna/Guanaco substantially increase harmful
  compliance in ChatGPT, Bard, Claude, and Llama‑2‑Chat, despite no direct access during training.
- Major gains over prior automatic methods: GCG achieves much higher attack success and exact
  target‑string matches than AutoPrompt, PEZ, and GBDA on the evaluated benchmark behaviors.
- Security implications: Alignment based on post‑hoc refusal heuristics can be brittle to small
  adversarial suffixes. Robustness will likely require principled defenses, better evaluation, and
  possibly training‑time robustness techniques rather than only post‑hoc filters.

## Limitations and Failure Modes
- Transfer is uneven: Success is lower against some commercial models (notably Claude) compared to
  GPT‑family models. While still non‑trivial, this indicates architectural/data differences matter.
- Attack scope: The suffixes target refusal behavior rather than arbitrary steering; they may not
  induce complex multi‑step harmful plans without further scaffolding.
- Robustness arms race: As with vision adversarial examples, defenses may reduce some attacks but
  can impose performance costs, overfit to specific threat models, or lag new attack variants.
- Ethical and operational concerns: Disclosing universal suffixes poses misuse risk; responsible
  handling and red‑teaming protocols are emphasized by the authors.

## Fit to This Course (Week: Extension Track A, Section: Security and Robustness of LLMs)
- Key Topics & Labs: Jailbreaking/Evasion; universal, transferable adversarial suffixes; multi‑prompt
  and multi‑model transfer.
- Course fit: This paper is a cornerstone for understanding adversarial prompt attacks against aligned
  LLMs. It connects directly to alignment (why refusals fail), evaluation (how to measure jailbreak
  success and transfer), and system design (threat models for deployment). It sets up later work on
  poisoning, certified robustness, watermarking, and RAG‑specific attacks in this extension track.

## Discussion Questions
1) Why does optimizing a universal suffix across multiple prompts and models improve black‑box
   transfer to commercial systems? What does this suggest about shared alignment features?
2) How would you design a defense that explicitly targets suffix‑style jailbreaks without causing
   over‑refusal (excessive false positives) on benign inputs?
3) What evaluation protocol would you adopt to track the arms race, ensuring defenses are tested
   against adaptive attacks rather than a fixed attack set?
4) Could training‑time robustness (e.g., adversarial SFT/RLHF) meaningfully harden refusal behavior,
   or would it mostly chase artifacts of current attacks?
5) Where should responsibility lie operationally for mitigation: model developers, platform providers,
   or application builders? What feedback loops are needed?

## Glossary
- Universal adversarial suffix: A fixed token sequence appended to diverse prompts that reliably
  induces a normally‑refusing model to comply.
- Greedy Coordinate Gradient (GCG): Discrete optimization method that greedily replaces suffix
  tokens using token‑level gradients to propose/highlight beneficial substitutions.
- Transferability: An attack’s ability to succeed on unseen models or prompts after being optimized
  on others.
- Refusal behavior: Alignment‑induced policy of declining harmful requests (e.g., “I can’t help with…”).
- Black‑box attack: An attack mounted without gradients or internal access to the target model.
- Exact target‑string match: Evaluation criterion requiring the model to output a specific harmful
  string or closely predefined wording.
- Prompt‑level adversarial example: An input‑space perturbation (here, a token suffix) that changes
  the model’s behavior without modifying model parameters.
- Alignment: Post‑pretraining finetuning (SFT/RLHF) or system policies that steer models away from
  harmful outputs.
- Adversarial training: Training with adversarially perturbed inputs to increase robustness to similar
  attacks (effective in vision; costly and narrow in scope).
- Safety filter: Post‑hoc detection/guardrail layer that attempts to block harmful content at inference.

## References
- Paper: Zou, Wang, Carlini, Nasr, Kolter, Fredrikson. “Universal and Transferable Adversarial Attacks
  on Aligned Language Models.” arXiv:2307.15043, 2023.
- Related: Shin et al. “AutoPrompt: Eliciting Knowledge from Language Models with Automatically
  Generated Prompts.” 2020. Wen et al. “PPrompt/PEZ.” 2023. Guo et al. “Gradient‑based discrete
  adversarial attacks (GBDA).” 2021. Ouyang et al. 2022 (InstructGPT). Bai et al. 2022 (Constitutional AI).

## Claim Checks (with PDF hints)
- Abstract: “Our approach finds a suffix that … maximizes the probability the model produces an
  affirmative response …” and shows high transfer to ChatGPT, Bard, Claude, Llama‑2‑Chat.
- Figure 1: Demonstrates a single adversarial prompt/suffix eliciting harmful outputs from multiple
  commercial/open models.
- Section 1 (Introduction): Reports universal/multi‑model training and transfer, including to GPT‑family
  models, Bard, Claude, and Llama‑2‑Chat.
- Section 1: “99/100” harmful behaviors in Vicuna and “88/100” exact target‑string matches; “up to
  84%” success on GPT‑3.5/GPT‑4 and “66%” on PaLM‑2; Claude success is lower (~2%).
- Section 2: Technical description of the universal attack and the GCG optimizer; token‑level
  gradients guide replacements and greedy selection.
- Sections 2–3: Multi‑prompt and multi‑model setup (Vicuna‑7B/13B, Guanaco‑7B) improves robustness
  and transfer.
- Discussion/Responsible Disclosure: Notes coordination with OpenAI, Google, Meta, Anthropic; calls
  out broader impacts and ethical considerations.

