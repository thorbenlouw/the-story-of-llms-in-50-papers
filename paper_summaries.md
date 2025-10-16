Here is a comprehensive list of the 50 papers covered in the course and its extension tracks, along with a summary of each paper's main idea.

---

### Phase I: The Transformer Foundations (Weeks 1-3)

* **1. Attention Is All You Need** (Vaswani et al., 2017)
    * **Main Idea:** Introduced the **Transformer architecture**, completely replacing sequential Recurrent Neural Networks (RNNs) with a parallelizable **self-attention mechanism**. This solved the long-range dependency problem and became the foundation for all modern LLMs.
* **2. Recurrent Neural Network Regularization** (Zaremba et al., 2014)
    * **Main Idea:** Serves as a key point of contrast, showing the methods (like dropout) used to prevent older RNN models from overfitting. This highlights the architectural shift and different challenges faced by Transformers.
* **3. Improving Language Understanding by Generative Pre-Training** (Radford et al., 2018)
    * **Main Idea:** Introduced the first **GPT** model, demonstrating the effectiveness of a two-stage approach: first, pre-train a Transformer on a massive text corpus to predict the next word (generative pre-training), then fine-tune it for specific tasks.
* **4. BERT: Pre-training of Deep Bidirectional Transformers for Language Understanding** (Devlin et al., 2018)
    * **Main Idea:** Introduced **BERT**, a model pre-trained to understand context from both left and right directions simultaneously using a "Masked Language Model" objective (filling in blanks). This achieved state-of-the-art results on language understanding tasks.
* **5. Exploring the Limits of Transfer Learning with a Unified Text-to-Text Transformer** (Raffel et al., 2019)
    * **Main Idea:** Introduced the **T5** model and proposed that every NLP task (translation, summarisation, classification) could be framed as a single, unified "text-to-text" problem, simplifying the training and application of LLMs.
* **6. RoFormer: Enhanced Transformer with Rotary Position Embedding** (Su et al., 2021)
    * **Main Idea:** Introduced **Rotary Positional Embeddings (RoPE)**, an elegant method for encoding word positions by rotating the embedding vectors. This approach has better generalization properties for long sequences and is now widely used in models like LLaMA and PaLM.

---

### Phase II: Scaling and Efficiency (Weeks 4-6)

* **7. Scaling Laws for Neural Language Models** (Kaplan et al., 2020)
    * **Main Idea:** Empirically demonstrated that an LLM's performance improves in a predictable, power-law relationship as you scale up model size, dataset size, and compute budget. This provided a scientific justification for building massive models.
* **8. Training Compute-Optimal Large Language Models** (Hoffmann et al., 2022)
    * **Main Idea:** Introduced the **"Chinchilla" scaling laws**, which refined earlier findings. It argued that for optimal performance, models should be smaller but trained on much more data, shifting the industry's focus toward data curation over just parameter count.
* **9. Switch Transformers: Scaling to Trillion Parameter Models with Simple and Efficient Sparsity** (Fedus et al., 2021)
    * **Main Idea:** Popularised the **Mixture-of-Experts (MoE)** architecture. This allows for models with trillions of parameters by only activating a small subset of "expert" networks for any given input, making training and inference far more compute-efficient.
* **10. LLaMA 2: Open Foundation and Fine-Tuned Chat Models** (Touvron et al., 2023)
    * **Main Idea:** Provided a detailed account of the data collection, training, and alignment process behind a family of high-performing, open-source models. It set a new standard for transparency and performance in open LLMs.
* **11. FlashAttention: Fast and Memory-Efficient Exact Attention with IO-Awareness** (Dao et al., 2022)
    * **Main Idea:** Introduced a memory-efficient attention algorithm that avoids storing the massive intermediate attention matrix on the GPU. By using tiling and fusion, it dramatically speeds up training and inference, making long contexts practical.
