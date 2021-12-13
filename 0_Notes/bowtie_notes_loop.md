# Bowtie2 For Heterozygosity
## Looping for multiple specimens after single specimen test
Code and notes adapted from [Calder's repo](https://github.com/calderatta/ca-exon-capture) and [Eleni's repo](https://github.com/EleniLPetrou/ancient_DNA_salish_sea)

## Test 2
After running bowtie2 on single sample, ran again with 5 samples
Two well behaved samples (C. amb 152101 from first run, L. gibbus 153834)
Three poorly behaved samples (Crystallichthyes 150847, Crystallichthyes 151026 C. faunus 117078)

## Test 3
Looped over 15 more samples to test the process

NOTE: for each iteration will need to make new test folder and replace that test folder name in various places in codes and scripts

## Step 1: Set up samples
Select samples and make names lists

1. Select samples and make txt file of Sxxx numbers save as `12_bowtie/test4_remaining/snum_list.txt`
  - Get all Snums from 1_trimmed using:
  `ls ../1_trimmed/ | cut -c40- | sed "s/..............$//" | sort -u | gsed 's/.*_//' > test4_remaining/all_snum.txt`
  - Remove Snums that were already run or didn't assemble (S435 and S436):
  ` grep -v -f test4_remaining/snums_already_done.txt test4_remaining/all_snum.txt > test4_remaining/snum_list.txt`
  - will have to edit samples_suffix.sh to change what file it is reading with each new iteration

2. Run the following to get `sample_list.txt` to be used with SAMTOOLS later and to make specimen list.
  `cd 12_bowtie`
  `bash samples_suffix.sh`
  `sed "s/.........$//" test4_remaining/sample_list_suffix.txt > test4_remaining/sample_list_dup.txt`
  `sort -u test4_remaining/sample_list_dup.txt > test4_remaining/sample_list.txt`
  `rm test4_remaining/sample_list_*.txt`

3. Make list of specimens and then make one tab delimited file named `specimen_list.txt` (genome and samplefile on same line). Genome in format: GSPP_UWCATNUM_SNUM with all "-" changed to "_", samplefile same as in sample_list. Do this by running:
  `cut -c27- test4_remaining/sample_list.txt | sed "s/.....$//" > test4_remaining/specimen_list_1.txt`
  `cat test4_remaining/specimen_list_1.txt| awk '{gsub (/-/,"_")}1' > test4_remaining/specimen_list_2.txt`
  `paste -d "\t" test4_remaining/specimen_list_2.txt test4_remaining/sample_list.txt > test4_remaining/specimen_list.txt`
  `rm test4_remaining/specimen_list_*.txt`

4. Check that the each snum is only found on one line meaning the columns match. If all it outputs is "Checking file" then file is good, otherwise will list "SNUM lines don't match"
  `bash specimen_list_check.sh`

5. **SKIP THIS STEP TO AVOID LARGE FILE REDUNDANCY.** - edited `bowtie_align.sh` to call directly from `jg-exon-capture/1_trimmed/`
  Copy selected samples using sample_list.txt to test3/1_trimmed:
  `mkdir test3/1_trimmed`
  `bash copy_trimmed.sh`

## Step 2: Align samples to the genome

### 1. Locate indexed "genome"
All pseudo-genomes put together and indexed in folder `12_bowtie/ref_genomes`

### 2. Align to genome:

   *bowtie2 -q -x <bt2-idx> -1 <m1> -2 <m2> -S <sam>*
    bowtie2 -x lambda_virus -1 $BT2_HOME/example/reads/reads_1.fq -2 $BT2_HOME/example/reads/reads_2.fq -S eg2.sam
   -q query input files are in fastq format

   -x <bt2-idx> Indexed "reference genome" filename prefix (minus trailing .X.bt2)

   -1 <m1> Files with 1 mates, paired with files in <m2>.
           Could be gzip'ed (extension: .gz) or bzip2'ed (extension: .bz2).
   -2 <m2> Files with 2 mates, paired with files in <m1>.
           Could be gzip'ed (extension: .gz) or bzip2'ed (extension: .bz2).

   -S <sam> File for SAM output (default: stdout)
   you can use 2> to redirect stdout to a file (bowtie writes the summary log files to stdout)

#### For all files need to Loop over each sample fastq file and align it to genome, then output a sam file
Edit `bowtie_align.sh` and change all references to appropriate test folder (change test2 to test3)
  `mkdir test4_remaining/3_sam_paired/`
  `bash bowtie_align.sh`
Test3 run of 15 started at 16:25 and ended at 18:00
Test4 run of 77 started at 12:32 and ended at 

## Step 3: Convert sam files to bam format, filter, remove PCR duplicates, and index bam files
Filter the bam files based on Eleni's settings using *samtools*:
  * remove any sequences shorter than 30 nucleotides long
  * remove sequences that have a mapping quality below 30
  * convert the files into bam format
  * sort and index the bam files.

   - samtools view: prints all alignments in the specified input alignment file (in SAM, BAM,  or  CRAM format) to standard output. Can use the samtools *view* command to convert a sam file to bam file

     -S: input file is in sam format

     -b: output file should be in bam format

     -q <integer>: discards reads whose mapping quality is below this number

     -m <integer>: only outputs alignments with the number of bases greater than or equal to the integer specified

     -h: Include the header in the output.

   - samtools sort : Sort alignments by leftmost coordinates

   - samtools rmdup : Remove potential PCR duplicates: if multiple read pairs have identical external coordinates, only retain the pair with highest mapping quality.

     -s : Remove duplicates for single-end reads. By default, the command works for paired-end reads only.

   - samtools index : Index a coordinate-sorted BAM or CRAM file for fast random access. Index the bam files to quickly extract alignments overlapping particular genomic regions. This index is needed when region arguments are used to limit samtools view and similar commands to particular regions of interest.

#### Loop for multiple
`mkdir test3/4_bam`
`bash samtools.sh`

samtools.sh currently set with -q 30 -m 30; ran previously with -q 100 and that filtered out everything
Run of 15 took from 13:33 - 13:40

## Step 4: Variant Calling and Filtering

## Variant calling in modern herring samples

Variant sites were identified using Eleni's code and the *mpileup* and *call* (--consensus-caller model) commands in *bcftools version 1.9* . Genotypes were filtered with *vcftools* (Danecek et al. 2011) for genotype quality (--minQ ???) and SNPs were removed from the data set if they were genotyped in fewer than ??% of samples, had a read depth and mean read depth that was below ?? sequences (--min-meanDP ??, --minDP ??), and were characterized by a minor allele frequency that was less than ?.?? (--maf ?.??).


### Using *bcftools version 1.9*, use *mpileup* command to create multi-way pileup and calculate genotype likelihoods.

explanation of terms:

mpileup:      multi-way pileup producing genotype likelihoods

--fasta-ref FILE    faidx indexed reference sequence file

--bam-list FILE     list of input BAM filenames, one per line

--skip-indels       do not perform indel calling

--output FILE       write output to FILE [standard output]

--output-type TYPE  'b' compressed BCF; 'u' uncompressed BCF; 'z' compressed VCF; 'v' uncompressed VCF [v]

--annotate: depth-related vcf tags are generated by mpileup, see bcftools mpileup --annotate ? for list.

FORMAT/AD   .. Allelic depth (Number=R,Type=Integer)
FORMAT/ADF  .. Allelic depths on the forward strand (Number=R,Type=Integer)
FORMAT/ADR  .. Allelic depths on the reverse strand (Number=R,Type=Integer)
FORMAT/DP   .. Number of high-quality bases (Number=1,Type=Integer)


INFO/AD     .. Total allelic depth (Number=R,Type=Integer)
INFO/ADF    .. Total allelic depths on the forward strand (Number=R,Type=Integer)
INFO/ADR    .. Total allelic depths on the reverse strand (Number=R,Type=Integer)






#1. Create list of bam files then add genomes

  `ls test3/4_bam/*.bam > test3/4_bam/mybamlist1.txt`
  `paste test3/specimen_list.txt test3/4_bam/mybamlist1.txt | awk '{$2=""; print $0}' > test3/4_bam/mybamlist.txt`
  `rm test3/4_bam/mybamlist1.txt`
#2. Create multi-way pileup
Use script `mpileup.sh`
Run of 15 took about 1 minute

### Using *bcftools version 1.9*, use *call* command to do SNP variant calling from VCF/BCF file created in the previous step (mpileup)

Usage:   bcftools call [options] <in.vcf.gz>

--variants-only            output variant sites only

--consensus-caller       command to call genotypes

--output-type <b|u|z|v>     output type: 'b' compressed BCF; 'u' uncompressed BCF; 'z' compressed VCF; 'v' uncompressed VCF [v]

--output <file>             write output to a file [standard output]

-A, --keep-alts              keep all possible alternate alleles at variant sites

-f, --format-fields <list>      output format fields: GQ,GP

run this using `bcftools_call.sh`
`mkdir test3/5_variants`
`bash bcftools_call.sh`

runs very quickly (<20 seconds for run of 15)
### Filter the genotypes for quality using *bcftools* and missing data using *vcftools*

I did this iteratively, starting with very permissive thresholds (MINQ== 30; missing data = 75%) and visualizing the distribution of samples and genotypes. I observed that relatively few individuals and SNPs were characterized by large amounts of low-quality or missing data, so I happily proceeded to filter the genotypes using more stringent thresholds (minQ==900; missing data = 20%, minDP= 10, min-meanDP =10, maf = 0.05). For the sake of brevity, I show the final filtering criteria here:

-- minQ 900:  QUAL > 900

--max-missing 0.8: filter out genotypes called in less than 80% of all samples (this syntax is kind of counter-intuitive, so be careful)

`bash vcftools_recode.sh`
runs very quickly (<10 seconds for run of 15)

#### Use vcftools to output some useful summary statistics for plotting
Don't have to run this because plotting in R from vcf file not summaries  but to run:
`bash vcftools_files.sh`
Note: not run yet for test3 as of 12/6/21

### Add lines to vcf files so R can read them
Fixed an irritating little issue with the first two lines of the vcf file
When you use the --consensus-caller model in bcftools, the vcf header lacks the following two header lines:

Thus, you have to copy and paste these header lines to the top of your vcf file before other programs can read in the vcf.
Use `vcf_filelines.sh` to do it

  `mkdir test3/6_recoded_vcfs`
  `bash vcf_filelines.sh`
runs very quickly (<10 seconds for run of 15)

# Run again with 4 samples
Two samples that are well behaved in tree (C. amb 152101 from first run, L. gibbus 153834)
and two samples that are poorly behaved (Crystallichthyes 150847, C. faunus 117078)



# 11/16/21 Notes
- Mpileup assumes diploid, need to figure out how to remove this constraint
  - run a handful of genes with ploidy not set and then ploidy 3

- VCF parser to get allele depth-INFO AD and then (FORMAT DP for high quality reads)
  - use this to hand calculate allelic frequency distribution and see what this looks like for each individual
  - filter out sites with high quality read depth less than 20

- Then can use `check-ploidy` to see if there is anything not diploid
    `bcftools +check-ploidy file.bcf`

- Use alignment from Luke to make raxml tree for COI
  - COI flag to check for labeling errors

- take a single species from Calder's data and run it through to see allelic read occurrence
  - email calder and ask about one good (not contam) spp and need raw data and assembly
