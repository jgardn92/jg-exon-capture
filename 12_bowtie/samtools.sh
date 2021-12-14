#!/bin/bash
set -e
set -u
set -o pipefail
while read -r SAMPLEFILE
 do
  echo $SAMPLEFILE
  samtools view -S -b -h -q 30 -m 30 test4_remaining/3_sam_paired/"${SAMPLEFILE}.sam" | \
  samtools sort - | \
  samtools rmdup -s - test4_remaining/4_bam/"${SAMPLEFILE}_sorted_rd.bam"
  samtools index test4_remaining/4_bam/"${SAMPLEFILE}_sorted_rd.bam"
  samtools view test4_remaining/4_bam/"${SAMPLEFILE}_sorted_rd.bam" | wc -l
done < test4_remaining/sample_list.txt
