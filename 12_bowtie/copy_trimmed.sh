#!/bin/bash
set -e
set -u
set -o pipefail
while read -r SAMPLEFILE
 do
  echo $SAMPLEFILE
  cp ../1_trimmed/"${SAMPLEFILE}_R1.fastq" test3/1_trimmed/
  cp ../1_trimmed/"${SAMPLEFILE}_R2.fastq" test3/1_trimmed/
done < test3/sample_list.txt
