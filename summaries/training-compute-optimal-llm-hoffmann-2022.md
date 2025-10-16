# Training Compute-Optimal Large Language Models

**Authors:** Jordan Hoffmann*, Sebastian Borgeaud*, Arthur Mensch*, Elena Buchatskaya, Trevor Cai, Eliza Rutherford, Diego de Las Casas, Lisa Anne Hendricks, Johannes Welbl, Aidan Clark, Tom Hennigan, Eric Noland, Katie Millican, George van den Driessche, Bogdan Damoc, Aurelia Guy, Simon Osindero, Karen Simonyan, Erich Elsen, Jack W. Rae, Oriol Vinyals, Laurent Sifre (*Equal contribution)

**Venue:** arXiv preprint  
**Year:** 2022  
**arXiv ID:** 2203.15556

---

## TL;DR

- Current large language models (GPT-3, Gopher, MT-NLG) are significantly **undertrained**—they are too large for their compute budgets and trained on too little data.
- For compute-optimal training, **model size and training tokens should scale equally**: doubling compute means doubling both parameters and data (not just making models bigger).
- Training over 400 models (70M to 16B parameters), the authors derive scaling laws that contradict Kaplan et al. (2020), predicting much smaller optimal models trained on far more data.
- **Chinchilla** (70B parameters, 1.4T tokens) validates this hypothesis by outperforming Gopher (280B parameters, 300B tokens) on nearly every benchmark using the same compute budget.
- The smaller optimal model provides substantial benefits: lower inference costs, easier deployment, and state-of-the-art performance (67.5% on MMLU, surpassing expert forecasts).
- The results emphasize the critical importance of **scaling datasets** alongside model development, requiring increased focus on high-quality data collection.

---

## 1. Problem and Motivation

The field of large language models has been dominated by a "bigger is better" mentality. Models have grown from GPT-3 (175B parameters) to MT-NLG 530B (530B parameters) in just two years, all trained on approximately 300 billion tokens. This trend was informed by Kaplan et al.'s (2020) scaling laws, which suggested that when compute budget increases by 10×, model size should increase 5.5× while training data should only increase 1.8×.

However, this parameter-heavy scaling approach has significant downsides: massive models are expensive to train, costly to run at inference time, and difficult to deploy. The key question this paper addresses is: **Given a fixed compute budget, what is the optimal trade-off between model size and the number of training tokens?**

The authors hypothesize that current large models are substantially oversized and undertrained. If true, training smaller models on more data could achieve better performance for the same compute cost, with the added benefits of faster inference and easier deployment. Since training these models is extremely expensive (often feasible only once), getting this allocation right from the start is critical.

---

## 2. Core Idea and Contributions

The central finding is that **model parameters and training tokens should scale in equal proportions** as compute increases, not the parameter-heavy scaling suggested by previous work. Specifically:

- For every doubling of model size, the number of training tokens should also double
- Current large models should be approximately 4× smaller and trained on 4× more data
- This equal scaling (N_opt ∝ C^0.5, D_opt ∝ C^0.5) holds across three independent estimation approaches

The paper makes four key contributions:

1. **Empirical scaling analysis**: Training over 400 language models ranging from 70 million to over 16 billion parameters on 5 billion to 500 billion tokens, varying both model size and training duration.

2. **Three convergent approaches**: Developing three different methodologies to estimate optimal scaling, all of which reach similar conclusions despite different assumptions.

3. **Chinchilla model**: Training a 70B parameter model on 1.4 trillion tokens to validate predictions—using the same compute as Gopher (280B) but with the predicted optimal allocation.

4. **Comprehensive evaluation**: Demonstrating that Chinchilla uniformly outperforms much larger models (Gopher, GPT-3, MT-NLG 530B) across language modeling, MMLU, BIG-bench, reading comprehension, and question answering tasks.

The authors show that a 175 billion parameter model (like GPT-3) should be trained on over 4.2 trillion tokens to be compute-optimal, not the 300 billion used in practice. Similarly, a 280 billion parameter model should use approximately 6.8 trillion tokens.

---

## 3. Method

The authors employ three complementary approaches to estimate the optimal allocation of compute between model size and training tokens, all based on modeling the relationship between loss L, model parameters N, and training tokens D.

### Approach 1: Fixed Model Sizes, Varying Training Duration

Train multiple models of fixed sizes (70M to 10B parameters) for four different training durations (varying by 16× in tokens). For each compute budget:
- Extract the training loss curve for each model
- Interpolate to find which model achieves the lowest loss at that compute level
- Fit power laws to the resulting optimal points

