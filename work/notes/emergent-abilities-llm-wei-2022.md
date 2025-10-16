# Emergent Abilities of Large Language Models (Wei et al., 2022)
## Notes and Outline

### Paper Metadata
- **Title**: Emergent Abilities of Large Language Models
- **Authors**: Jason Wei, Yi Tay, Rishi Bommasani, Colin Raffel, Barret Zoph, et al.
- **Year**: 2022
- **Venue**: Transactions on Machine Learning Research (08/2022)
- **arXiv**: 2206.07682

### Course Context (Week 7)
- **Section**: Instruction Tuning and Generalization (Phase III)
- **Key Topics**: 
  - The shift to instruction-following
  - Task generalization via instruction-tuning (FLAN)
  - Emergent abilities (In-context learning)
  - Multimodality introduction
  - Evaluation & Benchmarking: Holistic evaluation frameworks and task diversity

### Core Definition
- **Emergent ability**: An ability is emergent if it is not present in smaller models but is present in larger models
- Cannot be predicted by extrapolating performance from smaller-scale models
- Shows phase transition pattern: near-random until critical threshold, then jumps to substantially above random
- Qualitative change in behavior from quantitative scaling

### Key Outline (12 bullets)

1. **Emergence definition and measurement**
   - Phase transition behavior in scaling curves
   - Measured via training FLOPs, model parameters, or perplexity
   - Performance near-random until critical scale threshold

2. **Few-shot prompting emergence**
   - BIG-Bench tasks: arithmetic, IPA transliteration, word unscrambling, Persian QA
   - Emergence occurs at different scales for different tasks (typically 10²²-10²⁴ FLOPs)
   - Multiple model families show similar emergence patterns (GPT-3, LaMDA, Gopher, Chinchilla, PaLM)

3. **TruthfulQA emergence**
   - GPT-3 fails at all scales (adversarially curated against it)
   - Gopher 280B (5×10²³ FLOPs) emerges to >20% above random
   - Shows task-specific emergence patterns

4. **MMLU benchmark emergence**
   - 57 test topics spanning math, history, law, etc.
   - Models <10²² FLOPs perform at random
   - Emergence at 3-5×10²³ FLOPs (70B-280B parameters)
   - Suggests knowledge-based QA requires threshold scale

5. **Word in Context (WiC) benchmark**
   - GPT-3 and Chinchilla fail even at largest scale (~5×10²³ FLOPs)
   - PaLM 540B (2.5×10²⁴ FLOPs) achieves above-random
   - Challenges assumptions about architecture vs. scale

6. **Chain-of-thought prompting**
   - Enables multi-step reasoning by generating intermediate steps
   - Only surpasses standard prompting at ~10²³ FLOPs (100B parameters)
   - Emergent technique that didn't help smaller models

7. **Instruction following**
   - Finetuning on instruction-phrased tasks
   - Hurts performance for models ≤7×10²¹ FLOPs (8B params)
   - Helps only when scaled to 10²³ FLOPs (100B params)
   - Later work showed encoder-decoder models need less scale

8. **Program execution and scratchpad**
   - Predicting intermediate outputs for multi-step computation
   - 8-digit addition: helps only for models ≥9×10¹⁹ FLOPs (40M params)
   - Demonstrates low-scale emergence example

9. **Model calibration improvements**
   - True/False calibration technique
   - Only superior at largest scale (~3×10²³ FLOPs, 52B params)
   - Enables models to assess their own correctness

10. **Cross-entropy loss analysis**
    - Even when downstream metrics (accuracy, exact match) are random, cross-entropy loss improves
    - Suggests models are improving but improvements masked by discrete metrics
    - Doesn't explain when or why emergence occurs

11. **Factors beyond scale**
    - Data quality and composition matter (e.g., PaLM 62B outperforms larger GPT-3/LaMDA on some tasks)
    - Architecture differences can enable earlier emergence
    - Training procedures and objectives influence emergence thresholds

12. **Emergent risks and sociological changes**
    - Risks (bias, toxicity, memorization) can also emerge with scale
    - Shift to general-purpose models vs. task-specific models
    - Unpredictability raises safety concerns

### Key Empirical Results

**Few-shot prompting emergence scales** (Table 1):
- Addition/subtraction (3-digit): 2.3×10²² FLOPs, 13B params (GPT-3)
- MMLU (57 topics avg): 3.1×10²³ FLOPs, 175B params (GPT-3)
- TruthfulQA: 5×10²³ FLOPs, 280B params (Gopher)
- WiC benchmark: 2.5×10²⁴ FLOPs, 540B params (PaLM)

**Augmented prompting emergence scales**:
- Instruction following: 1.3×10²³ FLOPs, 68B params (FLAN)
- Chain-of-thought (math): 1.3×10²³ FLOPs, 68B params (LaMDA)
- Scratchpad (8-digit add): 8.9×10¹⁹ FLOPs, 40M params (LaMDA)

### Prior Work Contrasts

1. **vs. Scaling Laws (Kaplan 2020, Hoffmann 2022)**
   - Scaling laws predict smooth, power-law improvements
   - Emergent abilities show discontinuous jumps
   - Cannot be predicted by extrapolation

2. **vs. Standard evaluation metrics**
   - Cross-entropy loss improves smoothly
   - Task-specific metrics (accuracy, exact match) show phase transitions
   - Suggests evaluation metric choice matters

3. **vs. Architecture-focused explanations**
   - Brown et al. 2020 suggested WiC failure due to GPT-3 architecture
   - PaLM (same architecture, larger scale) succeeded
   - Scale can overcome perceived architectural limitations

### Limitations and Open Questions

1. **Unpredictability**: Cannot predict which abilities will emerge or at what scale
2. **Metric dependence**: Emergence may be partially artifact of discrete evaluation metrics
3. **Incomplete explanations**: Why certain tasks emerge at certain scales remains unclear
4. **Computational cost**: Discovering emergence requires expensive large-scale training
5. **Risks**: Harmful behaviors may also emerge unpredictably
6. **Plateau uncertainty**: No guarantee abilities reach desired performance levels
7. **Task distribution**: Some abilities may never emerge if far out-of-distribution

### Relation to Week 7 Labs
- Direct connection to FLAN (instruction tuning emergence)
- Emergent abilities fundamental to HELM/BIG-bench evaluation frameworks
- In-context learning as emergent phenomenon
- Understanding when generalization emerges informs instruction tuning strategies

### Technical Details
- Models analyzed: GPT-3, LaMDA, Gopher, Chinchilla, PaLM, Anthropic models
- Scale range: 2.1M to 540B parameters, 3.3×10¹⁸ to 2.5×10²⁴ FLOPs
- BIG-Bench: 200+ tasks categorized by emergence patterns
- MMLU: 57 topics in 4 categories (Humanities, STEM, Social Science, Other)

### Important Figures
- Figure 2: Eight emergent few-shot prompting tasks
- Figure 3: Four emergent augmented prompting strategies
- Figure 4: MMLU vs. FLOPs, parameters, and WikiText103 perplexity
- Table 1: Comprehensive list of emergent abilities and emergence scales

### Future Directions (from paper)
1. Further model scaling
2. Improved architectures and training procedures
3. Data scaling and quality improvements
4. Better prompting techniques
5. Understanding why emergence occurs
6. Frontier tasks that haven't emerged yet
7. Multilingual and multimodal emergence