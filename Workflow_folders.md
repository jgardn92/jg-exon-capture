# Workflow and Folder Description

## Supplemental Folders

#### 0_Notes
Meeting notes, filter 1 notes, pipeline running note for both Mac and PC, and tree relabeling notes.

#### 0_Other
*Filter2_attempts* folder containing attempts to run filter 2 where samples are filtered without needing Oreochromis in the Alignment

*standard-RAxML-master* files from RAxML download

*taxnameconvert-2.4* files from taxnameconvert download

*convert_names_CA.md* Calder's convert names Description

*rm_ORENILO.R* Calder's script to remove Oreochromis from each gene file after alignment and filter.pl

#### rename_table.txt
Tab delimited file for relabeling tree files using taxnameconvert
***

#### 1_assemblednew
zip results from assembly run by Calder in spring 2020 on Shanghai cluster

#### 2_assemble_result
unzip results from assembly run by Calder in spring 2020 on Shanghai cluster

#### 2_assemble_result_supp
Supplemental information about assembly run
***

## 3_Run_1
50% filter (49 samples), aligned and filtered to Oreochromis
* Filtering notes in 0_Notes/filter-step.Rmd

#### 3_nf_aligned
Results of alignment to Oreochromis after removing genes represented in fewer than 49 samples

#### 4_nf_filtered
Results of alignment filtering check against alignment to Oreochromis

#### 4_nf_filtered_supp
Summary statitics from filter fun

#### 4_nf_rm_poor
Results of pick_taxa.pl??

#### 5_concatinate_on_align
Concatinated samples from run 1

#### 5_RAxMLonCipres
Results from RAxML runs done on concatinations from run 1, run on Cipres portal

## Run 1.5 (located in 3_Run_1)

#### 6_RAxML_concate_onr
Concatinated file and results from RAxML run on file where Oreochromis was  removed from concatination after alignment and filtering.
***

## 4_Run_2
50% filter (49 samples), Oreochromis removed before alignment. Aligned samples not filtered.

#### 7_nf_aligned_orn
Alignment results after Oreochromis removed in pick_taxa.pl.

#### 7_nf_aligned_orn_supp
Number of genes captured file for run 2

#### 8_concatinate_orn_rm
Concatination files for samples in run 2 (7_nf_aligned_orn)

#### 9_RAxML_orn_rm
RAxML runs on concatinated files in 8_concatinate_orn_rm

#### 9_RAxML_consensus_tree
Concsensus tree runs from bootstrap trees produced in 9_RAxML_orn_rm to collapse nodes with low support and get a better idea about potential contamination.
***

## 5_Run_3
Retry aligning without Oreochromis and with min seq 69 instead of 49

#### 10_nf_v2
Results from pick taxa run removing Oreochromis and selected genes present in 69 samples minimum
`pick_taxa.pl --indir 2_assemble_result/nf --outdir 10_nf_v2 --min_seq 69 --deselected_tax "Oreochromis_niloticus"`

#### 11_nf_v2_aligned
Resutls from alignment of 10_nf_v2
`mafft_aln.pl --dna_unaligned 10_nf_v2 --dna_aligned 11_nf_v2_aligned --cpu 2`

#### 12_concatinate_v2
Concatination files from run 3.

#### 13_RAxML_nf_v2
RAxML results from concatinated file in 12_concatinate_v2

## Run 3.5 (located in 5_Run_3)

#### 14_RAxML_nf_v2_nogap
raxml run on 12_concat_filtered.fas, which is full concatinated alignment from run 3 but with sites with >50% missing data removed using delete_gaps.R (in 0_Other -> Filter2_attempts)
***

## 6_Detect_Contamination
Runs of detect_contamination.pl to determine if samples are contaminated and should be removed

#### 15_Detect_Contam
*contamination_stat.txt* results of pipeline run on *detect_contam.txt*

*detect_contam.txt* only samples from same species listed on same Aligned

*detect_contam2.txt* samples with more relatedness listed on same lines

*detect_contam3.txt* samples grouped based on clades in Clades.csv file
***

## 7_Run_4

