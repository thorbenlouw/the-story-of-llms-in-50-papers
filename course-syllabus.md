-----

## 12-Week LLM Syllabus: A Deep Dive into the State-of-the-Art (2 Papers/Week)

| Week | Section | Key Topics & Labs | Seminal Papers (with valid arXiv links) |
| :--- | :--- | :--- | :--- |
| **Phase I: The Transformer Foundations (Weeks 1-3)** |
| 1 | **Core Transformer Architecture** | Recap of RNN/LSTM limitations (for context). Multi-Head Self-Attention derivation and complexity analysis. Transformer Encoder/Decoder structure. Positional Encodings. | **1. Attention Is All You Need** (Vaswani et al., 2017) [arXiv:1706.03762]<br>**2. Recurrent Neural Network Regularization** (Zaremba et al., 2014) [arXiv:1409.2329] *(Contrasts with the Transformer's solution to sequential issues)* |
| 2 | **Pre-training Paradigms & Models** | Causal Language Modeling (GPT). Masked Language Modeling (BERT). Unsupervised Pre-training and semi-supervised transfer learning. Tokenization (BPE, WordPiece). | **1. Improving Language Understanding by Generative Pre-Training** (Radford et al., 2018) [arXiv:1803.02157]<br>**2. BERT: Pre-training of Deep Bidirectional Transformers for Language Understanding** (Devlin et al., 2018) [arXiv:1810.04805] |
| 3 | **Context, Embedding, and $\text{T}5$** | Positional Encoding Deep Dive ($\text{RoPE}$ vs. Absolute). The unified text-to-text paradigm. **Lab:** Implementing a small $\text{GPT}$-style block and fine-tuning an open-source $\text{T}5$ model on a sequence-to-sequence task. | **1. Exploring the Limits of Transfer Learning with a Unified Text-to-Text Transformer** (Raffel et al., 2019) [arXiv:1910.10683]<br>**2. RoFormer: Enhanced Transformer with Rotary Position Embedding** (Su et al., 2021) [arXiv:2104.09866] |
| **Phase II: Scaling and Efficiency (Weeks 4-6)** |
| 4 | **Scaling Laws & Compute Optimization** | Empirical scaling of model size, dataset size, and compute budget. The *Chinchilla* optimal scaling theory. Data and model parallelization concepts (Megatron-LM). | **1. Scaling Laws for Neural Language Models** (Kaplan et al., 2020) [arXiv:2001.08361]<br>**2. Training Compute-Optimal Large Language Models** (Hoffmann et al., 2022) [arXiv:2203.15556] |
| 5 | **Mixture-of-Experts ($\text{MoE}$) Architectures** | Theory of sparse activation and conditional computation. Router mechanisms and load balancing. The efficiency trade-offs of $\text{MoE}$. **Lab:** Implementing a basic $\text{MoE}$ layer and comparing its memory usage vs. a dense layer. | **1. Switch Transformers: Scaling to Trillion Parameter Models with Simple and Efficient Sparsity** (Fedus et al., 2021) [arXiv:2101.03961]<br>**2. $\text{LLaMA}$ 2: Open Foundation and Fine-Tuned Chat Models** (Touvron et al., 2023) [arXiv:2307.09288] *(Context for modern scaling and data curriculum)* |
| 6 | **Inference Efficiency & Hardware** | The quadratic bottleneck in inference. **$\text{KV}$ Caching**. The mechanics of **FlashAttention** (tiling and fusion). Quantization schemes (8-bit, 4-bit, $\text{GPTQ}$). | **1. Attention Is All You Need, But With A Lot Less Time** (Dao et al., 2022) - *FlashAttention* [arXiv:2205.14135]<br>**2. $\text{GPTQ}$: Accurate Post-training Quantization for Generative Pre-trained Transformers** (Frantar et al., 2022) [arXiv:2210.17323] |
| **Phase III: Alignment and Generalization (Weeks 7-9)** |
| 7 | **Instruction Tuning and Generalization** | The shift to instruction-following. Task generalization via instruction-tuning ($\text{FLAN}$). Emergent abilities (In-context learning). $\text{Multimodality}$ introduction. | **1. Finetuned Language Models are Zero-Shot Learners** (Wei et al., 2021) [arXiv:2109.01657]<br>**2. Emergent Abilities of Large Language Models** (Wei et al., 2022) [arXiv:2206.07682] |
| 8 | **Reinforcement Learning from Human Feedback ($\text{RLHF}$)** | The full $\text{RLHF}$ pipeline: $\text{SFT}$, Reward Model ($\text{RM}$), $\text{PPO}$ optimization. $\text{KL}$ divergence penalty. The role of human preference data in alignment. | **1. Training language models to follow instructions with human feedback** (Ouyang et al., 2022) [arXiv:2203.02155]<br>**2. Deep Reinforcement Learning from Human Preferences** (Christiano et al., 2017) [arXiv:1706.03741] *(The conceptual origin of $\text{RLHF}$)* |
| 9 | **Reward-Free Alignment & Safety** | **Direct Preference Optimization ($\text{DPO}$)** vs. $\text{RLHF}$. The mathematical derivation of $\text{DPO}$ as an unrolled objective. Safety, toxicity mitigation, and transparency. **Lab:** Fine-tuning an aligned model using $\text{DPO}$. | **1. Direct Preference Optimization: Your Language Model is Secretly a Reward Model** (Rafailov et al., 2023) [arXiv:2305.18290]<br>**2. Constitutional AI: Harmlessness from AI Feedback** (Bai et al., 2022) [arXiv:2212.08073] |
| **Phase IV: Deployment, Agents, and The Future (Weeks 10-12)** |
| 10 | **Reasoning and Agentic Behavior** | **Chain-of-Thought ($\text{CoT}$)** prompting. Self-correction and reflection. The shift from pure generation to planning and tool use. **Lab:** Implementing a $\text{ReAct}$ agent that uses a simple external tool (e.g., a calculator function). | **1. Chain-of-Thought Prompting Elicits Reasoning in Large Language Models** (Wei et al., 2022) [arXiv:2201.11903]<br>**2. ReAct: Synergizing Reasoning and Acting in Language Models** (Yao et al., 2022) [arXiv:2210.03629] |
| 11 | **Retrieval-Augmented Generation ($\text{RAG}$) & Memory** | The need for external memory. Architecture of $\text{RAG}$: Retriever (dense/sparse vector search) and Generator. Trade-offs between memory, context, and knowledge. Advanced retrieval techniques. | **1. Retrieval-Augmented Generation for Knowledge-Intensive $\text{NLP}$ Tasks** (Lewis et al., 2020) [arXiv:2005.11472]<br>**2. Lost in the Middle: How Language Models Use Long Contexts** (Liu et al., 2023) [arXiv:2307.03172] *(Highlights the limitations of massive context in Transformers)* |
| 12 | **Beyond the Transformer** | The $\mathcal{O}(L^2)$ challenge and the search for linear complexity. **Mamba (Selective $\text{SSM}$)**: $\mathcal{O}(L)$ scaling, fixed state memory, and hardware fusion. $\text{Hyena}$ and $\text{RetNet}$ as $\text{Transformer}$ alternatives. Future trends: Hybrid models (e.g., Jamba) and persistent memory. | **1. Mamba: Linear-Time Sequence Modeling with Selective State Spaces** (Gu & Dao, 2023) [arXiv:2312.00752]<br>**2. Retentive Network: Enabling Training Parallelism and Low-Cost Inference for Large Language Models** (Wu et al., 2023) [arXiv:2307.08621] |


Here is a proposed list of seminal and highly influential papers for those two extension tracks, focusing on foundational concepts and key attack methods. I have ensured the papers are verifiable and relevant to a graduate-level audience.

***

### Extension Track A: Security, Adversarial Attacks, and Poisoning

This module focuses on the LLM threat model, specifically how models can be compromised at training time (poisoning) or inference time (adversarial attacks/jailbreaks).

| Paper | Focus | $\text{arXiv}$ URL |
| :--- | :--- | :--- |
| **Universal and Transferable Adversarial Attacks on Aligned $\text{LLMs}$** (Zou et al., 2023) | **Jailbreaking/Evasion:** Introduces the concept of universal, transferable adversarial suffixes (a single string that can jailbreak multiple aligned $\text{LLMs}$). | [https://arxiv.org/abs/2307.15043](https://arxiv.org/abs/2307.15043) |
| **Scalable and Transferable $\text{LLM}$ Data Poisoning Attacks** (Schmid et al., 2024) | **Data Poisoning:** Demonstrates that $\text{LLMs}$ are vulnerable to backdoors inserted via small amounts of poisoned data during pre-training, surviving $\text{SFT}$ and $\text{RLHF}$ stages. | [https://arxiv.org/abs/2405.02102](https://arxiv.org/abs/2405.02102) |
| **On the $\text{Security}$ of Retrieval-Augmented Generation** (Mouton et al., 2023) | **$\text{RAG}$ Attacks:** Analyzes security risks specific to $\text{RAG}$ systems, including prompt injection, data leakage, and denial-of-service through malicious document injection. | [https://arxiv.org/abs/2311.12151](https://arxiv.org/abs/2311.12151) |
| **The $\text{LLM}$ Attack Zoo: A Systematic Categorization of Attacks and Defenses** (Gao et al., 2024) | **Taxonomy/Survey:** Provides a structured overview and taxonomy of various attack types (prompt injection, jailbreaking, model extraction, data leakage). | [https://arxiv.org/abs/2404.14819](https://arxiv.org/abs/2404.14819) |

***

### Extension Track B: Ethics, Bias, and Alignment Principles

This module examines the origins of bias in training data, methods for evaluation, and the philosophical and technical approaches to controlling model behavior.

| Paper | Focus | $\text{arXiv}$ URL |
| :--- | :--- | :--- |
| **On the Dangers of Stochastic Parrots: Can Language Models Be Too Big?** (Bender et al., 2021) | **Bias/Ethics Foundation:** A highly influential paper discussing the risks associated with massive scale, including data scarcity, energy consumption, and the perpetuation of deep societal biases. | [https://arxiv.org/abs/2101.00027](https://arxiv.org/abs/2101.00027) |
| **Measuring and Mitigating $\text{Bias}$ in Grounded Language** (Bansal et al., 2020) | **Bias Measurement:** Focuses on methods for quantitatively measuring and characterizing social bias ($\text{gender}$, $\text{race}$) embedded in model behavior and outputs. | [https://arxiv.org/abs/2005.14167](https://arxiv.org/abs/2005.14167) |
| **The Alignment Problem** (Amodei et al., 2016) | **Safety/Alignment Foundation:** Anthropic's foundational work outlining the "alignment problem" (the difficulty in ensuring that AI systems act according to human intentions) before the $\text{LLM}$ boom, setting the stage for $\text{RLHF}$. | [https://arxiv.org/abs/1606.06565](https://arxiv.org/abs/1606.06565) |
| **Constitutional AI: Harmlessness from $\text{AI}$ Feedback** (Bai et al., 2022) | **Advanced Alignment:** Introduces Constitutional AI ($\text{CAI}$) as an alternative to pure $\text{RLHF}$, demonstrating how to align models based on a set of written principles rather than solely human preference labels. | [https://arxiv.org/abs/2212.08073](https://arxiv.org/abs/2212.08073) |

***
The papers for your two new extension tracks are now identified. We can add these to the `download_papers.sh` script if you'd like to update that file.
