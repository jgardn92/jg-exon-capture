#!/bin/bash
set -e
set -u
set -o pipefail
while read -r SAMPLEFILE
 do
  echo $SAMPLEFILE
  gsed '1 i\##fileformat=VCFv4.2##FILTER=<ID=PASS,Description="All filters passed">' 5_variants/"${SAMPLEFILE}_call.q30.m25.recode.vcf" > 6_recoded_vcfs/"${SAMPLEFILE}_results.vcf"
done < specimen_list.txt
