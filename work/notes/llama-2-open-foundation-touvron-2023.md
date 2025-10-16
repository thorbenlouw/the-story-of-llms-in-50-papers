# LLaMA 2: Open Foundation and Fine-Tuned Chat Models - Notes

## Paper Metadata
- **Title**: Llama 2: Open Foundation and Fine-Tuned Chat Models
- **Authors**: Hugo Touvron et al. (Meta AI)
- **Year**: 2023
- **arXiv**: 2307.09288
- **Week**: 5 - Mixture-of-Experts Architectures
- **Context**: Modern scaling and data curriculum

## Key Outline (10-12 bullets)

1. **Open release philosophy**: Meta releases both pretrained Llama 2 (7B, 13B, 70B) and fine-tuned Llama 2-Chat models for commercial and research use
2. **Pretraining improvements**: 40% more training data (2T tokens), doubled context length (4k), grouped-query attention (GQA) for inference efficiency
3. **Data quality over quantity**: Used only ~27,540 high-quality SFT examples instead of millions, showing quality beats scale
4. **Iterative RLHF process**: 5 versions (V1-V5) combining rejection sampling and PPO, with weekly data collection batches
5. **Dual reward models**: Separate helpfulness and safety reward models to address inherent tension between the two objectives
6. **Ghost Attention (GAtt)**: Novel technique to maintain multi-turn consistency by synthetically concatenating system instructions
7. **Safety-first approach**: Comprehensive safety tuning with adversarial prompts, red teaming (350+ people), and context distillation
8. **Human evaluation results**: Llama 2-Chat 70B competitive with ChatGPT on helpfulness, outperforms open-source models significantly
9. **Scaling data curriculum**: Progressive annotation difficulty, with later batches having harder prompts and more complex multi-turn dialogues
10. **Truthfulness and safety metrics**: Major improvements over Llama 1 - 50.18→64.14% truthfulness, 24.60→0.01% toxicity for 70B
11. **Emergent capabilities**: Model shows temporal awareness and zero-shot tool use despite no explicit training
12. **Responsible release**: Detailed documentation, acceptable use policy, red teaming results, and responsible use guide

## Key Contributions
- Open release of state-of-the-art chat models
- Detailed methodology for fine-tuning and safety alignment
- Novel techniques: GAtt, margin-based reward modeling
- Comprehensive safety evaluation and mitigation strategies
- Evidence that RLHF can exceed human annotation quality

## Method Highlights
- **Pretraining**: 2T tokens, RMSNorm, SwiGLU, RoPE, GQA for larger models
- **SFT**: Quality over quantity - 27,540 examples with careful curation
- **Reward Modeling**: Binary ranking loss with preference-rating margin, separate safety/helpfulness models
- **RLHF**: Rejection sampling (K outputs, select best) + PPO, iterative updates
- **Safety**: Adversarial prompts, safety auxiliary loss, context distillation with preprompts

## Prior Work Contrasts
1. **vs Llama 1**: 40% more data, 2x context, GQA, much better safety alignment
2. **vs GPT-3/ChatGPT**: Comparable performance while being open-source, detailed methodology
3. **vs Chinchilla scaling**: Continues training beyond compute-optimal for better downstream performance
4. **vs Constitutional AI**: Uses both human feedback and targeted safety preprompts

## Key Results
- **Benchmarks**: 68.9 MMLU (70B), competitive with closed-source on many tasks
- **Human eval**: 36% win rate vs ChatGPT (70B model), 60%+ vs open-source models
- **Safety**: Effectively 0% toxic generations after fine-tuning, low violation rates
- **Reward model accuracy**: Well-calibrated with human preferences, improves with scale

## Limitations
- English-centric (89.7% of pretraining data)
- Knowledge cutoff (September 2022 for pretraining)
- May refuse some benign prompts (false refusals increase with safety data)
- Conservative responses on some prompts due to safety tuning
- Not suitable for all use cases without additional tuning

## Course Fit (Week 5)
- Demonstrates modern scaling approaches beyond pure MoE
- Shows data curriculum and quality matter more than raw scale
- GQA represents efficiency innovation (related to MoE efficiency themes)
- Illustrates production-ready system with multiple design tradeoffs
- Connects to broader Phase II themes of efficiency and scaling