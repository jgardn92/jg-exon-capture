# Notes on applying fishlifeqc pipeline
Step 1: only keep single contig when multiple contigs have low divergence
  - done by our pipeline
Step 2: Remove loci with too few taxa
  - done by our pipeline
Step 3: Reciprocal blast
  - Sequence for one sp at one locus against all other spp at that locus. Matches too far away, remove both
  - Concern: how do we define what is too far? is this that different than our own pipeline? not really
Step 4: Cross-validate ID with mitochondrial markers
  - Concern: they have probes for mtDNA we don't; don't appear to have mtDNA
  - Concern: if contamination is locus by locus a correct COI ID only tells us that this sample isn't contaminated at that locus
Step 5: Branch-length correlation
  - Concern: gene trees are constrained by a phylogeny; we don't have a phylogeny to constrain with