This yields N_opt ∝ C^0.50 and D_opt ∝ C^0.50, where C is the compute budget in FLOPs.

### Approach 2: IsoFLOP Profiles

For nine fixed FLOP budgets (6×10^18 to 3×10^21), train models of varying sizes and plot final loss against parameter count. Each curve shows a clear valley—a single optimal model size for that budget. Fitting power laws to these optima yields N_opt ∝ C^0.49 and D_opt ∝ C^0.51.

The key insight is matching the learning rate schedule to the training duration. The authors find that when the cosine decay schedule overshoots the actual training steps by more than 25%, performance degrades significantly (see Figure A1).

### Approach 3: Parametric Loss Function

Model the loss using a decomposition based on learning theory:

**L(N, D) = E + A/N^α + B/D^β**

where:
- E is the entropy of natural text (irreducible Bayes risk)
- A/N^α captures the approximation error from finite model capacity
- B/D^β captures the optimization suboptimality from limited training data

Fit this function to all experimental data using Huber loss (robust to outliers) with L-BFGS optimization. The fitted parameters are E = 1.69, A = 406.4, B = 410.7, α = 0.34, β = 0.28. This approach predicts N_opt ∝ C^0.46 and D_opt ∝ C^0.54.

### Chinchilla Training

Based on these predictions, the authors train Chinchilla: a 70B parameter model on 1.4 trillion tokens, using the same compute budget as Gopher (280B parameters, 300B tokens). Architecture details:
- 80 layers, 64 attention heads, 128 key/value size, 8192 d_model
- AdamW optimizer (instead of Adam used for Gopher)
- Modified SentencePiece tokenizer (no NFKC normalization)
- Trained on MassiveText with adjusted sampling proportions

The total FLOPs are approximately 5.76×10^23, split optimally between a smaller model and more training data.

---

## 4. Comparison to Prior Work

### vs. Kaplan et al. (2020)

The most important contrast is with Kaplan's scaling laws:

1. **Training methodology**: Kaplan used a fixed number of training tokens (130B) and a fixed learning rate schedule for all models. This prevents modeling how learning rate schedule affects loss and leads to overestimating the loss for models trained on fewer than 130B tokens. Chinchilla varies both training duration and matches the cosine schedule length to actual training steps.

2. **Model size range**: Kaplan's analysis primarily used models under 100M parameters (many under 100M), while Chinchilla trains models up to 16B parameters and observes curvature in the FLOP-loss frontier that isn't visible at smaller scales.

3. **Scaling predictions**: Kaplan predicts N_opt ∝ C^0.73 and D_opt ∝ C^0.27 (heavily parameter-biased). Chinchilla finds N_opt ∝ C^0.50 and D_opt ∝ C^0.50 (equal scaling). At 10^21 FLOPs, a head-to-head comparison (Figure A4) shows the Chinchilla-predicted 2.8B model outperforms Kaplan's predicted 4.7B model.

### vs. Current Practice

Existing large models (GPT-3, Gopher, Jurassic-1, MT-NLG 530B) all trained on approximately 300 billion tokens, following the "scale parameters, not data" approach. Chinchilla demonstrates these models are substantially oversized:
- GPT-3 (175B) should use ~4.2T tokens, not 300B
- Gopher (280B) should use ~6.8T tokens, not 300B  
- MT-NLG (530B) should use ~11T tokens, not 270B

The compute used to train Gopher could have produced a 67B optimal model—very close to Chinchilla's 70B size.

### vs. Clark et al. (2022)

Clark et al. studied Mixture-of-Experts scaling but also used fixed training tokens, potentially underestimating the benefits of sparse models when data is properly scaled.

---

## 5. Results and What They Mean

Chinchilla's performance validates the compute-optimal hypothesis across diverse benchmarks:

### Language Modeling
- **The Pile**: Outperforms Gopher on all 19 subsets (Figure 5)
- **Wikitext103**: 7.16 perplexity vs. 7.75 for Gopher (though some train/test leakage expected with 4× more training data)

### MMLU (Massive Multitask Language Understanding)
- **67.6% average** (5-shot) vs. 60.0% for Gopher and 43.9% for GPT-3
- Exceeds the expert forecast of 63.4% for June 2023 performance
- Achieves >90% on 4 individual tasks (high_school_gov_and_politics, international_law, sociology, us_foreign_policy)
- Improves on 51/57 tasks compared to Gopher

### BIG-bench
- **65.1% average** vs. 54.4% for Gopher (10.7% improvement)
- Outperforms on 58/62 tasks considered

### Question Answering
- **Natural Questions**: 35.5% (64-shot) vs. 28.2% for Gopher—new closed-book SOTA
- **TriviaQA** (filtered): 64.6% vs. 57.2% for Gopher; only 7.9% behind open-book SOTA

### Common Sense & Reading Comprehension
- **RACE-h**: 82.3% vs. 71.6% for Gopher (10.7% improvement)
- **HellaSwag**: 80.8% vs. 79.2% for Gopher
- **TruthfulQA**: 43.6% (0-shot) vs. 29.5% for Gopher—14.1% improvement contradicts Lin et al.'s finding that larger models don't improve truthfulness

**What this means**: The results demonstrate that better modeling of pre-training data (through optimal allocation) leads to substantial improvements across the board. The consistency of improvements suggests the scaling laws are robust, not task-specific. Importantly, Chinchilla achieves these gains while being 4× smaller, making it far more practical for deployment—lower inference costs, reduced memory requirements, and easier fine-tuning.

---

## 6. Limitations and Failure Modes

The authors acknowledge several important limitations:

1. **Limited large-scale validation**: Only two comparable training runs exist at large scale (Chinchilla and Gopher), with no intermediate-scale tests to verify the predictions.

2. **Power-law assumption**: The analysis assumes the compute-optimal frontier follows a power law, but the authors observe some concavity in log(N_opt) at high compute budgets (Appendix E). This suggests they may still be slightly overestimating optimal model sizes for very large budgets.

3. **Single-epoch regime**: All training runs use less than one epoch of data. The optimal allocation for multiple-epoch training remains unexplored.

4. **Dataset quality unknown**: While the analysis shows that more data is needed, it doesn't address whether sufficient high-quality data exists at trillion-token scales. The authors speculate that scaling benefits diminish with lower-quality data.

5. **Methodology constraints**: The three approaches use different model ranges and methodologies, with Approach 3 (parametric fitting) weighting high-compute points more heavily due to Huber loss, potentially underestimating optimal sizes.

6. **Bias and toxicity**: While Chinchilla shows slightly better performance on Winogender and similar toxicity levels to Gopher, the fundamental issues of bias and toxic generation remain, inherited from the training data.

7. **Generalization uncertainty**: Though validated on C4 and GitHub datasets (Appendix C, Table A2), the extent to which these laws generalize to other domains and modalities requires further study.

The curvature observation is particularly significant—if the frontier is indeed concave, then even smaller models than predicted may be optimal for future very-large-scale training.

---

## 7. Fit to This Course

**Week 4: Scaling Laws & Compute Optimization**

This paper is central to understanding the "Chinchilla optimal scaling theory" mentioned in the syllabus. It directly addresses the week's key topics:

### Empirical Scaling
The paper provides the most comprehensive empirical study of how model size, dataset size, and compute budget interact. Unlike Kaplan et al., which extrapolated from small models, this work trains models up to 16B parameters and validates predictions at 70B scale—giving students a realistic view of scaling behavior at practical LLM sizes.

### Compute Optimization
The three methodological approaches (envelope analysis, IsoFLOP profiles, parametric fitting) teach students multiple ways to think about compute allocation. The key insight—equal scaling of parameters and data—has immediate practical implications for anyone planning to train large models with limited budgets.

### Relationship to Parallelization (Megatron-LM)
While the syllabus mentions "data and model parallelization concepts," Chinchilla's findings emphasize that optimal training requires massive datasets (trillions of tokens). This necessitates efficient data loading and parallelization strategies—Megatron-LM's contributions become more critical when training on 1.4T tokens vs. 300B tokens.

### Contrast with Week 4, Paper 1 (Kaplan et al.)
Reading both papers in sequence illustrates how empirical ML research progresses: Kaplan established initial scaling laws from limited data; Chinchilla refined them with broader experiments and better methodology. Students learn that even influential results require validation and that experimental design choices (fixed vs. variable schedules, model size ranges) profoundly impact conclusions.

### Foundation for Later Weeks
The emphasis on dataset scaling sets up discussions in Week 7 (evaluation and generalization), Week 9 (alignment—you need more data for RLHF), and Week 11 (RAG as an alternative to pure scaling). Understanding that trillion-token datasets are necessary helps motivate retrieval-augmented approaches and parameter-efficient fine-tuning.

### Practical Lab Connection
If students implement scaling experiments as suggested in Week 4, this paper provides concrete recipes: how to vary training schedules, how to identify compute-optimal points, and what metrics to track. The validation that similar results hold on C4 and GitHub (Appendix C) means students can experiment on smaller, accessible datasets.

