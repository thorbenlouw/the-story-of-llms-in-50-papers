# On the Dangers of Stochastic Parrots: Can Language Models Be Too Big?

**Authors:** Emily M. Bender, Timnit Gebru, Angelina McMillan-Major, and Shmargaret Shmitchell  
**Venue:** FAccT '21 (Conference on Fairness, Accountability, and Transparency), March 2021  
**DOI:** https://doi.org/10.1145/3442188.3445922  
**PDF:** [llm_papers_syllabus/Dangers_of_Stochastic_Parrots_Bias_Bender_2021.pdf](llm_papers_syllabus/Dangers_of_Stochastic_Parrots_Bias_Bender_2021.pdf)

---

## TL;DR

- **Critical examination of the trend toward ever-larger language models** (BERT, GPT-2/3, Switch-C) and the "bigger is better" assumption that dominated NLP in 2018-2021, asking whether sufficient thought has been given to potential risks.
- **Identifies four major categories of risk**: environmental costs that disproportionately harm marginalized communities; unfathomable training data that encodes hegemonic biases; misdirected research effort away from meaning-based approaches; and real-world harms from synthetic yet seemingly coherent text.
- **Introduces the "stochastic parrot" metaphor** for language models that "haphazardly stitch together sequences of linguistic forms" based on statistical patterns without reference to meaning, communicative intent, or accountability.
- **Advocates for value-sensitive design and careful curation** over scale, recommending documentation frameworks (datasheets, model cards), stakeholder engagement, pre-mortems, and investing in datasets sized to what can be thoroughly documented.
- **Emphasizes environmental and social justice**: large LM development has climate impacts and financial barriers that exclude marginalized populations globally, while reinforcing biases that harm those same communities most acutely.

---

## Problem and Motivation

By 2020-2021, the field of NLP had witnessed an explosion in language model size, from BERT's 340M parameters (2018) to GPT-3's 175B parameters and Switch-C's 1.6T parameters (see Table 1, p.2). This "race to scale" was driven by empirical findings that larger models with more training data achieved better performance on benchmarks like GLUE, SQuAD, and others. The prevailing narrative suggested that progress in language technology depended on creating ever larger models trained on ever larger datasets scraped from the Internet.

However, Bender et al. argue that **the field had not sufficiently considered the costs and risks** associated with this trajectory. While investigating properties of large LMs held scientific interest, the authors ask whether enough thought had been given to:
- **Environmental and financial costs** of training models requiring enormous compute resources
- **Documentation debt** from using massive, uncurated web-scraped datasets
- **Opportunity costs** of pouring research effort into scaling rather than alternative approaches
- **Real-world harms** when synthetic text from biased models enters circulation

The motivation is to step back from the momentum toward ever-larger models and critically assess whether this path serves the goals of language technology and the public it purports to serve, particularly marginalized communities who bear the greatest risks.

---

## Core Idea and Contributions

The paper's central argument is that **language models, no matter how large, are "stochastic parrots"**—systems that generate fluent-seeming text by stitching together statistical patterns from training data, without genuine language understanding, communicative intent, or grounding in meaning (Section 6.1). This metaphor captures three key properties:

1. **No semantic grounding**: LMs predict linguistic form given surrounding form, never accessing actual meaning or world models
2. **No communicative intent**: Unlike human language use (which involves shared context, mental state modeling, and accountability), LM output has no author with intentions or responsibility
3. **Human tendency to impute meaning**: Humans are predisposed to interpret language as meaningful, leading to an "illusion" of comprehension when encountering fluent synthetic text

Building on this foundation, the paper makes four major contributions:

**1. Environmental Cost Analysis (Section 3)**  
Training a Transformer with neural architecture search emits an estimated 284 tonnes of CO₂ (compared to 5 tonnes per year for an average human; p.3, citing Strubell et al. 2019). These costs disproportionately harm marginalized communities through environmental racism, while benefits accrue primarily to privileged populations who can afford devices and speak well-supported languages. The authors argue environmental impact should be a **first consideration**, not an afterthought.

**2. Critique of Unfathomable Training Data (Section 4)**  
Web-scale datasets like Common Crawl appear diverse but actually **overrepresent hegemonic viewpoints** through multiple filters: who has Internet access (younger users, developed countries), who participates on platforms like Reddit (67% male, 64% ages 18-29 in U.S.; p.4), whose voices persist despite harassment, and whose content survives filtering. Filtering "bad words" to remove toxicity inadvertently suppresses LGBTQ discourse (e.g., removing pages containing "twink"; p.5). The result: models encode stereotypes and biases harmful to marginalized groups.

**3. Misdirection of Research Effort (Section 5)**  
Large LMs achieve high scores on NLU benchmarks not through understanding but by exploiting spurious correlations. The field risks "going down the garden path" by allocating effort to beating benchmarks with scale rather than building systems that genuinely capture meaning. As Karen Spärck Jones argued, LMs commit us to epistemological assumptions (noisy-channel models, atheoretical "convenient technology," or invalid statistical relationships) that don't advance language understanding (p.7).

**4. Real-World Harms from Synthetic Text (Section 6)**  
When fluent-seeming but meaningless text enters circulation, harms include: (a) amplifying biases and stereotypes, causing psychological harm and reinforcing discrimination; (b) generating overtly abusive language; (c) enabling malicious actors to flood recruitment forums or social media with extremist content; (d) misleading users of machine translation when errors are masked by fluency; and (e) exposing personally identifiable information memorized during training.

---

## Method (Approach and Key Arguments)

This is a **critical analysis paper** rather than an empirical study. The authors synthesize evidence from multiple domains:

- **Environmental science and justice**: Carbon emissions data, documentation of climate impacts on marginalized communities (e.g., Maldives, Sudan flooding)
- **Computational analysis**: Model size trends (Table 1), training data composition studies (Reddit demographics, GPT-2 data analysis showing 272K unreliable news documents)
- **Linguistics and communication theory**: Theories of meaning, common ground, communicative intent (Clark, de Saussure)
- **Social movement scholarship**: How language changes faster than models can retrain (Black Lives Matter's influence on Wikipedia; Section 4.2)
- **Bias and fairness literature**: Evidence of stereotyping in BERT/GPT models, intersectional biases, toxicity in generated text

The argumentative structure moves systematically through risk categories, using concrete examples (e.g., Palestinian man arrested after MT mistranslated "good morning" as "attack them"; p.9) and quantitative evidence where available. The authors acknowledge limitations of bias auditing (requires knowing what to audit for, culturally-specific metrics, dynamic social norms; Section 4.3) and argue that **prevention through curation is more effective than post-hoc detection**.

---

## Comparison to Prior Work

1. **vs. Strubell et al. (2019) on environmental costs**: Bender et al. extend the carbon footprint analysis to a **social justice framework**, explicitly connecting environmental harms to marginalized populations and questioning who benefits from large LMs. Where Strubell focused on technical metrics (CO₂, compute costs), this paper asks "Is it fair to ask Maldives residents to pay the environmental price for English LMs?" (p.3).

2. **vs. BERT (Devlin et al., 2019) and GPT-3 (Brown et al., 2020)**: These papers demonstrated impressive benchmark results and framed scale as enabling progress. Bender et al. **challenge the assumption that scale equals understanding**, arguing the successes are form manipulation rather than meaning comprehension, and questioning whether the opportunity cost is worthwhile.

3. **vs. typical bias measurement studies** (e.g., Basta et al. 2019, Hutchinson et al. 2020): Most prior work demonstrated specific biases in specific models. Bender et al. argue such demonstrations are valuable but **cannot exhaustively discover all risks** due to the need for a priori knowledge of salient categories, cultural context, and shifting social norms. They advocate for **preventative curation** rather than reactive auditing.

4. **vs. technical mitigation approaches** (knowledge distillation, quantization, etc.): The paper is less interested in making large models more efficient and more focused on questioning whether large models are the right approach at all, advocating for **values-centered design processes** that precede technical choices.

---

## Results and What They Mean

Key empirical observations include:

- **Carbon footprint**: Training Transformer with neural architecture search = 284t CO₂ vs. 5t/year for average human (p.3)
- **Demographic skews**: Reddit (GPT-2 data source): 67% male, 64% ages 18-29; Wikipedia editors: 8.8-15% women (p.4)
- **Training data quality**: GPT-2's data includes 272K documents from unreliable news sites, 63K from banned subreddits (p.6)
- **Filtering harms**: Removing pages with "bad words" disproportionately eliminates LGBTQ community discourse (p.5)

**What this means:**

1. **Environmental justice issue**: The compute required for state-of-the-art LMs imposes climate costs on populations (Global South, low-lying island nations, Indigenous communities) least likely to benefit from the technology.

2. **Representation failure**: Despite vast data scale, large web-crawled datasets **systematically underrepresent** marginalized voices through Internet access disparities, platform moderation that silences harassment targets, and filtering approaches that remove reclaimed slurs or LGBTQ terminology.

3. **Bias amplification**: Models don't just passively reflect training data biases—they can **amplify** them, and their fluent output makes biased content more likely to be taken seriously and propagated.

4. **Research misdirection**: High benchmark scores from large LMs may be **misleading indicators of progress** toward genuine language understanding, potentially directing resources away from more fundamental approaches.

---

## Limitations and Failure Modes

The authors acknowledge several limitations of their analysis:

1. **Auditing limitations**: Exhaustive bias testing is impossible because it requires knowing which social categories are salient (which varies by culture), having appropriate metrics for each context, and keeping pace with changing social norms (Section 4.3, p.6-7).

2. **Static vs. dynamic language**: Large LMs trained on snapshots of web data struggle to capture evolving framings from social movements (e.g., Black Lives Matter's influence on Wikipedia coverage; Section 4.2, p.5-6). Retraining is computationally expensive, and fine-tuning may not adequately capture contested meanings.

3. **No technical silver bullet**: The paper doesn't propose a complete technical solution to identified problems. While advocating for curation and documentation, the authors acknowledge this requires **resource allocation** and may limit dataset size, potentially reducing performance on some tasks.

4. **Beneficial uses**: The paper gives limited attention to cases where large LMs genuinely help marginalized communities (brief discussion of ASR for Deaf/hard-of-hearing people in Section 7, p.10, with important caveats). The focus on risks might overshadow legitimate benefits.

5. **Dual-use dilemma**: The paper recognizes but doesn't fully resolve scenarios where LMs enable both harms (e.g., as stochastic parrots) and benefits (e.g., within ASR pipelines). The proposed watermarking and policy approaches (p.10) remain speculative.

**Failure modes** identified include:
- **Value lock**: Deploying LMs with outdated norms "reifies older, less-inclusive understandings" (p.5)
- **Documentation debt**: Creating datasets "too large to document post hoc" (p.6)
- **Automation bias**: Humans over-trusting fluent synthetic text (Section 6)
- **Amplification loops**: LM-generated content entering future training data, compounding biases

---

## Fit to This Course (Extension Track B: Ethics, Bias, and Alignment Principles)

This paper serves as the **Bias/Ethics Foundation** for Extension Track B, examining the origins and consequences of bias in training data and the ethical implications of massive-scale language modeling. It connects to the course in several ways:

**Core themes:**
- **Environmental and social costs** of LM development, introducing environmental justice perspectives often absent from technical ML discourse
- **Data bias and hegemonic viewpoints**: How Internet data overrepresents privileged populations and marginalizes others through access, participation, and filtering
- **Value-sensitive design**: Proposing frameworks (datasheets, model cards, stakeholder engagement, pre-mortems) to center human values and potential harms before technical development

**Connections to other Extension Track B papers:**
- **vs. StereoSet (Nadeem et al., 2020)**: While StereoSet provides a benchmark for measuring bias, Stochastic Parrots argues such measurements are incomplete and advocates preventative curation
- **vs. The Alignment Problem (Amodei et al., 2016)**: Both papers emphasize challenges of aligning AI systems with human values, though Amodei focuses on technical safety while Bender et al. emphasize social context and power structures
- **vs. Constitutional AI (Bai et al., 2022)**: Constitutional AI offers a technical approach to alignment; Stochastic Parrots argues we need broader process-oriented changes (documentation, stakeholder engagement) alongside technical solutions

**Connections to main syllabus:**
- Provides critical context for understanding **instruction tuning** (Week 7): Are we teaching models to follow instructions or just to mimic instruction-following form?
- Informs **RLHF and DPO** (Weeks 8-9): Whose preferences are captured? How do we avoid encoding existing power imbalances?
- Challenges assumptions in **scaling laws** (Week 4): Is bigger always better, or does scale introduce new risks?

**Pedagogical value:**
This paper encourages students to think beyond technical metrics (perplexity, accuracy) to consider:
- **Who benefits and who bears costs** of technology development
- **What assumptions** are embedded in data collection and model design
- **How to incorporate values** into the research process itself, not just as post-hoc evaluation

---

## Discussion Questions

1. **Environmental trade-offs**: The paper argues environmental costs should be a "first consideration" when developing large LMs. How should researchers balance potential benefits (e.g., improved accessibility tools for disabled users) against environmental harms that disproportionately affect marginalized populations? Are there cases where large compute expenditures are justified?

2. **Curation vs. scale dilemma**: If thorough data curation limits dataset size (due to resource constraints), and smaller datasets may reduce performance on some benchmarks, how should the field navigate this trade-off? Can we develop effective language technology for low-resource languages without terabytes of data?

3. **The "stochastic parrot" metaphor**: Do you find the paper's central metaphor persuasive? Are there cases where large LMs demonstrate capabilities that go beyond "haphazardly stitching together" statistical patterns? How would you distinguish genuine understanding from sophisticated form manipulation?

4. **Bias auditing limitations**: The paper argues exhaustive bias testing is impossible because salient social categories are culture-bound and language evolves faster than models can retrain (Sections 4.2-4.3). If comprehensive auditing is infeasible, what practical steps can researchers take to identify and mitigate harms before deployment?

5. **Value-sensitive design in practice**: The authors propose frameworks like pre-mortems, stakeholder engagement, and value scenarios. Imagine you're developing a large LM for a specific application (e.g., medical documentation, customer service, educational tutoring). How would you identify relevant stakeholders? What values would you try to operationalize, and how would you measure whether your system supports those values?

---

## Glossary

**Stochastic Parrot**: A system that generates text by probabilistically combining linguistic forms from training data without access to meaning, communicative intent, or grounding in the world. The paper's central metaphor for large language models.

**Hegemonic Viewpoint**: The dominant or mainstream perspective in a society, often reflecting the views of those in positions of power and privilege. Web-scraped training data tends to overrepresent hegemonic views.

**Documentation Debt**: A situation where datasets are both undocumented and too large to document after creation, making it impossible to understand or mitigate their characteristics. Analogous to technical debt in software engineering.

**Value Lock**: When a system reifies (makes concrete and unchangeable) older social norms or less-inclusive understandings because it was trained on historical data and cannot adapt to evolving language and values.

**Environmental Racism**: The disproportionate impact of environmental hazards (including climate change) on marginalized communities, particularly communities of color and low-income populations.

**Value-Sensitive Design**: A design methodology that accounts for human values throughout the technology development process, using techniques like stakeholder analysis, envisioning cards, and value scenarios to surface potential harms early.

**Pre-mortem**: A planning exercise where team members imagine a project has failed and reverse-engineer potential causes, encouraging consideration of risks and alternatives before committing to a course of action.

**Natural Language Understanding (NLU)**: Genuine comprehension of meaning, as opposed to manipulating linguistic form. The paper argues LMs don't perform NLU despite high benchmark scores.

**Common Ground**: In communication theory, the shared knowledge, beliefs, and context between speakers that enables interpretation of implicit meaning. LMs lack common ground with human users.

**Datasheets for Datasets**: A documentation framework (Gebru et al. 2018) that provides standardized information about dataset motivation, composition, collection process, preprocessing, uses, and maintenance.

**Model Cards**: A documentation framework (Mitchell et al. 2019) that describes a model's intended uses, performance characteristics across different demographic groups, and ethical considerations.

**Spurious Correlations**: Statistical patterns in data that don't reflect genuine causal relationships or semantic understanding. LMs may exploit spurious cues to achieve benchmark success without understanding.

---

## References

Bender, E. M., & Koller, A. (2020). Climbing towards NLU: On meaning, form, and understanding in the age of data. *ACL 2020*.

Gebru, T., Morgenstern, J., Vecchione, B., Vaughan, J. W., Wallach, H., Daumé III, H., & Crawford, K. (2020). Datasheets for datasets. *arXiv:1803.09010*.

Mitchell, M., Wu, S., Zaldivar, A., Barnes, P., Vasserman, L., Hutchinson, B., ... & Gebru, T. (2019). Model cards for model reporting. *FAccT 2019*.

Strubell, E., Ganesh, A., & McCallum, A. (2019). Energy and policy considerations for deep learning in NLP. *ACL 2019*.