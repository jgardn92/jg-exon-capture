#Post Processing Steps Notes
***
##Filter Data
* See R-markdown file for notes and work on this step
***
## Aligning
* mafft_align.pl
* install mafft 
	* NEED TO REMMEBER HOW I DID THIS  
* Change shebang on pipeline
* make sure Moo is installed properly
	* Error was Generate::Method::Constructor.pm module missing
* ran with code from [Calder's GitHub](https://github.com/calderatta/ca-exon-capture/blob/master/Exon_Capture_Pipeline.md#vi-aligning) 
	* used `--cpu 2`

## Alignment Filtering
* filter.pl
	* used `--cpu 2`
	* Message: `CAUTION: --trim_gap is disabled right now. --colgap_pct are turned off`
*Looked and did not find the `nf_filtered.numofgenescaptured.txt` file that Calder refers to so didn't move it out of the folder

## Summary Statistics
* statistics.pl
