# Workflow and Folder Description

#### 1_assemblednew
zip results from assembly run by Calder in spring 2020 on Shanghai cluster

#### 2_assemble_result
unzip results from assembly run by Calder in spring 2020 on Shanghai cluster

#### 2_assemble_result_supp
Supplemental information about assembly run
***

## Run 1
50% filter (49 samples), aligned and filtered to Oreochromis
* Filtering notes in 0_Notes/filter-step.Rmd

#### 3_nf_aligned
Results of alignment to Oreochromis after removing genes represented in fewer than 49 samples

#### 4_nf_filtered
Results of alignment filtering check against alignment to Oreochromis

***
## Run 2
50% filter (49 samples), Oreochromis removed before alignment. Aligned samples not filtered.
***

## To Do
* work on using renaming script
* work on redoing alignment with stricter first filtering
* work on script to remove aligned sites that have too few represented...

## Run 3
Retry aligning without Oreochromis and with min seq 69 instead of 49
#### 10_nf_v2
Results from pick taxa run removing Oreochromis and selected genes present in 69 samples minimum
`pick_taxa.pl --indir 2_assemble_result/nf --outdir 10_nf_v2 --min_seq 69 --deselected_tax "Oreochromis_niloticus"`
#### 11_nf_v2_aligned
Resutls from alignment of 10_nf_v2
`mafft_aln.pl --dna_unaligned 10_nf_v2 --dna_aligned 11_nf_v2_aligned --cpu 2`

#### 14_RAxML_nf_v2_nogap
raxml run on 12_concat_filtered.fas, which is full concatinated alignment from run 3 but with sites with >50% missing data removed using delete_gaps.R
