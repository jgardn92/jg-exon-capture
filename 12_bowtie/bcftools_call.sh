#!/bin/bash
set -e
set -u
set -o pipefail
while read -r GENOME SAMPLEFILE
 do
  echo $GENOME
  echo $SAMPLEFILE
  touch test2/5_variants/"${GENOME}_call.bcf"

  bcftools call --variants-only \
  --consensus-caller \
  --keep-alts \
  --format-fields GQ \
  --output-type b \
  --output test2/5_variants/"${GENOME}_call.bcf" \
  test2/4_bam/"${GENOME}_pileup.bcf"
done < specimen_list.txt
