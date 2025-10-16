# Exploring the Limits of Transfer Learning with a Unified Text-to-Text Transformer

**Authors:** Colin Raffel, Noam Shazeer, Adam Roberts, Katherine Lee, Sharan Narang, Michael Matena, Yanqi Zhou, Wei Li, Peter J. Liu

**Venue:** Journal of Machine Learning Research (JMLR), 2020

**Year:** 2019 (arXiv), 2020 (publication)

**arXiv ID:** arXiv:1910.10683

---

## TL;DR

- **Unified framework**: Introduces "Text-to-Text Transfer Transformer" (T5), treating every NLP task as converting input text to output text using the same model, objective, and training procedure
- **Systematic study**: Performs comprehensive empirical comparison of architectures, objectives, datasets, and training strategies for transfer learning in NLP
- **C4 dataset**: Creates the "Colossal Clean Crawled Corpus" (750 GB of cleaned English text from Common Crawl) for pre-training
- **Strong results**: Achieves state-of-the-art on many benchmarks including GLUE (90.3), SuperGLUE (88.9), and SQuAD (91.26 EM) with 11 billion parameter model
- **Key insights**: Encoder-decoder architecture with span-corruption denoising objective works best; scale matters significantly for performance

---

## 1. Problem and Motivation

Transfer learning had become the dominant paradigm in NLP by 2019, with approaches like BERT and GPT showing remarkable success. However, the field faced several challenges. Different methods used different architectures (encoder-only like BERT, decoder-only like GPT), different pre-training objectives (masked language modeling, causal language modeling), and different datasets (Wikipedia, BookCorpus, Common Crawl). This diversity made it difficult to compare approaches systematically and understand which factors truly contributed to performance gains.

The authors motivate this work by noting the need for "more rigorous understanding" of transfer learning techniques (Section 1). They observe that the "rapid rate of progress and diversity of techniques" made it hard to "compare different algorithms, tease apart the effects of new contributions, and understand the space of existing methods." Additionally, most prior work focused on specific innovations rather than comprehensive comparisons, making it unclear which design choices mattered most.

---

## 2. Core Idea and Contributions

The central innovation is the **text-to-text framework**: casting every NLP task as taking text as input and producing text as output. For example:
- Translation: "translate English to German: That is good." → "Das ist gut."
- Classification: "cola sentence: The course is jumping well." → "not acceptable"  
- Summarization: "summarize: [article text]" → "[summary text]"

This simple unification (illustrated in Figure 1) enables using the same model architecture, loss function, and training procedure across all tasks. The framework allows the authors to systematically compare different approaches while keeping other factors constant.

The paper's main contributions are:

1. **Text-to-text framework** enabling unified treatment of diverse NLP tasks
2. **C4 dataset**: A new 750 GB pre-training corpus with heuristic cleaning of Common Crawl data
3. **Systematic study** comparing architectures, objectives, datasets, and training strategies
4. **Scaling analysis** exploring model sizes from 60M to 11B parameters
5. **State-of-the-art results** on GLUE, SuperGLUE, SQuAD, and CNN/DM
6. **Open release** of code, data, and pre-trained models

---

## 3. Method

**Architecture**: T5 uses the standard encoder-decoder Transformer (Vaswani et al., 2017) with some modifications. The baseline model has 12 blocks each in encoder and decoder (similar to BERT-BASE size in each stack), totaling ~220M parameters. Key architectural details (Section 2.1):
- Simplified layer normalization (rescaling only, no bias)
- Relative position embeddings instead of absolute (32 embeddings covering offsets up to 128)
- Layer normalization applied outside the residual path

The model uses SentencePiece with a 32,000 wordpiece vocabulary that covers English, German, French, and Romanian.

**Pre-training Objective**: The baseline uses a span-corruption denoising objective (Section 3.1.4 and Figure 2). The procedure:
1. Sample 15% of tokens in the input sequence
2. Replace consecutive corrupted spans with unique sentinel tokens
3. Train the model to predict the dropped-out spans, delimited by sentinel tokens

For example, given "Thank you <X> me to your party <Y> week .", the target becomes "<X> for inviting <Y> last <Z>". This approach is more efficient than predicting the full uncorrupted text since target sequences are shorter.

**Training Procedure** (Section 3.1.2):
- Pre-train for 2^19 = 524,288 steps with batch size 128 sequences (length 512)
- Total: 2^35 ≈ 34B tokens (less than BERT's 137B or RoBERTa's 2.2T)
- Use inverse square root learning rate schedule
- Fine-tune for 2^18 = 262,144 steps on each downstream task
- AdaFactor optimizer throughout

**C4 Dataset**: The "Colossal Clean Crawled Corpus" (Section 2.2) applies heuristic filtering to Common Crawl:
- Only retain lines ending in terminal punctuation
- Discard pages with <3 sentences or lines with <5 words
- Remove pages containing offensive words, JavaScript warnings, lorem ipsum, code
- Deduplicate at the three-sentence span level
- Use langdetect to filter for English (probability ≥ 0.99)

