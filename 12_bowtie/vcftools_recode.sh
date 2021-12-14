#!/bin/bash
set -e
set -u
set -o pipefail
while read -r GENOME SAMPLEFILE
 do
  echo $GENOME
  echo $SAMPLEFILE
  vcftools --bcf test4_remaining/5_variants/"${GENOME}_call.bcf" \
  --minQ 30 \
  --max-missing 0.75 \
  --recode \
  --recode-INFO-all \
  --out test4_remaining/5_variants/"${GENOME}_call.q30.m25"
done < test4_remaining/specimen_list.txt
