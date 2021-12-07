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

1. Select samples and make txt file of Sxxx numbers save as `12_bowtie/test3/snum_list.txt`
  - will have to edit samples_suffix.sh to change what file it is reading with each new iteration

2. Run the following to get `sample_list.txt` to be used with SAMTOOLS later and to make specimen list.
  `cd 12_bowtie`
  `bash samples_suffix.sh`
  `sed "s/.........$//" test3/sample_list_suffix.txt > test3/sample_list_dup.txt`
  `sort -u test3/sample_list_dup.txt > test3/sample_list.txt`
  `rm sample_list_*.txt`

3. Make list of specimens and then make one tab delimited file named `specimen_list.txt` (genome and samplefile on same line). Genome in format: GSPP_UWCATNUM_SNUM with all "-" changed to "_", samplefile same as in sample_list. Do this by running:
  `cut -c27- test3/sample_list.txt | sed "s/.....$//" > test3/specimen_list_1.txt`
  `cat test3/specimen_list1.txt| awk '{gsub (/-/,"_")}1' > test3/specimen_list_2.txt`
  `paste -d "\t" test3/specimen_list2.txt test3/sample_list.txt > test3/specimen_list.txt`
  `rm test3/specimen_list_*.txt`

4. Check that the each snum is only found on one line meaning the columns match. If all it outputs is "Checking file" then file is good, otherwise will list "SNUM lines don't match"
  `bash specimen_list_check.sh`

5. Copy selected samples using sample_list.txt to test3/1_trimmed:
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
  `mkdir test3/3_sam_paired/`
  `bash bowtie_align.sh`
Test3 run of 15 started at 16:25 and ended at 18:00

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
``` bash
   for SAMPLEFILE in `cat test3/sample_list.txt`
   do
     samtools view -S -b -h -q 100 -m 30 test3/3_sam_paired/"${SAMPLEFILE}.sam" | \
     samtools sort - | \
     samtools rmdup -s - test3/4_bam/"${SAMPLEFILE}_sorted_rd.bam"
     samtools index test3/4_bam/"${SAMPLEFILE}_sorted_rd.bam"
     samtools view test3/4_bam/"${SAMPLEFILE}_sorted_rd.bam" | wc -l
   done
```
Run of 15 took ~3 minutes

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

### Using *bcftools version 1.9*, use *call* command to do SNP variant calling from VCF/BCF file created in the previous step (mpileup)

Usage:   bcftools call [options] <in.vcf.gz>

--variants-only            output variant sites only

--consensus-caller       command to call genotypes

--output-type <b|u|z|v>     output type: 'b' compressed BCF; 'u' uncompressed BCF; 'z' compressed VCF; 'v' uncompressed VCF [v]

--output <file>             write output to a file [standard output]

-A, --keep-alts              keep all possible alternate alleles at variant sites

-f, --format-fields <list>      output format fields: GQ,GP

``` bash
BAMDIR=/test/4_bam/ #directory with sorted, indexed, filtered .bam files
INFILE=mpileup_results.bcf #name of input file (created by previous step)
OUTDIR=/test/5_variants #directory for output files
OUTFILE=call_results.bcf #name for output file with ancient genotypes
####

cd test/5_variants
touch call_results.bcf

cd /test/4_bam/

bcftools call --variants-only \
--consensus-caller \
--keep-alts \
--format-fields GQ \
--output-type b \
--output ../5_variants/call_results.bcf \
mpileup_results.bcf
```

### Filter the genotypes for quality using *bcftools* and missing data using *vcftools*

I did this iteratively, starting with very permissive thresholds (MINQ== 30; missing data = 75%) and visualizing the distribution of samples and genotypes. I observed that relatively few individuals and SNPs were characterized by large amounts of low-quality or missing data, so I happily proceeded to filter the genotypes using more stringent thresholds (minQ==900; missing data = 20%, minDP= 10, min-meanDP =10, maf = 0.05). For the sake of brevity, I show the final filtering criteria here:

-- minQ 900:  QUAL > 900

--max-missing 0.8: filter out genotypes called in less than 80% of all samples (this syntax is kind of counter-intuitive, so be careful)

After filtering using these minQ 30 and max-missing 0.75, kept 2996 out of a possible 4638 Sites (unpaired)
After filtering using these minQ 30 and max-missing 0.75, kept 1478 out of a possible 2049 Sites (paired)