* **12. GPTQ: Accurate Post-training Quantization for Generative Pre-trained Transformers** (Frantar et al., 2022)
    * **Main Idea:** Introduced **GPTQ**, an accurate method to compress (quantize) a trained LLM's weights to very low precision (e.g., 4-bit) with minimal performance loss. This makes it possible to run large models on consumer-grade hardware.

---

### Phase III: Alignment and Generalization (Weeks 7-9)

* **13. Finetuned Language Models are Zero-Shot Learners** (Wei et al., 2021)
    * **Main Idea:** Introduced **instruction fine-tuning** (with FLAN), showing that training an LLM on a massive collection of tasks described via natural language instructions significantly improves its ability to perform new, unseen tasks without any examples (zero-shot).
* **14. Emergent Abilities of Large Language Models** (Wei et al., 2022)
    * **Main Idea:** Observed that certain complex abilities, like multi-step reasoning, do not scale smoothly but rather **emerge** unpredictably once a model surpasses a certain size and scale.
* **15. Holistic Evaluation of Language Models (HELM)** (Liang et al., 2022)
    * **Main Idea:** Proposed **HELM**, a comprehensive framework for evaluating LLMs across a wide variety of tasks and metrics (e.g., accuracy, fairness, robustness) to provide a more holistic and standardized view of their capabilities and risks.
* **16. Beyond the Imitation Game: Quantifying and Extrapolating the Capabilities of Language Models (BIG-bench)** (Srivastava et al., 2022)
    * **Main Idea:** Introduced a massive, collaborative benchmark with over 200 diverse tasks designed to probe the limits of current LLMs and anticipate their future capabilities.
* **17. Training language models to follow instructions with human feedback** (Ouyang et al., 2022)
    * **Main Idea:** Detailed the three-step **Reinforcement Learning from Human Feedback (RLHF)** pipeline (SFT -> Reward Model -> PPO) that was used to create InstructGPT and ChatGPT, effectively aligning models to be more helpful and follow user intent.
* **18. Deep Reinforcement Learning from Human Preferences** (Christiano et al., 2017)
    * **Main Idea:** Established the foundational concept of learning a reward model directly from human preference data (i.e., which of two outputs is better), laying the theoretical groundwork for what would later become RLHF.
* **19. Direct Preference Optimization: Your Language Model is Secretly a Reward Model** (Rafailov et al., 2023)
    * **Main Idea:** Introduced **Direct Preference Optimization (DPO)**, a more direct and stable method for alignment that optimizes the LLM on preference data without needing a separate reward model or complex reinforcement learning.
* **20. Constitutional AI: Harmlessness from AI Feedback** (Bai et al., 2022)
    * **Main Idea:** Proposed a method to align an AI with a set of principles (a "constitution"). Instead of humans, an AI model provides the feedback, making the alignment process more scalable and less reliant on human labeling.
* **21. TruthfulQA: Measuring How Models Mimic Human Falsehoods** (Lin et al., 2021)
    * **Main Idea:** Introduced a benchmark designed to test an LLM's **truthfulness**, measuring its tendency to repeat common misconceptions found in its training data versus providing factually accurate answers.
* **22. Measuring Faithfulness in Chain-of-Thought Reasoning** (Lanham et al., 2023)
    * **Main Idea:** Investigated whether the step-by-step reasoning an LLM outputs actually reflects its true computational process, finding that the reasoning can often be a post-hoc rationalization rather than a faithful explanation.

---

### Phase IV: Deployment, Agents, and The Future (Weeks 10-12)

* **23. Chain-of-Thought Prompting Elicits Reasoning in Large Language Models** (Wei et al., 2022)
    * **Main Idea:** Discovered that simply prompting an LLM to "think step-by-step" before giving an answer dramatically improves its performance on complex arithmetic, commonsense, and symbolic reasoning tasks.
* **24. ReAct: Synergizing Reasoning and Acting in Language Models** (Yao et al., 2022)
    * **Main Idea:** Introduced the **ReAct** framework, which enables an LLM to solve complex tasks by interleaving **reasoning** (generating thought traces) and **acting** (using external tools like a search engine), mimicking how humans approach problems.
