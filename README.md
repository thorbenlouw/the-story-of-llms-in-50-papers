# the-story-of-llms-in-50-papers
> **IMPORTANT NOTE**:
> This is a work in progress! 

Follows the story of LLMs in 50 seminal papers from 2017 to 2025, with (LLM-generated) plain-english explanations

I had an idea today to develop a course/super boring novel/series of blog posts/podcast about the innovations since 2017 that help us go from the state of the art at the time to what we have today, and a glimpse of what research is happening in LLMs and might affect the future. It uses 50 seminal academic papers that cover this revolution, but is designed for the **tech-worker lay person**—someone who works in or around technology, is curious about how large language models (LLMs) work, and wants to understand the ideas that have driven today’s AI revolution. Everything is presented in **plain English**, with relatable examples and real-world parallels, rather than mathematical detail. The aim is to focus on the **main concepts and breakthroughs** that have shaped the extraordinary technological changes we’re all living through.

## Plain‑Language Series

- Browse the ordered, plain‑English explainers for each paper: plain-language/README.md

Quick preview (first six):

- [01 — Attention Is All You Need](plain-language/01-attention-is-all-you-need-vaswani-2017.md) — Transformer
  and self‑attention unlock parallelism and long‑range context.
- [02 — Recurrent Neural Network Regularization](plain-language/02-rnn-regularization-zaremba-2014.md) — RNN
  regularisation highlights limits before the Transformer era.
- [03 — Improving Language Understanding (GPT‑1)](plain-language/03-improving-language-understanding-gpt1-radford-2018.md) —
  Pre‑train on next‑token prediction, then fine‑tune for tasks.
- [04 — BERT: Bidirectional Pre‑Training](plain-language/04-bert-pretraining-devlin-2018.md) — Masked language
  modelling for deep bidirectional understanding.
- [05 — T5: Text‑to‑Text Transfer](plain-language/05-t5-unified-text-to-text-raffel-2019.md) — Unifies tasks as
  text‑to‑text for a single training interface.
- [06 — RoFormer: Rotary Positional Embeddings](plain-language/06-roformer-enhanced-transformer-su-2021.md) — Position as
  rotation for better long‑context behaviour and extrapolation.

> *** COURSE IMPLEMENTATION NOTE*** 
> Of course I haven't done this myself. After using Gemini and ChatGPT to refine the course "syllabus", and have Claude Code create a script which downloads the papers, I had Gemini create some great prompts for a sub-agent to systematically summarise each paper and validate its summaries. Then I used an orchestrator agent in RooCode to run the subtasks for each of the papers and summaries it. Then I've converted the detailed summaries into shorter, accessible prose. The agents are still busy running -- 17 papers down, 33 to go.

I've also played with a dialog/novel format that might not work out:

```
The campus courtyard was alive with midday energy, students sprawled on the grass enjoying the unseasonably warm October afternoon. Sophie, Jai, and Fritz had claimed a shaded picnic table, lunch containers spread between them.

"So Meta just... gave it away?" Fritz asked, unwrapping his sandwich. "A model that competes with ChatGPT, completely open-source?"

"That's the headline," Jai said, pulling up the paper on his tablet. "But the real story is way more interesting than just 'Meta releases free model.' It's about what they learned building it, and what they're willing to share."

Sophie speared a piece of lettuce thoughtfully. "I saw the announcement when it dropped. The safety documentation alone is like 70 pages. That's unprecedented."

"Right!" Jai's enthusiasm was immediate. "That's what makes this paper so valuable. OpenAI doesn't tell you how they built ChatGPT. Anthropic shares some stuff about Constitutional AI, but it's limited. Meta basically publishes their entire playbook—the alignment methodology, the safety techniques, the failures, the trade-offs. Everything."
```

Don't worry -- I'm not going spam BlogIn with 50 posts and a seriously bad novel! If you're interested in seeing this, I'll be publishing it later at 

Here's what it will cover:

### The World Before the Revolution

