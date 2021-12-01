#!/bin/bash
set -e
set -u
set -o pipefail
while read -r GENOME SAMPLEFILE
 do
  echo $GENOME
  echo $SAMPLEFILE
  bcftools mpileup --fasta-ref ref_genomes/fastas/"${GENOME}.fasta" \
  $SAMPLEFILE \
  --skip-indels \
  --output test2/4_bam/"${GENOME}_pileup.bcf" \
  --output-type b \
  --annotate FORMAT/AD,FORMAT/ADF,FORMAT/ADR,FORMAT/DP,INFO/AD,INFO/ADF,INFO/ADR
done < test2/4_bam/mybamlist.txt