This produces ~750 GB of relatively clean English text.

---

## 4. Comparison to Prior Work

**vs. BERT** (Devlin et al., 2018): BERT uses an encoder-only architecture optimized for classification and span prediction tasks. T5 uses encoder-decoder, enabling both discriminative and generative tasks. BERT's masked language modeling objective predicts individual masked tokens; T5 predicts corrupted spans. Section 3.2 shows encoder-decoder with denoising outperforms encoder-only approaches.

**vs. GPT** (Radford et al., 2018): GPT uses a decoder-only architecture with causal language modeling. T5's encoder-decoder architecture allows fully-visible attention over inputs before generating outputs, avoiding GPT's limitation where input representations can only depend on previous tokens. Section 3.2.4 shows this architectural choice matters: encoder-decoder scores 83.28 on GLUE vs. 73.78 for pure language model.

**vs. Multi-task approaches** (McCann et al., 2018): While prior work explored multi-task learning, T5 provides more systematic study of mixing strategies. Section 3.5.2 compares examples-proportional mixing (with various dataset size limits K), temperature-scaled mixing, and equal mixing. The study finds that pre-training then fine-tuning generally outperforms joint multi-task training, though multi-task pre-training followed by fine-tuning works nearly as well (Table 12).

---

## 5. Results and What They Mean

**Systematic Study Results**: The paper presents extensive ablations across architectures (Section 3.2), objectives (Section 3.3), datasets (Section 3.4), and training strategies (Section 3.5). Key findings:

- **Architecture** (Table 2): Encoder-decoder with denoising achieves 83.28 GLUE score vs. 81.82 for prefix LM and 74.70 for pure language model
- **Objectives** (Tables 4-7): Denoising objectives outperform language modeling (82.96 vs. 80.69); span corruption with average length 3 performs best
- **Datasets** (Table 8): Domain-matched data helps specific tasks (e.g., Wikipedia+TBC achieves 73.24 SuperGLUE vs. 71.36 baseline), but large diverse C4 works well overall
- **Pre-training amount** (Table 9): Performance degrades when data repeats >64 times during pre-training, suggesting overfitting

**Scaling** (Section 3.6 and Table 13): Comparing ways to use 4× more compute shows all help, but larger models provide the biggest gains. Training 4× longer improves GLUE from 83.28 to 85.33; using a 4× larger model improves to 85.91.

**State-of-the-Art Results** (Section 3.7 and Table 14): With insights from the systematic study, T5-11B achieves:
- **GLUE**: 90.3 average (previous best: 89.4)
- **SuperGLUE**: 88.9 average (previous best: 84.6), nearly matching human performance of 89.8
- **SQuAD**: 91.26 EM / 96.22 F1 (previous best: 90.1 / 95.5)
- **CNN/DM**: 21.55 ROUGE-2 (previous best: 20.30)

However, T5 did not achieve state-of-the-art on WMT translation tasks, likely due to English-only pre-training and lack of techniques like backtranslation.

**Practical Insights**: Section 3.7 compares baseline, baseline trained on 1T tokens, and T5-Base. The results (Table 15) show both scale and non-scaling improvements matter: baseline-1T achieves 84.80 GLUE, while T5-Base reaches 85.97, demonstrating that the systematic study's insights provide value beyond just scale.

---

## 6. Limitations and Failure Modes

The authors explicitly discuss several limitations (Section 4.2):

**Computational cost**: Large models are expensive to train and deploy. The 11B parameter model requires substantial resources, limiting accessibility. This poses challenges for low-resource settings and applications requiring fast inference.

**English-only pre-training**: The focus on English limits performance on translation tasks. Section 3.7 notes T5 "did not achieve state-of-the-art performance on any of the WMT translation tasks," likely because "most of the best results on these tasks use backtranslation" and cross-lingual techniques.

**Data repetition effects**: Table 9 shows that repeating data >64 times during pre-training degrades performance, suggesting memorization. This necessitates very large pre-training corpora for best results.

**Multi-task learning**: Section 3.5.2 finds that "multi-task training underperforms pre-training followed by fine-tuning on most tasks" (Table 11), indicating challenges in setting appropriate mixing proportions.

**Task-specific limitations**: On SuperGLUE, humans achieve 100% on COPA and WSC while T5-11B reaches only 94.8% and 93.8%, showing remaining challenges in reasoning tasks (Section 3.7). The authors note this "suggests that there remain linguistic tasks that are hard for our model to perfect, particularly in the low-resource setting."

**Inefficient knowledge extraction**: Section 4.2 acknowledges that denoising "may not be a very efficient way to teach the model general-purpose knowledge," requiring training on ~1 trillion tokens for best results.

---

## 7. Fit to This Course (Week 3: Context, Embedding, and T5)

This paper perfectly aligns with Week 3's focus on **"Positional Encoding Deep Dive (RoPE vs. Absolute)" and "The unified text-to-text paradigm."**

