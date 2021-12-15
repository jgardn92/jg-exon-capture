# Bowtie2 For Heterozygosity
## Running on three samples of Calder's data to double check method
Code and notes adapted from [Calder's repo](https://github.com/calderatta/ca-exon-capture) and [Eleni's repo](https://github.com/EleniLPetrou/ancient_DNA_salish_sea)

## Step 0: Set up
`cd test5_calder` - pretty much all of this will be run in the test5_calder folder to keep the ref_genomes separate.

Selected samples of Calder's that should work because the raw reads are ~10 million which is roughly the average of my cleaned reads from `1_trimmed_supp/trimmed_reads_bases_count.txt`
  - ACANADU_UW118829_S45
  - PLEQUAD_UW151438_S22
  - PSEMELA_UW154235_S57

Run `gunzip *.fastq.gz` on zipped raw files
Run `tar -xzvf 2_assemble_result/round1_assemble_result.tar.gz` to unzip assembly files

## Step 1: Trim Adapters
Didn't trim adapters because files listed as trimmed in Calder's folder.
Verified with FastQC that no adapters present. Good to move ahead with analysis

### 1. Quality control of sequencing data using *FastQC*
    `mkdir 1_trimmed_fastqc`
    `cd 1_trimmed_zipped`
    `(for file in *.fq; do mv "$file" "$(basename "$file" .fq).fastq"; done)`
    `cd ../`

Then run fastqc for every file in directory

    `for FILE in 1_trimmed_zipped/*.fastq
    do
    fastqc -f fastq --extract -o 1_trimmed_fastqc $FILE
    done`


## Step 2: Align samples to the genome

### 1. Assemble and index "genome"

#### Get reference genomes by taking locixspecies files and making them speciesxloci
    `ls 3_assemble_result/nf > assembled_loci.txt`
Make file with the three chosen sample names and save as `test5_calder/specimen_list.txt`
    `mkdir ref_genomes`
    `mkdir ref_genomes/fastas`

Edited `pseudo_genome_loop.sh` to work for Calder's in test5 folder and saved as `test5_calder/pseudo_genome_loop_calder.sh`

    `bash pseudo_genome_loop_calder.sh`

Make sure it worked (should have 3 files)
    `ls 12_bowtie/ref_genomes/fastas/``

Compare gene counts to column M in file Calder sent by:
    `cat ref_genomes/fastas/ACANADU_UW118829_S45.fasta| wc -l` and divide given number by 2 to get genes. All three files checked and matched column M.

#### Index "genome" files using bowtie

        `(for SPECIMEN in `cat specimen_list.txt`; do bowtie2-build fastas/"${SPECIMEN}.fasta" indexed/${SPECIMEN}; done)`

## Step 3: Set up samples
Select samples and make names lists

Don't need to do the list making step because Calder's file names already simplified so the file name with the _R1.fastq ending is the same as the genome name.

## Step 2: Align samples to the genome

### 1. Locate indexed "genome"
All pseudo-genomes put together and indexed in folder `test5_calder/ref_genomes`

### 2. Align to genome:

Use `bowtie_align_calder.sh` because naming convention slightly different for these files.
  `mkdir 3_sam_paired/`
  `bash bowtie_align_calder.sh`

## Step 3: Convert sam files to bam format, filter, remove PCR duplicates, and index bam files
Edit script for Calder's for naming convention
  `mkdir 4_bam`
  `bash samtools_calder.sh`

samtools_calder.sh currently set with -q 30 -m 30 to match snailfish runs

## Step 4: Variant Calling and Filtering

### 1. Create list of bam files then add genomes

  `ls 4_bam/*.bam > 4_bam/mybamlist1.txt`
  `paste specimen_list.txt 4_bam/mybamlist1.txt > 4_bam/mybamlist.txt`
  `rm 4_bam/mybamlist1.txt`

### 2. Create multi-way pileup
Use script `mpileup_calder.sh`

### 3. Call variants
run this using `bcftools_call_calder.sh`
`mkdir 5_variants`
`bash bcftools_call_calder.sh`

### 4. Filter the genotypes for quality using *bcftools* and missing data using *vcftools*
`bash vcftools_recode_calder.sh`

### 5. Add lines to vcf files so R can read them
Use `vcf_filelinesa_calder.sh` to do it

  `mkdir 6_recoded_vcfs`
  `bash vcf_filelines.sh`
