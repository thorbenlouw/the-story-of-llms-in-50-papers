# Notes: Concrete Problems in AI Safety (Amodei et al., 2016)

## Key Contributions
- Defines "accidents" in ML: unintended harmful behavior from poor system design
- Identifies 5 concrete research problems that are ready for experimentation NOW
- Grounds speculative safety discussions in practical ML challenges
- Uses "cleaning robot" running example throughout
- Published before RLHF boom (2016) - foundational/anticipatory work

## Method Sketch
5 Problem categories based on where things go wrong:
1. **Avoiding Negative Side Effects** - task objective ignores broader environment
2. **Avoiding Reward Hacking** - objective admits "gaming"/wireheading solutions
3. **Scalable Oversight** - correct objective too expensive to evaluate frequently
4. **Safe Exploration** - exploratory actions have irreversible negative consequences
5. **Robustness to Distributional Shift** - performs poorly on novel inputs with high confidence

Each section: problem definition, prior work review, proposed approaches, potential experiments

## Prior Work Contrast
- vs. futurist work (Bostrom, MIRI): Focuses on practical modern ML not superintelligence
- vs. cyber-physical systems: Extends verification to ML where formal methods don't apply
- vs. specific robustness work: Unifies multiple problems under "accident risk" framework
- Foundational for later RLHF/alignment work (InstructGPT, Constitutional AI)

## Notable Results
- Not empirical - primarily theoretical/framework paper
- Cleaning robot example shows all 5 problems arise naturally
- Safe exploration has most prior work; side effects/reward hacking least studied
- Three trends amplify importance: RL adoption, complex environments, increasing autonomy

## Limitations
- Exploratory in nature (especially side effects, reward hacking sections)
- Pre-dates modern RLHF - didn't anticipate some current approaches
- Some proposed solutions remain preliminary/untested
- Focuses on RL/supervised learning paradigms

## Course Context (Extension Track B: Ethics & Alignment)
- **Alignment Problem foundation** paper
- Frames alignment as preventing "accidents" not superintelligence risks
- Problems 1-2 (side effects, reward hacking): wrong objective function
- Problem 3 (scalable oversight): expensive objective function
- Problems 4-5 (safe exploration, distributional shift): learning process issues
- Directly connects to RLHF (Week 8), DPO (Week 9), Constitutional AI (Week 9)