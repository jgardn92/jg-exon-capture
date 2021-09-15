#!/bin/bash
set -e
set -u
set -o pipefail
for GENOME in `cat specimen_list.txt`
  for SAMPLEFILE in `cat sample_list.txt`
  do
    bowtie2 -q -x ref_genomes/indexed/$GENOME \
    -1 1_trimmed/"${SAMPLEFILE}_R1.fastq" \
    -2 1_trimmed/"${SAMPLEFILE}_R2.fastq" \
    -S 12_bowtie/sam_paired/"${SAMPLEFILE}.sam"
  done
done
