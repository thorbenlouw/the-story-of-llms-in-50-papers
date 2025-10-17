# Retrieval-Augmented Generation for Knowledge-Intensive NLP Tasks (Lewis et al., 2020)

Patrick Lewis, Ethan Perez, Aleksandra Piktus, Fabio Petroni, Vladimir Karpukhin, Naman Goyal,
Heinrich Küttler, Mike Lewis, Wen-tau Yih, Tim Rocktäschel, Sebastian Riedel, Douwe Kiela.
NeurIPS 2020. arXiv:2005.11401.

## TL;DR
- Combines a neural retriever (DPR) with a seq2seq generator (BART) to ground generation in
  retrieved evidence.
- Two variants: RAG-Sequence (single document for the whole output) and RAG-Token (document can
  change per token), trained end-to-end by marginalizing over top-K retrieved passages.
- Achieves state-of-the-art open-domain QA accuracy at the time, while retaining the flexibility of
  abstractive generation and stronger factuality vs parametric-only models.
- Uses a Wikipedia dense vector index (≈21M 100‑word passages) queried via MIPS/FAISS; trains the
  query encoder and generator jointly while keeping the document encoder/index fixed.
- Supports easy knowledge updates (swap or refresh the index) and provides inspectable provenance
  via retrieved passages; improves diversity and reduces hallucinations.

## Problem and Motivation
Large pre-trained language models can store factual knowledge in parameters, but struggle to update
that knowledge, provide provenance, or avoid hallucinations on knowledge-intensive tasks. Purely
retrieval-based systems (retrieve-then-extract) provide explicit evidence but lack the flexibility of
free-form generation. The core challenge is to combine parametric knowledge (for fluency and
reasoning) with non-parametric knowledge (for up-to-date, inspectable facts) in a single, general
framework that works across QA, generation, and classification.

## Core Idea and Contributions
- Retrieval-Augmented Generation (RAG): treat retrieved documents as latent variables and
  marginalize them during training and inference, enabling end-to-end learning of retriever +
  generator while conditioning generation on evidence.
- Two formulations:
  - RAG-Sequence: conditions on the same retrieved document for the entire output sequence.
  - RAG-Token: allows a different document per token, letting the model combine evidence across
    documents within a single answer.
- Practical recipe: dense passage retriever (DPR) over a Wikipedia FAISS index + BART-large
  generator; joint fine-tuning of the query encoder and generator, keeping the document encoder and
  index fixed for efficiency.
- Strong empirical results across open-domain QA, abstractive QA (MSMARCO), Jeopardy-style
  question generation, and FEVER fact verification, showing RAG’s breadth and improved factuality.
- Interpretability and maintainability: inspect retrieved evidence and refresh knowledge by updating
  the index instead of retraining the whole generator.

## Method
RAG introduces a latent document variable z for each input x and optimizes the marginal likelihood
of outputs y over the top-K documents retrieved given x. Concretely:

- Retriever p_eta(z|x): DPR bi-encoder scores passages by a dot product between a BERT-based
  query encoder q(x) and document encoder d(z). The top-K by Maximum Inner Product Search
  (MIPS) are returned via FAISS.
- Generator p_theta(y|x,z): a BART-large seq2seq model conditions on x concatenated with z,
  generating y autoregressively.
- Marginalization:
  - RAG-Sequence: uses one z for the whole sequence and sums over K candidates.
  - RAG-Token: sums over K candidates at every time step, allowing token-wise document switching.
- Training: minimize negative marginal log-likelihood over (x,y) pairs. For efficiency, the document
  encoder (and index) remains frozen; only the query encoder and generator are fine-tuned.
- Decoding:
  - RAG-Token: beam search using the mixture distribution over documents per step.
  - RAG-Sequence: either Thorough Decoding (score beams under each document and marginalize) or
    Fast Decoding (approximate by marginalizing only across beams actually produced).

