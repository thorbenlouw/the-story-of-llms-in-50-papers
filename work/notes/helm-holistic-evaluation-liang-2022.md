# Notes: HELM - Holistic Evaluation of Language Models (Liang et al., 2022)

## Paper Metadata
- **Title:** Holistic Evaluation of Language Models
- **Authors:** Percy Liang, Rishi Bommasani, Tony Lee, Dimitris Tsipras, Dilara Soylu, Michihiro Yasunaga, and many others (50+ authors)
- **Institution:** Stanford Center for Research on Foundation Models (CRFM)
- **Venue:** Transactions on Machine Learning Research (TMLR), August 2023
- **arXiv:** 2211.09110v2
- **Date:** November 2022 (arXiv), August 2023 (published)

## Course Context (Week 7)
- **Section:** Instruction Tuning and Generalization (Phase III)
- **Key Topics:** The shift to instruction-following. Task generalization via instruction-tuning (FLAN). Emergent abilities (In-context learning). Multimodality introduction. **Evaluation & Benchmarking**: Holistic evaluation frameworks and task diversity.
- **Lab:** Mini-eval comparing two open models on 3–5 HELM/BIG-bench categories; report accuracy + calibration notes.

## Outline (10-12 bullets)

1. **Problem:** Prior LM evaluation was fragmented, inconsistent, and accuracy-centric - models evaluated on different scenarios, under different conditions, with metrics beyond accuracy often relegated to separate datasets

2. **Three pillars of holistic evaluation:** (a) Broad coverage with explicit taxonomy and recognition of gaps, (b) Multi-metric measurement across 7 desiderata for each scenario, (c) Standardization - same scenarios, same metrics, same prompting conditions

3. **Core innovation:** Top-down taxonomy approach - explicitly state what to evaluate (scenarios as task×domain×language triples, metrics as desiderata) then systematically select, making gaps transparent

4. **Scenarios:** 16 core scenarios spanning 6 user-facing tasks + 26 targeted evaluation scenarios (21 new to mainstream LM evaluation). Dense multi-metric coverage: 87.5% of scenario×metric pairs measured

5. **Metrics:** 7 categories measured holistically - accuracy, calibration, robustness (invariance/equivariance), fairness (counterfactual + disparities), bias (demographic representation + stereotypes), toxicity, efficiency (training + inference)

6. **Massive evaluation:** 30 prominent LMs from 12 organizations (open, limited-access, closed), standardized via 5-shot prompting. 4,939 runs, 12B+ tokens, $38K API costs, 19.5K GPU hours

7. **Key empirical findings:** Instruction-tuning advantages (text-davinci-002 dominates), open vs. non-open accuracy gap, scenario-dependent calibration-accuracy relationships, strong accuracy-robustness-fairness correlations, performance disparities across dialects/demographics

8. **Model comparison results:** Before HELM - models evaluated on 17.9% of core scenarios on average with no standardization. After HELM - 96% coverage under standardized conditions. Clear benefits of scale >50B parameters and instruction-tuning

9. **Perturbation-based insights:** Robustness via typos/misspellings/contractions; fairness via dialect/gender/race perturbations. Worst-case performance measured. Contrast sets reveal larger drops than synthetic perturbations

10. **Prompting sensitivity:** Massive variance from in-context example selection (e.g., NaturalQuestions F1 range 0.38-0.64 for davinci), adaptation method choice critical (OPT-175B: 79% vs 30% on HellaSwag for separate vs. joint), model-specific optima

11. **Targeted evaluations:** Language (WikiText, Pile, TwitterAAE, ICE, BLiMP), Knowledge (MMLU, TruthfulQA, WikiFact), Reasoning (synthetic, GSM8K, MATH, HumanEval, legal, Dyck), Copyright/memorization, Disinformation (reiteration/wedging), fine-grained bias (BBQ), toxicity (RealToxicityPrompts, BOLD)

12. **Living benchmark philosophy:** Open source codebase, public website with all predictions/prompts, extensible framework. Explicit acknowledgment of limitations and missing coverage (languages, domains, metrics, models). Transparency via taxonomy makes gaps visible

## Key Contributions
1. **Taxonomy:** Explicit design space for scenarios (task, domain, language) and metrics (desiderata)
2. **Broad coverage:** 16 core + 26 targeted scenarios, 7 metrics measured densely
3. **Standardization:** 30 models evaluated under identical conditions
4. **Empirical findings:** 25 top-level findings about model capabilities, limitations, and tradeoffs
5. **Infrastructure:** Public website, codebase, all prompts/completions released

## Method Highlights
- **Scenarios as instances:** Each scenario = list of (input, references) pairs
- **Adaptation via prompting:** 5-shot by default, fixed examples across test instances (measuring variance across 3 random seeds)
- **Multi-metric always:** For each core scenario, measure all 7 metrics where applicable (Table 4 matrix)
- **Perturbations:** Robustness (typos, misspellings, contractions, etc.), Fairness (dialect, gender, race substitutions)
- **Targeted deep-dives:** Beyond core scenarios, 7 targeted evaluations isolate specific skills/risks