Not so long ago, the world of natural language processing was dominated by architectures known as Recurrent Neural Networks (RNNs). These models processed language sequentially, word by word, much like we read a sentence. They maintained a 'memory' that was passed along at each step, trying to remember what came before to predict what might come next. While clever, they had a fundamental limitation: their memory was short. When faced with long, complex sentences, they would often forget the beginning by the time they reached the end. It was like trying to remember the first chapter of a book while reading the last – the crucial connections were often lost. This was the core challenge that needed to be solved.

### Phase I: A Foundational Breakthrough

Our journey begins with the "Big Bang" of the modern AI era: the 2017 paper, **"Attention Is All You Need."** This work introduced the **Transformer architecture**, a radically new design that abandoned sequential memory. Instead of reading word-by-word, the Transformer could look at all the words in a sentence at once and weigh the importance of every other word to the one it was currently processing. This "self-attention" mechanism allowed it to draw connections between distant words, finally cracking the problem of long-range dependencies. We contrast with another paper from the pre-transformer era showing impressive improvements in RNNs but which still fundamentally fails to scale -- we needed the Transformers' potential for parallelisation to be able to scale language models to the size and datasets we have today.

This single innovation unlocked a Cambrian explosion in model design. We'll explore the two dominant paradigms that emerged by reading their founding papers. First came **"Improving Language Understanding by Generative Pre-Training,"** the paper that introduced **GPT**. It showed that by training a Transformer to master the simple task of predicting the next word, it could become an incredibly powerful text generator. Almost simultaneously, **"BERT: Pre-training of Deep Bidirectional Transformers for Language Understanding"** took a different approach. BERT looked at text non-sequentially, learning to fill in missing words in a sentence. This gave it a deep, contextual understanding of language, making it perfect for tasks like search and analysis. We will close this phase by studying the elegant **T5** model, which, in **"Exploring the Limits of Transfer Learning with a Unified Text-to-Text Transformer,"** proposed a unified framework: what if every language task could be treated as a simple "text-to-text" problem? This idea dramatically simplified the field and set the stage for greater generalisation.

### Phase II: The Unreasonable Effectiveness of Scale

With a powerful new architecture in hand, the next phase was a race to scale. Researchers discovered a set of predictable **"Scaling Laws,"** a revelation detailed in the paper of the same name. It showed an almost law-of-physics-like relationship: as you exponentially increased the amount of training data, the size of the model, and the compute used to train it, the model’s capabilities improved in a smooth, predictable way. This insight, later refined by DeepMind's _Chinchilla_ paper, justified the immense investment required to build ever-larger models.

But scaling brings its own challenges. Training and running models with hundreds of billions of parameters is incredibly expensive. We will investigate the clever innovations designed to make this feasible. We'll dive into the **"Switch Transformers"** paper, which popularised the **Mixture-of-Experts (MoE)** paradigm. Instead of one monolithic network where all parts are activated for every task, an MoE model consists of many smaller "expert" networks and a router that intelligently sends each piece of information to the most relevant expert. This allows for models with trillions of parameters while only using a fraction of the compute. We will also explore crucial inference-time optimisations through papers like **"FlashAttention,"** which details the software wizardry that makes it possible to run these behemoths efficiently.

### Phase III: Aligning Power with Purpose, Security and Ethics

A massive, powerful model isn't necessarily a useful or safe one. Early large models were impressive text completers, but they couldn't follow instructions. The third phase of our course explores the critical process of **alignment**: shaping model behaviour to be helpful, harmless, and honest.

We’ll start with **instruction tuning**, the technique that transformed LLMs from mere predictors into conversational partners. By studying papers like **"Finetuned Language Models are Zero-Shot Learners" (FLAN)**, we'll see how training on vast datasets of instructions and desired outputs taught models to follow natural language prompts that lead to remarkable _emergent abilities_—skills that arise not from explicit training, but from scale itself.

