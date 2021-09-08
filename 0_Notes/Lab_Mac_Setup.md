# Setting Up Lab Mac
***
##  Perl Scripts
* use `which perl` to determine what the shebang should be and where to put modules
* put Perl Modules in /usr/bin/perl
* change shebang on perl scripts to `#!/usr/bin/perl`
* create a folder called biotools in `/usr/local/bin/` and add to path following [Calder’s instructions](https://github.com/calderatta/ca-exon-capture/blob/master/Installation_Guide.md)
* move scripts with updated shebangs here using `sudo mv ~/pipeline_scripts/postprocess/*.pl /usr/local/bin/biotools/``
* **NOTE** Only the post processing scripts have been loaded on the Mac, since the assembly scripts need to be run on a cluster

### Scripts List
* *italicized* scripts have updated shebangs
assemble.pl		            flank_filter.pl		   *predict_frames.pl*
clocklikeness_test.pl	    gatk.sh			          reblast.pl
concat_loci.pl		        get_orthologues.pl	  rmdup.pl
consensus.pl		         *gunzip_Files.pl*	    sga_assemble.pl
construct_tree.pl	        mafft_aln.pl		      statistics.pl
count_reads_bases.pl	    map_statistics.pl	   *trim_adaptor.pl*
*demultiplex_inline.pl*	  merge.pl		          ubxandp.pl
detect_contamination.pl	  merge_loci.pl		      unixlb_unwarp.pl
exonerate_best.pl	        monophyly_test.pl	    vcftosnps.pl
filter.pl		              pick_taxa.pl


## Perl Modules
 * @INC for perl is `/Library/Perl/5.18` move all modules to here
 * download Moo from website and be sure to move from the `lib/` folder both `Moo.pm` `oo.pm` and the folders `Moo/` and `Method/`

## Cutadapt
* Run `python3 -m pip install --user --upgrade cutadapt`
	* Generated warning to add `/Users/luketornabene/Library/Python/3.9/bin` to PATH
	* Generated warning to update cutadapt using `python3 -m pip install --user --upgrade cutadapt`

## Note on Scripts
* based on running scriptname.pl -h all scripts are working *except*
	*  `clocklikeness_test.pl` - need to install the Statistics::Distributions module
	*  `gatk.sh` - need to install Java runtime (I think)
* downloaded [taxnameconvert.pl](http://www.cibiv.at/software/taxnameconvert/)

***
## Installing RAxML and ASTRAL  
* both installed
* RAxML has been added to path and can be called with `raxmlHPC-PTHREADS-AVX` *note: tab complete works after rax*
* Astral could not be added to path and instead can be run by `java -jar /Users/luketornabene/Astral/astral.5.7.3.jar`

***
## Git in Command line
Use when moving folders with lots of files (atom doesn't like to do this itself)
`git status` to make sure your changes are staged
`git commit -m "Commit message here"` to commit with in line commit message. Otherwise opens a text editor when moving a lot of files it's a mess. Use -m for in line.

## Homebrew
`/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
### Samtools with Homebrew
`brew install samtools`
### BWA with Homebrew
`brew install bwa`
### bowtie2 with Homebrew
`brew install bowtie2`
### vcftools with Homebrew
`brew install vcftools`
