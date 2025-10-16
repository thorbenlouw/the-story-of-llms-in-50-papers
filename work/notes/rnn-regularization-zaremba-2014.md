# RNN Regularization (Zaremba et al., 2014) - Notes

## Paper Metadata
- **Title**: Recurrent Neural Network Regularization
- **Authors**: Wojciech Zaremba, Ilya Sutskever, Oriol Vinyals
- **Year**: 2014
- **arXiv**: 1409.2329v5
- **Venue**: Under review as a conference paper at ICLR 2015

## Course Context
- **Week**: Week 1 - Core Transformer Architecture
- **Section**: Contrasts with the Transformer's solution to sequential issues
- **Key Topics**: RNN/LSTM limitations (context for why Transformers emerged)

## Key Contributions (10-12 bullet outline)

1. **Main Innovation**: A simple but effective method to apply dropout to LSTMs that actually works (unlike naive dropout)
   - Apply dropout ONLY to non-recurrent connections (layer-to-layer)
   - Do NOT apply dropout to recurrent connections (time-step-to-time-step)
   - This preserves the LSTM's ability to remember long-term dependencies

2. **Why Standard Dropout Failed with RNNs**: 
   - Bayer et al. (2013) claimed recurrence amplifies noise from dropout
   - Problem: Applying dropout to recurrent connections corrupts memory over time
   - Information needs to flow across many timesteps without excessive corruption

3. **The Solution's Elegance**:
   - Information corrupted exactly L+1 times (L = depth), independent of sequence length
   - Maintains memorization ability while preventing overfitting
   - Works across multiple domains

4. **Experimental Domains** (4 tasks):
   - Language modeling (Penn Tree Bank)
   - Speech recognition (Icelandic dataset)
   - Machine translation (WMT'14 English-French)
   - Image caption generation (MSCOCO)

5. **Language Modeling Results** (PTB):
   - Medium LSTM: 82.7 test perplexity (vs 114.5 non-regularized)
   - Large LSTM: 78.4 test perplexity
   - 38-model ensemble: 68.7 perplexity
   - Massive improvement from regularization

6. **Speech Recognition**: 
   - Frame accuracy improved from 68.9% to 70.5% on validation
   - Small dataset (93k utterances) where overfitting is critical

7. **Machine Translation**:
   - Test perplexity: 5.0 (regularized) vs 5.8 (non-regularized)
   - BLEU score: 29.03 vs 25.9
   - Still below phrase-based LIUM system (33.30 BLEU)

8. **Technical Details**:
   - LSTM equations with memory cells c_t, gates (i, f, o), input modulation g
   - Dropout operator D() applied to h^(l-1)_t but not h^l_(t-1)
   - Dropout rates: 50% (medium), 65% (large) on non-recurrent connections

9. **Why This Matters for Transformers**:
   - Shows fundamental difficulty of training deep sequence models
   - RNNs require complex regularization tricks to scale
   - Sequential bottleneck makes parallelization impossible
   - Sets stage for why attention-based models were revolutionary

10. **Limitations Revealed**:
    - RNNs still fundamentally sequential (can't parallelize across time)
    - Even with dropout, require careful hyperparameter tuning
    - Memory cells still face vanishing/exploding gradient issues for very long sequences
    - Path length between distant positions is O(n) - key contrast with Transformers

11. **Prior Work Context**:
    - Hochreiter & Schmidhuber (1997): Original LSTM to handle long dependencies
    - Srivastava (2013): Dropout for feedforward networks
    - Pham et al. (2013): Independently discovered same method for handwriting

12. **Course Alignment**:
    - Demonstrates RNN limitations that Transformers overcome
    - Shows sequential processing bottleneck
    - Illustrates why O(1) path length (attention) vs O(n) path length (RNN) matters
    - Motivates Transformer's parallel architecture

## Key Equations (Verbal)
- LSTM gates compute input (i), forget (f), output (o), and candidate (g)
- Dropout D() masks random subset of units to zero during training
- Applied to inter-layer connections: D(h^(l-1)_t) but keeps h^l_(t-1) intact
- Memory cell updates: c^l_t = f ⊙ c^l_(t-1) + i ⊙ g

## Notable Results
- **Table 1**: PTB perplexity comparison - large regularized LSTM achieves 78.4 vs 114.5 non-regularized
- **Figure 2**: Visual showing dropout on vertical (layer) connections but not horizontal (time) connections
- **Figure 3**: Information flow path affected by dropout exactly L+1 times
- **Section 3.2**: Core explanation of why approach works

## Limitations
- Still sequential processing (no parallelization)
- Requires extensive hyperparameter tuning (dropout rates, learning rate schedules)
- Doesn't solve fundamental O(n) path length problem
- Training time still scales with sequence length

## Connection to Transformer Motivation
- This paper shows RNNs can be improved but remain fundamentally limited
- Sequential bottleneck persists even with better regularization
- Path length O(n) vs Transformer's O(1) for self-attention
- Transformers solve both overfitting AND parallelization in one architecture