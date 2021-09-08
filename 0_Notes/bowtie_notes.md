# Bowtie2 For Heterozygosity
Most code from eleni's ancient dna repo

- Use assembled genes as reference genome for each individual

## III. Trim Adapters

##### 1. Rename merged files as .fq
The input files for `trim_adaptor.pl` must be .fq, NOT .fastq, so in `merge` (or `raw` if there was no merge step) run:

    (for file in *.fastq; do mv "$file" "$(basename "$file" .fastq).fq"; done)

Output:
`sample_name_R2.fq`
`sample_name_R2.fq`

##### 2. Trim adapters
*** Best to run on a supercomputer (see instructions on using HYAK/MOX) ***

Check the options for `trim_adaptor.pl` by adding the help flag `-h` and to make sure the script works. You should do this for all of the custom perl scripts (.pl files) going forward.

    trim_adaptor.pl -h

In your home directory run the following:

    trim_adaptor.pl \
    --raw_reads input \
    --trimmed output

Example:

    trim_adaptor.pl --raw_reads 1_merge --trimmed 2_trimmed

The output will be in the directory `trimmed`. This will also produce report files `trimmed_reads_bases_count.txt` and `trimming_report/sample_name_trimming_report.txt`. To clean these file up into a new directory `trimmed_supp` run:

    mkdir 2_trimmed_supp
    mv trimmed_reads_bases_count.txt 2_trimmed_supp/
    mv trimming_report 2_trimmed_supp/

    # Quality control of sequencing data using *FastQC*

    It is always a great idea to look at the demultiplexed fastq files and verify that:
    1. data quality looks good
    2. there are no adapters still hanging around the sequencing data

    I did this using the program *FastQC*. Explanation of *FastQC* arguments used:

    -f : Bypasses the normal sequence file format  detection  and  forces
                  the  program  to  use  the  specified format.  Valid formats are
                  bam,sam,bam_mapped,sam_mapped and fastq

    -o : Create all output  files  in  the  specified  output  directory.
                  Please  note  that this directory must exist as the program will
                  not create it.  If this option is not set then the  output  file
                  for  each  sequence file is created in the same directory as the
                  sequence file which was processed.

    ``` bash
    BASEDIR=/media/ubuntu/Herring_aDNA/hybridization_capture/ancient_samples #path of base directory
    INPUTDIR=$BASEDIR'/'trimmed_fastq #path to fastq files

    # Make a directory to hold the fastqc results
    mkdir $BASEDIR'/'fastqc

    # Specify path to the folder where you want the fastqc results to be stored
    OUTPUTDIR=$BASEDIR'/'fastqc

    for FILE in $INPUTDIR'/'*.fastq # for any file ending in .fastq in this directory
    do
    fastqc -f fastq --extract -o $OUTPUTDIR $FILE
    done

    ```
    ## Take a look at the FastQC output

    Let's verify that sequencing quality is good and adapters are not present. Yay!

    Here is an example of FastQC file for one of the ancient samples (2B_01):

    ![quality-img](fastqc_quality.png)

    ![adapter-img](fastqc_adapter.png)

    Align ancient samples to the genome

   ## Explanation of terms:

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


   # Convert sam files to bam format, filter, remove PCR duplicates, and index bam files
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




       

Step 1: Trim adapters and other things

Step 2:

Step 3:

Step 4:
