#!/bin/bash
set -e
set -u
set -o pipefail
while read -r GENOME SAMPLEFILE
 do
  echo $GENOME
  echo $SAMPLEFILE
  vcftools --vcf test2/5_variants/"${GENOME}_call.q30.m20.recode.vcf" --depth
  vcftools --vcf test2/5_variants/"${GENOME}_call.q30.m20.recode.vcf" --site-mean-depth
  vcftools --vcf test2/5_variants/"${GENOME}_call.q30.m20.recode.vcf" --site-quality
  vcftools --vcf test2/5_variants/"${GENOME}_call.q30.m20.recode.vcf" --missing-indv
  vcftools --vcf test2/5_variants/"${GENOME}_call.q30.m20.recode.vcf" --missing-site
  vcftools --vcf test2/5_variants/"${GENOME}_call.q30.m20.recode.vcf" --freq
  vcftools --vcf test2/5_variants/"${GENOME}_call.q30.m20.recode.vcf" --counts
done < specimen_list.txt