#### 16_nf_r4
Results from pick taxa run removing Oreochromis and contaminated samples determined from running detect_contamination.pl with detect_contam3. Selected genes present in 49 samples minimum
`pick_taxa.pl --indir 2_assemble_result/nf --outdir 16_nf_r4 --min_seq 49 --deselected_tax "Oreochromis_niloticus ATAN_UW150813_S404 AUNA_UW150790_S402 AUNA_UW150804_S403 CSIM_UW154482_2_S421 CSTA_UW155711_S387"`

#### 17_nf_r4_aligned
Resutls from alignment of 16_nf_r4
`mafft_aln.pl --dna_unaligned 16_nf_r4 --dna_aligned 17_nf_r4_aligned --cpu 2`

#### 18_concatinate_r4
Concatination files and num of genes captured file from run 4.
`concat_loci.pl --indir 17_nf_r4_aligned --outfile 18_concat`

#### 19_RAxML_nf_r4
RAxML results from concatinated file in 18_concatinate_r4
`raxmlHPC-PTHREADS-AVX -T 4 -n 19_r4 -y -f a -# 100 -p 12345 -x 12345 -m GTRCAT -s 18_concatinate_r4/18_concat.phy `

#### 20_RAxML_nf_r4k
RAxML results from concatinated file in 18_concatinate_r4 with `-k` to print bootstrap trees with branch lengths to preserve branch lengths on consensus tree (I think...)
`raxmlHPC-PTHREADS-AVX -T 4 -n run4k -y -f a -# 100 -p 12345 -x 12345 -m GTRCAT -k -s 18_concatinate_r4/18_concat.phy `


## 8_Run_5

#### 21_nf_r5
Results from pick axa run removing Oreochromis and contaminated samples determined from detect contamination **and** samples contaminated based on Run 4 tree
`pick_taxa.pl --indir 2_assemble_result/nf --outdir 21_nf_r5 --min_seq 49 --deselected_tax "Oreochromis_niloticus ATAN_UW150813_S404 AUNA_UW150790_S402 AUNA_UW150804_S403 CSIM_UW154482_2_S421 CSTA_UW155711_S387 CCYC_UW151026_S409 PMEN_UW150606_S400 PROS_UW153323_S419"`

#### 22_nf_r5_aligned
Resutls from alignment of 21_nf_r5
`mafft_aln.pl --dna_unaligned 21_nf_r5 --dna_aligned 22_nf_r5_aligned --cpu 2`

#### 23_concatinate_r5
Concatination files and num of genes captured file from run 5.
`concat_loci.pl --indir 22_nf_r5_aligned --outfile 23_concat`

#### 24_RAxML_nf_r5
RAxML results from concatinated file in 18_concatinate_r4
`raxmlHPC-PTHREADS-AVX -T 4 -n 24_r5 -y -f a -# 100 -p 12345 -x 12345 -m GTRCAT -k -s 23_concatinate_r5/23_concat.phy `

## 9_Run_6

#### 25_nf_r6
Results from pick axa run removing Oreochromis and contaminated samples determined from detect contamination **and** samples contaminated based on Run 4 tree **and** samples contaminated based on Run 5 tree
`pick_taxa.pl --indir 2_assemble_result/nf --outdir 25_nf_r6 --min_seq 49 --deselected_tax "Oreochromis_niloticus ATAN_UW150813_S404 AUNA_UW150790_S402 AUNA_UW150804_S403 CSIM_UW154482_2_S421 CSTA_UW155711_S387 CCYC_UW151026_S409 PMEN_UW150606_S400 PROS_UW153323_S419 AJOR_UW153152_S416 RBAR_UW157184_S476 LNAN_UW119179_2_S452 CCYC_UW150847_S408 LCUR_UW44504_S439"`

#### 26_nf_r6_aligned
Resutls from alignment of 25_nf_r6
`mafft_aln.pl --dna_unaligned 25_nf_r6 --dna_aligned 26_nf_r6_aligned --cpu 4`

#### 27_concatinate_r6
Concatination files and num of genes captured file from run 5.
`concat_loci.pl --indir 26_nf_r6_aligned --outfile 27_concat`

#### 28_RAxML_nf_r6
RAxML results from concatinated file in 18_concatinate_r4
`raxmlHPC-PTHREADS-AVX -T 4 -n 28_r6 -y -f a -# 100 -p 12345 -x 12345 -m GTRCAT -s 27_concatinate_r6/27_concat.phy `
