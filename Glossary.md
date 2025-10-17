# Glossary

This glossary consolidates terms from all paper summaries in the course.

**Abel Transformation:** A mathematical technique for rearranging summations, used in the paper to prove RoPE's long-term decay property by bounding the inner product magnitude.

**Absolute Position Encoding:** Methods that assign position-specific representations (learned or sinusoidal) to each sequence position, typically added to token embeddings; examples include original Transformer and BERT.

**Adversarial benchmark:** A test set designed to expose specific model weaknesses rather than measure performance on representative real-world tasks. TruthfulQA is adversarial in targeting imitative falsehoods, not in targeting malicious exploitation.

**All-to-All Communication:** A collective operation where each device sends unique data to every other device. Required in expert parallelism to route tokens (on device i) to experts (on device j≠i) and return results.

**Auxiliary Objective:** An additional training goal (e.g., language modeling during fine-tuning) that improves generalization beyond the primary task objective.

**Best-of-N sampling:** An inference-time method: generate N completions from the policy, score each with a reward model, and return the highest-scoring one. While this can achieve strong performance (Best-of-128 matches DPO in Figure 3), it is computationally expensive and impractical for production.

**BLEU Score:** Evaluation metric for translation quality measuring n-gram precision between generated and reference translations, with brevity penalty for short outputs.

**BPE (Byte-Pair Encoding):** A subword tokenization method that builds vocabulary by iteratively merging the most frequent character pairs.

**Bradley-Terry model:** A probabilistic model for pairwise comparisons: the probability that item y1 is preferred to y2 is σ(r(y1) - r(y2)), where r is a latent reward and σ is the logistic function. In preference learning for LMs, y1 and y2 are model completions conditioned on a prompt x.

**Capacity Factor:** A hyperparameter (typically 1.0-1.5) multiplying the even-split token allocation to provide buffer for routing imbalance. Higher values reduce dropped tokens but waste memory on padding.

**Causal Language Modeling:** Predicting the next token in a sequence given only previous tokens (left-to-right, autoregressive prediction).

**Change of variables:** A technique for transforming an optimization problem by reparameterizing the objective. DPO uses a change of variables from reward function r to policy π, converting a two-stage problem (fit reward, then optimize policy) into a single-stage problem (optimize policy directly). Theorem 1 (page 5-6) proves this transformation is lossless.

**Control questions:** Questions constructed by editing 1-3 words of TruthfulQA questions to create straightforward trivia with similar syntax. Used to test whether poor performance arises from question form (non-imitative weakness) or semantic content (imitative weakness).

**Discriminative Fine-tuning:** Adapting a pre-trained model to a supervised classification or regression task using labeled examples.

**Distillation (Knowledge Distillation):** Training a smaller "student" model to mimic a larger "teacher" model's outputs (soft labels) in addition to ground-truth labels. Used here to compress sparse Switch models into dense deployable models.

**Dropout:** A regularization technique that randomly sets a fraction of neuron activations to zero during training, forcing the network to learn robust features that don't rely on any single unit. At test time, all neurons are active but their outputs are scaled by the keep probability.

**Dropped Tokens:** Tokens routed to experts that have exceeded their capacity. These bypass expert computation, passing through only the residual connection. Typically <1% with good load balancing.

**Encoder-Decoder Architecture:** Two-component structure where the encoder processes the input sequence into representations, and the decoder generates output autoregressively while attending to encoder outputs.

**Equivalence class (of reward functions):** A set of reward functions that differ only by a function of the prompt: r(x,y) and r'(x,y) are equivalent if r'(x,y) = r(x,y) + f(x). All rewards in an equivalence class induce the same preference distribution (Bradley-Terry is invariant to adding constants) and the same optimal policy under the KL-constrained objective.

**Expert Capacity:** The maximum number of tokens each expert can process in a batch, calculated as `(tokens_per_batch / num_experts) × capacity_factor`. Necessary for static tensor allocation on accelerators.

