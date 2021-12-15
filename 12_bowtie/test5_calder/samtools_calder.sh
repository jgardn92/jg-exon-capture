#!/bin/bash
set -e
set -u
set -o pipefail
while read -r SAMPLEFILE
 do
  echo $SAMPLEFILE
  samtools view -S -b -h -q 30 -m 30 3_sam_paired/"${SAMPLEFILE}.sam" | \
  samtools sort - | \
  samtools rmdup -s - 4_bam/"${SAMPLEFILE}_sorted_rd.bam"
  samtools index 4_bam/"${SAMPLEFILE}_sorted_rd.bam"
  samtools view 4_bam/"${SAMPLEFILE}_sorted_rd.bam" | wc -l
done < sample_list.txt
