 #Post Processing Steps Notes
***
##Filter Data
* See R-markdown file for notes and work on this step
* Use
    `pick_taxa2.pl --indir 2_assemble_result/nf --outdir 3_nf_rm_orn --min_seq 49 --deselected_taxa 'Oreochromis_niloticus'`
***
## Aligning
* mafft_align.pl
* install mafft
	* NEED TO REMMEBER HOW I DID THIS  
* Change shebang on pipeline
* make sure Moo is installed properly
	* Error was Generate::Method::Constructor.pm module missing
	* download Moo-2.004000 from Cpan -> cp the Method folder to the same location as other perl modules
* ran with code from [Calder's GitHub](https://github.com/calderatta/ca-exon-capture/blob/master/Exon_Capture_Pipeline.md#vi-aligning)
	* used `--cpu 2`
	* `mafft_aln2.pl --dna_unaligned 3_nf_rm_orn --dna_aligned 4_nf_aligned_onr --cpu 2`

## Alignment Filtering
* filter.pl
	* used `--cpu 2`
	* Message: `CAUTION: --trim_gap is disabled right now. --colgap_pct are turned off`
*Looked and did not find the `nf_filtered.numofgenescaptured.txt` file that Calder refers to so didn't move it out of the folder

## Summary Statistics
* statistics.pl

## Constructing Gene trees
Need to edit construct_tree.pl to call my version of RAxML. Currently calling raxmlHPC-SSE3. Need to call raxmlHPC-PTHREADS-AVX.
