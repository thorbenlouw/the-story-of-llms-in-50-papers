# Switch Transformers (Fedus et al., 2021) - Notes

## Key Contributions
- Simplifies MoE to route to single expert (k=1) instead of top-k
- Achieves 7x pre-training speedup over T5-Base with same compute
- Scales to trillion parameter models
- Improves training stability with selective precision and initialization
- Expert dropout for fine-tuning regularization

## Method Sketch
- Router: softmax over experts, select top-1
- Load balancing loss: encourages uniform routing
- Expert capacity: (tokens/batch / num_experts) × capacity_factor
- Dropped tokens pass through residual connection
- Float32 precision only in router (rest bfloat16)
- Smaller initialization scale (0.1x)

## Prior Work Contrast
1. vs. MoE (Shazeer 2017): k=1 vs k=2, simpler routing, halved expert capacity, faster
2. vs. Dense T5: Same FLOPs/token but 10x-100x more parameters via sparsity
3. vs. Model parallelism: Faster wall-clock time, different scaling axis

## Notable Results
- Switch-Base 64 experts: 7.5x sample efficiency vs T5-Base
- 91% of 101 languages achieve 4x+ speedup in multilingual setting
- Distillation: 30% quality gain preserved at 99% compression
- Switch-XXL (395B): 4x speedup over T5-XXL (11B)
- Switch-C (1.6T params): trained stably, no instability

## Limitations
- Training instability at largest scales (Switch-XXL)
- Communication overhead from all-to-all routing
- Downstream fine-tuning gap for reasoning tasks
- Dropped tokens when experts overflow
- Requires static tensor shapes (TPU constraint)

## Course Fit (Week 5)
- Core example of sparse activation and conditional computation
- Router mechanism is key load balancing concept
- Demonstrates memory vs compute trade-offs
- Lab-relevant: basic MoE implementation, capacity factor tuning