**Expert Dropout:** Applying higher dropout rates (e.g., 0.4) within expert FFN layers during fine-tuning, while using standard rates (0.1) elsewhere. Regularizes the larger parameter count of sparse models.

**Filtered vs. unfiltered questions:** Filtered questions (437) were iteratively tested on GPT-3-175B and kept only if the model consistently failed. Unfiltered questions (380) were written to elicit failures without direct testing, based on experience from filtered questions.

**Fine-tuning:** Continuing to train a pre-trained model on a new task with task-specific data, allowing weights to adapt while retaining general knowledge.

**FLOP (Floating Point Operation):** A single arithmetic operation (addition, subtraction, multiplication, or division) on floating-point numbers. FLOPs (plural) is used as a measure of computational cost for training and running neural networks. Often expressed in aggregate units like GFLOPs (10^9 operations) or PFLOPs (10^15 operations).

**FLOP-Matched:** Models designed to use the same number of floating-point operations per training example, enabling fair comparison. Switch-Base and T5-Base are FLOP-matched despite Switch-Base having ~17x more parameters.

**Frame accuracy:** In speech recognition, the percentage of correctly predicted phonetic states at each audio frame. Correlates with Word Error Rate (WER) but faster to compute.

**Generative Pre-training:** Training a model to generate/predict text (unsupervised) on large unlabeled corpora before adapting it to specific tasks.

**GPT-judge:** A GPT-3-6.7B model finetuned on 22.4k human-labeled (question, answer, truthfulness) triples, achieving 90-96% cross-validation accuracy predicting human judgments. Provides fast automated evaluation for TruthfulQA.

**Gradient clipping:** A training stability technique that scales down gradients exceeding a threshold norm, preventing explosive updates. Essential for RNNs due to potential gradient explosion through recurrent connections.

**Hadamard Product (⊗):** Element-wise multiplication of vectors or matrices; RoPE uses Hadamard products for efficient implementation avoiding full matrix multiplication.

**Imitative falsehood:** A false answer with high likelihood on the model's training distribution, incentivized by the language modeling objective. Distinguished from falsehoods caused by insufficient learning of the training distribution.

**Implicit reward model:** In DPO, the reward is not represented as a separate neural network rφ(x,y). Instead, it is implicitly defined by the policy and reference policy: rˆθ(x,y) = β log(πθ(y|x)/πref(y|x)). The policy network serves dual duty as both the language model and the (implicit) reward model.

**Informativeness:** A measure of whether an answer provides information reducing uncertainty raised by the question. Contrasted with true-but-uninformative responses like "I have no comment" or "No."

**Inverse scaling:** The phenomenon where larger models perform worse on a task, contrasting with typical NLP scaling laws. In TruthfulQA, inverse scaling suggests larger models better fit false claims in training data.

**KL divergence (Kullback-Leibler divergence):** A measure of how one probability distribution differs from another reference distribution. In LLM training, KL divergence D_KL(P||Q) quantifies the difference between distributions P and Q, commonly used to constrain how much a fine-tuned model can deviate from a reference policy. Always non-negative, with D_KL(P||Q) = 0 only when P and Q are identical.

**KL-constrained reward maximization:** The RLHF objective max_π E[r(x,y)] - β D_KL(π||πref), which seeks a policy π that maximizes expected reward while staying close (in KL-divergence) to a reference policy πref. The constraint prevents the model from collapsing onto a narrow high-reward mode and maintains output diversity.

**Layer Normalization:** Normalization technique applied across features for each example independently, stabilizing training when combined with residual connections.

**Linear Attention:** Attention mechanisms with O(N) complexity in sequence length (versus O(N²) for standard softmax attention), achieved by reformulating attention using kernel functions; examples include Performer and Linformer.

**Load Balancing Loss:** An auxiliary loss term encouraging uniform distribution of tokens across experts. In Switch Transformers: `α·N·Σ(f_i · P_i)`, minimized when both fraction dispatched (f_i) and probability mass (P_i) equal 1/N.

