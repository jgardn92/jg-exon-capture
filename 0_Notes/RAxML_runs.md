# RAxML Runs on Mac

## Run 1:
### Oreochromis removed after alignment, filtering, and concatenation
`raxmlHPC-PTHREADS-AVX -T 4 -n5_raxml_orm -y -f a -# 100 -p 12345 -x 12345 -m GTRCAT -s 4_concat_update.phy`

IMPORTANT WARNING
Found 1590 columns that contain only undetermined values which will be treated as missing data.
Normally these columns should be excluded from the analysis.

Just in case you might need it, an alignment file with
undetermined columns removed is printed to file 4_concat_update.phy.reduced

Using BFGS method to optimize GTR rate parameters, to disable this specify "--no-bfgs"


Alignment has 1590 completely undetermined sites that will be automatically removed from the input data


This is the RAxML Master Pthread

This is RAxML Worker Pthread Number: 1

This is RAxML Worker Pthread Number: 2

This is RAxML Worker Pthread Number: 3


This is RAxML version 8.2.12 released by Alexandros Stamatakis on May 2018.

With greatly appreciated code contributions by:
Andre Aberer      (HITS)
Simon Berger      (HITS)
Alexey Kozlov     (HITS)
Kassian Kobert    (HITS)
David Dao         (KIT and HITS)
Sarah Lutteropp   (KIT and HITS)
Nick Pattengale   (Sandia)
Wayne Pfeiffer    (SDSC)
Akifumi S. Tanabe (NRIFS)
Charlie Taylor    (UF)


Alignment has 160746 distinct alignment patterns

Proportion of gaps and completely undetermined characters in this alignment: 24.40%

RAxML rapid bootstrapping and subsequent ML search

Using 1 distinct models/data partitions with joint branch length optimization



Executing 100 rapid bootstrap inferences and thereafter a thorough ML search

All free model parameters will be estimated by RAxML
ML estimate of 25 per site rate categories

Likelihood of final tree will be evaluated and optimized under GAMMA

GAMMA Model parameters will be estimated up to an accuracy of 0.1000000000 Log Likelihood units

Partition: 0
Alignment Patterns: 160746
Name: No Name Provided
DataType: DNA
Substitution Matrix: GTR

Overall Time for 100 Rapid Bootstraps 11391.750721 seconds
Average Time per Rapid Bootstrap 113.917507 seconds

Fast ML search Time: 5367.751114 seconds
Slow ML search Time: 7874.495465 seconds
Thorough ML search Time: 1541.351264 seconds

Final ML Optimization Likelihood: -3667005.779593

Model Information:

Model Parameters of Partition 0, Name: No Name Provided, Type of Data: DNA
alpha: 0.155199
Tree-Length: 3.598194
rate A <-> C: 1.178121
rate A <-> G: 2.393459
rate A <-> T: 0.441459
rate C <-> G: 0.947201
rate C <-> T: 3.294175
rate G <-> T: 1.000000

freq pi(A): 0.243246
freq pi(C): 0.281470
freq pi(G): 0.282356
freq pi(T): 0.192928


ML search took 14783.600720 secs or 4.106556 hours

Combined Bootstrap and ML search took 26175.351604 secs or 7.270931 hours

Drawing Bootstrap Support Values on best-scoring ML tree ...



Found 1 tree in File /Users/luketornabene/github/jg-exon-capture/RAxML_bestTree.5_raxml_orm



Found 1 tree in File /Users/luketornabene/github/jg-exon-capture/RAxML_bestTree.5_raxml_orm

Program execution info written to /Users/luketornabene/github/jg-exon-capture/RAxML_info.5_raxml_orm
All 100 bootstrapped trees written to: /Users/luketornabene/github/jg-exon-capture/RAxML_bootstrap.5_raxml_orm

Best-scoring ML tree written to: /Users/luketornabene/github/jg-exon-capture/RAxML_bestTree.5_raxml_orm

Best-scoring ML tree with support values written to: /Users/luketornabene/github/jg-exon-capture/RAxML_bipartitions.5_raxml_orm

Best-scoring ML tree with support values as branch labels written to: /Users/luketornabene/github/jg-exon-capture/RAxML_bipartitionsBranchLabels.5_raxml_orm

Overall execution time for full ML analysis: 26175.386703 secs or 7.270941 hours or 0.302956 days

# Run 2
### Oreochromis removed before alignment
`raxmlHPC-PTHREADS-AVX -T 4 -n 9_orn -y -f a -# 100 -p 12345 -x 12345 -m GTRCAT -s 8_concat_orn.phy`


Using BFGS method to optimize GTR rate parameters, to disable this specify "--no-bfgs"


This is the RAxML Master Pthread

This is RAxML Worker Pthread Number: 1

This is RAxML Worker Pthread Number: 2

This is RAxML Worker Pthread Number: 3


This is RAxML version 8.2.12 released by Alexandros Stamatakis on May 2018.

With greatly appreciated code contributions by:
Andre Aberer      (HITS)
Simon Berger      (HITS)
Alexey Kozlov     (HITS)
Kassian Kobert    (HITS)
David Dao         (KIT and HITS)
Sarah Lutteropp   (KIT and HITS)
Nick Pattengale   (Sandia)
Wayne Pfeiffer    (SDSC)
Akifumi S. Tanabe (NRIFS)
Charlie Taylor    (UF)


Alignment has 183546 distinct alignment patterns

Proportion of gaps and completely undetermined characters in this alignment: 19.01%

RAxML rapid bootstrapping and subsequent ML search

Using 1 distinct models/data partitions with joint branch length optimization



Executing 100 rapid bootstrap inferences and thereafter a thorough ML search

All free model parameters will be estimated by RAxML
ML estimate of 25 per site rate categories

Likelihood of final tree will be evaluated and optimized under GAMMA

GAMMA Model parameters will be estimated up to an accuracy of 0.1000000000 Log Likelihood units

Partition: 0
Alignment Patterns: 183546
Name: No Name Provided
DataType: DNA
Substitution Matrix: GTR




RAxML was called as follows:

raxmlHPC-PTHREADS-AVX -T 4 -n 9_orn -y -f a -# 100 -p 12345 -x 12345 -m GTRCAT -s 8_concat_orn.phy



Time for BS model parameter optimization 33.455080

Overall Time for 100 Rapid Bootstraps 13080.321896 seconds
Average Time per Rapid Bootstrap 130.803219 seconds

Starting ML Search ...

Fast ML optimization finished

Fast ML search Time: 7143.790702 seconds

Slow ML search Time: 8357.142029 seconds
Thorough ML search Time: 1721.502587 seconds

Final ML Optimization Likelihood: -4158424.268684

Model Information:

Model Parameters of Partition 0, Name: No Name Provided, Type of Data: DNA
alpha: 0.162642
Tree-Length: 3.769670
rate A <-> C: 1.170090
rate A <-> G: 2.373026
rate A <-> T: 0.451135
rate C <-> G: 0.969291
rate C <-> T: 3.196682
rate G <-> T: 1.000000

freq pi(A): 0.242182
freq pi(C): 0.281774
freq pi(G): 0.284290
freq pi(T): 0.191754


ML search took 17222.438295 secs or 4.784011 hours

Combined Bootstrap and ML search took 30302.760418 secs or 8.417433 hours

Overall execution time for full ML analysis: 30302.787692 secs or 8.417441 hours or 0.350727 days
