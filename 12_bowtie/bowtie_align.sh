#!/bin/bash
set -e
set -u
set -o pipefail
while read -r GENOME SAMPLEFILE
 do
  echo $GENOME
  echo $SAMPLEFILE
  bowtie2 -q -x ref_genomes/indexed/$GENOME \
  --phred33 -q \
  -1 test3/1_trimmed/"${SAMPLEFILE}_R1.fastq" \
  -2 test3/1_trimmed/"${SAMPLEFILE}_R2.fastq" \
  -S test3/3_sam_paired/"${SAMPLEFILE}.sam"
done < test3/specimen_list.txt
