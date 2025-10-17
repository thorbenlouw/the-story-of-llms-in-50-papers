# Where It All Began: A Dialog on the Transformer

The study room on the fourth floor of the engineering library had terrible ventilation but excellent whiteboards. Sophie arrived first, claiming the room at 6 PM sharp, spreading her laptop and a printed paper across the table. She'd highlighted half the pages in yellow and orange, with marginal notes crowding every available space.

Jai showed up five minutes later, looking slightly harried, laptop bag in one hand and a energy drink in the other. "Sorry, my office hours ran late. Everyone suddenly cares about neural networks now that ChatGPT exists."

"You're literally on time," Sophie said with a smile. "And yeah, I've noticed. Half my undergrad mentees want to pivot their projects to LLMs. None of them understand how they actually work."

"That's why we're doing this, right?" Jai dropped into a chair. "Read the foundational papers, understand the actual architecture and theory, not just use the API."

"Speaking of which, where's Fritz?"

The door swung open and Fritz entered, balancing a coffee and a stack of books. "Here! Sorry. I was in the stacks and lost track of time." He set everything down with a thud. "Also, I found the Sutskever sequence-to-sequence paper from 2014 if anyone wants to borrow it. Figured it might give context for what came before."

"Perfect," Sophie said. "Okay, so welcome to week one of our unofficial, self-directed, probably-too-ambitious reading group on large language models. We're starting at the beginning: 'Attention Is All You Need,' Vaswani et al., 2017."

"The paper that launched a thousand transformers," Jai said dramatically.

Fritz settled in, opening his laptop. "I've seen this cited everywhere but never actually read it. What makes it so revolutionary?"

"It eliminated recurrence completely," Sophie said immediately. "Like, that's the whole point. The title is almost cheeky—'Attention Is All You Need.' Before this, every sequence model used RNNs, LSTMs, GRUs. You'd maybe add attention as a helper mechanism, but the core was always recurrent. This paper said: what if we just... don't?"

"Why is that such a big deal?" Fritz asked.

"Parallelization," Jai said. "RNNs are inherently sequential. To process token five, you have to wait for token four. To process token four, you need token three. The whole sequence has to flow through one step at a time. You literally can't parallelize within a training example."

"And modern ML is all about parallelization," Sophie added. "We have these massive GPU clusters designed for parallel computation. RNNs couldn't take full advantage because of the sequential bottleneck."

Fritz nodded slowly. "So attention lets you process all positions at once?"

"Exactly!" Sophie pulled up a diagram on her laptop. "Self-attention computes relationships between all positions in the sequence simultaneously. Every position can attend to every other position in parallel. No waiting for the previous timestep."

"Walk me through how it actually works," Fritz said, pen poised over his notebook.

Jai leaned forward. "Okay, so the core mechanism is scaled dot-product attention. You have three matrices: queries, keys, and values—Q, K, and V. Think of it like a search system. Queries are 'what am I looking for,' keys are 'what do I contain,' and values are the actual content."

"For each position," Sophie continued, "you take its query and compute dot products with all the keys. That gives you attention scores—how much should this position attend to every other position. You scale those scores by the square root of the dimension, apply softmax to get weights that sum to one, then use those weights to take a weighted average of the values."

Fritz was writing quickly. "Why the scaling factor? The square root of the dimension?"

"Great question," Sophie said. "The paper explains this in a footnote. As the dimension gets large, the dot products grow in magnitude. They push the softmax into regions with extremely small gradients—basically the softmax output is all zero except one position gets nearly 1. The scaling keeps the dot products in a reasonable range."

"So the formula is softmax of QK transpose divided by root d_k, times V," Jai said. "Elegant and simple."

"That's single-head attention," Sophie added. "The transformer uses multi-head attention, which is even more clever."

"What's the difference?" Fritz asked.