**Long Short-Term Memory (LSTM):** An RNN architecture with gated memory cells that can maintain information over long sequences. Introduced by Hochreiter & Schmidhuber (1997) to address vanishing gradients.

**Long-term Decay:** Property where the magnitude of attention between tokens decreases as their relative distance increases; proven for RoPE via Abel transformation.

**Masked Attention:** Attention modification in the decoder preventing positions from attending to subsequent positions, preserving autoregressive properties during training.

**Memory cell (c_t):** In LSTM architecture, a linear pathway that stores information across timesteps with minimal transformation. Gates (input, forget, output) control what enters, stays, or exits the memory.

**Mixture-of-Experts (MoE):** A model architecture where multiple sub-networks (experts) exist, and a gating mechanism (router) dynamically selects which expert(s) process each input. Enables parameter scaling without proportional compute increase.

**Multi-Head Attention:** Parallel attention operations with different learned projections, allowing the model to jointly attend to different representation subspaces and capture diverse relationships.

**Non-imitative weakness:** A model property causing falsehoods that is not incentivized by the training objective. Examples include unusual syntax triggering parsing failures or rare word combinations outside training distribution coverage.

**Non-recurrent connections:** The layer-to-layer transformations within a single timestep. In a deep RNN, these are the vertical connections between stacked layers.

**Orthogonal Matrix:** A matrix whose transpose equals its inverse (R^T R = I); orthogonal transformations preserve vector norms and angles, ensuring stable encodings.

**Overfitting:** When a model learns training data patterns (including noise) so well that it performs worse on unseen test data. Large RNNs are especially prone to overfitting without regularization.

**Partition function Z(x):** The normalizing constant in the optimal policy π*(y|x) = (1/Z(x)) πref(y|x) exp(r(x,y)/β), where Z(x) = Σ_y πref(y|x) exp(r(x,y)/β). Computing Z(x) exactly is intractable, but DPO sidesteps this by deriving an objective where Z(x) cancels.

**Penn Tree Bank (PTB):** A standard language modeling benchmark with ~1M training words, 10k vocabulary, used to evaluate sequence models' ability to predict the next word.

**Perplexity:** A metric for language models equal to the exponentiated average negative log-likelihood: `exp(-1/N Σ log P(w_i))`. Lower is better; perplexity of 78.4 means the model is as uncertain as a uniform distribution over ~78 words.

**Position-wise Feed-Forward Network:** Two linear transformations with ReLU applied identically to each position, providing non-linear transformations between attention layers.

**Positional Encoding:** Sinusoidal or learned embeddings added to input embeddings to inject information about token positions, compensating for the lack of inherent sequence order in attention.

**PPO (Proximal Policy Optimization):** A reinforcement learning algorithm used in standard RLHF. PPO iteratively samples completions from the current policy, computes advantages using a value function, and updates the policy to increase the probability of high-advantage actions while clipping large policy updates to maintain stability.

**Preferred-FT (Preferred Fine-Tuning):** A baseline method that simply maximizes the log-likelihood of preferred completions: max_π E[log π(y_w|x)]. This ignores the relative nature of preferences and lacks the KL constraint, resulting in weaker performance than DPO.

**Query, Key, Value (Q, K, V):** The three components of attention where queries determine what to look for, keys determine what can be found, and values contain the actual information to be aggregated.

**Recurrent connections:** The timestep-to-timestep links in an RNN that carry hidden states and memory cells forward, creating the network's sequential dependency structure.

**Reference policy πref:** The initial policy (typically the SFT model) used to anchor the KL divergence constraint. In DPO, πref is frozen during training and provides the log-probabilities needed to compute the implicit reward. The reference policy prevents the optimized policy from drifting too far from the initial distribution.

**Relative Position Encoding:** Methods that model position as the distance or relationship between pairs of tokens rather than absolute indices; used in Transformer-XL, T5, and DeBERTa.

**Residual Connection:** Adding the input of a sub-layer to its output (x + Sublayer(x)), enabling gradient flow in deep networks and facilitating training.