---

## 8. Discussion Questions

1. **Methodological critique**: Kaplan et al. used a fixed learning rate schedule and training duration, while Chinchilla matches the schedule to training length. How do these design choices bias scaling law estimates, and what does this teach us about experimental methodology in deep learning research?

2. **Future implications**: If a 1 trillion parameter model requires 21.2 trillion tokens (Table 3) to be compute-optimal, where will this data come from? What are the quality, ethical, and practical challenges of assembling such datasets?

3. **Inference vs. training trade-offs**: Chinchilla is 4× smaller than Gopher but achieves better performance. How should organizations weigh one-time training costs against ongoing inference costs when deciding model scale? In what scenarios might an "oversized" model still be preferable?

4. **Why equal scaling?**: The paper empirically finds N_opt ∝ C^0.5 and D_opt ∝ C^0.5, but the fitted exponents α = 0.34 and β = 0.28 are asymmetric. Why does the optimization still yield approximately equal scaling? What does this reveal about the loss landscape?

5. **Generalization to other modalities**: The authors validate their findings on text (MassiveText, C4, GitHub). How might optimal scaling differ for vision-language models, code-specialized models, or multimodal architectures? Would you expect the same 1:1 parameter-data scaling?

---

## 9. Glossary

1. **Compute-optimal**: The allocation of a fixed computational budget (FLOPs) that minimizes final model loss, balancing model size against training data quantity.

2. **IsoFLOP profile**: A curve showing model performance as a function of parameter count for a fixed compute budget; reveals the optimal model size for that budget.

3. **Chinchilla scaling**: The empirical finding that model parameters and training tokens should scale proportionally (N_opt ∝ C^0.5, D_opt ∝ C^0.5) as compute increases.

4. **FLOPs (Floating Point Operations)**: The total number of floating-point operations performed during training; approximately 6ND for transformers, where N is parameters and D is tokens.

5. **Power law**: A functional relationship of the form y = Cx^a, appearing frequently in scaling laws; here, optimal size grows as a power of compute.

6. **Huber loss**: A robust loss function that behaves like mean squared error for small residuals and mean absolute error for large residuals; reduces sensitivity to outliers.

7. **Cosine schedule**: A learning rate decay schedule that follows a cosine curve from the maximum rate to a minimum (typically 10× lower); the cycle length affects final performance.

8. **Parametric loss function**: A mathematical model (here L(N,D) = E + A/N^α + B/D^β) that predicts training loss as a function of model size and training data.

9. **Undertrained**: A model that has not seen enough training data relative to its parameter count to achieve optimal performance for its compute budget.

10. **MMLU (Massive Multitask Language Understanding)**: A benchmark consisting of 57 diverse academic subject exams testing knowledge and reasoning across STEM, humanities, and social sciences.

11. **AdamW**: A variant of the Adam optimizer that decouples weight decay from the gradient update, generally improving generalization over standard Adam.

12. **Entropy of natural text (E)**: The irreducible uncertainty in next-token prediction even with a perfect model; represents the Bayes error rate for the language modeling task.

---

## 10. References

- Kaplan, J., McCandlish, S., Henighan, T., et al. (2020). Scaling Laws for Neural Language Models. arXiv:2001.08361
- Brown, T., et al. (2020). Language Models are Few-Shot Learners (GPT-3). NeurIPS.
- Rae, J., et al. (2021). Scaling Language Models: Methods, Analysis & Insights from Training Gopher. arXiv:2112.11446
- Raffel, C., et al. (2020). Exploring the Limits of Transfer Learning with a Unified Text-to-Text Transformer (T5). JMLR.
- Hendrycks, D., et al. (2020). Measuring Massive Multitask Language Understanding. arXiv:2009.03300
- Clark, A., et al. (2022). Unified Scaling Laws for Routed Language Models. arXiv:2202.01169
- Gao, L., et al. (2020). The Pile: An 800GB Dataset of Diverse Text for Language Modeling. arXiv:2101.00027

## Figure Insights

- Figure 1 (Approaches Overlaid): Compares three strategies—scaling parameters,
  data, and compute—for reducing loss; motivates compute-optimal tradeoffs.
- Figure 3 (IsoFLOP Curves): Shows performance vs parameter count for fixed
  compute budgets, revealing optimal model sizes per budget.
- Table 2 (Scaling Coefficients): Reports α, β exponents for loss vs N and D,
  underpinning the Chinchilla N∝D prescription.