"Instead of doing attention once with the full dimension—512 in their model—you split it up," Sophie explained. "They use 8 heads. For each head, you project Q, K, and V down to 64 dimensions with different learned projection matrices, compute attention, then concatenate all the heads and project back to 512."

"Why is that better than just using 512 directly?" Fritz pressed.

"Because it lets the model attend to different types of relationships simultaneously," Jai said. "One head might focus on syntactic dependencies, another on coreference, another on semantic similarity. The paper says it allows the model to 'jointly attend to information from different representation subspaces at different positions.'"

Sophie nodded enthusiastically. "With single-head attention, averaging across all 512 dimensions would wash out those different patterns. Separate heads preserve them."

"Okay," Fritz said, "so we have this attention mechanism that processes everything in parallel. What's the overall architecture?"

"Encoder-decoder structure," Sophie said, pulling up the famous Figure 1 from the paper. "Both the encoder and decoder are stacks of identical layers. The paper uses 6 layers for each."

"Each encoder layer has two sub-layers," Jai continued. "First is multi-head self-attention—each position attends to all positions in the input sequence. Second is a position-wise feed-forward network, which is just two linear transformations with ReLU in between. The inner dimension is 2048, four times the model dimension."

"They use residual connections and layer normalization around each sub-layer," Sophie added. "So it's actually x plus the sublayer applied to x, then normalize. Helps with gradient flow in deep networks."

Fritz looked up. "What about the decoder?"

"The decoder has three sub-layers," Jai said. "First is masked self-attention—it can only attend to earlier positions, preserving the autoregressive property. You don't want position 5 to see position 6 during training, since at inference time it won't have access to future tokens."

"Second sub-layer is cross-attention," Sophie said. "This attends to the encoder output. So the decoder can look at the entire input sequence when generating each output token."

"And third is the same position-wise feed-forward network as the encoder," Jai finished.

Fritz tapped his pen thoughtfully. "Wait. If there's no recurrence, how does the model know what order the tokens are in? Isn't sequence order kind of important for language?"

"Another great question," Sophie said approvingly. "You're right, the attention mechanism itself has no notion of position. You could permute the input and get the same attention weights. So they add positional encodings."

"What are those?"

"Embeddings that encode the position of each token," Jai explained. "They add these to the input embeddings before the first layer. The paper uses sinusoidal functions—sine and cosine of different frequencies. Position 0 uses one frequency, position 1 slightly different, and so on."

"Why sinusoidal?" Fritz asked.

"Couple reasons," Sophie said. "First, they can extrapolate to sequence lengths longer than seen during training. Second, the paper hypothesizes that it would let the model easily learn to attend by relative positions, since any fixed offset can be represented as a linear function of the encoding. Though honestly, I think this is the least elegant part of the architecture."

"An architectural band-aid," Jai agreed. "But it works."

"Okay," Fritz said, "so we have attention instead of recurrence, multi-head attention to capture different relationships, positional encodings for sequence order. What about the computational complexity you mentioned earlier?"

Jai flipped to Table 1 in the paper. "This is where the comparison to RNNs gets interesting. RNNs need O(n) sequential operations where n is the sequence length. Maximum path length between any two positions is also O(n). Self-attention needs only O(1) sequential operations, and maximum path length is O(1)—any position can attend directly to any other position."

"But there's a trade-off," Sophie interjected. "Self-attention has O(n²·d) complexity per layer, where d is the dimension. RNNs are O(n·d²). So if your sequence length n is larger than your dimension d, self-attention becomes more expensive computationally."

"When is d larger than n?" Fritz asked.

"Most of the time, actually," Jai said. "With byte-pair encoding or word-piece tokenization, sequences are typically 512 or 1024 tokens. Model dimension is 512 in the base model. So n and d are comparable, meaning self-attention isn't prohibitively expensive. And the parallelization benefits massively outweigh the higher nominal complexity."

Fritz nodded, scribbling more notes. "What about the results? Did it actually work better than RNNs?"