Next, we’ll demystify **Reinforcement Learning from Human Feedback (RLHF)** by analysing the groundbreaking **"Training language models to follow instructions with human feedback"** paper from the creators of InstructGPT (the precursor to ChatGPT). This work laid out the full pipeline: training a "reward model" on human preferences and then using it as a guide to fine-tune the LLM to produce outputs that humans find more helpful. We'll then examine its modern successor in **"Direct Preference Optimization: Your Language Model is Secretly a Reward Model,"** a more direct and often more stable method for achieving the same goal. Finally, we'll discuss the ideas in **"Constitutional AI,"** an approach where models are aligned using a written set of principles, reducing the reliance on constant human oversight. We also look at **TruthfulQA**, and **faithfulness in reasoning**, inviting reflection on what it means for an AI to be not only powerful, but trustworthy.

Security and robustness form an equally vital thread. You’ll examine how large models can be manipulated or attacked, both during training and deployment. Works such as **Universal and Transferable Adversarial Attacks on Aligned LLMs** and **On the Security of Retrieval-Augmented Generation** reveal vulnerabilities like jailbreaks, data poisoning, and prompt injection. Complementary studies including **Red Teaming Language Models to Reduce Harms _and_ A Watermark for Large Language Models** highlight proactive strategies for identifying weaknesses and tracing AI-generated content. Every leap in capability demands equal progress in safety and governance.

Ethics runs throughout. Landmark works like **On the Dangers of Stochastic Parrots** challenge you to reflect on the environmental, social, and cultural consequences of building ever-larger models. Papers on bias measurement and fairness deepen this reflection, asking who benefits—and who might be harmed—by the systems we create. The foundational **Concrete Problems in AI Safety** frames these issues as practical design challenges, not just abstract concerns.

### Phase IV: Towards Agents and the Future

In our final phase, we'll explore the frontier where LLMs are evolving from passive text generators into active agents that can reason, plan, and interact with the world. We'll examine the power of a simple but profound idea in **"Chain-of-Thought Prompting Elicits Reasoning in Large Language Models,"** which showed that prompting models to "think step-by-step" unlocks complex reasoning abilities.

The most exciting development is the ability of LLMs to **use tools**. We'll study systems like **"ReAct: Synergizing Reasoning and Acting in Language Models,"** which gives models access to calculators, search engines, and other external APIs, allowing them to overcome their inherent limitations. To combat the issue of stale knowledge, we'll investigate **"Retrieval-Augmented Generation for Knowledge-Intensive NLP Tasks,"** the foundational paper for **RAG**. This technique allows a model to first retrieve relevant, up-to-date information from a database before answering a question, making its responses more factual and trustworthy.

Finally, we'll look beyond the horizon. The Transformer, for all its power, has computational constraints. We will conclude our journey by studying the next generation of architectures, spearheaded by papers like **"Mamba: Linear-Time Sequence Modeling with Selective State Spaces."** These new designs promise similar performance with far greater efficiency, potentially unlocking capabilities we can only begin to imagine. We also consider **RetNet**, and **Hyena** are emerging, promising faster, more efficient, and potentially more human-like reasoning. The hybrid **Jamba** model combines the best of these approaches, pointing towards a future where the Transformer may become part of a broader ecosystem of intelligent systems.

Through fifty seminal papers, this course tells the story of how large language models evolved from simple word predictors into powerful, multifaceted systems capable of reasoning, creativity, and conversation. It traces the scientific ingenuity that made them possible, the engineering breakthroughs that made them practical, and the philosophical questions that now define their use. you will have a comprehensive understanding of how we arrived at today's state-of-the-art and a well-informed perspective on the exciting road ahead.

* * *

## The papers

Here is a comprehensive list of the 50 papers covered in the course and its extension tracks, along with a summary of each paper's main idea.

* * *

### Phase I: The Transformer Foundations (Weeks 1-3)

*   **1\. Attention Is All You Need** (Vaswani et al., 2017)
    *   **Main Idea:** Introduced the **Transformer architecture**, completely replacing sequential Recurrent Neural Networks (RNNs) with a parallelizable **self-attention mechanism**. This solved the long-range dependency problem and became the foundation for all modern LLMs.
