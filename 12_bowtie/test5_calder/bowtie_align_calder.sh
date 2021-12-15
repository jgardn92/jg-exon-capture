#!/bin/bash
set -e
set -u
set -o pipefail
while read -r SAMPLEFILE
 do
  echo $SAMPLEFILE
  bowtie2 -q -x ref_genomes/indexed/$SAMPLEFILE \
  --phred33 -q \
  -1 1_trimmed/"${SAMPLEFILE}_R1.fastq" \
  -2 1_trimmed/"${SAMPLEFILE}_R2.fastq" \
  -S 3_sam_paired/"${SAMPLEFILE}.sam"
done < specimen_list.txt
