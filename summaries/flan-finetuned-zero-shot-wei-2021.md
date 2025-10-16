# Finetuned Language Models are Zero-Shot Learners (FLAN)

**Authors**: Jason Wei, Maarten Bosma, Vincent Y. Zhao, Kelvin Guu, Adams Wei Yu, Brian Lester, Nan Du, Andrew M. Dai, and Quoc V. Le  
**Venue**: ICLR 2022  
**Year**: 2021  
**arXiv**: [2109.01652](https://arxiv.org/abs/2109.01652)

---

## TL;DR

- **Instruction tuning** improves zero-shot performance by finetuning language models on a diverse collection of tasks described via natural language instructions
- FLAN (Finetuned Language Net), a 137B-parameter instruction-tuned model, substantially outperforms untuned models and beats zero-shot GPT-3 175B on 20 of 25 evaluated datasets
- The method works by training on 62 datasets across 12 task clusters with multiple instruction templates per dataset, then evaluating on held-out task types
- Instruction tuning benefits only emerge at sufficient scale (≥68B parameters); smaller models actually perform worse after instruction tuning
- The approach combines advantages of pretrain-finetune and prompting paradigms, making large language models more accessible through natural instruction-following
- Ablation studies reveal that task diversity, model scale, and natural language instructions are all crucial to success

---

## 1. Problem and Motivation

Language models at scale demonstrate remarkable few-shot learning capabilities when provided with exemplars, but their zero-shot performance—using only task instructions without examples—remains far weaker. GPT-3, for instance, shows significant performance degradation on tasks like reading comprehension, question answering, and natural language inference when exemplars are removed. This limitation stems from a fundamental mismatch: without examples, it's harder for models to map instruction-formatted prompts to patterns resembling their pretraining data.

This zero-shot weakness poses a practical barrier. Few-shot learning requires users to carefully select and format exemplars, demanding both technical expertise and access to labeled examples. For many real-world applications, particularly those serving non-technical users or handling novel tasks, a model that can respond directly to natural language instructions would be far more accessible and useful.

The central question driving FLAN is deceptively simple: **Can finetuning a language model on diverse tasks described via instructions improve its ability to follow instructions on completely unseen task types?** If so, this would suggest that instruction-following is a learnable skill that generalizes across task boundaries, much like how pretraining on diverse text enables transfer to downstream tasks.

---

## 2. Core Idea and Contributions

FLAN introduces **instruction tuning**: finetuning pretrained language models on a mixture of tasks where each is phrased as responding to a natural language instruction. Rather than training separate models for each task (the traditional pretrain-finetune paradigm) or relying solely on prompting (the GPT-3 approach), instruction tuning teaches a single model to respond to instructions across many task types.

The key methodological innovation lies in the evaluation strategy. Wei et al. group datasets into **12 task clusters** based on task type (e.g., natural language inference, reading comprehension, translation). When evaluating on a particular cluster, they ensure that **no datasets from that cluster appeared during instruction tuning**—a stricter definition of zero-shot than simply using held-out datasets. For example, when testing FLAN's natural language inference capabilities, no NLI datasets at all were seen during training; the model learned from translation, sentiment analysis, question answering, and other task types instead.

The paper's main contributions include:

1. **Empirical demonstration** that instruction tuning substantially improves zero-shot performance at scale (137B parameters)
2. **Comprehensive evaluation** showing FLAN outperforms zero-shot GPT-3 175B on 20 of 25 datasets and even surpasses few-shot GPT-3 on several challenging benchmarks
3. **Ablation studies** revealing that benefits emerge only with sufficient model scale, task diversity, and natural language instructions
4. **Evidence** that instruction tuning is compatible with and enhances other methods like few-shot prompting and prompt tuning

---

## 3. Method

FLAN builds on **LaMDA-PT**, a 137B-parameter decoder-only transformer pretrained on 2.49 trillion BPE tokens from web documents, dialog data, and Wikipedia. The base model uses a 32,000-token vocabulary and processes sequences up to 1,024 tokens.

### Instruction Tuning Procedure

The authors aggregate **62 publicly available datasets** spanning 12 task clusters: natural language inference (7 datasets), reading comprehension (5), closed-book QA (3), commonsense reasoning (4), sentiment analysis (4), paraphrase detection (4), coreference resolution (3), translation (8 language pairs), summarization (11), structured data-to-text (4), reading comprehension with commonsense (2), and miscellaneous tasks (7).

For each dataset, researchers manually compose **10 unique instruction templates** using natural language. For instance, a natural language inference template might ask: "Does [premise] mean that [hypothesis]?" rather than formatting it as sentence completion. To increase diversity, some templates "turn the task around" (e.g., for sentiment classification, generating movie reviews instead of classifying them).

The training process mixes all datasets, randomly selecting one of the ten templates for each example. To prevent large datasets from dominating, examples per dataset are capped at 30,000, using examples-proportional mixing with a maximum rate of 3,000. The model trains for 30,000 gradient steps with a batch size of 8,192 tokens, using the Adafactor optimizer with a learning rate of 3×10⁻⁵. Packing combines multiple examples into single sequences, separated by special tokens.

### Handling Classification Tasks

A crucial technical detail addresses classification outputs. Since FLAN is a generative model, it naturally produces free text, but classification requires selecting from specific options. Wei et al. append an **"OPTIONS"** suffix listing the valid choices (e.g., "OPTIONS: - yes - no"). This constrains the model's response space and dramatically improves classification performance compared to unconstrained rank classification.

### Evaluation Strategy

For each task cluster, the team trains a separate checkpoint excluding all datasets from that cluster. Evaluation reports both the mean performance across all instruction templates and the best performance using the template that scored highest on the development set. This dual reporting acknowledges that while prompt engineering can improve results, the average across templates better represents expected performance with typical instructions.

---

## 4. Comparison to Prior Work

FLAN relates to but differs substantially from three key paradigms:

1. **vs. GPT-3 prompting**: GPT-3 prompts are carefully engineered to resemble pretraining data continuations (e.g., formatting questions as if they appear in a test with an answer key). FLAN instead uses natural instructions one might give a human ("Translate this to Spanish:" or "Is this review positive?"). Without instruction tuning, such natural prompts yield near-zero performance on the base model; GPT-3 prompts remain necessary for the untuned LaMDA-PT baseline.

2. **vs. T5-style multitask learning**: While T5 and similar work use multitask finetuning, they typically evaluate on the same tasks seen during training or unseen domains of seen task types. FLAN's evaluation is stricter: entire task categories are held out. Testing on natural language inference means **zero NLI datasets** appeared in training—the model must generalize from fundamentally different task types.

3. **vs. traditional supervised finetuning**: Standard pretrain-finetune creates task-specific models. FLAN demonstrates that a single instruction-tuned model can zero-shot many tasks, positioning it between pure prompting (no finetuning) and traditional task-specific finetuning.

---

## 5. Results and What They Mean

FLAN demonstrates substantial improvements over both the untuned LaMDA-PT base model and zero-shot GPT-3 175B across diverse task types:

**Strong performance on instruction-amenable tasks**: On natural language inference, FLAN achieves 56.2% accuracy (averaged across ANLI R1-R3, CB, RTE) compared to GPT-3's 42.9%, a 13.3-point improvement. Reading comprehension shows similar gains (+4.8 points), and closed-book QA improves by 6.8 points. These tasks naturally align with instruction-following: "Does X entail Y?" or "Answer this question about the world."

**Surpassing few-shot GPT-3**: Remarkably, zero-shot FLAN outperforms **few-shot** GPT-3 on several challenging datasets including ANLI, RTE, BoolQ, AI2-ARC, OpenbookQA, and StoryCloze. This suggests that instruction tuning provides a different form of task adaptation than in-context learning from examples.

**Limitations on language modeling tasks**: Instruction tuning shows minimal benefit for tasks that closely resemble the pretraining objective, such as sentence completion for commonsense reasoning or coreference resolution. On these seven tasks, FLAN outperforms the base model on only three. When the task is fundamentally "predict the next token" and instructions would be redundant, instruction tuning doesn't help.

**Task diversity matters**: Ablation studies (Section 4.1) reveal that performance improves roughly linearly as more task clusters are added to instruction tuning, from 49.9% with one cluster to 63.5% with seven clusters, without showing saturation. This suggests even broader task coverage could yield further gains.

**Scale is crucial**: Perhaps most striking, instruction tuning only helps models at or above 68B parameters (Section 4.2, Figure 7). For the 8B model and smaller, instruction tuning actually **hurts** zero-shot performance on held-out tasks, likely because the model's entire capacity is consumed learning the ~40 training tasks, leaving no room for generalization. Only at 68B+ do models gain sufficient capacity to both learn the instruction-tuning tasks and develop general instruction-following capabilities.

---

## 6. Limitations and Failure Modes

The paper candidly acknowledges several limitations:

**Task coverage**: Instruction tuning doesn't help with language modeling tasks where instructions are redundant. Commonsense reasoning formatted as sentence completion sees little benefit because the task already matches the pretraining objective.

**Context limitations**: The 1,024-token context window prevents evaluation on most summarization datasets, which typically require longer inputs. This constraint limits FLAN's applicability to document-level tasks.

**Language coverage**: The pretraining corpus is ~90% English, with only ~10% non-English text not specifically curated for machine translation. While FLAN performs respectably on translating into English, translation from English into other languages is weaker, likely due to the English-centric tokenizer and training data.

**Simple task failures**: The paper shows failure examples (Appendix F, Figure 22) where FLAN fails surprisingly simple tasks like "return the second word in this sentence" or mistakenly translates a question when asked to answer it in another language. These failures suggest brittleness in how instructions are interpreted.

**Subjectivity in clustering**: Task cluster definitions involve judgment calls. While the authors follow established categorizations, the choice of which datasets belong to which cluster could influence results.

**Training data contamination**: Like GPT-3, FLAN's massive pretraining corpus (2.49T tokens) creates potential for test set contamination. The paper includes extensive contamination analysis (Appendix C), generally finding minimal impact except for PIQA and ReCoRD, which are marked with asterisks.

---

## 7. Fit to This Course (Week 7: Instruction Tuning and Generalization)

FLAN represents a pivotal moment in the evolution of large language models, directly addressing Week 7's focus on **instruction tuning and generalization**. The paper introduces the core paradigm that would influence subsequent work including InstructGPT, T0, and the broader push toward instruction-following models.

### Connection to Key Topics

**The shift to instruction-following**: FLAN demonstrates that natural language instructions can replace carefully engineered prompts, making LLMs more accessible. Rather than requiring users to understand how to format inputs to resemble pretraining data, instruction tuning enables models to respond to straightforward commands.

**Task generalization via instruction tuning**: The paper's methodological rigor in holding out entire task clusters provides strong evidence that instruction-following generalizes across task boundaries. This isn't merely transfer learning within a task type, but evidence that "following instructions" is itself a learnable metalevel skill.

**Emergent abilities and scale**: The finding that instruction tuning only helps at ≥68B parameters connects to Week 7's discussion of emergent abilities. Instruction-following appears to be an emergent capability that manifests only at sufficient scale, similar to other complex reasoning abilities.

**Evaluation frameworks**: While FLAN predates HELM and BIG-bench, the paper's comprehensive evaluation across 25 datasets with multiple metrics anticipates the need for holistic evaluation frameworks discussed in Week 7. The careful attention to task diversity and held-out evaluation methodology influenced later benchmark design.

### Lab Connections

The Week 7 lab involves "mini-eval comparing two open models on 3-5 HELM/BIG-bench categories." FLAN's evaluation methodology—testing across diverse task types, reporting both average and best-template performance, and using held-out task clusters—provides a template for rigorous model comparison. The paper's ablation studies (varying task clusters, model scale, instruction formats) also model the kind of systematic experimentation valuable in understanding model capabilities.

FLAN's release of instruction-tuning code at `github.com/google-research/flan` makes it a practical reference for implementing instruction tuning, though the 137B scale makes direct replication challenging for most course labs.

---

## 8. Discussion Questions

1. **Scale dependence**: Why might instruction tuning hurt smaller models (<8B parameters) while helping larger ones (≥68B)? What does this reveal about the relationship between model capacity, task learning, and generalization?

2. **Task boundaries**: FLAN defines "unseen tasks" as entire task clusters held out during training. How might results differ with a looser definition (e.g., just held-out datasets)? Does the stricter definition better or worse reflect real-world deployment scenarios?

3. **Instruction redundancy**: The paper finds instruction tuning doesn't help language modeling tasks where "instructions are largely redundant." Can you think of other task types where instruction tuning might not help, and why?

4. **Template diversity**: Ablation studies show that adding more templates per dataset has minimal effect compared to adding more task types. Why might task diversity matter more than prompt diversity? What implications does this have for data collection strategies?

5. **FLAN vs. InstructGPT**: FLAN uses supervised instruction tuning while InstructGPT adds RLHF. What are the tradeoffs between these approaches? In what scenarios might pure instruction tuning be preferable to RLHF, and vice versa?

---

## 9. Glossary

**Instruction tuning**: Finetuning a language model on a diverse collection of tasks where each task is phrased as following a natural language instruction; the method introduced by this paper to improve zero-shot task generalization.

**Zero-shot learning**: Evaluating a model on tasks it has never seen during training, relying only on instructions or task descriptions without any exemplars.

**Few-shot learning**: Providing a model with a small number of examples (typically 1-10) in the prompt to help it understand the task before generating a response.

**Task cluster**: A group of datasets representing the same fundamental task type (e.g., all natural language inference datasets form one cluster); used in FLAN to ensure truly unseen task evaluation.

**OPTIONS suffix**: A technique appending "OPTIONS:" followed by valid answer choices to classification prompts, constraining the model's output space and improving classification performance.

**Examples-proportional mixing**: A data mixing strategy that samples from datasets proportionally to their size, with caps to prevent large datasets from dominating; FLAN uses a 30k example cap and 3k maximum mixing rate.

**Rank classification**: An evaluation approach where, given multiple answer choices, the model assigns probabilities to each and selects the highest; used by GPT-3 but supplemented in FLAN with the OPTIONS suffix.

**Template**: A specific phrasing of how to present a task as an instruction; FLAN uses 10 templates per dataset to increase diversity and reduce overfitting to particular phrasings.

**Task generalization**: The ability of a model to perform well on task types not seen during training, going beyond domain adaptation to true cross-task transfer.

**Prompt tuning**: An adaptation method using learnable continuous vectors prepended to inputs; FLAN shows instruction tuning improves prompt tuning effectiveness (Section 4.5).

**LaMDA-PT**: Language Model for Dialogue Applications - Pretrained; the 137B-parameter base model used for FLAN, trained on 2.49T tokens before instruction tuning.

**Instruction-following**: The capability of responding appropriately to natural language instructions without requiring carefully engineered prompts or few-shot examples; the core ability developed by instruction tuning.

---

## References

Wei, J., Bosma, M., Zhao, V. Y., Guu, K., Yu, A. W., Lester, B., Du, N., Dai, A. M., & Le, Q. V. (2022). Finetuned Language Models are Zero-Shot Learners. In *Proceedings of the International Conference on Learning Representations (ICLR)*. arXiv:2109.01652.

Brown, T., Mann, B., Ryder, N., Subbiah, M., Kaplan, J. D., Dhariwal, P., ... & Amodei, D. (2020). Language models are few-shot learners. In *Advances in Neural Information Processing Systems*, 33, 1877-1901.

Raffel, C., Shazeer, N., Roberts, A., Lee, K., Narang, S., Matena, M., ... & Liu, P. J. (2020). Exploring the limits of transfer learning with a unified text-to-text transformer. *Journal of Machine Learning Research*, 21(140), 1-67.

Ouyang, L., Wu, J., Jiang, X., Almeida, D., Wainwright, C., Mishkin, P., ... & Lowe, R. (2022). Training language models to follow instructions with human feedback. *Advances in Neural Information Processing Systems*, 35, 27730-27744.

Sanh, V., Webson, A., Raffel, C., Bach, S. H., Sutawika, L., Alyafeai, Z., ... & Rush, A. M. (2021). Multitask prompted training enables zero-shot task generalization. *arXiv preprint arXiv:2110.08207*.