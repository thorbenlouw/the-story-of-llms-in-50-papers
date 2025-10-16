# Attention Is All You Need (Vaswani et al., 2017)

**Title:** Attention Is All You Need  
**Authors:** Ashish Vaswani, Noam Shazeer, Niki Parmar, Jakob Uszkoreit, Llion Jones, Aidan N. Gomez, Łukasz Kaiser, Illia Polosukhin  
**Venue/Year:** NeurIPS 2017  
**arXiv ID:** 1706.03762

## TL;DR

- The Transformer is the first sequence transduction model relying entirely on self-attention, eliminating recurrence and convolutions completely
- Multi-head attention allows the model to jointly attend to information from different representation subspaces at different positions
- Achieves state-of-the-art translation results (28.4 BLEU on WMT 2014 EN-DE) while being significantly more parallelizable than RNN-based models
- Training time reduced from weeks to 3.5 days on 8 GPUs while exceeding previous best results by over 2 BLEU points
- The architecture's constant-time sequential operations and maximum path length of O(1) fundamentally change how we approach sequence modeling
- Positional encodings provide sequence order information without the computational burden of recurrence

## Problem and Motivation

Prior to the Transformer, sequence transduction models were dominated by recurrent neural networks (RNNs), particularly LSTMs and GRUs, which had become the standard for tasks like machine translation and language modeling. These models suffered from a fundamental limitation: their inherently sequential nature prevented parallelization within training examples. As the paper notes in Section 1, "This inherently sequential nature precludes parallelization within training examples, which becomes critical at longer sequence lengths." Processing sequences required O(n) sequential operations, making training prohibitively slow for long sequences.

While attention mechanisms had shown promise when used alongside RNNs, they were always auxiliary components rather than the primary computational mechanism. Convolutional approaches like ByteNet and ConvS2S offered better parallelization but required O(log n) or more operations to connect distant positions, making it difficult to learn long-range dependencies. The field needed an architecture that could model long-range dependencies effectively while enabling massive parallelization during training.

## Core Idea and Contributions

The Transformer's revolutionary insight is that attention alone is sufficient for sequence transduction—no recurrence or convolution needed. The paper states clearly in the abstract: "We propose a new simple network architecture, the Transformer, based solely on attention mechanisms, dispensing with recurrence and convolutions entirely."

The key innovation is the multi-head self-attention mechanism, which allows the model to attend to all positions in a sequence simultaneously. Unlike RNNs that process sequences step-by-step, the Transformer computes representations for all positions in parallel. The architecture introduces three critical components: scaled dot-product attention to handle varying sequence lengths effectively, multi-head attention to capture different types of relationships, and positional encodings to inject sequence order information.

The model maintains the successful encoder-decoder framework but reimagines it entirely through the lens of attention. Each component—from the stacked layers to the position-wise feed-forward networks—is designed to maximize parallelization while preserving the ability to model complex dependencies.

## Method

The Transformer architecture consists of an encoder-decoder structure, with both components built from stacks of identical layers (Section 3.1 describes N=6 layers for each). Each encoder layer contains two sub-layers: a multi-head self-attention mechanism and a position-wise fully connected feed-forward network. The decoder adds a third sub-layer performing multi-head attention over the encoder output.

The attention mechanism itself is elegantly simple. Scaled dot-product attention computes attention weights by taking the dot product of queries with keys, scaling by the square root of the dimension, and applying softmax: Attention(Q,K,V) = softmax(QK^T/√d_k)V. The scaling factor of 1/√d_k prevents the dot products from growing too large and pushing the softmax into regions with extremely small gradients (explained in Section 3.2.1 and footnote 4).

Multi-head attention extends this by running h=8 parallel attention operations with different learned linear projections. Instead of computing attention once with d_model=512 dimensions, the model projects queries, keys, and values h times to d_k=d_v=64 dimensions. This design choice, detailed in Section 3.2.2, allows the model to "jointly attend to information from different representation subspaces at different positions," which wouldn't be possible with single-head attention due to averaging.

Position-wise feed-forward networks apply two linear transformations with a ReLU activation, processing each position independently with the same parameters. The inner dimension d_ff=2048 is four times larger than d_model=512. Combined with residual connections and layer normalization around each sub-layer, these components create a powerful yet trainable architecture.

Since the architecture contains no recurrence or convolution, positional encodings are crucial. The model uses sinusoidal functions of different frequencies, allowing it to potentially extrapolate to sequence lengths longer than those seen during training (Section 3.5).

## Comparison to Prior Work

The Transformer's advantages over previous architectures are quantified precisely in Table 1 of the paper. RNNs require O(n) sequential operations and have a maximum path length of O(n) between any two positions, severely limiting parallelization and making long-range dependency learning difficult. Each position must wait for the previous position's computation to complete.

Convolutional models like ByteNet improve parallelization with O(1) sequential operations but require O(log_k(n)) layers for dilated convolutions to connect all pairs of positions. As noted in Section 4, a single convolutional layer with kernel width k<n cannot connect all input and output positions, necessitating deep stacks of layers.

The Transformer achieves O(1) sequential operations and O(1) maximum path length between any two positions in the network. While self-attention has O(n²·d) complexity per layer compared to RNNs' O(n·d²), this is faster when sequence length n is smaller than representation dimension d, which holds for most practical applications using word-piece or byte-pair representations.

## Results and What They Mean

The empirical results definitively established the Transformer as the new state-of-the-art. On WMT 2014 English-to-German translation, the big Transformer achieved 28.4 BLEU (Table 2), improving over the previous best result by more than 2.0 BLEU points—a substantial margin in machine translation. The English-to-French results were equally impressive at 41.8 BLEU, setting a new single-model record.