**Positional Encoding**: T5 uses relative position embeddings (Section 2.1) rather than the absolute sinusoidal encodings from the original Transformer. The paper describes using 32 learned position embeddings for ranges of key-query offsets, with ranges growing logarithmically up to 128 tokens. This contrasts with the absolute encodings covered in Week 1 and sets up discussion of more advanced schemes like RoPE (the other Week 3 paper). The choice reflects practical considerations: "layers can build sensitivity to larger offsets by combining local information from previous layers."

**Text-to-Text Paradigm**: T5 exemplifies the unified text-to-text framework that Week 3 emphasizes. The paper demonstrates how a single model architecture and training procedure can handle translation ("translate English to German: ..."), classification ("mnli premise: ... hypothesis: ..."), regression (converting STS-B scores to text like "2.6"), and generation (summarization) tasks. This unification enables the systematic comparison that forms the paper's core contribution.

**Lab Connection**: The Week 3 lab involves "Implementing a small GPT-style block and fine-tuning an open-source T5 model on a sequence-to-sequence task." This paper provides the theoretical foundation and empirical validation for why T5's architecture works well for seq2seq tasks. The systematic study (especially Section 3.2 comparing architectures) explains why encoder-decoder outperforms decoder-only approaches for many tasks, directly informing the lab's design choices.

**Course Progression**: T5 synthesizes concepts from Weeks 1-2 (Transformer architecture, pre-training paradigms) while introducing ideas that continue through the course: the importance of scale (Week 4), efficient training (Week 6), and multi-task learning (Week 7).

---

## 8. Discussion Questions

1. **Architecture trade-offs**: T5 shows encoder-decoder outperforms decoder-only models on most tasks, but GPT-style models have since achieved impressive results. Under what circumstances might decoder-only architectures be preferable, and how have recent models like GPT-3 addressed T5's architectural critiques?

2. **Pre-training efficiency**: The paper trains on ~34B tokens for baseline but 1T tokens for final models. Given that increasing data helps but requires massive corpora, what alternative approaches (better objectives, curriculum learning, etc.) might achieve similar performance with less data?

3. **Domain adaptation vs. generalization**: Table 8 shows domain-specific pre-training (Wikipedia for SQuAD, news for ReCoRD) helps individual tasks. How should practitioners balance using large diverse corpora like C4 versus domain-specific data when pre-training for a known target domain?

4. **Unification costs**: The text-to-text framework requires converting all tasks to the same format, including treating regression (STS-B) as 21-class classification. What information or inductive biases might be lost by this unification, and are there tasks fundamentally ill-suited to text-to-text framing?

5. **Scaling laws**: Section 3.6 compares scaling via longer training, larger models, and ensembling. How do these results relate to subsequent work on scaling laws (Kaplan et al., 2020; Hoffmann et al., 2022), and what do they suggest about optimal resource allocation for a fixed compute budget?

---

## 9. Glossary

- **Text-to-text framework**: Unified approach casting all NLP tasks as mapping input text to output text, enabling consistent model architecture and training across diverse tasks
- **C4 (Colossal Clean Crawled Corpus)**: 750 GB dataset created by heuristically filtering Common Crawl web data for clean English text
- **Span corruption**: Pre-training objective that masks contiguous token spans (not individual tokens) and trains the model to predict them
- **Sentinel token**: Special token (e.g., `<X>`, `<Y>`) used to replace corrupted spans in the input and delimit them in the target sequence
- **Encoder-decoder architecture**: Transformer variant with separate encoder stack (processes input) and decoder stack (generates output), connected by cross-attention
- **Relative position embeddings**: Positional encoding scheme where attention weights depend on the relative distance between tokens rather than absolute positions
- **Examples-proportional mixing**: Multi-task learning strategy where sampling probability for each task is proportional to its dataset size (often with an artificial limit)
- **Temperature-scaled mixing**: Method to adjust task mixing rates by raising them to power 1/T, where higher T makes proportions more equal
- **AdaFactor**: Memory-efficient adaptive optimization algorithm that maintains running averages without storing full second-moment estimates
- **Denoising objective**: Pre-training approach where the model learns to reconstruct corrupted input, in contrast to pure language modeling
- **Fine-tuning**: Training phase where a pre-trained model is adapted to a specific downstream task by continuing training on task-specific data
- **Transfer learning**: Machine learning paradigm where knowledge from one task (pre-training) improves performance on another task (downstream)

---

## 10. References

- Vaswani et al. (2017). Attention Is All You Need. arXiv:1706.03762
- Devlin et al. (2018). BERT: Pre-training of Deep Bidirectional Transformers for Language Understanding. arXiv:1810.04805
- Radford et al. (2018). Improving Language Understanding by Generative Pre-Training.
- Kaplan et al. (2020). Scaling Laws for Neural Language Models. arXiv:2001.08361
- Hoffmann et al. (2022). Training Compute-Optimal Large Language Models. arXiv:2203.15556
- McCann et al. (2018). The Natural Language Decathlon: Multitask Learning as Question Answering. arXiv:1806.08730