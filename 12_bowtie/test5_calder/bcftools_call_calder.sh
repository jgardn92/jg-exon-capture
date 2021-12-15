#!/bin/bash
set -e
set -u
set -o pipefail
while read -r SAMPLEFILE
 do
  echo $SAMPLEFILE
  touch 5_variants/"${SAMPLEFILE}_call.bcf"

  bcftools call --variants-only \
  --consensus-caller \
  --keep-alts \
  --format-fields GQ \
  --output-type b \
  --output 5_variants/"${SAMPLEFILE}_call.bcf" \
  4_bam/"${SAMPLEFILE}_pileup.bcf"
done < specimen_list.txt
