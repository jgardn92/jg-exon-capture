#!/bin/bash
set -e
set -u
set -o pipefail
while read -r SAMPLEFILE
 do
  echo $SAMPLEFILE
  samtools view -S -b -h -q 30 -m 30 test3/3_sam_paired/"${SAMPLEFILE}.sam" | \
  samtools sort - | \
  samtools rmdup -s - test3/4_bam/"${SAMPLEFILE}_sorted_rd.bam"
  samtools index test3/4_bam/"${SAMPLEFILE}_sorted_rd.bam"
  samtools view test3/4_bam/"${SAMPLEFILE}_sorted_rd.bam" | wc -l
done < test3/sample_list.txt
