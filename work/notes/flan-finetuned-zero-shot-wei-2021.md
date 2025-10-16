# FLAN: Finetuned Language Models are Zero-Shot Learners
## Wei et al., 2021 (ICLR 2022)

## Key Metadata
- **Authors**: Jason Wei, Maarten Bosma, Vincent Y. Zhao, Kelvin Guu, Adams Wei Yu, et al.
- **Venue**: ICLR 2022
- **arXiv**: 2109.01652
- **Model**: LaMDA-PT 137B parameters
- **Week 7 Context**: Instruction Tuning and Generalization

## Outline for Summary

### 1. Core Problem
- Language models perform well on few-shot learning but struggle with zero-shot tasks
- Without exemplars, models have difficulty with prompts that don't match pretraining data format
- Need: improve zero-shot performance to make LLMs more accessible

### 2. Main Innovation: Instruction Tuning
- Finetuning LMs on mixture of tasks described via natural language instructions
- 62 datasets across 12 task clusters (NLI, QA, translation, sentiment, etc.)
- 10 unique instruction templates per dataset for diversity
- Hold-out evaluation: train on all clusters except one, test on held-out cluster
- FLAN = Finetuned Language Net (instruction-tuned LaMDA-PT)

### 3. Method Details
- Base model: LaMDA-PT 137B (decoder-only transformer, 2.49T BPE tokens)
- Training: 30k datasets, examples-proportional mixing with 3k max
- 30k gradient steps, batch size 8,192 tokens, Adafactor optimizer
- Input/target: 1024/256 tokens
- Classification: uses "OPTIONS" suffix to constrain output space
- Evaluation: mean performance across templates AND best dev template

### 4. Key Results
- FLAN outperforms untuned LaMDA-PT substantially
- Beats zero-shot GPT-3 175B on 20 of 25 datasets
- Surpasses few-shot GPT-3 on ANLI, RTE, BoolQ, ARC, OBQA, StoryCloze
- Strong on: NLI (+13.3% over GPT-3), reading comp (+4.8%), closed-book QA (+6.8%)
- Weaker on: language modeling tasks (commonsense, coreference) where instructions are redundant

### 5. Ablation Studies
- **Task clusters**: More clusters → better performance (saturates around 7 clusters)
- **Model scale**: Benefits only emerge at ≥68B parameters; <8B models actually hurt by instruction tuning
- **Instructions matter**: No-instruction baselines perform 15-18% worse
- **Few-shot compatible**: Adding exemplars improves performance further (complementary)
- **Prompt tuning**: FLAN checkpoint responds better to soft prompts than base model

### 6. Prior Work Contrasts
- vs. GPT-3 prompting: FLAN uses natural instructions, not completion-style prompts
- vs. T5 multitask: FLAN evaluates on unseen task types, not just unseen domains
- vs. traditional MTL: Focus on zero-shot generalization to new task categories

### 7. Limitations and Failure Cases
- Doesn't help language modeling tasks where instructions are redundant
- Context length limited to 1024 tokens (insufficient for summarization)
- Mostly English training data
- Fails simple tasks like "return second word in sentence"
- Can misinterpret instructions (e.g., translates question instead of answering in target language)

### 8. Course Fit (Week 7)
- Exemplifies the shift from few-shot to instruction-following paradigm
- Shows task generalization via instruction tuning (FLAN key innovation)
- Demonstrates emergent abilities tied to scale
- Foundation for later work: InstructGPT, T0, natural instructions benchmarks
- Lab connection: evaluation frameworks (HELM/BIG-bench mentioned in Week 7)

### 9. Important Technical Details
- Task cluster methodology ensures true zero-shot (no similar tasks in training)
- 12 task clusters: NLI, reading comp, closed-book QA, commonsense, sentiment, paraphrase, coreference, translation, summarization, struct-to-text, read comp w/ commonsense, misc
- Data contamination analysis performed (similar to GPT-3)
- OPTIONS suffix crucial for classification tasks to constrain output space

### 10. Key Findings from Experiments
- Scale is necessary but not sufficient (need both scale AND instruction tuning)
- Template diversity less important than task diversity
- Natural instructions crucial (dataset names or no templates perform worse)
- Instruction tuning facilitates other adaptation methods (prompt tuning, few-shot)

## Page/Section References for Claims
- Abstract/Intro: Core idea and 137B model (p. 1-2)
- Section 2.1: 62 datasets, 12 clusters, 10 templates each (p. 3)
- Section 2.2: Task cluster evaluation methodology (p. 3)
- Section 2.3: OPTIONS suffix for classification (p. 4)
- Section 2.4: Training details - 30k steps, batch 8192 (p. 4)
- Section 3: Main results - beats GPT-3 on 20/25 datasets (p. 4-5, Figure 5)
- Section 4.1: More clusters improve performance (p. 6, Figure 6)
- Section 4.2: Scale matters - benefits only at ≥68B (p. 7, Figure 7)
- Section 4.3: Instructions crucial - 15-18% drop without (p. 7, Figure 8)
- Section 4.4: Few-shot compatibility (p. 7-8, Figure 9)
- Section 4.5: Prompt tuning facilitation (p. 8, Figure 10)

## Key Terminology for Glossary
1. Instruction tuning
2. Zero-shot learning
3. Task cluster
4. Few-shot learning
5. Rank classification
6. OPTIONS suffix
7. Template
8. Task generalization
9. Examples-proportional mixing
10. Prompt tuning
11. Multi-task learning (MTL)
12. Natural language inference (NLI)