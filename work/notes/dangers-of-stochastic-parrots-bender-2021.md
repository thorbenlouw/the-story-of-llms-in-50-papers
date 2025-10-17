# Notes: On the Dangers of Stochastic Parrots (Bender et al., 2021)

## Key Contributions
- Foundational critique of the "bigger is better" trend in LM development (2018-2021)
- Identifies 4 major risk categories: environmental, data curation, misleading research directions, real-world harms
- Introduces "stochastic parrot" metaphor for LMs that generate coherent form without meaning
- Proposes value-sensitive design and documentation frameworks as mitigation strategies

## Method Sketch
- Critical analysis paper examining:
  - Environmental/financial costs of training large LMs (Section 3)
  - Bias encoding in web-scraped training data (Section 4)
  - Misdirection of NLU research efforts (Section 5)
  - Risks from coherent but meaningless synthetic text (Section 6)
  - Paths forward with careful curation and documentation (Section 7)
- Draws on literature from environmental justice, linguistics, HCI, social movements

## Prior Work Contrast
- vs. Strubell et al. (2019): Extends environmental cost analysis to broader social impacts
- vs. BERT/GPT-2/GPT-3 papers: Challenges assumption that scale alone drives progress
- vs. typical bias studies: Argues exhaustive bias auditing is impossible; advocates preventative curation
- Introduces cross-disciplinary lens (not just technical fixes)

## Notable Results
- 284t CO2 for training Transformer with neural architecture search vs. 5t CO2/year for average human (p.3)
- GPT-2 training data: 67% male Reddit users, 64% ages 18-29 (p.4)
- Only 8.8-15% of Wikipedians are women/girls (p.4)
- 272K documents from unreliable news sites in GPT-2 training data (p.6)
- Filtering "bad words" removes LGBTQ community discourse (p.5)
- Social movements change language faster than models can retrain (p.5-6)

## Limitations
- Published before GPT-3.5/GPT-4 era; some examples now dated
- Doesn't propose specific technical solutions, focuses on process/values
- "Stochastic parrot" metaphor somewhat polarizing in community
- Limited discussion of beneficial uses (brief ASR example in Section 7)
- Doesn't fully address scenarios where scale genuinely helps marginalized communities

## Course Context (Extension Track B: Ethics)
- Bias/Ethics Foundation paper
- Challenges assumptions about scale and progress
- Introduces environmental justice perspective
- Advocates for curation over ingestion
- Connects to Constitutional AI, alignment work in main syllabus