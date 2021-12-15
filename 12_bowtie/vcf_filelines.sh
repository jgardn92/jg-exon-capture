#!/bin/bash
set -e
set -u
set -o pipefail
while read -r GENOME SAMPLEFILE
 do
  echo $GENOME
  echo $SAMPLEFILE
  gsed '1 i\##fileformat=VCFv4.2##FILTER=<ID=PASS,Description="All filters passed">' test2/5_variants/"${GENOME}_call.q30.m25.recode.vcf" > test2/6_recoded_vcfs/"${GENOME}_results.vcf"
done < test2/specimen_list.txt
