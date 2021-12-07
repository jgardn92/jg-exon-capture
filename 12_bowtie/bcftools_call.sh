#!/bin/bash
set -e
set -u
set -o pipefail
while read -r GENOME SAMPLEFILE
 do
  echo $GENOME
  echo $SAMPLEFILE
  touch test3/5_variants/"${GENOME}_call.bcf"

  bcftools call --variants-only \
  --consensus-caller \
  --keep-alts \
  --format-fields GQ \
  --output-type b \
  --output test3/5_variants/"${GENOME}_call.bcf" \
  test3/4_bam/"${GENOME}_pileup.bcf"
done < test3/specimen_list.txt