*   **2\. Recurrent Neural Network Regularization** (Zaremba et al., 2014)
    *   **Main Idea:** Serves as a key point of contrast, showing the methods (like dropout) used to prevent older RNN models from overfitting. This highlights the architectural shift and different challenges faced by Transformers.
*   **3\. Improving Language Understanding by Generative Pre-Training** (Radford et al., 2018)
    *   **Main Idea:** Introduced the first **GPT** model, demonstrating the effectiveness of a two-stage approach: first, pre-train a Transformer on a massive text corpus to predict the next word (generative pre-training), then fine-tune it for specific tasks.
*   **4\. BERT: Pre-training of Deep Bidirectional Transformers for Language Understanding** (Devlin et al., 2018)
    *   **Main Idea:** Introduced **BERT**, a model pre-trained to understand context from both left and right directions simultaneously using a "Masked Language Model" objective (filling in blanks). This achieved state-of-the-art results on language understanding tasks.
*   **5\. Exploring the Limits of Transfer Learning with a Unified Text-to-Text Transformer** (Raffel et al., 2019)
    *   **Main Idea:** Introduced the **T5** model and proposed that every NLP task (translation, summarisation, classification) could be framed as a single, unified "text-to-text" problem, simplifying the training and application of LLMs.
*   **6\. RoFormer: Enhanced Transformer with Rotary Position Embedding** (Su et al., 2021)
    *   **Main Idea:** Introduced **Rotary Positional Embeddings (RoPE)**, an elegant method for encoding word positions by rotating the embedding vectors. This approach has better generalization properties for long sequences and is now widely used in models like LLaMA and PaLM.

* * *

### Phase II: Scaling and Efficiency (Weeks 4-6)

*   **7\. Scaling Laws for Neural Language Models** (Kaplan et al., 2020)
    *   **Main Idea:** Empirically demonstrated that an LLM's performance improves in a predictable, power-law relationship as you scale up model size, dataset size, and compute budget. This provided a scientific justification for building massive models.
*   **8\. Training Compute-Optimal Large Language Models** (Hoffmann et al., 2022)
    *   **Main Idea:** Introduced the **"Chinchilla" scaling laws**, which refined earlier findings. It argued that for optimal performance, models should be smaller but trained on much more data, shifting the industry's focus toward data curation over just parameter count.
*   **9\. Switch Transformers: Scaling to Trillion Parameter Models with Simple and Efficient Sparsity** (Fedus et al., 2021)
    *   **Main Idea:** Popularised the **Mixture-of-Experts (MoE)** architecture. This allows for models with trillions of parameters by only activating a small subset of "expert" networks for any given input, making training and inference far more compute-efficient.
*   **10\. LLaMA 2: Open Foundation and Fine-Tuned Chat Models** (Touvron et al., 2023)
    *   **Main Idea:** Provided a detailed account of the data collection, training, and alignment process behind a family of high-performing, open-source models. It set a new standard for transparency and performance in open LLMs.
*   **11\. FlashAttention: Fast and Memory-Efficient Exact Attention with IO-Awareness** (Dao et al., 2022)
    *   **Main Idea:** Introduced a memory-efficient attention algorithm that avoids storing the massive intermediate attention matrix on the GPU. By using tiling and fusion, it dramatically speeds up training and inference, making long contexts practical.
*   **12\. GPTQ: Accurate Post-training Quantization for Generative Pre-trained Transformers** (Frantar et al., 2022)
    *   **Main Idea:** Introduced **GPTQ**, an accurate method to compress (quantize) a trained LLM's weights to very low precision (e.g., 4-bit) with minimal performance loss. This makes it possible to run large models on consumer-grade hardware.

* * *

### Phase III: Alignment and Generalization (Weeks 7-9)

*   **13\. Finetuned Language Models are Zero-Shot Learners** (Wei et al., 2021)
    *   **Main Idea:** Introduced **instruction fine-tuning** (with FLAN), showing that training an LLM on a massive collection of tasks described via natural language instructions significantly improves its ability to perform new, unseen tasks without any examples (zero-shot).
