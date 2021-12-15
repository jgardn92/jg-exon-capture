#!/bin/bash
set -e
set -u
set -o pipefail
while read -r SAMPLEFILE
 do
  echo $SAMPLEFILE
  vcftools --bcf 5_variants/"${SAMPLEFILE}_call.bcf" \
  --minQ 30 \
  --max-missing 0.75 \
  --recode \
  --recode-INFO-all \
  --out 5_variants/"${SAMPLEFILE}_call.q30.m25"
done < specimen_list.txt