"Crushed them," Sophie said with satisfaction. "On WMT 2014 English-to-German translation, previous state-of-the-art was around 26.4 BLEU. The big transformer got 28.4 BLEU—more than 2 points higher, which is huge in translation."

"And it trained way faster," Jai added. "3.5 days on 8 GPUs instead of weeks. The training cost in FLOPs was less than a quarter of the previous best system while achieving better results."

"English-to-French was similar," Sophie said. "41.8 BLEU, setting a new single-model record. And they showed it generalizes—they applied it to English constituency parsing with no task-specific tuning and got competitive results."

"So this paper basically obsoleted RNNs?" Fritz asked.

"Pretty much," Jai said. "I mean, RNNs are still used in some niche applications, but for sequence modeling at scale? Transformers won. Everything since 2017—BERT, GPT, T5, all the modern LLMs—they're all transformers. This is the foundation."

Sophie glanced at the time. "We've been at this for almost an hour. Should we do a quick recap before we lose steam?"

"Good idea," Fritz said. "Help me make sure I've got the main points."

"First," Sophie began, "the Transformer eliminates recurrence and convolutions entirely, relying solely on attention mechanisms for sequence transduction. This is fundamentally different from all prior sequence models."

"Second," Jai continued, "multi-head attention allows parallel processing of different types of relationships by using multiple attention heads with different learned projections, each capturing different representation subspaces."

"Third," Fritz added, reading from his notes, "scaled dot-product attention uses the formula softmax of QK transpose over root d_k times V, where the scaling prevents gradient vanishing in the softmax for large dimensions."

"Fourth," Sophie said, "the encoder-decoder architecture uses stacked layers—six each—with self-attention, cross-attention in the decoder, and position-wise feed-forward networks, connected via residual connections and layer normalization."

"Fifth," Jai noted, "positional encodings provide sequence order information since attention itself is position-invariant, using sinusoidal functions that can potentially extrapolate to longer sequences."

"Sixth," Fritz said, "computational advantages include O(1) sequential operations versus O(n) for RNNs and O(1) maximum path length between positions, enabling massive parallelization despite O(n²·d) complexity per layer."

"And seventh," Sophie concluded, "empirical results showed state-of-the-art translation quality—28.4 BLEU on English-German—achieved in dramatically less training time, 3.5 days versus weeks, demonstrating both performance and efficiency gains."

They sat back, the whiteboard now covered in attention diagrams and complexity analyses.

"You know what strikes me," Fritz said after a moment, "is how simple the core idea is. Just... compute attention between all positions. No fancy recurrent connections, no complicated gating mechanisms like LSTMs. Just queries, keys, values, and softmax."

"That's often how breakthroughs work," Jai said. "The hard part isn't the complexity of the idea, it's having the insight to try something simpler. Everyone was so focused on making RNNs work better—adding gates, trying different architectures—that it took a leap to ask whether you need recurrence at all."

"And the answer was no," Sophie said. "You don't. Attention is all you need."

Fritz closed his notebook with a sense of satisfaction. "Okay, so this is week one. What's next?"

Sophie grinned. "Week two is GPT and BERT—seeing how this architecture gets adapted for language modeling and understanding. Then we hit positional encodings more deeply, scaling laws, efficiency improvements, the works."

"12 weeks to understand modern LLMs from the ground up," Jai said. "Think we can do it?"

"One paper at a time," Fritz said, gathering his things. "Same time next week?"

"Absolutely," Sophie said. "And Fritz, bring that Sutskever paper. I want to see what translation looked like before transformers."

"Will do."

As they filed out of the study room, turning off the lights and leaving the whiteboard covered with attention matrices and complexity analyses, they were already anticipating next week's papers. The transformer was just the beginning—the foundation upon which an entire revolution in AI would be built.

But they had to start somewhere. And in 2017, at a conference in Long Beach, eight researchers from Google had started by asking a simple question: what if attention was all you needed?

The answer had changed everything.