*   **14\. Emergent Abilities of Large Language Models** (Wei et al., 2022)
    *   **Main Idea:** Observed that certain complex abilities, like multi-step reasoning, do not scale smoothly but rather **emerge** unpredictably once a model surpasses a certain size and scale.
*   **15\. Holistic Evaluation of Language Models (HELM)** (Liang et al., 2022)
    *   **Main Idea:** Proposed **HELM**, a comprehensive framework for evaluating LLMs across a wide variety of tasks and metrics (e.g., accuracy, fairness, robustness) to provide a more holistic and standardized view of their capabilities and risks.
*   **16\. Beyond the Imitation Game: Quantifying and Extrapolating the Capabilities of Language Models (BIG-bench)** (Srivastava et al., 2022)
    *   **Main Idea:** Introduced a massive, collaborative benchmark with over 200 diverse tasks designed to probe the limits of current LLMs and anticipate their future capabilities.
*   **17\. Training language models to follow instructions with human feedback** (Ouyang et al., 2022)
    *   **Main Idea:** Detailed the three-step **Reinforcement Learning from Human Feedback (RLHF)** pipeline (SFT -> Reward Model -> PPO) that was used to create InstructGPT and ChatGPT, effectively aligning models to be more helpful and follow user intent.
*   **18\. Deep Reinforcement Learning from Human Preferences** (Christiano et al., 2017)
    *   **Main Idea:** Established the foundational concept of learning a reward model directly from human preference data (i.e., which of two outputs is better), laying the theoretical groundwork for what would later become RLHF.
*   **19\. Direct Preference Optimization: Your Language Model is Secretly a Reward Model** (Rafailov et al., 2023)
    *   **Main Idea:** Introduced **Direct Preference Optimization (DPO)**, a more direct and stable method for alignment that optimizes the LLM on preference data without needing a separate reward model or complex reinforcement learning.
*   **20\. Constitutional AI: Harmlessness from AI Feedback** (Bai et al., 2022)
    *   **Main Idea:** Proposed a method to align an AI with a set of principles (a "constitution"). Instead of humans, an AI model provides the feedback, making the alignment process more scalable and less reliant on human labeling.
*   **21\. TruthfulQA: Measuring How Models Mimic Human Falsehoods** (Lin et al., 2021)
    *   **Main Idea:** Introduced a benchmark designed to test an LLM's **truthfulness**, measuring its tendency to repeat common misconceptions found in its training data versus providing factually accurate answers.
*   **22\. Measuring Faithfulness in Chain-of-Thought Reasoning** (Lanham et al., 2023)
    *   **Main Idea:** Investigated whether the step-by-step reasoning an LLM outputs actually reflects its true computational process, finding that the reasoning can often be a post-hoc rationalization rather than a faithful explanation.

* * *

### Phase IV: Deployment, Agents, and The Future (Weeks 10-12)

*   **23\. Chain-of-Thought Prompting Elicits Reasoning in Large Language Models** (Wei et al., 2022)
    *   **Main Idea:** Discovered that simply prompting an LLM to "think step-by-step" before giving an answer dramatically improves its performance on complex arithmetic, commonsense, and symbolic reasoning tasks.
*   **24\. ReAct: Synergizing Reasoning and Acting in Language Models** (Yao et al., 2022)
    *   **Main Idea:** Introduced the **ReAct** framework, which enables an LLM to solve complex tasks by interleaving **reasoning** (generating thought traces) and **acting** (using external tools like a search engine), mimicking how humans approach problems.
*   **25\. Toolformer: Language Models Can Teach Themselves to Use Tools** (Schick et al., 2023)
    *   **Main Idea:** Showed that an LLM can learn to use external tools (calculators, web search) in a **self-supervised** way by learning to insert API calls into text where they would be helpful.
