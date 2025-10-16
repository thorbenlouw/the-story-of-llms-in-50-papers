# Emergent Abilities of Large Language Models

**Authors**: Jason Wei, Yi Tay, Rishi Bommasani, Colin Raffel, Barret Zoph, Sebastian Borgeaud, Dani Yogatama, Maarten Bosma, Denny Zhou, Donald Metzler, Ed H. Chi, Tatsunori Hashimoto, Oriol Vinyals, Percy Liang, Jeff Dean, William Fedus

**Venue**: Transactions on Machine Learning Research (TMLR), August 2022

**arXiv**: [2206.07682](https://arxiv.org/abs/2206.07682)

## TL;DR

- **Emergent abilities** are capabilities that appear suddenly in large language models at certain scale thresholds but are not present in smaller models, defying prediction by extrapolation from small-scale performance.
- The paper documents dozens of emergent abilities across multiple model families (GPT-3, LaMDA, Gopher, Chinchilla, PaLM) spanning few-shot prompting tasks and augmented prompting strategies like chain-of-thought reasoning and instruction following.
- Emergence manifests as a **phase transition**: performance remains near-random until reaching a critical scale (typically 10²²-10²⁴ FLOPs or 10B-100B+ parameters), after which it jumps sharply to substantially above random.
- While cross-entropy loss improves smoothly with scale, discrete metrics like accuracy and exact match can mask gradual improvements, contributing to the apparent discontinuity of emergence.
- The unpredictability of emergent abilities raises fundamental questions about future capabilities, safety risks, and whether further scaling will unlock additional unforeseen abilities.

## 1. Problem and Motivation

The prevailing understanding of language model scaling has been shaped by **scaling laws**, which predict smooth, power-law improvements in performance as models grow larger (Kaplan et al., 2020; Hoffmann et al., 2022). These laws have successfully characterized how cross-entropy loss decreases predictably across seven orders of magnitude of compute. However, this picture of smooth improvement is incomplete.

For certain downstream tasks, performance does not improve continuously with scale. Instead, smaller models perform at essentially random levels, showing no meaningful capability, until suddenly—at some threshold scale—performance jumps dramatically to well above random. This **discontinuous** behavior cannot be predicted by simply extrapolating trends from smaller models, creating a fundamental gap in our understanding of what capabilities will emerge as we build ever-larger systems.

The motivation for studying emergent abilities is threefold. First, **scientific understanding**: if we cannot predict when or why abilities emerge, we lack a complete theory of language model capabilities. Second, **practical planning**: researchers and practitioners need to understand what investments in scale will unlock which capabilities. Third, **safety**: if beneficial abilities emerge unpredictably, so too might harmful ones, making it critical to characterize emergence patterns.

The stakes are particularly high given the rapid pace of scaling. GPT-3 (175B parameters) was considered massive in 2020, yet by 2022, PaLM reached 540B parameters—roughly 8× the training compute of GPT-3. Understanding emergence helps us reason about what these frontier models can and cannot do.

## 2. Core Idea and Contributions

Wei et al. define an **emergent ability** formally: "An ability is emergent if it is not present in smaller models but is present in larger models" (§2). This definition captures abilities that cannot be predicted by extrapolating a scaling law from smaller systems. When plotted on a scaling curve (x-axis: model scale, y-axis: performance), emergent abilities exhibit a characteristic pattern: performance is near-random until a certain critical threshold, after which it increases to substantially above random. This qualitative change is also known as a **phase transition**—a dramatic shift in behavior that could not have been foreseen from smaller-scale observations.

The paper's core contributions are:

1. **Systematic documentation** of emergent abilities across five major model families (GPT-3, LaMDA, Gopher, Chinchilla, PaLM), demonstrating that emergence is not an artifact of a single model or training setup.

2. **Categorization** of emergent abilities into two classes: (a) **few-shot prompted tasks** where models perform tasks given only a natural language description and a few examples, and (b) **augmented prompting strategies** like chain-of-thought reasoning or instruction following that only help when models reach sufficient scale.

3. **Analysis** of BIG-Bench (a suite of 200+ tasks) to identify which types of tasks are more likely to exhibit emergence versus smooth scaling, revealing that analogical reasoning, word sense disambiguation, truthfulness, social reasoning, and emotional understanding have high emergence rates.

4. **Alternative perspectives** on emergence, showing how abilities can be viewed as functions of WikiText103 perplexity (a measure of language modeling quality) rather than just compute or parameters, though these metrics remain highly correlated.

5. **Critical examination** of potential explanations, including the role of evaluation metrics (showing that cross-entropy loss improves smoothly even when discrete metrics show phase transitions) and factors beyond scale (data quality, architecture choices).

## 3. Method

The authors do not train new models but instead conduct a **meta-analysis** of existing large language models and their published evaluations. Their methodology involves:

**Model selection**: They analyze dense Transformer language models spanning several orders of magnitude in scale, from models with millions of parameters to PaLM's 540 billion. The key model families are GPT-3 (Brown et al., 2020), LaMDA (Thoppilan et al., 2022), Gopher and Chinchilla (Rae et al., 2021; Hoffmann et al., 2022), PaLM (Chowdhery et al., 2022), and Anthropic's models.

**Scale measurement**: The primary x-axis for scaling curves is **training FLOPs** (floating-point operations), which accounts for both model size and training duration. They also plot results using **number of parameters** and **WikiText103 perplexity** to show emergence from multiple perspectives. Training FLOPs and parameters are highly correlated for dense models since most families scale these proportionally.

**Task selection**: The authors focus on tasks from BIG-Bench (a collaborative benchmark of 200+ diverse tasks) and established benchmarks like MMLU (57-topic multitask understanding), TruthfulQA (adversarial truthfulness), and WiC (word sense disambiguation). Tasks are selected to span reasoning, knowledge, language understanding, and specialized skills.

**Emergence identification**: A task is classified as emergent if it shows near-random performance (close to the random baseline for that task) until a certain model scale, after which performance jumps significantly above random. Two co-authors manually agreed on which tasks met this criterion for transparency.

**Cross-entropy analysis**: To investigate whether emergence is an artifact of discrete evaluation metrics (accuracy, exact match, BLEU), the authors re-analyze six emergent BIG-Bench tasks using cross-entropy loss, which gives partial credit for probability distributions closer to the target even when the discrete metric shows random performance.

The analysis also examines **augmented prompting strategies**—techniques like chain-of-thought prompting (Wei et al., 2022b) or instruction finetuning (Wei et al., 2022a)—to identify when these methods transition from ineffective or harmful to beneficial as model scale increases.

## 4. Comparison to Prior Work

1. **Scaling Laws (Kaplan et al., 2020; Hoffmann et al., 2022)**: Prior scaling laws documented smooth, predictable power-law improvements in cross-entropy loss spanning seven orders of magnitude. In contrast, emergent abilities show **discontinuous jumps** in task-specific metrics (accuracy, exact match) that cannot be predicted by extrapolating from smaller models. While cross-entropy may improve smoothly, the practical capabilities measured by downstream metrics exhibit phase transitions.

2. **GPT-3's Architecture Explanations (Brown et al., 2020)**: When GPT-3 failed to achieve above-random performance on the Word in Context (WiC) benchmark even at 175B parameters, Brown et al. speculated this might require bidirectional architectures rather than autoregressive ones. However, **PaLM (Chowdhery et al., 2022) later achieved above-random WiC performance by simply scaling the same decoder-only architecture to 540B parameters** (2.5×10²⁴ FLOPs). This demonstrates that scale can overcome perceived architectural limitations, and premature conclusions about impossibility can be invalidated by further scaling.

3. **Evaluation Metric Studies**: Prior work used discrete metrics (accuracy, exact match) without analyzing how continuous metrics like cross-entropy loss behave on the same tasks. This paper shows that **cross-entropy loss improves smoothly even when downstream metrics appear emergent**, revealing that models are gradually improving in ways masked by all-or-nothing evaluation. However, this doesn't fully explain emergence, as the question remains: why do models suddenly cross the threshold where discrete outputs become predominantly correct?

## 5. Results and What They Mean

**Few-shot prompting emergence** (Figure 2, Table 1): The paper documents eight prominent examples of emergent few-shot abilities:

- **BIG-Bench arithmetic** (3-digit addition/subtraction, 2-digit multiplication): GPT-3 and LaMDA have near-zero accuracy until 2×10²² FLOPs (13B parameters for GPT-3), then jump sharply above random.
- **MMLU benchmark** (57 knowledge topics): GPT-3, Gopher, and Chinchilla perform at random until ~10²² FLOPs (10B parameters), then substantially surpass random at 3-5×10²³ FLOPs (70B-280B parameters). This suggests **knowledge-based question-answering** spanning diverse topics requires crossing this threshold for dense models without retrieval.
- **TruthfulQA** (adversarial truthfulness): GPT-3 never exceeds random even at 175B parameters (adversarially curated against it), but Gopher 280B (5×10²³ FLOPs) emerges to >20% above random, showing model-family-specific emergence.
- **Word in Context (WiC)**: Both GPT-3 175B and Chinchilla 70B fail, but PaLM 540B (2.5×10²⁴ FLOPs) succeeds, demonstrating that even very large models may require further scaling for certain semantic understanding tasks.

**Augmented prompting emergence** (Figure 3): Specialized techniques also emerge:

- **Chain-of-thought prompting** (math word problems): Prompting models to show intermediate reasoning steps only outperforms standard prompting when scaled to ~10²³ FLOPs (100B parameters). Smaller models don't benefit from or are hurt by generating reasoning chains.
- **Instruction following** (FLAN): Finetuning on instruction-phrased tasks actually **degrades** performance for models ≤7×10²¹ FLOPs (8B parameters) but substantially improves performance at 10²³ FLOPs (100B parameters). This shows that not all techniques are universally beneficial—some require scale to be effective.
- **Scratchpad for computation** (8-digit addition): Finetuning models to predict intermediate outputs helps only for models ≥9×10¹⁹ FLOPs (40M parameters), demonstrating emergence at much smaller scale for structured computation tasks.

**What these results mean**:

1. **Unpredictability**: There is currently no way to predict which abilities will emerge or at what scale without expensive experiments at that scale.
2. **Scale as a capability threshold**: Many complex abilities simply do not exist below certain compute budgets, implying hard minimums for deployment goals.
3. **Task heterogeneity**: Different tasks emerge at wildly different scales (40M to 540B parameters), suggesting diverse underlying mechanisms.
4. **Risk of premature conclusions**: Assuming a capability is impossible because current models fail is risky; further scaling might unlock it.

## 6. Limitations and Failure Modes

The paper acknowledges several critical limitations:

1. **Lack of predictive theory**: While emergence is well-documented empirically, the authors cannot explain **why** specific abilities emerge at specific scales or **which** future abilities will emerge. This unpredictability limits planning and safety analysis.

2. **Evaluation metric artifacts**: The apparent discontinuity of emergence may be partially explained by discrete metrics (exact match, accuracy) that give no partial credit. The cross-entropy analysis shows models gradually improve even when these metrics suggest random performance. However, this doesn't fully explain emergence, as the discrete metrics still transition sharply.

3. **Computational barriers**: Discovering emergence requires training models at massive scale, which costs millions of dollars and is infeasible for most researchers. This limits who can contribute to understanding emergence and may lead to blind spots.

4. **No guarantee of success**: An ability might emerge and then **plateau** before reaching desired performance levels. Alternatively, some abilities may **never emerge** if they require knowledge far outside the training distribution.

5. **Emergent risks**: Just as beneficial abilities emerge unpredictably, so might harmful ones. The paper cites examples where bias, toxicity, and memorization can increase with scale, and notes that future models might exhibit unforeseen dangerous behaviors (backdoor vulnerabilities, deception, harmful content synthesis).

6. **Scale is not the only factor**: Data quality, architecture, and training procedures also matter. PaLM 62B outperforms larger GPT-3 175B and LaMDA 137B on 14 BIG-Bench tasks despite fewer parameters and less compute, likely due to better training data and architectural improvements. This means emergence thresholds are not immutable properties of tasks.

7. **Sociological challenges**: The shift toward general-purpose models creates new research dynamics, with capabilities concentrated in well-resourced organizations and reproducibility challenges for the broader community.

## 7. Fit to This Course (Week 7: Instruction Tuning and Generalization)

This paper is **foundational** to Week 7's focus on instruction tuning and generalization, as it provides the empirical basis for understanding when and why language models develop emergent capabilities:

**Emergent abilities and in-context learning**: The paper documents that few-shot prompting—the ability to perform tasks given only natural language instructions and a few examples—is itself an emergent ability. Models below ~10²²-10²³ FLOPs often cannot leverage in-context examples effectively, performing at random. This directly motivates the shift to instruction tuning: if base few-shot abilities are emergent, instruction tuning (covered in FLAN, Paper 1 this week) attempts to lower the threshold for instruction-following via targeted finetuning.

**Connection to FLAN**: The paper explicitly discusses **instruction following as an emergent ability** (§4, Figure 3B). Wei et al. (2022a) found that instruction finetuning hurts models ≤8B parameters but helps at ≥68B parameters. This finding is directly relevant to understanding FLAN's design choices and why instruction tuning became viable only with sufficiently large models. It also explains why later work on smaller encoder-decoder models (Sanh et al., 2022) required different architectures to achieve similar effects at lower scale.

**Evaluation frameworks (HELM/BIG-bench)**: Week 7 introduces holistic evaluation frameworks. The **BIG-Bench benchmark** (200+ tasks) featured extensively in this paper is central to understanding emergent abilities. The paper's analysis categorizes which BIG-Bench tasks are emergent, smoothly scaling, or flat (no model better than random), providing a taxonomy for evaluation. Understanding emergence is critical for interpreting scores on comprehensive benchmarks like HELM and BIG-bench: a low score might indicate a capability hasn't emerged yet rather than fundamental impossibility.

**Task generalization**: The paper shows that models develop the ability to generalize to unseen tasks (like MMLU's diverse topics or BIG-Bench's novel challenges) only above certain scale thresholds. This emergence of **generalization ability itself** explains why instruction tuning became a productive research direction: only at sufficient scale do models have the latent capability to follow instructions for arbitrary tasks.

**Multimodality introduction**: The paper briefly touches on multimodal emergence (§5.5), noting that multimodal models like Flamingo 80B achieve few-shot state-of-the-art on visual QA benchmarks, suggesting emergence extends beyond text. This previews Week 7's multimodality discussion.

**Lab implications**: For the Week 7 lab comparing models on HELM/BIG-bench categories, this paper provides essential context: differences between models might reflect whether certain abilities have emerged, not just smooth capability gradients. When running mini-evaluations, students should look for phase-transition patterns that might indicate emergence thresholds.

## 8. Discussion Questions

1. **Predictability and Planning**: If emergent abilities cannot be predicted by extrapolating from smaller models, how should research labs and companies plan their scaling investments? What early indicators might suggest an ability is close to emerging, even if we can't predict the exact threshold?

2. **Evaluation Metric Design**: The paper shows that cross-entropy loss improves smoothly while accuracy/exact-match show phase transitions. Should we design new evaluation metrics that give partial credit and might reveal smoother scaling curves? Or do discrete metrics capture something fundamentally important about usable capabilities? How does this relate to the HELM evaluation framework's approach?

3. **Emergent Risks vs. Emergent Capabilities**: The paper notes that harmful behaviors (bias, toxicity, memorization) can also emerge with scale, and future risks might be unpredictable. How should the field balance the pursuit of emergent capabilities with the mitigation of emergent risks? Should there be scale thresholds that trigger mandatory safety evaluations?

4. **Alternative Paths to Emergence**: The paper shows that PaLM 62B outperforms larger GPT-3 and LaMDA models on some tasks, suggesting data quality and architecture matter as much as scale. If we could reliably lower emergence thresholds through better training, how would this change the field's focus on ever-larger models? What are the trade-offs between "brute force scaling" and "efficient emergence"?

5. **Generalization Theory**: The paper documents emergence but offers limited mechanistic explanations. Drawing on your understanding of transformer architectures and the other papers this week, what hypotheses might explain why certain abilities require specific model depths, widths, or parameter counts? For instance, why might multi-step reasoning emerge only above 100B parameters while 8-digit addition emerges at 40M parameters?

## 9. Glossary

1. **Emergent ability**: A capability that is not present in smaller language models but appears in larger models, exhibiting a phase transition rather than smooth scaling. Cannot be predicted by extrapolating performance from small-scale systems.

2. **Phase transition**: A dramatic, discontinuous change in system behavior at a critical threshold. In language models, performance jumps from near-random to substantially above random at a certain scale.

3. **Few-shot prompting**: The ability to perform a task given only a natural language instruction and a small number (typically 0-5) of input-output examples, without gradient updates or finetuning. Popularized by GPT-3 (Brown et al., 2020).

4. **Training FLOPs**: Floating-point operations used during model training, accounting for both model size and number of training steps. A common measure of computational scale that combines parameters and training duration.

5. **Chain-of-thought prompting**: A prompting strategy where models generate intermediate reasoning steps before producing a final answer, enabling multi-step reasoning. Only effective above certain scale thresholds (~100B parameters).

6. **BIG-Bench**: Beyond the Imitation Game Benchmark—a collaborative suite of over 200 diverse tasks designed to probe language model capabilities across reasoning, knowledge, language understanding, and other dimensions.

7. **MMLU** (Massive Multitask Language Understanding): A benchmark aggregating 57 test datasets spanning humanities, STEM, social sciences, and other domains, requiring broad knowledge and reasoning to perform well.

8. **Instruction following**: The ability of a model to perform tasks described in natural language instructions without task-specific training. Can be improved via instruction tuning (finetuning on instruction-phrased datasets like FLAN).

9. **Cross-entropy loss**: A continuous metric measuring the difference between predicted and actual probability distributions. Unlike discrete metrics (accuracy, exact match), gives partial credit for predictions closer to ground truth.

10. **Scaling laws**: Empirical power-law relationships describing how model performance (typically cross-entropy loss) improves predictably with increases in compute, parameters, or data. Established by Kaplan et al. (2020) and refined by Hoffmann et al. (2022).

11. **WikiText103 perplexity**: A measure of how well a language model predicts held-out text from Wikipedia. Lower perplexity indicates better language modeling. Highly correlated with training compute for standard dense transformers.

12. **Task generalization**: The ability to perform well on tasks not explicitly included in training, often via few-shot prompting or instruction following. A key emergent ability enabling general-purpose language models.

## References

- Brown, T., Mann, B., Ryder, N., et al. (2020). Language models are few-shot learners. *NeurIPS*.
- Chowdhery, A., Narang, S., Devlin, J., et al. (2022). PaLM: Scaling language modeling with Pathways. *arXiv:2204.02311*.
- Hoffmann, J., Borgeaud, S., Mensch, A., et al. (2022). Training compute-optimal large language models. *arXiv:2203.15556*.
- Kaplan, J., McCandlish, S., Henighan, T., et al. (2020). Scaling laws for neural language models. *arXiv:2001.08361*.
- Rae, J. W., Borgeaud, S., Cai, T., et al. (2021). Scaling language models: Methods, analysis & insights from training Gopher. *arXiv:2112.11446*.
- Thoppilan, R., De Freitas, D., Hall, J., et al. (2022). LaMDA: Language models for dialog applications. *arXiv:2201.08239*.
- Wei, J., Bosma, M., Zhao, V. Y., et al. (2022a). Finetuned language models are zero-shot learners. *ICLR*. (FLAN paper)
- Wei, J., Wang, X., Schuurmans, D., et al. (2022b). Chain of thought prompting elicits reasoning in large language models. *NeurIPS*.