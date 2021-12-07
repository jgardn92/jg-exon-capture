# Bowtie2 For Heterozygosity
## Single Specimen Test
Code and notes adapted from [Calder's repo](https://github.com/calderatta/ca-exon-capture) and [Eleni's repo](https://github.com/EleniLPetrou/ancient_DNA_salish_sea)

## Step 0: Set up
Test samples in `12_bowtie/test1/0_raw`:  
lane7-s409-index-ACGAACTT-CCYC_UW151026_S409_L007_R2_001.fastq.gz (largest single raw sample)  
lane7-s409-index-ACGAACTT-CCYC_UW151026_S409_L007_R1_001.fastq.gz  
lane8-s459-index-GGTAGAAT-CAMB_UW152101_S459_L008_R2_001.fastq.gz  
lane8-s459-index-GGTAGAAT-CAMB_UW152101_S459_L008_R1_001.fastq.gz  

Moved anything that wasn't raw samples to be unzipped to 0_raw/0_raw/extras including 4 fastq.gz files of 2 samples that didn't get assembled.

Run `gunzip -k *.fastq.gz`  
Run `mv *fastq.gz zipped` to keep only unzipped files in raw folder and save another folder with zipped files (plan is to delete unzipped files after trimming to save space)

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

    `trim_adaptor.pl --raw_reads 0_raw/0_raw --trimmed 1_trimmed`

The output will be in the directory `trimmed`. This will also produce report files `trimmed_reads_bases_count.txt` and `trimming_report/sample_name_trimming_report.txt`. To clean these file up into a new directory `trimmed_supp` run:

    `mkdir 2_trimmed_supp
    mv trimmed_reads_bases_count.txt 2_trimmed_supp/
    mv trimming_report 2_trimmed_supp/`

Note: ran on everything and have 194 files in `1_trimmed` but generated the following error a bunch
      Use of uninitialized value $R1_all_bases in addition (+) at /usr/local/bin/biotools/trim_adaptor.pl line 110.
      Use of uninitialized value $R2_all_reads in addition (+) at /usr/local/bin/biotools/trim_adaptor.pl line 111.

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

    `mkdir 1_trimmed_fastqc`

In 1_trimmed rename files to .fastq instead of .fq

    `(for file in *.fq; do mv "$file" "$(basename "$file" .fq).fastq"; done)`

Then run fastqc for every file in directory

    `for FILE in 1_trimmed/*.fastq
    do
    fastqc -f fastq --extract -o 1_trimmed_fastqc $FILE
    done`

Verify that sequencing quality is good and adapters are not present. For an example see [Eleni's repo](https://github.com/EleniLPetrou/ancient_DNA_salish_sea/blob/main/scripts/step1_process_ancient_raw_data.md)

CCYC_UW151026_S409_L007_R1_001 quality ok but not great  
CCYC_UW151026_S409_L007_R2_001 quality poor  
CAMB_UW152101_S459_L008_R1_001 quality good  
CAMB_UW152101_S459_L008_R2_001 quality ok but not great  

Note: Ran for all, results in `1_trimmed_fastqc`; results best viewed on GitHub in broswer

### Use CAMB for test going forward

## Step 2: Align samples to the genome

### 1. Assemble and index "genome"

#### Get reference genomes by taking locixspecies files and making them speciesxloci
Make a file with the name of all genes in 2_assemble_result/nf/ in the main folder (cd to main folder)
    `ls 2_assemble_result/nf > assembled_loci.txt`

Copy file with sample names from supplemental assembly results
    `cp 2_assemble_result_supp/samplelist.txt specimen_list.txt`

Run pseudo_genome_loop.sh script to get data for CAMB_UW152101_S459 out of each file

    `bash pseudo_genome_loop.sh`

Make sure it worked (should have 99 files with the largest being roughly the same as the largest raw files)
    `ls 12_bowtie/ref_genomes/fastas/ | wc -l` #should be 97 and is

Compare sizes by making txt files with sizes and then comparing in a [google sheet](https://docs.google.com/spreadsheets/d/1qvlXr-OaZlDfOPI9fQfhSmWmPACXwDxz9HZ__DgSMuw/edit?usp=sharing)
    `ls -l 0_raw/0_raw/*.fastq.gz > 12_bowtie/ref_genomes/raw_size.txt`
    `ls -l 12_bowtie/ref_genomes/fastas/*.fasta > 12_bowtie/ref_genomes/pseudo_size.txt`
Some are a little different but generally seems ok

#### Index "genome" files using bowtie


``` bash
    (for SPECIMEN in `cat specimen_list.txt`; do bowtie2-build fastas/"${SPECIMEN}.fasta" indexed/${SPECIMEN}; done)
```

Note: all pseudo-genomes assembed and indexed in `12_bowtie/ref_genomes
`
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

#### For Single Test file

    bowtie2 -q -x ref_genomes/CAMB_UW152101_S459 \
            -1 test/1_trimmed/lane8-s459-index-GGTAGAAT-CAMB_UW152101_S459_L008_R1.fastq \
            -2 -1 test/1_trimmed/lane8-s459-index-GGTAGAAT-CAMB_UW152101_S459_L008_R2.fastq \
            -S test/3_sam_paired/lane8-s459-index-GGTAGAAT-CAMB_UW152101_S459_L008.sam

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

#### For Single Test file

samtools view -S -b -h -q 30 -m 30 test/3_sam_paired/lane8-s459-index-GGTAGAAT-CAMB_UW152101_S459_L008.sam | \
samtools sort - | \
samtools rmdup -s - test/4_bam_paired/lane8-s459-index-GGTAGAAT-CAMB_UW152101_S459_L008_sorted_rd.bam
samtools index test/4_bam_paired/lane8-s459-index-GGTAGAAT-CAMB_UW152101_S459_L008_sorted_rd.bam
samtools view test/4_bam_paired/lane8-s459-index-GGTAGAAT-CAMB_UW152101_S459_L008_sorted_rd.bam | wc -l

samtools view -S -b -h -q 30 -m 30 test2/3_sam_paired/lane8-s459-index-GGTAGAAT-CAMB_UW152101_S459_L008.sam | \
samtools sort - | \
samtools rmdup -s - test2/4_bam/lane8-s459-index-GGTAGAAT-CAMB_UW152101_S459_L008_sorted_rd.bam
samtools index test2/4_bam/lane8-s459-index-GGTAGAAT-CAMB_UW152101_S459_L008_sorted_rd.bam
samtools view test2/4_bam/lane8-s459-index-GGTAGAAT-CAMB_UW152101_S459_L008_sorted_rd.bam | wc -l

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

#1. Create list of bam files and save to a txt file:
```bash
    ls test1/4_bam_paired/*.bam > test/4_bam_paired/mybamlist_paired.txt #had to add test2/4_bam/ before each file name to make it work
```
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