Intuition: RAG marries two complementary memories. The parametric memory (BART) supplies fluent
language and priors; the non-parametric memory (Wikipedia index) anchors generation in up-to-date,
inspectable evidence. RAG-Token, by mixing documents token-wise, can stitch together facts from
multiple sources within a single coherent output.

## Comparison to Prior Work
- REALM/ORQA: Prior retrieval-augmented masked language models focus on extractive QA with
  retrieval during pretraining; RAG extends the approach to seq2seq generation and classification,
  avoiding specialized pretraining while supporting abstractive outputs.
- DPR pipelines (retrieve–re-rank–extract): RAG replaces extractive readers with a generator,
  enabling correct answers even when documents contain only clues rather than verbatim spans, and
  uses end-to-end training to align retrieval with the generator.
- Parametric-only “closed-book” models (e.g., T5/BART): RAG improves factuality and provides
  provenance, while retaining generative flexibility and diversity.

## Results and What They Mean
- Open-domain QA (NQ, TriviaQA, WebQuestions, CuratedTREC): RAG-Sequence and RAG-Token
  set new SOTA on several datasets at publication time, outperforming DPR+extractive readers and
  rivaling REALM/T5+SSM without specialized salient-span pretraining. This shows end-to-end
  retrieval-augmented generation can match or surpass retrieve-then-extract pipelines while being
  generative.
- Abstractive QA (MSMARCO NLG): RAG-Sequence improves over BART by ≈2.6 BLEU and ≈2.6
  ROUGE-L, demonstrating that retrieval helps reduce hallucinations and increase factuality even in
  purely generative settings with knowledge gaps.
- Jeopardy Question Generation: RAG-Token outperforms BART and RAG-Sequence on Q-BLEU-1;
  human evaluation favors RAG for factuality and specificity. Token-wise document mixing appears
  advantageous when outputs reference multiple facts.
- FEVER Fact Verification: While not specialized to FEVER’s evidence-pipeline, RAG achieves label
  accuracy within a few points of engineered SOTA systems—evidence that RAG’s latent-document
  marginalization suffices for classification without retrieval supervision.

Key implications:
- Factuality and diversity improve when generation is grounded in retrieved evidence.
- Provenance is inspectable by exposing top-K passages used during decoding.
- Knowledge updates require refreshing the index rather than retraining the generator, simplifying
  maintenance.

## Limitations and Failure Modes
- Retriever quality bound: If the retriever fails to surface relevant passages, generation can degrade
  or fall back to parametric guesses; dense retrievers still show recall gaps, especially outside
  Wikipedia.
- Domain shift and coverage: Wikipedia-only indexing limits coverage for some tasks (e.g., specific
  MSMARCO queries). Non-Wikipedia or multi-corpus indices are needed for production.
- Efficiency trade-offs: RAG-Sequence decoding can be computationally heavy (Thorough Decoding),
  and even Fast Decoding increases inference cost over parametric-only models.
- Attribution ambiguity: RAG-Token’s token-wise mixing complicates assigning a single passage as
  “the source” for an output, which may matter for explainability.
- End-to-end stability: Jointly tuning retriever and generator can be sensitive; many deployments
  partially freeze components and rely on careful negative sampling and index refresh cycles.

## Fit to This Course (Week: Week 11, Section: Retrieval-Augmented Generation (RAG) & Memory)
- Key Topics & Labs: The need for external memory. Architecture of RAG: Retriever (dense/sparse
  vector search) and Generator. Trade-offs between memory, context, and knowledge. Advanced
  retrieval techniques. Infrastructure, Serving, and PEFT: Efficient fine-tuning and deployment.
  Lab: Fine-tune with LoRA on a small task and serve with vLLM; measure latency vs. throughput.

How it fits:
- External memory: RAG is the canonical architecture that operationalizes external, non-parametric
  memory for LLMs; it cleanly separates facts (index) from linguistic competence (generator).