## Key Results Summary

### Top Models (Accuracy)
1. text-davinci-002 (instruction-tuned, wins 90%+ head-to-head)
2. TNLG v2 (530B)
3. Anthropic-LM v4-s3 (52B) (instruction-tuned, 10× smaller than TNLG but comparable)

### Major Findings
- **Instruction-tuning benefit:** text-davinci-002 and Anthropic-LM dominate despite latter being much smaller
- **Scale threshold:** Models >50B parameters form accuracy tier, but within tier other factors matter more
- **Open vs. limited-access gap:** Exists but open models (OPT, BLOOM) increasingly competitive (within 5 points on many scenarios)
- **Calibration:** Relationship with accuracy is scenario-dependent (improves together for OpenBookQA, trades off for HellaSwag)
- **Robustness/Fairness:** Strongly correlated with accuracy (0.75-1.0 Pearson), minimal tradeoffs observed under perturbation approach
- **Performance disparities:** Consistent worse performance for AAE vs. White English, dialect variations in ICE, demographic disparities in CivilComments
- **Bias patterns:** Most accurate models (text-davinci-002, T0++, TNLG) show biases aligning with societal stereotypes on BBQ ambiguous contexts
- **Prompting brittleness:** Wild swings (30-80% accuracy) from prompt format changes, in-context example selection

### Task-Specific Insights
- **Question Answering:** text-davinci-002 wins all 9 scenarios, largest margin on TruthfulQA (62% vs 35%)
- **Information Retrieval:** Competitive with fine-tuned neural retrievers but trails SOTA; computationally intensive
- **Summarization:** ROUGE scores low but correlate with model size; length control challenging
- **Sentiment (IMDB):** Many models >90% accuracy, but Contrast Sets reveal 8%+ drops for top models
- **Toxicity Detection:** Most models barely above chance (50-67%), severe robustness drops especially on Black split
- **Language Modeling:** Pile-trained models (GPT-NeoX, OPT) excel; clear AAE vs. White English disparities (2.1 vs 1.5 BPB for OPT-175B)
- **Reasoning:** code-davinci-002 dominates (52% on GSM8K vs 16% for others), excels even on natural language reasoning
- **Memorization:** Rare but observable; higher for popular books, code models, and more accurate models

## Comparison to Prior Work
- SuperGLUE, GLUE: Single score or score vector (accuracy only)
- EleutherAI LM Harness, BIG-bench: Collections of datasets with canonical metrics
- **HELM difference:** Score matrix (scenarios × metrics), top-down taxonomy design, explicit gap recognition, standardization across models

## Limitations and Missing
- **Missing scenarios:** Non-English languages, many domains (biomedical, financial, legal depth), temporal coverage, demographic groups
- **Missing metrics:** User experience, linguistic plausibility, provenance/credibility, interpretability
- **Missing models:** Gopher, Chinchilla, PaLM, LaMDA (at time of publication)
- **Adaptation:** Only 5-shot prompting evaluated; no fine-tuning, chain-of-thought, or other methods
- **Contamination:** Limited visibility into training data; documented evidence where available (Table 13)

## Technical Details
- **Total cost:** $38,001 API costs + 19,500 GPU hours
- **Total queries:** 17.4M queries, 12.2B tokens
- **Evaluation scale:** 4,939 runs (model × scenario combinations)
- **Metrics implementation:** ECE-10 for calibration, worst-case for robustness/fairness, TVD for bias, PerspectiveAPI for toxicity

## Relation to Course Labs
- Direct relevance to Week 7 lab: "Mini-eval comparing two open models on 3–5 HELM/BIG-bench categories"
- Provides framework for understanding multi-metric evaluation
- Demonstrates importance of standardization and calibration measurement
- Shows how to measure beyond accuracy (robustness, fairness, efficiency)

## Important Quotes/Claims to Verify
1. "Prior to HELM, models on average were evaluated on just 17.9% of the core HELM scenarios" - Section 1.1
2. "We improve this to 96.0%" - Section 1.1
3. "30 prominent language models" evaluated - Abstract
4. "87.5% of the time" for multi-metric coverage (98 of 112 possible pairs) - Abstract, Table 4
5. text-davinci-002 "62.0% accuracy on TruthfulQA compared to second place of 36.2%" - Finding 15
6. OPT-175B "1.506 bits per byte for White English to 2.114 bits per byte for African American English" - Finding 5
7. "Model scale... reliably predicts model accuracy" within family but not across families - Finding 25
8. "All models that win head-to-head... at a rate well above chance (i.e. >55%) are at least 50B parameters" - Finding 25