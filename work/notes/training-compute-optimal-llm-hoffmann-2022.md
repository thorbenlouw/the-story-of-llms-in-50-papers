# Training Compute-Optimal Large Language Models (Hoffmann et al., 2022) - Notes

## Key Context
- Week 4: Scaling Laws & Compute Optimization
- Focus: Chinchilla optimal scaling theory, relationship between model size and training data

## Initial Outline (10-12 bullets)

1. **Main Finding**: Current LLMs are undertrained - model size and training tokens should scale equally
2. **Kaplan vs Chinchilla**: Kaplan (2020) suggested 55× model scaling vs 1.8× data; Chinchilla finds 1:1 scaling
3. **Three Approaches**: Used 3 different methods (all converge to similar predictions)
4. **400+ Models**: Trained models from 70M to 16B parameters on 5B to 500B tokens
5. **Chinchilla Result**: 70B param model on 1.4T tokens outperforms Gopher (280B) on same compute
6. **Practical Impact**: Smaller optimal models = lower inference cost, easier deployment
7. **Key Equation**: Loss L(N,D) = E + A/N^α + B/D^β (separates model size and data effects)
8. **Power Law**: N_opt ∝ C^0.5, D_opt ∝ C^0.5 (equal scaling)
9. **Implications**: 175B GPT-3 should have used 4.2T tokens; 280B Gopher needs 6.8T tokens
10. **Performance**: Chinchilla achieves 67.5% on MMLU (7% over Gopher), SOTA on many benchmarks
11. **Dataset Importance**: Results emphasize need for larger, high-quality datasets
12. **Validation**: Confirmed on C4 and GitHub datasets - scaling behavior is consistent

## Core Innovation
- Challenges Kaplan scaling laws with empirical evidence from broader model range
- Shows equal scaling of parameters and data is optimal (not parameter-heavy scaling)
- Introduces Chinchilla as proof: 4× smaller, 4× more data, better performance

## Prior Work Contrast
1. **vs Kaplan et al. (2020)**: 
   - Kaplan: fixed tokens (130B), fixed LR schedule → underestimates data importance
   - Chinchilla: varies both, matches LR schedule to training length
   - Kaplan: mostly <100M models; Chinchilla: up to 16B models
   
2. **vs Practice (GPT-3, Gopher, MT-NLG)**:
   - All trained on ~300B tokens
   - Chinchilla shows they're oversized for compute budget

## Method Overview
- **Approach 1**: Fix model sizes, vary training duration → extract loss envelope
- **Approach 2**: IsoFLOP profiles - fix compute budget, vary model size → find minima
- **Approach 3**: Parametric loss function fitting with Huber loss (robust to outliers)

## Key Results
- MMLU: 67.6% (vs 60.0% Gopher, 43.9% GPT-3)
- LAMBADA: 77.4% (vs 74.5% Gopher)
- TruthfulQA: 43.6% 0-shot, 66.7% 10-shot (vs 29.5%, 43.7% Gopher)
- BIG-bench: 65.1% avg (vs 54.4% Gopher)
- Outperforms on 51/57 MMLU tasks

## Limitations
- Only 2 large-scale runs (Chinchilla, Gopher) for validation
- Assumes power-law holds (observe some concavity at high compute)
- All training <1 epoch
- Dataset quality becomes critical at scale

## Fit to Course (Week 4)
- Central to understanding compute-optimal scaling
- Corrects previous scaling laws (Kaplan)
- Emphasizes data scaling alongside model scaling
- Foundation for modern LLM training decisions
- Ties to Megatron-LM parallelization needs (larger datasets require better infrastructure)

## Important Equations/Concepts
- FLOPs ≈ 6ND for transformers
- Loss: L(N,D) = E + A/N^α + B/D^β
- Optimal: N_opt = G(C/6)^a, D_opt = G'(C/6)^b where a ≈ b ≈ 0.5
- E = 1.69 (entropy of natural text)
- α = 0.34, β = 0.28 (empirically fitted)

## Discussion Questions Ideas
1. Why did Kaplan's fixed-schedule approach underestimate data importance?
2. What are implications for future 1T+ parameter models?
3. How does dataset quality interact with scaling?
4. Why equal scaling (not parameter-favored)?
5. Inference cost vs training cost trade-offs

## Notable Claims to Verify
- "Current large models are significantly undertrained" (Sec 1, abstract)
- "Model size and tokens should scale equally" (Table 2)
- "Chinchilla outperforms Gopher uniformly" (Sec 4.2)
- "175B model needs 4.2T tokens" (Table 3)
- "Similar results on C4 and GitHub" (Appendix C, Table A2)