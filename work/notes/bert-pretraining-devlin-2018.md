# Notes for "BERT: Pre-training of Deep Bidirectional Transformers for Language Understanding"

## Key Contributions
- Introduces BERT (Bidirectional Encoder Representations from Transformers).
- Proposes two new pre-training tasks: Masked LM (MLM) and Next Sentence Prediction (NSP).
- Achieves state-of-the-art results on 11 NLP tasks.
- Demonstrates the importance of bidirectionality for language understanding.

## Method Sketch
- BERT's architecture is a multi-layer bidirectional Transformer encoder.
- **Masked LM (MLM):** Randomly mask some percentage of the input tokens, and the objective is to predict only those masked tokens. This allows the model to learn a deep bidirectional representation.
- **Next Sentence Prediction (NSP):** The model receives pairs of sentences as input and learns to predict if the second sentence is the subsequent sentence in the original document. This teaches the model to understand sentence relationships.
- **Fine-tuning:** For downstream tasks, a simple classification layer is added on top of the transformer output for the `[CLS]` token.

## Prior Work Contrast
- **vs. GPT-1:** GPT is unidirectional (left-to-right), while BERT is bidirectional. This means BERT can see the entire input sentence at once, leading to a deeper understanding of context.
- **vs. ELMo:** ELMo uses a shallow concatenation of independently trained left-to-right and right-to-left LSTMs. BERT uses a single, deeply bidirectional Transformer architecture.

## Notable Results
- BERT obtains new state-of-the-art results on GLUE, SQuAD v1.1, and SWAG.
- Ablation studies show that both MLM and NSP contribute significantly to the model's performance.

## Limitations
- Pre-training/fine-tuning discrepancy due to the `[MASK]` token.
- NSP's effectiveness has been questioned in later work (e.g., RoBERTa).
- Computationally expensive to pre-train.