*   **26\. Gorilla: Large Language Model Connected with Massive APIs** (Patil et al., 2023)
    *   **Main Idea:** Demonstrated that fine-tuning an LLM specifically on a massive corpus of API documentation makes it highly proficient at writing accurate and relevant API calls, overcoming the unreliability of general-purpose models for tool use.
*   **27\. Flamingo: a Visual Language Model for Few-Shot Learning** (Alayrac et al., 2022)
    *   **Main Idea:** Introduced a foundational **vision-language model** capable of processing interleaved sequences of images and text, enabling it to perform new multimodal tasks with just a few examples provided in context.
*   **28\. Visual Instruction Tuning (LLaVA)** (Liu et al., 2023)
    *   **Main Idea:** Created a powerful, open-source multimodal model by connecting a pre-trained vision encoder to an LLM and then instruction-tuning it on a dataset of image-text conversations, giving it impressive visual chat capabilities.
*   **29\. Kosmos-2: Grounding Multimodal Large Language Models to the World** (Peng et al., 2023)
    *   **Main Idea:** Introduced a multimodal LLM that can **ground** text to specific regions in an image, outputting bounding box coordinates. This enables it to not just see an image but to refer to and locate objects within it.
*   **30\. Retrieval-Augmented Generation for Knowledge-Intensive NLP Tasks** (Lewis et al., 2020)
    *   **Main Idea:** Introduced **RAG**, a framework that enhances LLMs by first retrieving relevant documents from an external knowledge base and then using that information as context to generate a more factual and up-to-date answer.
*   **31\. Lost in the Middle: How Language Models Use Long Contexts** (Liu et al., 2023)
    *   **Main Idea:** Discovered that LLMs often struggle to utilize information located in the middle of a long context window, exhibiting a U-shaped performance curve where they recall information from the beginning and end much better.
*   **32\. LoRA: Low-Rank Adaptation of Large Language Models** (Hu et al., 2021)
    *   **Main Idea:** Introduced **LoRA**, a highly popular parameter-efficient fine-tuning (PEFT) method that freezes the main model and only trains a few small, low-rank matrices, drastically reducing the memory and compute required for specialization.
*   **33\. Efficient Memory Management for Large Language Model Serving with PagedAttention (vLLM)** (Kwon et al., 2023)
    *   **Main Idea:** Introduced **PagedAttention**, a new attention algorithm inspired by virtual memory in operating systems. It solves memory fragmentation issues in the KV cache, leading to significantly higher throughput when serving LLMs.
*   **34\. MemGPT: Towards LLMs as Operating Systems** (Wu et al., 2023)
    *   **Main Idea:** Proposed a system that gives LLMs a form of "virtual context" management. It teaches the LLM to manage its own memory, moving less critical information to external storage to effectively create an unbounded context window.
