Hyena: Long‑Range Modelling with Fast Convolutions

Paper: Hyena Hierarchy: Towards Larger Convolutional Language Models (Poli et al., 2023)

## Introduction: Another Path Beyond Full Attention
Attention is powerful but pricey at long ranges. Hyena asks: can we get similar modelling capacity using fast convolutions with clever filters instead of all‑pairs attention? If so, we could keep parallel training and gain efficiency on long sequences.

## The Big Idea: Implicit Long‑Range Interactions
Hyena builds hierarchical blocks that mix information over long distances via lightweight, parameter‑efficient convolutions with learned filters. The design maintains parallelism while approximating the global dependency capture associated with attention.

Analogy 1: Rather than every person talking to everyone, Hyena organises information flow through well‑placed loudspeakers that broadcast the right signals across the room.

Analogy 2: It’s like ripples in a pond—local waves propagate and interact, carrying information over distance without direct pairwise messaging.

Key concept: Carefully structured convolutions can approximate long‑range mixing with lower memory and compute, challenging attention’s monopoly.

## The “So What?”: Efficiency Without Giving Up Scale
Empirically, Hyena variants reach competitive quality on long‑context tasks while using less memory. That translates into training larger contexts on the same hardware and faster inference for certain workloads.

Practically, Hyena expands the architecture toolbox. Depending on constraints, teams can choose pure Transformers, SSMs (Mamba), retention‑based models (RetNet), or convolutional mixers (Hyena).

## Connecting the Dots: Pluralism in Model Design
In our course narrative, Hyena underscores a shift from a single dominant architecture to a pluralistic landscape where multiple backbones vie on efficiency and quality. This sets the stage for hybrids that combine strengths—the topic of our next paper.

## Conclusion: Many Roads to Long Context
Hyena shows that fast, learned filters can move information far without paying attention’s quadratic cost. Next, a hybrid: Jamba mixes Transformers and Mamba to enjoy both worlds.

## See Also
- Prev: [36 — RetNet](36-retentive-network-retnet-wu-2023.md)
- Next: [38 — Jamba (Hybrid Transformer‑Mamba)](38-jamba-hybrid-transformer-mamba-lieber-2024.md)

