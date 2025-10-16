
# HELM: Holistic Evaluation of Language Models

**Authors:** Percy Liang, Rishi Bommasani, Tony Lee, Dimitris Tsipras, Dilara Soylu, Michihiro Yasunaga, and 50+ additional authors  
**Institution:** Stanford Center for Research on Foundation Models (CRFM)  
**Venue:** Transactions on Machine Learning Research (TMLR), August 2023  
**arXiv:** [2211.09110](https://arxiv.org/abs/2211.09110) (November 2022)

---

## TL;DR

- HELM introduces a systematic, top-down approach to language model evaluation: first taxonomize all scenarios (task × domain × language) and metrics (desiderata), then deliberately select a representative subset, making gaps and priorities explicit
- Evaluates 30 prominent language models under standardized conditions (same scenarios, same metrics, same 5-shot prompting) across 16 core scenarios and 26 targeted evaluations, achieving 96% coverage vs. 17.9% before HELM
- Measures 7 desiderata for each scenario (accuracy, calibration, robustness, fairness, bias, toxicity, efficiency) in a multi-metric approach that foregrounds societal considerations alongside performance, computing 87.5% of possible scenario × metric pairs
- Reveals that instruction-tuned models (text-davinci-002, Anthropic-LM v4-s3) dramatically outperform larger non-instruction-tuned models; model scale >50B parameters forms an accuracy tier but instruction-tuning proves more efficient than pure scaling
- Exposes systematic performance disparities across demographics (African American English performs consistently worse than White English), extreme prompting sensitivity (30-80% accuracy swings from formatting changes), and strong correlations between accuracy, robustness, and fairness under perturbation-based measurement
- Provides public website with all model predictions, prompts, and an extensible open-source codebase designed as a living benchmark that the community can continuously update with new scenarios, metrics, and models

---

## 1. Problem and Motivation

Language models have become foundational to nearly all language technologies, yet their capabilities, limitations, and risks remain poorly understood. Evaluation practices prior to HELM were fragmented and inadequate in three critical ways. First, different models were evaluated on different scenarios under different conditions—some prominent models like T5 (11B) and Anthropic-LM v4-s3 (52B) shared not a single evaluation scenario in their original works, making direct comparison impossible. Second, evaluation overwhelmingly centered on accuracy, relegating other crucial desiderata like fairness, robustness, and toxicity to separate specialized benchmarks (if measured at all). Third, adaptation procedures varied widely even for nominally identical scenarios—some models evaluated via fine-tuning, others via 0-shot prompting, still others via 5-shot prompting, making results incomparable.

As language models rapidly proliferate in deployment—powering search engines, chatbots, code assistants, and content moderation systems—this evaluation crisis poses serious risks. Without transparent, comprehensive understanding of model behavior across multiple dimensions, we cannot make informed decisions about which models to deploy where, cannot anticipate failures, and cannot track whether progress in accuracy comes at the cost of fairness or other societal concerns.

## 2. Core Idea and Contributions

HELM addresses these challenges through **holistic evaluation** built on three foundational principles. First, **broad coverage with recognition of incompleteness**: rather than collecting arbitrary datasets, HELM taxonomizes the entire space of potential scenarios (structured as task × domain × language triples) and metrics (structured as desiderata), then systematically selects from this space based on coverage and feasibility. Critically, this taxonomy makes explicit what is missing—HELM acknowledges gaps in non-English languages, certain domains, and specific metrics. Second, **multi-metric measurement**: HELM evaluates 7 categories of metrics (accuracy, calibration, robustness, fairness, bias, toxicity, efficiency) for each scenario rather than treating accuracy as sufficient, exposing tradeoffs and ensuring societal considerations aren't "second-class citizens." Third, **standardization**: all 30 models are evaluated on the same scenarios using the same metrics under the same 5-shot prompting conditions, enabling direct head-to-head comparison.

The benchmark comprises 16 core scenarios covering user-facing tasks (question answering, information retrieval, summarization, sentiment analysis, toxicity detection, miscellaneous classification) measured across all 7 metrics (87.5% coverage of the 112 possible pairs), plus 26 targeted evaluation scenarios providing deeper analysis of specific capabilities (language understanding, knowledge, reasoning) and risks (memorization/copyright, disinformation, fine-grained bias and toxicity). This massive evaluation—4,939 runs totaling 12.2 billion tokens, $38,001 in API costs, and 19,500 GPU hours—standardizes what was previously chaotic, evaluating models from 12 organizations spanning open (GPT-NeoX, OPT, BLOOM), limited-access (GPT-3, Cohere, J1), and closed (Anthropic-LM, TNLG) accessibility tiers.

## 3. Method

HELM's methodology centers on four conceptual primitives clearly defined in Section 2. A **scenario** specifies what we want models to do, operationalized as a list of instances where each instance contains an input (string) and references (strings with evaluation-relevant properties). An **adaptation** procedure transforms a raw language model into a system that makes predictions—HELM uses 5-shot prompting exclusively, with training examples fixed across all test instances to better reflect realistic few-shot conditions. **Metrics** determine how well the model performs by computing scores over model completions and probabilities. The evaluation itself is a collection of runs, each defined by a (scenario, adaptation, metric) triple.

For **scenarios**, HELM taxonomizes tasks by consulting ACL 2022 conference tracks (Table 1), then prioritizes user-facing tasks where progress confers direct social utility. Domains are decomposed via "3 Ws": *what* (genre—Wikipedia, news, social media), *when* (time period—pre-Internet, 2018, present), and *who* (demographic—gender, race, nationality). This structured approach enables systematic selection ensuring coverage of tasks and domains independently rather than requiring exhaustive (task × domain) combinations.

For **metrics**, HELM taxonomizes desiderata by surveying major AI conference tracks (Table 2), identifying accuracy, bias, fairness, robustness, toxicity, calibration, efficiency, and many others. Selection focuses on desiderata measurable given blackbox-only model access without assumptions about model construction. Perturbation-based approaches enable scalable measurement: robustness uses invariance perturbations (typos, misspellings via NL-Augmenter) and equivariance perturbations (human-authored Contrast Sets); fairness uses counterfactual perturbations (dialect, gender, race substitutions) and performance disparity measurement when demographic metadata exists.

**Adaptation via 5-shot prompting** follows specific conventions (Section 7, Appendix J). In-context examples are selected via class-coverage sampling (representing the 5 most frequent classes) then fixed across all test instances, with 3 random seeds measuring variance. For multiple-choice scenarios, HELM supports three methods: *joint* (all choices presented together, model predicts A/B/C/D), *separate* (each choice scored independently), and *separate-calibrated* (separate method calibrated by standalone choice probability). Temperature = 0 for short-answer scenarios, higher for generation scenarios. Stop sequences prevent runaway generation.

The **priority system** (Appendix H) enables adaptive evaluation under budget constraints, assigning each scenario a priority (1-4, where 1 is highest) to support scaled-down evaluations when necessary.

## 4. Comparison to Prior Work

HELM differs from predecessors in three fundamental ways:

1. **Single score vs. score vector vs. score matrix.** Traditional benchmarks like ImageNet assign one score (accuracy). Meta-benchmarks like SuperGLUE and the EleutherAI LM Harness assign a
score vector (accuracy per dataset). HELM assigns a score *matrix*—for each scenario, models receive scores across all 7 desiderata, exposing tradeoffs that single-metric evaluation masks (Figure 3, Figure 24).

2. **Bottom-up dataset collection vs. top-down taxonomy.** Prior benchmarks collected datasets opportunistically (e.g., BIG-Bench's collaborative 208 tasks). HELM starts by taxonomizing the evaluation space, then selects systematically to maximize coverage while making explicit what's missing (Section 10). This top-down approach clarifies both aspiration and implementation.

3. **Evaluation standardization.** Figure 4 starkly illustrates the pre-HELM landscape: several core scenarios had zero models evaluated on them; HellaSwag had many but under wildly varying conditions (fine-tuned accuracy for T5, few-shot for GPT-3, different numbers of shots). HELM evaluates all 30 models on the same 16 core scenarios using identical 5-shot prompting, making head-to-head comparison valid for the first time.

Additionally, where datasets like RealToxicityPrompts or BBQ exist in isolation, HELM integrates them into both core scenarios (measuring toxicity/bias in realistic use cases) and targeted evaluations (deep-diving specific risks), connecting abstract capabilities to concrete harms.

## 5. Results and What They Mean

HELM's 4,939 evaluation runs surface 25 top-level findings documented in Section 1.2. The most consequential insights cluster around four themes:

**Instruction-tuning as a breakthrough.** text-davinci-002 emerges as the most accurate model across virtually all scenarios, winning head-to-head comparisons more than 90% of the time (Figure 26). Critically, Anthropic-LM v4-s3 (52B)—more than 10× smaller than TNLG v2 (530B)—ranks consistently in the top 3 for accuracy, robustness, and fairness. Both are the only instruction-tuned models evaluated. This suggests instruction-tuning and human feedback provide broad advantages far more efficiently than pure parameter scaling (Finding 1, Finding 25).

**Model accessibility and the capability gap.** Comparing open models (GPT-NeoX, OPT, BLOOM) against limited-access (GPT-3 variants, Cohere) and closed models (TNLG, Anthropic-LM), Figure 28 reveals a consistent accuracy gap favoring limited-access models. However, the gap has narrowed: open models released in 2021-2022 are often within 5 points of the best non-open models for most scenarios, with notable exceptions on knowledge-intensive tasks (MMLU, NaturalQuestions closed-book, TruthfulQA). This gap's evolution over time matters for tracking power dynamics and accessibility in foundation model development (Finding 2).

**Multi-metric relationships reveal tradeoffs and surprises.** Accuracy, robustness, and fairness show remarkably strong positive correlation (Pearson 0.75-1.0 across scenarios; Figure 25), meaning more accurate models tend to be more robust and fair under HELM's perturbation-based measurement. However, calibration relationships are scenario-dependent: improving accuracy worsens calibration for HellaSwag but improves it for OpenBookQA (Finding 3). For generative harms, bias and toxicity show weak or negative correlations, suggesting efforts to reduce one may inadvertently increase the other—T0++ ranks as most toxic but least gender-biased; davinci (175B) shows the opposite pattern (Figure 26).

**Performance disparities are pervasive and severe.** When demographic metadata exists, models consistently show worse performance for marginalized groups. For language modeling on TwitterAAE, all models perform noticeably worse on African American English: OPT (175B) achieves 1.506 bits-per-byte for White English but 2.114 for AAE—a 40% degradation (Finding 5, Section 8.4). On CivilComments toxicity detection, OPT (175B) drops from 51.3% standard accuracy to 8.8% robust accuracy on the Black split but only to 24.3% on the White split. These disparities have serious implications for equitable deployment.

**Prompting is extraordinarily brittle.** Models show shocking sensitivity to prompt design decisions. For in-context example selection, NaturalQuestions F1 scores for davinci (175B) range from 0.376 to 0.636 across three random seeds (Figure 31). For multiple-choice adaptation method, OPT (175B) achieves 79.1% accuracy on HellaSwag using the separate method but crashes to 30.2% using the joint method—while Anthropic-LM v4-s3 shows the *opposite* preference, performing best with the joint method (Finding 23, Figure 33). This raises fundamental questions about fair comparison across models and undermines claims about robust capabilities.

Targeted evaluations reveal additional insights. On **knowledge**, text-davinci-002 dramatically outperforms all others on TruthfulQA (62.0% vs. 36.2% for second-place Anthropic-LM), suggesting instruction-tuning improves factuality. On **reasoning**, code-davinci-002 excels even on natural-language reasoning tasks, achieving 52% on GSM8K vs. 16% for non-code models and 65% on synthetic natural language reasoning vs. 29% for the next-best text model (Finding 16). On **memorization**, while rare, models regurgitate verbatim sequences from popular books (Harry Potter, Dr. Seuss) at higher rates than random books, with the risk correlating with model accuracy (Finding 17). On **disinformation**, human evaluation shows text-davinci-002 and Anthropic-LM generate headlines supporting given theses effectively (quality >4.0/5.0) but struggle with targeted audience messaging (Finding 18).

## 6. Limitations and Failure Modes

HELM acknowledges limitations across three categories (Section 11). For **results**, few-shot prompting evaluations may not reflect models' potential under fine-tuning or more sophisticated adaptation; practitioners should prioritize scenario/metric subsets relevant to their specific use case. Train-test contamination remains largely unknown—while some models trained on The Pile are clearly contaminated for Pile-based scenarios (Table 13), documentation is sparse and verification impossible without training data access.

For **implementation**, validity and reliability of scenarios/metrics are assumed but not uniformly verified. Many datasets lack rigorous quality assurance; automated metrics (especially PerspectiveAPI for toxicity) have known flaws. Perturbation-based fairness measurement may overestimate disparities via simplistic lexical substitutions that don't fully capture linguistic variation.

For **design**, HELM's coverage gaps are extensive and explicitly documented (Section 10): non-English languages (Figure 10 shows 6000+ world languages but HELM evaluates only English), critical domains (biomedical, financial, educational, customer service), temporal dynamics (models can't update knowledge; no historical text evaluation), missing demographics (age, socioeconomic status, non-binary gender), and numerous desiderata requiring different access (interpretability, privacy, security). The multi-metric approach produces score matrices rather than single numbers, potentially overloading consumers and complicating decision-making—though this correctly reflects that no model strictly dominates across all scenarios and metrics.

**Prompting sensitivity** itself constitutes a failure mode: if model rankings depend critically on arbitrary formatting choices, evaluation legitimacy is compromised. The separate vs. joint adaptation controversy for multiple-choice scenarios (Finding 23) poses a "fundamental challenge for what it means to standardize language model evaluation in a fair way across models."

## 7. Fit to This Course (Week 7: Instruction Tuning and Generalization)

HELM directly addresses Week 7's core theme of **Evaluation & Benchmarking** within the broader context of instruction tuning and generalization. The paper provides the comprehensive evaluation framework needed to assess whether instruction-tuned models (FLAN, InstructGPT) truly generalize better, and demonstrates empirically that they do—text-davinci-002 and Anthropic-LM v4-s3's dominance across diverse scenarios validates that instruction-tuning confers broad generalization.

The **holistic evaluation framework** exemplified by HELM is essential infrastructure for the Week 7 lab: "Mini-eval comparing two open models on 3–5 HELM/BIG-bench categories; report accuracy + calibration notes." Students gain practical experience implementing HELM's multi-metric approach, learning to measure beyond accuracy. The emphasis on **calibration** (ECE-10, selective classification) ties directly to understanding when models can be trusted—critical for deploying instruction-tuned models in real applications.

HELM's findings on **task generalization via instruction-tuning** provide empirical grounding for Week 7 concepts. The paper shows instruction-tuned models excel across 16 diverse core scenarios (question answering, summarization, sentiment analysis, etc.) unlike base models that require scenario-specific fine-tuning. This validates the instruction-tuning paradigm introduced in FLAN (Wei et al., 2021), where training on diverse tasks with instructions enables zero-shot generalization to held-out tasks.

The **multi-metric measurement** philosophy—that accuracy alone is insufficient—aligns with responsible AI deployment concerns central to the instruction-tuning era. As models become more capable and widely deployed, understanding their fairness, robustness, and potential for generating harmful content becomes paramount. HELM's finding that the most accurate models on BBQ (text-davinci-002, T0++) also show the strongest bias in ambiguous contexts (Finding 19) demonstrates why holistic evaluation matters: optimizing solely for accuracy can exacerbate social harms.

Finally, HELM's **living benchmark** design anticipates the rapid evolution of language models. The extensible codebase and public website enable the community to continuously add scenarios, metrics, and models—essential as new capabilities emerge and new risks are discovered. This positions evaluation as an ongoing process rather than a fixed checkpoint, appropriate for the fast-moving field of LLMs.

## 8. Discussion Questions

1. **Tradeoff analysis:** HELM finds strong positive correlation between accuracy, robustness, and fairness under perturbation-based measurement, contradicting some prior work showing accuracy-fairness tradeoffs. What might explain this discrepancy? Could perturbation-based fairness measurement systematically miss certain types of unfairness that manifest in other evaluation paradigms?

2. **Aggregation challenge:** HELM produces a score matrix (scenarios × metrics) rather than a single number per model, complicating model comparison. Should the community develop standard aggregation methods (e.g., weighted sums with stakeholder-specified weights), or does pursuing a single number inevitably obscure important tradeoffs? How might you design an aggregation scheme for the Week 7 lab evaluation?

3. **Instruction-tuning efficiency:** Anthropic-LM v4-s3 (52B) rivals or exceeds TNLG v2 (530B) despite being 10× smaller, suggesting instruction-tuning is more efficient than pure scaling. However, instruction-tuning requires human feedback data, which has its own costs and potential biases. How should we compare the resource investment in gathering human feedback vs. training larger models? Which approach is more sustainable long-term?

4. **Prompting brittleness:** HELM reveals wild accuracy swings (30-80%) from formatting changes and that the optimal adaptation method for multiple-choice scenarios differs across models (OPT prefers separate, Anthropic-LM prefers joint). What does this brittleness imply for claims about "emergent abilities" and model robustness? Should evaluation standards specify exact prompts, or should models be expected to work across prompt variations?

5. **Evaluation scope and values:** HELM explicitly prioritizes user-facing tasks and acknowledges this excludes important capabilities (e.g., syntactic parsing, NLI). The choice of which scenarios and metrics to include encodes values about what matters. If you were designing an evaluation benchmark for deployed LLMs in educational settings, which HELM scenarios would you prioritize and which new scenarios would you add? How would you determine metric priorities?

## 9. Glossary

- **Holistic Evaluation:** Approach combining (1) broad scenario/metric coverage with explicit recognition of gaps, (2) multi-metric measurement to represent plural societal values, and (3) standardized evaluation conditions enabling valid model comparison
- **Scenario:** Operationalization of a use case as a list of instances, where each instance contains an input (string) and references (strings with evaluation properties); structured as task × domain × language triples
- **Adaptation:** Procedure transforming a language model into a system making predictions on test instances; HELM uses 5-shot prompting with fixed in-context examples
- **Multi-metric Measurement:** Evaluating multiple desiderata (accuracy, calibration, robustness, fairness, bias, toxicity, efficiency) for each scenario rather than accuracy alone, exposing tradeoffs and ensuring societal considerations aren't neglected
- **Expected Calibration Error (ECE):** Metric quantifying whether a model's predicted probabilities align with actual correctness rates; measures confidence calibration by binning predictions and comparing average probability to fraction correct per bin
- **Robustness (Invariance):** Model stability under semantics-preserving perturbations (typos, misspellings, contractions); measured as worst-case performance across perturbations of each instance
- **Fairness (Counterfactual):** Model behavior on counterfactual data generated by perturbing demographic attributes (dialect, gender, race); measured as worst-case accuracy across demographic perturbations
- **Performance Disparity:** Difference in model accuracy across demographic subgroups when metadata exists (e.g., accuracy on comments mentioning Black vs. White individuals); complements perturbation-based fairness
- **Demographic Representation Bias:** Unevenness in rates that different demographic groups are mentioned in model generations; measured via total variation distance from uniform distribution over gender/race terms
- **Stereotypical Association Bias:** Unevenness in rates that demographic groups co-occur with stereotyped terms (professions) in generations; measured as TVD from uniform for each profession, averaged across professions
- **Separate vs. Joint Adaptation:** For multiple-choice scenarios, *separate* scores each choice independently (possibly calibrated by standalone probability); *joint* presents all choices together with model predicting choice letter
- **Living Benchmark:** Evaluation framework designed for continuous community-driven updates with new scenarios, metrics, models, and adaptation methods as technology and social concerns evolve

## 10. References

- Liang, P., Bommasani, R., Lee, T., et al. (2022). Holistic Evaluation of Language Models. *Transactions on Machine Learning Research*, August 2023. arXiv:2211.09110
- Related evaluation frameworks: SuperGLUE (Wang et al., 2019), EleutherAI LM Harness (Gao et al., 2021), BIG-Bench (Srivastava et al., 2022)
- Perturbation methods: NL-Augmenter (Dhole et al., 2021), Contrast Sets (Gardner et al., 2020)
- Bias measurement: Bolukbasi et al. (2016), Garg et al. (2018), BBQ (Parrish et al., 2022)
- Models evaluated include: GPT-3 (Brown et al., 2020), InstructGPT (Ouyang et al., 2022), T5/T0++ (Raffel et al., 2019; Sanh et al., 2021), OPT (Zhang et al., 2022), BLOOM (Scao et al., 2022), and many others documented in Table 5

## Figure Insights

- Figure 2 (Taxonomy Structure): Overview of scenarios (task × domain × language)
  capturing breadth of user-facing use cases.
- Figure 3 (Multi-Metric Approach): Visualizes the accuracy/robustness/fairness
  matrix and the rationale for multi-dimensional reporting.
- Figure 4 (Standardization Before/After): Demonstrates variance reduction via
  standardized prompts, contexts, and evaluation harness.
- Figures 24–26 (Inter-Metric Relationships): Correlation plots between metrics
  suggesting where improvements co-occur or trade off.
- Figure 28 (Accessibility Gap): Shows compute/data accessibility disparities
  across model families and implications for reproducible evaluation.
- Figure 31 (Prompting Variance): Quantifies sensitivity to prompt format and
  adaptation method choices.
- Figure 33 (Adaptation Sensitivity): Compares separate vs joint choice formats
  and calibration strategies for multiple-choice scenarios.