* **25. Toolformer: Language Models Can Teach Themselves to Use Tools** (Schick et al., 2023)
    * **Main Idea:** Showed that an LLM can learn to use external tools (calculators, web search) in a **self-supervised** way by learning to insert API calls into text where they would be helpful.
* **26. Gorilla: Large Language Model Connected with Massive APIs** (Patil et al., 2023)
    * **Main Idea:** Demonstrated that fine-tuning an LLM specifically on a massive corpus of API documentation makes it highly proficient at writing accurate and relevant API calls, overcoming the unreliability of general-purpose models for tool use.
* **27. Flamingo: a Visual Language Model for Few-Shot Learning** (Alayrac et al., 2022)
    * **Main Idea:** Introduced a foundational **vision-language model** capable of processing interleaved sequences of images and text, enabling it to perform new multimodal tasks with just a few examples provided in context.
* **28. Visual Instruction Tuning (LLaVA)** (Liu et al., 2023)
    * **Main Idea:** Created a powerful, open-source multimodal model by connecting a pre-trained vision encoder to an LLM and then instruction-tuning it on a dataset of image-text conversations, giving it impressive visual chat capabilities.
* **29. Kosmos-2: Grounding Multimodal Large Language Models to the World** (Peng et al., 2023)
    * **Main Idea:** Introduced a multimodal LLM that can **ground** text to specific regions in an image, outputting bounding box coordinates. This enables it to not just see an image but to refer to and locate objects within it.
* **30. Retrieval-Augmented Generation for Knowledge-Intensive NLP Tasks** (Lewis et al., 2020)
    * **Main Idea:** Introduced **RAG**, a framework that enhances LLMs by first retrieving relevant documents from an external knowledge base and then using that information as context to generate a more factual and up-to-date answer.
* **31. Lost in the Middle: How Language Models Use Long Contexts** (Liu et al., 2023)
    * **Main Idea:** Discovered that LLMs often struggle to utilize information located in the middle of a long context window, exhibiting a U-shaped performance curve where they recall information from the beginning and end much better.
* **32. LoRA: Low-Rank Adaptation of Large Language Models** (Hu et al., 2021)
    * **Main Idea:** Introduced **LoRA**, a highly popular parameter-efficient fine-tuning (PEFT) method that freezes the main model and only trains a few small, low-rank matrices, drastically reducing the memory and compute required for specialization.
* **33. Efficient Memory Management for Large Language Model Serving with PagedAttention (vLLM)** (Kwon et al., 2023)
    * **Main Idea:** Introduced **PagedAttention**, a new attention algorithm inspired by virtual memory in operating systems. It solves memory fragmentation issues in the KV cache, leading to significantly higher throughput when serving LLMs.
* **34. MemGPT: Towards LLMs as Operating Systems** (Wu et al., 2023)
    * **Main Idea:** Proposed a system that gives LLMs a form of "virtual context" management. It teaches the LLM to manage its own memory, moving less critical information to external storage to effectively create an unbounded context window.
