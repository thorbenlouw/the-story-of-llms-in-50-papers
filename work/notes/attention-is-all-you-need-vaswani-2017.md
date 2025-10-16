# Notes: Attention Is All You Need (Vaswani et al., 2017)

## Key Contributions
- First sequence transduction model based entirely on attention (no recurrence/convolution)
- Introduced the Transformer architecture
- Multi-head self-attention mechanism
- Scaled dot-product attention
- Positional encodings for sequence order
- State-of-the-art results on translation tasks

## Method Sketch
1. **Architecture Components:**
   - Encoder-Decoder structure
   - 6 layers each
   - Multi-head attention (8 heads)
   - Position-wise feed-forward networks
   - Residual connections and layer normalization

2. **Attention Mechanism:**
   - Scaled Dot-Product Attention: Attention(Q,K,V) = softmax(QK^T/√d_k)V
   - Multi-head allows attending to different representation subspaces
   - Self-attention in encoder and decoder
   - Cross-attention from decoder to encoder

3. **Key Parameters:**
   - d_model = 512 (model dimension)
   - h = 8 (attention heads)
   - d_k = d_v = 64 (key/value dimensions)
   - d_ff = 2048 (feed-forward dimension)

## Prior Work Contrast
- RNNs/LSTMs: Sequential computation, O(n) operations, difficult parallelization
- ConvNets (ByteNet, ConvS2S): Better parallelization but O(log n) or O(n) path length
- Transformer: O(1) sequential operations, fully parallelizable, constant path length

## Notable Results
- WMT 2014 EN-DE: 28.4 BLEU (2+ BLEU improvement over previous best)
- WMT 2014 EN-FR: 41.8 BLEU (new state-of-the-art)
- Training time: 3.5 days on 8 P100 GPUs for big model
- WSJ parsing: 92.7 F1 (semi-supervised)

## Limitations
- Quadratic memory complexity O(n²) for self-attention
- Fixed context window
- No inherent sequence order (requires positional encoding)
- Struggles with very long sequences

## Course Alignment (Week 1)
- Core Transformer Architecture
- Multi-Head Self-Attention derivation
- Encoder/Decoder structure
- Positional Encodings
- Complexity analysis vs RNNs