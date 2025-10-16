# T5: Exploring the Limits of Transfer Learning with a Unified Text-to-Text Transformer
## Raffel et al., 2019

### Key Contributions
1. Text-to-text framework - unified approach for all NLP tasks
2. C4 dataset - Colossal Clean Crawled Corpus (750GB cleaned Common Crawl)
3. Systematic study comparing architectures, objectives, datasets, training strategies
4. T5 models achieving SOTA on many benchmarks (up to 11B parameters)
5. Span corruption pre-training objective

### Method Sketch
- Cast all tasks as text-to-text (input text → output text)
- Encoder-decoder Transformer architecture
- Pre-train on denoising objective (mask/corrupt spans, predict them)
- Fine-tune on individual downstream tasks
- Task-specific text prefixes (e.g., "translate English to German:")

### Prior Work Contrast
1. vs BERT: Uses encoder-decoder not encoder-only; text-to-text not classification
2. vs GPT: Uses encoder-decoder not decoder-only; can handle seq2seq tasks
3. vs multi-task approaches: More systematic study of mixing strategies

### Notable Results
- GLUE: 90.3 average (SOTA at time)
- SuperGLUE: 88.9 (near human performance of 89.8)
- SQuAD: 91.26 EM (beat previous SOTA)
- Encoder-decoder with denoising beats language modeling
- Scaling helps significantly (11B >> 3B >> Base)

### Limitations
- English-only pre-training limits translation performance
- Large models expensive to deploy
- Needs ~1 trillion tokens for best results
- Not SOTA on WMT translation tasks