- Architecture: Exactly the course’s Retriever–Generator split using dense vector search (DPR/FAISS)
  plus a seq2seq generator (BART/T5-style).
- Trade-offs: Highlights compute/latency costs of retrieval and marginalization vs. the accuracy and
  factuality gains; motivates index design, K selection, and caching.
- Advanced retrieval: Bridges to dense/sparse hybrids, hard-negative mining, and better training
  signals for retrievers.
- Infrastructure/PEFT: In practice, the generator can be adapted with LoRA while the index is served
  via a system like vLLM with KV caching; RAG’s decoupling supports modular deployments.

## Discussion Questions
1) When does RAG-Token’s token-wise mixing materially help over RAG-Sequence, and when might it
   hurt factual attribution or latency?
2) What index design choices (corpus, chunking, overlap, embedding model) most affect recall and
   final task metrics? How would you validate them efficiently?
3) How should one balance K (number of passages) vs. latency and factuality? Would a learned,
   adaptive K help?
4) How would you update a production RAG system’s knowledge safely and continuously (index
   refresh cadence, backfills, provenance retention)?
5) What are promising strategies to mitigate prompt-injection and data poisoning risks in RAG
   pipelines without crippling recall?

## Glossary
- Non-parametric memory: An external knowledge store (e.g., a passage index) accessed at inference
  time rather than stored in model weights.
- DPR (Dense Passage Retrieval): Bi-encoder retriever that encodes queries and passages into a
  shared space and scores by dot product.
- MIPS (Maximum Inner Product Search): Retrieval objective of selecting vectors with largest dot
  product to a query; commonly accelerated by FAISS/HNSW.
- FAISS: Library for efficient similarity search with vector indices (e.g., IVF, HNSW), used to serve
  top-K passages.
- RAG-Sequence: RAG variant that conditions on a single retrieved document for the entire output.
- RAG-Token: RAG variant that allows a different retrieved document per generated token.
- Marginalization over documents: Summing predictions across retrieved documents to form the final
  sequence/token distribution.
- Thorough vs. Fast Decoding: RAG-Sequence decoding strategies that trade compute for accuracy in
  marginalization across documents.
- Closed-book QA: Parametric-only generation without retrieval, relying solely on model weights.
- FEVER: Fact verification benchmark requiring classification of claims as supported, refuted, or
  unverifiable using evidence from Wikipedia.

## References and Claim Checks
- “Combine a pre-trained retriever with a pre-trained seq2seq model and fine-tune end-to-end … treat
  z as a latent variable and marginalize over seq2seq predictions” (Figure 1 and Section 2; see
  pdftotext lines around 114–125 and 150–170).
- “Two models … RAG-Sequence … RAG-Token … formally define” (Section 2.1; equations shown in
  pdftotext lines ~160–210).
- “Retriever based on DPR bi-encoder; MIPS via FAISS; Wikipedia December 2018 dump into ≈21M
  100-word chunks” (Sections 2.2 and 3; pdftotext lines ~220–236 and 280–287).
- “Train by minimizing negative marginal log-likelihood; keep document encoder and index fixed; tune
  query encoder + generator” (Section 2.4; pdftotext lines ~242–256).
- “Decoding differences and Thorough vs. Fast Decoding for RAG-Sequence” (Section 2.5; pdftotext
  lines ~256–269 and 270–279).
- “RAG sets new state of the art on several open-domain QA tasks … compares favorably to DPR and
  to REALM/T5+SSM without specialized pretraining” (Section 4.1; pdftotext lines ~360–379).
- “RAG-Sequence outperforms BART on MSMARCO NLG by ≈2.6 BLEU and ≈2.6 ROUGE-L; fewer
  hallucinations” (Section 4.2; pdftotext lines ~392–404).
- “RAG-Token superior on Jeopardy QG; humans prefer RAG for factuality and specificity” (Section
  4.3; pdftotext lines ~404–421).

