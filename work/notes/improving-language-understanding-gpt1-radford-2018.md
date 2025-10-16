# GPT-1: Improving Language Understanding by Generative Pre-Training
## Radford et al., 2018

## Quick Notes from Skimming

### Abstract & Introduction Key Points
- Problem: NLP tasks need labeled data; unlabeled text is abundant but hard to leverage
- Solution: Generative pre-training on unlabeled text + discriminative fine-tuning on specific tasks
- Uses Transformer decoder architecture (not encoder-decoder)
- Achieves SOTA on 9/12 tasks including Stories Cloze (+8.9%), RACE (+5.7%), MultiNLI (+1.5%)
- Two-stage procedure: unsupervised pre-training then supervised fine-tuning
- Minimal architecture changes needed for transfer

### Method Overview
1. **Unsupervised Pre-training (Section 3.1)**
   - Standard language modeling objective: predict next token given context
   - Uses multi-layer Transformer decoder (12 layers, 768 dim, 12 attention heads)
   - Trained on BooksCorpus (7000+ unpublished books, long contiguous text)
   - Achieved perplexity of 18.4
   - BPE tokenization with 40,000 merges

2. **Supervised Fine-tuning (Section 3.2)**
   - Add linear output layer on top of pre-trained model
   - Keep auxiliary LM objective during fine-tuning (with weight λ=0.5)
   - Task-specific input transformations for structured inputs
   - Minimal changes to architecture

3. **Task-Specific Input Transformations (Section 3.3)**
   - Text classification: direct fine-tuning
   - Textual entailment: concatenate premise + $ + hypothesis
   - Similarity: process both orderings, add representations
   - QA/Commonsense: concatenate context + question + $ + answer for each option

### Key Results (Section 4)
- Natural Language Inference: +1.5% MNLI, +5% SciTail, +5.8% QNLI, +0.6% SNLI
- Question Answering: +8.9% Story Cloze, +5.7% RACE
- Semantic Similarity: state-of-art on 2/3 tasks
- Classification: 45.4 CoLA (vs 35.0 previous), 91.3% SST-2
- Overall GLUE: 72.8 vs previous 68.9

### Analysis (Section 5)
- Transfer learning improves with more layers (up to 9% on MultiNLI)
- Zero-shot behaviors show model learns task-relevant functionality during pre-training
- Ablations show: auxiliary LM helps on larger datasets, Transformer >> LSTM, pre-training crucial (14.8% improvement)

### Prior Work Contrasts
1. **vs. ELMo (Peters et al. 2018)**: Uses LSTM which limits range; GPT-1 uses Transformer for longer dependencies
2. **vs. ULMFiT (Howard & Ruder 2018)**: Also LSTM-based; GPT-1 wider range of tasks
3. **vs. Word embeddings (GloVe, Word2Vec)**: Captures higher-level semantics beyond word-level

### Course Fit (Week 2: Pre-training Paradigms)
- **Causal Language Modeling**: Core pre-training objective (left-to-right, autoregressive)
- **Unsupervised Pre-training**: Demonstrates power of learning from unlabeled text
- **Semi-supervised Transfer Learning**: Two-stage approach
- **Tokenization (BPE)**: Uses Byte-Pair Encoding with 40K merges
- **Task-agnostic architecture**: Minimal changes needed for different tasks

## Outline for Summary (10-12 bullets)

1. **Context**: Labeled data scarcity vs. abundant unlabeled text; need for transfer learning
2. **Core Innovation**: Two-stage approach combining generative pre-training + discriminative fine-tuning
3. **Architecture Choice**: Transformer decoder (12 layers) for capturing long-range dependencies
4. **Pre-training Method**: Causal language modeling on BooksCorpus; predict next token given context
5. **Fine-tuning Strategy**: Add linear layer, keep auxiliary LM objective, minimal architecture changes
6. **Input Transformations**: Task-specific ways to format structured inputs as sequences
7. **Key Results**: SOTA on 9/12 tasks; major gains on reasoning (Stories Cloze +8.9%)
8. **Transfer Analysis**: More layers = better transfer; each layer learns useful functionality
9. **Zero-shot Capability**: Model acquires task-relevant knowledge during pre-training
10. **vs. Prior Work**: Transformer captures longer dependencies than LSTM-based approaches (ELMo, ULMFiT)
11. **Limitations**: Smaller datasets don't benefit as much; unidirectional limits understanding
12. **Course Relevance**: Foundational example of causal LM, unsupervised pre-training, BPE tokenization