Perhaps more significant than raw performance was training efficiency. The big model trained for just 3.5 days on 8 P100 GPUs, while the base model achieved competitive results in only 12 hours. The paper reports training cost in FLOPs, showing the Transformer big model used 2.3×10^19 FLOPs for English-to-German, less than a quarter of GNMT+RL's requirements while achieving superior results.

The model's generalization capability was demonstrated through English constituency parsing experiments (Section 6.3). Despite no task-specific tuning, the 4-layer Transformer achieved 92.7 F1 on WSJ parsing in a semi-supervised setting, outperforming all previous methods except the Recurrent Neural Network Grammar. This suggested the architecture's applicability beyond translation.

## Limitations and Failure Modes

The paper acknowledges several limitations, though some require reading between the lines. The quadratic memory complexity O(n²) of self-attention becomes prohibitive for very long sequences, as each position attends to all other positions. Section 4 mentions investigating "restricted self-attention" for very long sequences, acknowledging this fundamental scaling challenge.

The model's lack of inherent sequential bias means it relies entirely on positional encodings for order information. While the sinusoidal encodings work well in practice, they represent an architectural band-aid rather than an elegant solution to sequence ordering.

The paper notes in Section 3.2.1 that attention can suffer from "reduced effective resolution due to averaging attention-weighted positions," which multi-head attention only partially addresses. The model also requires careful hyperparameter tuning—the learning rate schedule with warmup proves critical for training stability.

## Fit to This Course (Week 1: Core Transformer Architecture)

This paper perfectly launches the course's exploration of modern LLMs by introducing the foundational architecture underlying GPT, BERT, and virtually all subsequent models. Week 1's focus on "Multi-Head Self-Attention derivation and complexity analysis" directly maps to Sections 3.2.1-3.2.2, where students learn the mathematical mechanics of scaled dot-product attention and why the scaling factor √d_k matters.

The paper's detailed architectural description of the Encoder/Decoder structure (Section 3.1, visualized in Figure 1) provides the blueprint students need before studying GPT's decoder-only and BERT's encoder-only variants in Week 2. The complexity analysis comparing self-attention to RNNs (Table 1) establishes the computational advantages that enabled the subsequent scaling to billions of parameters.

Understanding positional encodings from Section 3.5 prepares students for Week 3's exploration of advanced position representations like RoPE. The paper's introduction explicitly contrasts with "Recurrent Neural Network Regularization" (Zaremba et al., 2014), the week's second paper, helping students appreciate why the field abandoned RNNs. The training details in Section 5 introduce concepts like learning rate warmup and label smoothing that remain crucial for modern LLM training.

## Discussion Questions

1. The Transformer uses identical positional encodings for all layers—how might learned, layer-specific positional representations change the model's ability to capture hierarchical structure?

2. Given that self-attention has O(n²) complexity while RNNs have O(n), why does the paper claim Transformers are computationally superior? Under what conditions might RNNs actually be more efficient?

3. The paper demonstrates that 8 attention heads work better than 1 or 16 (Table 3). How might you determine the optimal number of heads for a given task, and what information does each head appear to capture based on the attention visualizations?

4. How does the Transformer's lack of inductive bias (no built-in notion of sequence order or locality) represent both a strength and weakness compared to CNNs and RNNs?

5. The decoder uses masked self-attention to preserve auto-regressive properties, but could you design a non-autoregressive Transformer variant? What would be the trade-offs?

## Glossary

**Self-Attention:** An attention mechanism where a sequence attends to itself, computing relationships between all positions to generate representations without recurrence or convolution.

**Multi-Head Attention:** Parallel attention operations with different learned projections, allowing the model to jointly attend to different representation subspaces and capture diverse relationships.

**Scaled Dot-Product Attention:** Attention computed as softmax(QK^T/√d_k)V, where the scaling prevents gradient vanishing in softmax for large dimensions.

**Positional Encoding:** Sinusoidal or learned embeddings added to input embeddings to inject information about token positions, compensating for the lack of inherent sequence order in attention.

**Encoder-Decoder Architecture:** Two-component structure where the encoder processes the input sequence into representations, and the decoder generates output autoregressively while attending to encoder outputs.

**Layer Normalization:** Normalization technique applied across features for each example independently, stabilizing training when combined with residual connections.

**Position-wise Feed-Forward Network:** Two linear transformations with ReLU applied identically to each position, providing non-linear transformations between attention layers.

**Masked Attention:** Attention modification in the decoder preventing positions from attending to subsequent positions, preserving autoregressive properties during training.

**Residual Connection:** Adding the input of a sub-layer to its output (x + Sublayer(x)), enabling gradient flow in deep networks and facilitating training.

**Query, Key, Value (Q, K, V):** The three components of attention where queries determine what to look for, keys determine what can be found, and values contain the actual information to be aggregated.

**Teacher Forcing:** Training technique where the decoder receives ground-truth previous outputs rather than its own predictions, enabling parallel training of all positions.

**BLEU Score:** Evaluation metric for translation quality measuring n-gram precision between generated and reference translations, with brevity penalty for short outputs.

## References

Vaswani, A., Shazeer, N., Parmar, N., Uszkoreit, J., Jones, L., Gomez, A. N., Kaiser, Ł., & Polosukhin, I. (2017). Attention Is All You Need. *Advances in Neural Information Processing Systems (NeurIPS)*, 30. arXiv:1706.03762