``` bash
DIR=test/5_variants # name of directory with bcf file containing genotype data
INFILE=call_results.bcf # name of input bcf file
BASEVCF=call_results.qual30.miss25 # 'basename' of filtered output vcf file (without extension)
VCF=call_results.qual30.miss25.recode.vcf # filtered output vcf file (with extension)
#####
cd test/5_variants

vcftools --bcf call_results.bcf \
--minQ 30 \
#--min-meanDP 10 \
#--minDP 10 \
--max-missing 0.75 \
#--maf 0.05 \
--recode \
--recode-INFO-all \
--out call_results.qual30.miss25

vcftools --vcf call_results.recode.vcf --min-alleles 3 #output a file with sites with more than 3 alleles

# Use vcftools to output some useful summary statistics for plotting

vcftools --vcf call_results.qual30.miss25.recode.vcf --depth
vcftools --vcf call_results.qual30.miss25.recode.vcf --site-mean-depth
vcftools --vcf call_results.qual30.miss25.recode.vcf --site-quality
vcftools --vcf call_results.qual30.miss25.recode.vcf --missing-indv
vcftools --vcf call_results.qual30.miss25.recode.vcf --missing-site
vcftools --vcf $GENOME --freq

```
### Couldn't get this to work/manually copy-paste for now

Fixed an irritating little issue with the first two lines of the vcf file
When you use the --consensus-caller model in bcftools, the vcf header lacks the following two header lines:

##fileformat=VCFv4.2

##FILTER=<ID=PASS,Description="All filters passed">

Thus, you have to copy and paste these header lines to the top of your vcf file before other programs can read in the vcf. This is how I did it:

``` bash
DIR=test/5_variants # name of directory with bcf file containing genotype data
INVCF=call_results.qual30.miss25.recode.vcf # name of input file (from previous step)
OUTVCF=call_results_filt.vcf
####
cd $DIR

sed '1 i\##fileformat=VCFv4.2##FILTER=<ID=PASS,Description="All filters passed">' call_results.qual30.miss25.recode.vcf>call_results_filt.vcf

less $OUTVCF #check the header, type q to quit less

```

## Step 5: Calculate individual observed Heterozygosity

As an attempt to see contamination we wanted to see if heterozygosity is out of whack for certain loci, so we need to calculate individual observed heterozygosity for each locus for each individual. Did this following Eleni's code:

### 1. Estimate individual observed heterozygosity using vcftools --het function

``` bash

# Specify the directory names and file names
BASEDIR=/12_bowtie/test #base directory
VCFDIR=test/5_variants #vcf directory
OUTDIR=test/6_heterozygosity # directory where output files should be saved

INFILE=call_results_filt.recode.vcf #name of input vcf
OUTFILE=call_results_filt #"base name" of output vcf (without .recode.vcf file extension)

######
vcftools --vcf 5_variants/call_results_filt.recode.vcf \
--het \
--out 6_heterozygosity/call_results_filt

```

### 2. plot the distribution of individual heterozygosity using R

``` r
# The purpose of this script is to make plots of individual heterozygosity calculated by vcftools --het

# Load libraries
library(tidyverse)
library(cowplot)

# Specify the directory containing the data tables:
DATADIR <- "G:/hybridization_capture/merged_analyses/heterozygosity"

# Setwd
setwd(DATADIR)

# specify input and output file names:
ancient_file <- "0002.filt.HWE.het"
modern_file <- "0003.filt.HWE.het"

outfile <- "observed_heterozygosity.pdf"

# read in the data
ancient_df <- read.delim(ancient_file)
modern_df <- read.delim(modern_file)

# calculate observed heterozygosity for each dataframe

ancient_df <- ancient_df %>%
  mutate(N_HET = (N_SITES-O.HOM.)) %>%
  mutate(OBS_HET = N_HET/N_SITES)


modern_df <- modern_df %>%
  mutate(N_HET = (N_SITES-O.HOM.)) %>%
  mutate(OBS_HET = N_HET/N_SITES)

# Plot the observed heterozygosity for each collection



(plot_anc <- ggplot(ancient_df, aes(x = OBS_HET)) +
  geom_histogram(binwidth = 0.01, fill = "#fc8d59") +
  theme_bw() +
  xlab("Observed individual heterozygosity") +
  xlim(0.20, 0.40) +
  ggtitle("Ancient herring"))

(plot_mod <- ggplot(modern_df, aes(x = OBS_HET)) +
  geom_histogram(binwidth = 0.01, fill = "#91bfdb") +
  theme_bw()+
  xlab("Observed individual heterozygosity")+
  xlim(0.20, 0.40)+
  ggtitle("Modern herring"))


# Merge the plots

(multi_plot <- plot_grid(plot_anc, plot_mod, labels = c('A', 'B'), label_size = 12))


# save plot to pdf file

ggsave(outfile,
  plot = multi_plot)
```

### 3. Take a look at the resulting plots

The distribution of observed heterozygosity is quite similar in the modern and ancient samples. Hurray!

![heterozygosity_plot](observed_heterozygosity.png)



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