## Key Claims to Verify (with page/section references)

1. "Achieves absolute improvements of 8.9% on commonsense reasoning (Stories Cloze Test)" - Abstract, page 1
2. "We use a multi-layer Transformer decoder for the language model" - Section 3.1, page 3
3. "Our language model achieves a very low token level perplexity of 18.4 on this corpus" - Section 4.1, page 4
4. "12-layer decoder-only transformer with masked self-attention heads (768 dimensional states and 12 attention heads)" - Section 4.1, page 5
5. "We used a bytepair encoding (BPE) vocabulary with 40,000 merges" - Section 4.1, page 5
6. "We observe a 5.6 average score drop when using the LSTM instead of the Transformer" - Section 5, Table 5
7. "The lack of pre-training hurts performance across all the tasks, resulting in a 14.8% decrease" - Section 5, page 8
8. "Transferring embeddings improves performance and that each transformer layer provides further benefits up to 9% for full transfer on MultiNLI" - Section 5, Figure 2

## Glossary Terms (8-12)

1. **Generative Pre-training**: Training a model to predict next tokens (unsupervised) before fine-tuning
2. **Discriminative Fine-tuning**: Adapting pre-trained model to labeled task with supervised learning
3. **Causal Language Modeling**: Predicting next token given only previous tokens (left-to-right)
4. **Transformer Decoder**: Multi-layer architecture with masked self-attention (only attends to previous positions)
5. **BPE (Byte-Pair Encoding)**: Subword tokenization method that builds vocabulary from character merges
6. **Transfer Learning**: Using knowledge from one task (pre-training) to improve performance on another
7. **Task-agnostic Model**: Architecture that works across tasks with minimal modifications
8. **Auxiliary Objective**: Additional training goal (LM) during fine-tuning to improve generalization
9. **Zero-shot**: Model performing tasks without explicit supervision for those tasks
10. **Perplexity**: Measure of how well model predicts text; lower is better
11. **Fine-tuning**: Adapting pre-trained model weights to specific task with labeled data
12. **Attention Heads**: Parallel attention mechanisms that learn different representation subspaces

## Limitations & Failure Modes

1. **Unidirectional**: Only sees left context, misses right context (addressed by BERT)
2. **Small Dataset Performance**: Smaller datasets benefit less from approach (e.g., RTE with 2490 examples)
3. **Auxiliary Objective Trade-off**: Helps large datasets, may not help small ones
4. **Task-specific Transformations**: Still requires some manual design for input formatting
5. **Compute Requirements**: Pre-training requires significant computational resources
6. **Long-range Dependencies**: While better than RNNs, still has quadratic complexity in sequence length

## Discussion Questions (5)

1. How does GPT-1's causal (unidirectional) language modeling differ from BERT's masked bidirectional approach, and what are the trade-offs for downstream tasks?

2. The paper shows that including an auxiliary language modeling objective during fine-tuning helps performance. Why might this be the case, especially for larger datasets?

3. GPT-1 uses task-specific input transformations (e.g., concatenating premise and hypothesis with delimiters) rather than task-specific architectures. What are the advantages and limitations of this approach?

4. The ablation study shows a 14.8% performance drop without pre-training. What linguistic knowledge might the model acquire during unsupervised pre-training that transfers to supervised tasks?

5. Why does the Transformer architecture significantly outperform LSTMs for this transfer learning approach, beyond just the ability to capture longer-range dependencies?