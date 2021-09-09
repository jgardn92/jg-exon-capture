# Bowtie2 For Heterozygosity
Code and notes adapted from [Calder's repo](https://github.com/calderatta/ca-exon-capture) and [Eleni's repo](https://github.com/EleniLPetrou/ancient_DNA_salish_sea)

## Step 0: Set up
Test samples in `12_bowtie/test/0_raw`:
lane7-s409-index-ACGAACTT-CCYC_UW151026_S409_L007_R2_001.fastq.gz (largest single raw sample)
lane7-s409-index-ACGAACTT-CCYC_UW151026_S409_L007_R1_001.fastq.gz
lane8-s459-index-GGTAGAAT-CAMB_UW152101_S459_L008_R2_001.fastq.gz
lane8-s459-index-GGTAGAAT-CAMB_UW152101_S459_L008_R1_001.fastq.gz

Run `gunzip -k *.fastq.gz`
Run `rm *fastq.gz` to keep only unzipped files

## Step 1: Trim Adapters

### 1. Rename merged files as .fq
The input files for `trim_adaptor.pl` must be .fq, NOT .fastq and must have the _001 preceding the .fastq removed (`merge` step does this but if no merge step use the script below), so in `merge` (or `raw` if there was no merge step) run:

    `(for file in *_001.fastq; do mv "$file" "$(basename "$file" _001.fastq).fq"; done)`

Output:
`sample_name_R1.fq`
`sample_name_R2.fq`

### 2. Trim adapters
*** Best to run on a supercomputer (see instructions on using HYAK/MOX) ***

Check the options for `trim_adaptor.pl` by adding the help flag `-h` and to make sure the script works. You should do this for all of the custom perl scripts (.pl files) going forward.

    `trim_adaptor.pl -h`

In your home directory run the following:

    `trim_adaptor.pl \
    --raw_reads input \
    --trimmed output`

Example:

    `trim_adaptor.pl --raw_reads 0_raw --trimmed 1_trimmed`

The output will be in the directory `trimmed`. This will also produce report files `trimmed_reads_bases_count.txt` and `trimming_report/sample_name_trimming_report.txt`. To clean these file up into a new directory `trimmed_supp` run:

    `mkdir 2_trimmed_supp
    mv trimmed_reads_bases_count.txt 2_trimmed_supp/
    mv trimming_report 2_trimmed_supp/`

### 3. Quality control of sequencing data using *FastQC*
It is always a great idea to look at the demultiplexed fastq files and verify that:
  * data quality looks good
  * there are no adapters still hanging around the sequencing data

Eleni did this using the program *FastQC*. Explanation of *FastQC* arguments used:

    -f : Bypasses the normal sequence file format  detection  and  forces
                  the  program  to  use  the  specified format.  Valid formats are
                  bam,sam,bam_mapped,sam_mapped and fastq

    -o : Create all output  files  in  the  specified  output  directory.
                  Please  note  that this directory must exist as the program will
                  not create it.  If this option is not set then the  output  file
                  for  each  sequence file is created in the same directory as the
                  sequence file which was processed.

In home directory make new file for fastqc results:
  `mkdir 2_trimmed_fastqc`
In 1_trimmed rename files to .fastq instead of .fq
  `(for file in *.fq; do mv "$file" "$(basename "$file" .fq).fastq"; done)`
Then run fastqc for every file in directory
  `for FILE in 1_trimmed/*.fastq # for any file ending in .fastq in this directory
  do
  fastqc -f fastq --extract -o 2_trimmed_fastqc $FILE
  done`

Verify that sequencing qulaity is good and adapaters are not present. For an example see [Eleni's repo](https://github.com/EleniLPetrou/ancient_DNA_salish_sea/blob/main/scripts/step1_process_ancient_raw_data.md)

CCYC_UW151026_S409_L007_R1_001 quality ok but not great
CCYC_UW151026_S409_L007_R2_001 quality poor
CAMB_UW152101_S459_L008_R1_001 quality good
CAMB_UW152101_S459_L008_R2_001 quality ok but not great

### Use CAMB for test going forward

## Step 2: Align samples to the genome
- Use assembled genes as reference genome for each individual

### Explanation of terms:

   *bowtie2 -q -x <bt2-idx> -U <r> -S <sam>*

   -q query input files are in fastq format

   -x <bt2-idx> Indexed "reference genome" filename prefix (minus trailing .X.bt2)

   -U <r> Files with unpaired reads.

   -S <sam> File for SAM output (default: stdout)
   you can use 2> to redirect stdout to a file (bowtie writes the summary log files to stdout)



   ``` bash

   #Directories and files

   BASEDIR=/media/ubuntu/Herring_aDNA/hybridization_capture/ancient_samples
   SAMPLELIST=$BASEDIR/sample_lists/sample_list.txt # Path to a text file with list of prefixes of the fastq files, separated by newline (so, the file name with no extension).
   FASTQDIR=$BASEDIR'/'trimmed_fastq # Path to folder containing fastq files.
   GENOMEDIR=/media/ubuntu/Herring_aDNA/atlantic_herring_genome # Path to folder with genome.
   GENOME=GCA_900700415 #genome prefix
   OUTPUTDIR=$BASEDIR'/'sam # path to folder with sam files (output)


   # Command

   # Loop over each sample fastq file and align it to genome, then output a sam file

   for SAMPLEFILE in `cat $SAMPLELIST`
   do
     bowtie2 -q -x $GENOMEDIR'/'$GENOME -U $FASTQDIR'/'$SAMPLEFILE.fastq -S $OUTPUTDIR'/'$SAMPLEFILE.sam
   done

   ```


## Step 3: Convert sam files to bam format, filter, remove PCR duplicates, and index bam files
   Next, I filtered the bam files. I removed any sequences that were shorter than 30 nucleotides long, removed sequences that had a mapping quality below 30, converted the files into bam format, and then sorted and indexed the bam files. All this was done using using *samtools*

   - samtools view: prints all alignments in the specified input alignment file (in SAM, BAM,  or  CRAM format) to standard output. Can use the samtools *view* command to convert a sam file to bam file

     -S: input file is in sam format

     -b: output file should be in bam format

     -q <integer>: discards reads whose mapping quality is below this number

     -m <integer>: only outputs alignments with the number of bases greater than or equal to the integer specified

     -h: Include the header in the output.

   - samtools sort : Sort alignments by leftmost coordinates

   - samtools rmdup : Remove potential PCR duplicates: if multiple read pairs have identical external coordinates, only retain the pair with highest mapping quality.

     -s : Remove duplicates for single-end reads. By default, the command works for paired-end reads only.

   - samtools index : Index a coordinate-sorted BAM or CRAM file for fast random access. Index the bam files to quickly extract alignments overlapping particular genomic regions.This index is needed when region arguments are used to limit samtools view and similar commands to particular regions of interest.


   ``` bash
   # Directories and files
   BASEDIR=/media/ubuntu/Herring_aDNA/hybridization_capture/ancient_samples
   SAMPLELIST=$BASEDIR/sample_lists/sample_list.txt # Path to a text file with list of prefixes of the fastq files, separated by newline (so, the file name with no extension).
   SAMDIR=$BASEDIR'/'sam # path to folder with sam files (input)
   BAMDIR=$BASEDIR'/'bam # path to folder with bam files (output)

   # Command
   for SAMPLEFILE in `cat $SAMPLELIST`
   do
     samtools view -S -b -h -q 30 -m 30 $SAMDIR'/'$SAMPLEFILE.sam | \
     # using a unix pipe (input file is taken from previous step and designated by '-')
     samtools sort - | \
     samtools rmdup -s - $BAMDIR'/'${SAMPLEFILE}'_sorted_rd.bam'
     samtools index $BAMDIR'/'${SAMPLEFILE}'_sorted_rd.bam'
     samtools view $BAMDIR'/'${SAMPLEFILE}'_sorted_rd.bam' | wc -l # count the number of alignments
   done

   ```
## Step 4: Calculate individual observed Heterozygosity

# Calculate individual observed heterozygosity

As a quality-control check (to verify that heterozygous sites were not being undercalled in the ancient samples), I decided to calculate individual observed heterozygosity
for the ancient samples and modern samples. Here is what I did:

#### Estimate individual observed heterozygosity using vcftools --het function

``` bash

# Use vcftools to estimate individual heterozygosity in modern and ancient samples

This script shows how I did it for the modern samples (prefix 0003)

# Specify the directory names and file names
BASEDIR=/media/ubuntu/Herring_aDNA/hybridization_capture/merged_analyses #base directory
VCFDIR=$BASEDIR'/'variants_filtered #vcf directory
OUTDIR=$BASEDIR'/'heterozygosity # directory where output files should be saved

INFILE=0003.filt.HWE.recode.vcf #name of input vcf
OUTFILE=0003.filt.HWE #"base name" of output vcf (without .recode.vcf file extension)

######
vcftools --vcf $VCFDIR'/'$INFILE \
--het \
--out $OUTDIR'/'$OUTFILE

```

#### plot the distribution of individual heterozygosity using R

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

## Take a look at the resulting plots

The distribution of observed heterozygosity is quite similar in the modern and ancient samples. Hurray!

![heterozygosity_plot](observed_heterozygosity.png)
