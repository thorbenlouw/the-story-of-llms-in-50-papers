# Notes: StereoSet (Nadeem et al., 2020)

## Key Contributions
- Creates StereoSet: large-scale natural dataset with 16,995 test instances across 4 domains (gender, profession, race, religion)
- Introduces Context Association Test (CAT): measures both bias AND language modeling ability
- Proposes 3 metrics: Language Modeling Score (lms), Stereotype Score (ss), Idealized CAT Score (icat)
- Shows all major pretrained models (BERT, GPT-2, RoBERTa, XLNet) exhibit strong stereotypical biases
- Public leaderboard with hidden test set: https://stereoset.mit.edu

## Method Sketch
- Two CAT types: intrasentence (fill-in-blank) and intersentence (next sentence selection)
- Each test has 3 options: stereotype, anti-stereotype, unrelated
- Crowdsourced from 475-803 US-based Mechanical Turk workers
- Validation: 5 annotators per instance, retain if ≥3 agree (83% retention)
- Target terms from Wikidata relations (profession, race, religion) + manual gender terms
- 321 target terms total

## Prior Work Contrast
- vs. WEAT (Caliskan 2017): Extends from word embeddings to pretrained LMs; uses natural context not artificial
- vs. SEAT (May 2019): Uses natural contexts instead of generic "This is [target]" templates
- vs. Kurita et al. (2019): Similar to intrasentence CAT but adds intersentence + natural contexts
- vs. extrinsic bias evaluation (coreference, sentiment): Intrinsic measure directly on pretrained models

## Notable Results
- Best model (GPT-2 small) icat=73.0 vs ideal=100 (27 points behind ideal)
- Strong correlation: better language models → higher stereotypical bias
- GPT-2 variants most balanced (high lms + moderate ss)
- BERT/XLNet: high lms but also high ss
- Domain bias: Race least biased (icat=69.7), other domains ~66-68
- 59% stereotypes positive sentiment vs 67% anti-stereotypes (p.4)
- Reddit demographics in GPT-2 training: 67% male, 64% ages 18-29 (p.4)

## Limitations
- US-only crowdworkers (80% under age 50) - may not reflect wider stereotypes
- Some stereotypes conflate with objective facts (e.g., "Everyone in Iraq is Muslim")
- Doesn't handle cases where stereotypes might be useful (chef makes delicious food)
- Dataset reflects 2020 stereotypes - may become dated

## Course Context (Extension Track B: Ethics)
- Bias measurement benchmark paper
- Complements Stochastic Parrots' critique with concrete measurement framework
- Shows that bias increases with model capability (problematic correlation)
- Provides standardized evaluation for comparing debiasing techniques