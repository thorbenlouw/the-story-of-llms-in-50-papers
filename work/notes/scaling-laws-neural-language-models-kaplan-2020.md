# Notes: Scaling Laws for Neural Language Models (Kaplan et al., 2020)

## Paper Metadata
- **Title**: Scaling Laws for Neural Language Models
- **Authors**: Jared Kaplan, Sam McCandlish, Tom Henighan, Tom B. Brown, et al. (OpenAI)
- **Year**: 2020
- **arXiv**: 2001.08361
- **Week**: 4 - Scaling Laws & Compute Optimization

## Key Contributions

1. **Power-law scaling relationships** for language model performance across:
   - Model size (N): L(N) ∝ N^(-0.076)
   - Dataset size (D): L(D) ∝ D^(-0.095)
   - Compute (C_min): L(C_min) ∝ C_min^(-0.050)

2. **Universal overfitting formula**: L(N,D) depends on ratio N^0.74/D

3. **Compute-efficient training**: Should use very large models trained on modest data, stopped before convergence

4. **Sample efficiency**: Larger models are significantly more sample-efficient

5. **Architectural independence**: Performance depends weakly on depth/width/heads when total parameters fixed

## Method Sketch

### Experimental Setup
- Trained Transformers on WebText2 dataset (22B tokens)
- Model sizes: 768 to 1.5B non-embedding parameters
- Varied: model size, dataset size, shape, context length, batch size
- Used cross-entropy loss as primary metric

### Key Equations
1. **Loss vs parameters (infinite data)**: L(N) = (N_c/N)^α_N where α_N ≈ 0.076
2. **Loss vs dataset (large model)**: L(D) = (D_c/D)^α_D where α_D ≈ 0.095
3. **Loss vs compute**: L(C_min) = (C_c^min/C_min)^α_C^min where α_C^min ≈ 0.050
4. **Combined N and D**: L(N,D) = [(N_c/N)^(α_N/α_D) + D_c/D]^α_D
5. **Training curves**: L(N,S) = (N_c/N)^α_N + (S_c/S_min)^α_S

### Critical Batch Size
- B_crit(L) ∝ L^(-1/α_B) where α_B ≈ 0.21
- Determines optimal time/compute tradeoff
- B_crit ≈ 2×10^8 tokens at convergence for largest models

## Prior Work Contrasts

1. **vs. Traditional scaling studies**: First systematic study showing power-laws across 7+ orders of magnitude
2. **vs. Architecture search**: Shows architecture details (depth, width, heads) matter little compared to total scale
3. **vs. Typical training**: Compute-efficient training uses 2.7x more parameters but 7.7x fewer steps (65% less compute)

## Notable Results

### Optimal Compute Allocation
- As compute increases by 10x: increase model size by ~5x, data by ~2x
- Optimal: N ∝ C^0.73, B ∝ C^0.24, S ∝ C^0.03
- Training steps grow negligibly with compute budget

### Overfitting Behavior
- To avoid overfitting: D ≥ (5×10^3) × N^0.74
- 22B token dataset sufficient for models up to ~10^9 parameters
- Overfitting depends primarily on ratio N^(α_N/α_D)/D

### Transfer and Generalization
- Performance on other distributions correlates with training loss
- Transfer incurs constant penalty but improves in parallel
- Generalization independent of model depth/shape

### Predictions and Contradictions
- At C* ∼ 10^4 PF-Days, N* ∼ 10^12 params, scaling laws predict contradiction
- May indicate fundamental limits or breakdown of power-law trends
- L* ∼ 1.7 nats/token suggested as possible entropy floor

## Limitations

1. **No theoretical foundation** - purely empirical power laws
2. **Limited data regime**: Poor fits for very small datasets (<40 steps/epoch)
3. **B_crit extrapolation**: Uncertain predictions far from explored range
4. **Context length**: Estimates exclude n_ctx-dependent compute (valid when d_model >> n_ctx/12)
5. **Hyperparameter tuning**: May have missed important sensitivities
6. **Learning rate**: Optimal LR depends on target loss; didn't explore all possibilities

## Course Fit (Week 4)

### Connection to Key Topics
- **Empirical scaling**: Core finding - performance scales predictably with N, D, C
- **Compute optimization**: Provides formulas for optimal allocation of compute budget
- **Chinchilla context**: This paper preceded Chinchilla (2022) which refined the scaling relationships
- **Parallelization implications**: Findings suggest prioritizing model parallelism over data parallelism

### Lab Relevance
- Provides theoretical foundation for deciding model size vs training time tradeoffs
- Critical batch size concept essential for efficient distributed training
- Power-law relationships enable prediction of performance before training

## Figure Insights

- **Figure 1**: Shows all three scaling laws (N, D, C) with smooth power-law fits
- **Figure 2**: Larger models reach same performance with fewer samples
- **Figure 3**: Optimal allocation: most compute → model size, not steps
- **Figure 4**: Left shows L(N,D) fits; Right shows learning curves L(N,S)
- **Figure 9**: Overfitting depends on N^(α_N/α_D)/D ratio
- **Figure 10**: Critical batch size B_crit follows power law in loss
- **Figure 13**: C_min scaling cleaner than naive C scaling

## Key Quotes & Page References

1. "Larger models are significantly more sample-efficient" (Abstract)
2. "Performance depends most strongly on scale... very weakly on other architectural hyperparameters" (Section 1.1)
3. "Every time we increase the model size 8x, we only need to increase the data by roughly 5x" (p. 3)
4. "Compute-efficient training involves training very large models on a relatively modest amount of data and stopping significantly before convergence" (Abstract)
5. "Big models may be more important than big data" (Section 8, p. 18)
6. Section 3: Empirical power laws with >6 orders of magnitude
7. Section 5.1: Critical batch size definition and measurement
8. Section 6: Optimal allocation derives N ∝ C^0.73
9. Appendix B: Mathematical derivation of compute-efficient frontier

## Open Questions for Discussion

1. Why do these power laws hold so consistently across scales?
2. What causes the architectural independence - why doesn't depth matter more?
3. How do these findings change with different objectives (not just cross-entropy)?
4. What happens at the predicted contradiction point (C* ∼ 10^4 PF-Days)?
5. How do Chinchilla's findings (2022) refine these original scaling laws?