**Reward reparameterization:** Expressing the reward function r(x,y) in terms of the policy π and reference policy πref: r(x,y) = β log(π(y|x)/πref(y|x)) + β log Z(x). This change of variables is central to DPO, enabling the transformation from reward-then-RL to direct policy optimization.

**Rotary Position Embedding (RoPE):** A position encoding method that represents position as rotation in high-dimensional space, encoding absolute position through rotation matrices while enabling natural emergence of relative position in attention scores.

**Rotation Matrix:** An orthogonal matrix that rotates vectors in Euclidean space without changing their magnitude; in RoPE, block-diagonal matrices with 2×2 rotation blocks encode position.

**Router:** A learned function (typically a linear layer + softmax) that computes assignment probabilities for routing inputs to experts. In Switch Transformers, outputs probabilities over N experts per token.

**Scalar truth score:** A continuous value in [0,1] representing the probability a statement is true. Assigned via qualitative labels (e.g., "Mostly true" = 0.9, "Mixed true/false" = 0.1). Thresholded at 0.5 for binary classification.

**Scaled Dot-Product Attention:** Attention computed as softmax(QK^T/√d_k)V, where the scaling prevents gradient vanishing in softmax for large dimensions.

**Selective Precision:** Training most of the model in bfloat16 but casting specific operations (here, the router) to float32. Achieves near-bfloat16 speed with float32 stability by localizing precision to critical numerics.

**Self-Attention:** An attention mechanism where a sequence attends to itself, computing relationships between all positions to generate representations without recurrence or convolution.

**Sequence Length Extrapolation:** The ability to apply a model to sequences longer than those seen during training; RoPE enables this through its rotation-based formulation.

**Sequential bottleneck:** The inability to parallelize computation across timesteps in RNNs. Each timestep depends on the previous one's hidden state, forcing sequential processing.

**Sinusoidal Position Encoding:** The original Transformer's position encoding using sine and cosine functions of different frequencies; RoPE uses the same frequency schedule but applies it through rotation.

**Sparse Activation:** The property that only a subset of model parameters activate for any given input. Switch Transformers achieve this via routing: each token activates 1/N experts, making the model sparsely activated despite dense parameter count.

**Task-agnostic Model:** A model architecture that can adapt to multiple different tasks with minimal structural changes.

**Teacher Forcing:** Training technique where the decoder receives ground-truth previous outputs rather than its own predictions, enabling parallel training of all positions.

**Transfer Learning:** Using knowledge learned from one task (pre-training on unlabeled text) to improve performance on different tasks (supervised downstream tasks).

**Transformer Decoder:** A neural architecture using masked self-attention (attending only to previous positions) and feedforward layers, stacked in multiple layers.

**True-and-informative:** The intersection metric requiring answers to be both truthful (avoiding falsehoods) and informative (reducing uncertainty). Analogous to precision AND recall in information retrieval.

**Truthfulness (TruthfulQA standard):** A statement describes the literal truth about the real world, supported by reliable evidence (Wikipedia, scientific sources). Excludes claims true only within belief systems or traditions. An answer is truthful iff it avoids asserting a false statement (allows uncertainty, non-committal responses, or irrelevant truths).

**Vanishing gradients:** When gradients shrink exponentially during backpropagation through many layers or timesteps, making early parameters nearly untrainable. LSTMs use gated memory to mitigate this.

**Win rate:** The fraction of comparisons in which a method's output is preferred over a baseline (either human-written reference or another method's output). In the paper, win rates are computed using GPT-4 as a judge for scalability, and validated against human judgments (Section 6, Tables 2 and Figures 2-3).

**Zero-shot (true zero-shot):** No gradient updates and no TruthfulQA examples in prompts. Prompts may contain natural language instructions or unrelated examples. Hyperparameters not tuned on TruthfulQA. Stricter than "zero-shot" definitions allowing prompt engineering on validation data.

**Zero-shot Learning:** A model's ability to perform tasks it wasn't explicitly trained on, using only the knowledge from pre-training.