* **35. Mamba: Linear-Time Sequence Modeling with Selective State Spaces** (Gu & Dao, 2023)
    * **Main Idea:** Introduced **Mamba**, a new architecture based on Selective State Space Models (SSMs) that scales linearly with sequence length (vs. the Transformer's quadratic scaling). It offers a highly efficient and powerful alternative for long-context tasks.
* **36. Retentive Network: A Successor to Transformer for Large Language Models** (Sun et al., 2023)
    * **Main Idea:** Introduced **RetNet**, an architecture designed to achieve the best of three worlds: parallel training (like Transformers), low-cost inference (like RNNs), and strong performance, making it another strong contender to succeed the Transformer.
* **37. Hyena Hierarchy: Towards Larger Convolutional Language Models** (Poli et al., 2023)
    * **Main Idea:** Proposed an attention-free architecture that uses long convolutions gated by input signals to capture long-range dependencies, achieving sub-quadratic scaling and rivaling Transformers on key benchmarks.
* **38. Jamba: A Hybrid Transformer-Mamba Language Model** (Lieber et al., 2024)
    * **Main Idea:** Presented the first production-scale **hybrid architecture** that combines Transformer attention layers with Mamba's SSM layers. This aims to get the best of both worlds: the power of attention and the efficiency of Mamba.

---

### Extension Track A: Security and Robustness

* **39. Universal and Transferable Adversarial Attacks on Aligned LLMs** (Zou et al., 2023)
    * **Main Idea:** Demonstrated that a single, optimized string of characters can act as a universal **"jailbreak"** suffix, causing multiple different aligned LLMs to generate harmful or prohibited content when appended to a prompt.
* **40. Scalable and Transferable LLM Data Poisoning Attacks** (Schmid et al., 2024)
    * **Main Idea:** Showed that it's possible to insert hidden **backdoors** into LLMs by contaminating a tiny fraction of the pre-training data, and these backdoors remain effective even after standard alignment procedures like RLHF.
* **41. On the Security of Retrieval-Augmented Generation** (Mouton et al., 2023)
    * **Main Idea:** Analyzed the unique security vulnerabilities of RAG systems, such as an attacker injecting malicious documents into the retrieval database to control the model's output or perform prompt injection.
* **42. The LLM Attack Zoo: A Systematic Categorization of Attacks and Defenses** (Gao et al., 2024)
    * **Main Idea:** Provided a comprehensive **taxonomy** that categorizes the landscape of attacks on LLMs (e.g., prompt injection, data poisoning, model extraction), creating a structured framework for understanding and defending against threats.
* **43. Red Teaming Language Models to Reduce Harms** (Perez et al., 2022)
    * **Main Idea:** Formalized the process of **"red teaming"** for LLMs, where humans (or other AIs) adversarially test models to proactively find safety flaws and vulnerabilities before they are exploited in the real world.
* **44. A Watermark for Large Language Models** (Kirchenbauer et al., 2023)
    * **Main Idea:** Proposed a method to embed a statistical, imperceptible **watermark** into the text generated by an LLM. This allows for post-hoc detection of whether text was generated by a specific model, helping to trace its origin.
* **45. Certified Robustness to Adversarial Word Substitutions** (Wang et al., 2023)
    * **Main Idea:** Developed methods to provide **mathematical guarantees** (certified defenses) that a model's output will remain unchanged even if an attacker makes small, specific perturbations to the input, such as swapping synonyms.
* **46. Poisoning Language Models During Instruction Tuning** (Qi et al., 2023)
    * **Main Idea:** Investigated how **data poisoning attacks** can be specifically targeted at the instruction-tuning phase and explored potential detection and mitigation strategies for this critical stage of model development.

---

### Extension Track B: Ethics, Bias, and Alignment Principles

* **47. On the Dangers of Stochastic Parrots: Can Language Models Be Too Big?** (Bender et al., 2021)
    * **Main Idea:** A highly influential critique arguing that the pursuit of ever-larger LLMs carries significant risks, including perpetuating societal biases from web data, environmental costs, and creating a misleading illusion of genuine understanding.
* **48. Measuring and Mitigating Bias in Grounded Language** (Bansal et al., 2020)
    * **Main Idea:** Developed quantitative methods and benchmarks to **measure social biases** (e.g., related to gender, race, and age) in the outputs of language models and explored technical strategies for mitigating them.
* **49. Concrete Problems in AI Safety** (Amodei et al., 2016)
    * **Main Idea:** A foundational AI safety paper that, before the LLM era, outlined practical problems in ensuring AI systems behave as intended. It framed the core challenges of the modern **"alignment problem"** that RLHF later sought to address.
* **50. Constitutional AI: Harmlessness from AI Feedback** (Bai et al., 2022)
    * **Main Idea:** (Repeated from main syllabus due to its centrality). Proposed an alignment method based on a set of written principles (a "constitution"), using AI-generated feedback to guide the model towards harmlessness, thereby making alignment more scalable.