*   **35\. Mamba: Linear-Time Sequence Modeling with Selective State Spaces** (Gu & Dao, 2023)
    *   **Main Idea:** Introduced **Mamba**, a new architecture based on Selective State Space Models (SSMs) that scales linearly with sequence length (vs. the Transformer's quadratic scaling). It offers a highly efficient and powerful alternative for long-context tasks.
*   **36\. Retentive Network: A Successor to Transformer for Large Language Models** (Sun et al., 2023)
    *   **Main Idea:** Introduced **RetNet**, an architecture designed to achieve the best of three worlds: parallel training (like Transformers), low-cost inference (like RNNs), and strong performance, making it another strong contender to succeed the Transformer.
*   **37\. Hyena Hierarchy: Towards Larger Convolutional Language Models** (Poli et al., 2023)
    *   **Main Idea:** Proposed an attention-free architecture that uses long convolutions gated by input signals to capture long-range dependencies, achieving sub-quadratic scaling and rivaling Transformers on key benchmarks.
*   **38\. Jamba: A Hybrid Transformer-Mamba Language Model** (Lieber et al., 2024)
    *   **Main Idea:** Presented the first production-scale **hybrid architecture** that combines Transformer attention layers with Mamba's SSM layers. This aims to get the best of both worlds: the power of attention and the efficiency of Mamba.

* * *

### Extension Track A: Security and Robustness

*   **39\. Universal and Transferable Adversarial Attacks on Aligned LLMs** (Zou et al., 2023)
    *   **Main Idea:** Demonstrated that a single, optimized string of characters can act as a universal **"jailbreak"** suffix, causing multiple different aligned LLMs to generate harmful or prohibited content when appended to a prompt.
*   **40\. Backdoor Attacks on Language Models** (Wallace et al., 2021)
    *   **Main Idea:** Demonstrated that language models are vulnerable to **backdoor attacks** where adversaries can inject triggers during training that cause targeted misbehavior at test time, compromising model security even after deployment.
*   **41\. PoisonedRAG: Knowledge Corruption Attacks to Retrieval-Augmented Generation** (Zou et al., 2024)
    *   **Main Idea:** Introduced the first **knowledge corruption attack** on RAG systems, showing that injecting as few as five malicious texts into a knowledge database of millions can achieve a 90% attack success rate, inducing LLMs to generate attacker-chosen answers.
*   **42\. JailbreakZoo: Survey, Landscapes, and Horizons in Jailbreaking LLMs** (Chao et al., 2024)
    *   **Main Idea:** Provided a comprehensive **survey** categorizing jailbreak attacks into seven distinct types and reviewing defense mechanisms, creating a structured framework for understanding vulnerabilities in both LLMs and vision-language models.
*   **43\. Red Teaming Language Models to Reduce Harms** (Perez et al., 2022)
    *   **Main Idea:** Formalized the process of **"red teaming"** for LLMs, where humans (or other AIs) adversarially test models to proactively find safety flaws and vulnerabilities before they are exploited in the real world.
*   **44\. A Watermark for Large Language Models** (Kirchenbauer et al., 2023)
    *   **Main Idea:** Proposed a method to embed a statistical, imperceptible **watermark** into the text generated by an LLM. This allows for post-hoc detection of whether text was generated by a specific model, helping to trace its origin.
*   **45\. Certified Robustness to Adversarial Word Substitutions** (Jia et al., 2019)
    *   **Main Idea:** Developed foundational methods using **Interval Bound Propagation** to provide **mathematical guarantees** (certified defenses) that a model's output will remain unchanged even if an attacker makes adversarial word substitutions in the input.
*   **46\. Poisoning Language Models During Instruction Tuning** (Qi et al., 2023)
    *   **Main Idea:** Investigated how **data poisoning attacks** can be specifically targeted at the instruction-tuning phase and explored potential detection and mitigation strategies for this critical stage of model development.

* * *

### Extension Track B: Ethics, Bias, and Alignment Principles

*   **47\. On the Dangers of Stochastic Parrots: Can Language Models Be Too Big?** (Bender et al., 2021)
    *   **Main Idea:** A highly influential critique arguing that the pursuit of ever-larger LLMs carries significant risks, including perpetuating societal biases from web data, environmental costs, and creating a misleading illusion of genuine understanding.
*   **48\. StereoSet: Measuring Stereotypical Bias in Pretrained Language Models** (Nadeem et al., 2020)
    *   **Main Idea:** Introduced a comprehensive **benchmark** for measuring stereotypical bias across gender, race, religion, and profession in LLMs, using both intrasentence and intersentence contexts to evaluate model associations with social stereotypes.
*   **49\. Concrete Problems in AI Safety** (Amodei et al., 2016)
    *   **Main Idea:** A foundational AI safety paper that, before the LLM era, outlined practical problems in ensuring AI systems behave as intended. It framed the core challenges of the modern **"alignment problem"** that RLHF later sought to address.
*   **50\. Constitutional AI: Harmlessness from AI Feedback** (Bai et al., 2022)
    *   **Main Idea:** (Repeated from main syllabus due to its centrality). Proposed an alignment method based on a set of written principles (a "constitution"), using AI-generated feedback to guide the model towards harmlessness, thereby making alignment more scalable.
