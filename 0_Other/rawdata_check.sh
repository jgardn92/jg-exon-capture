#!/bin/bash
set -e
set -u
set -o pipefail
echo "rawfiles.txt"
read file
while IFS= read -r line
do
    echo $line
    gunzip -k $line.fastq.gz
    mv $line.fastq unzips/
    gsed -n '1~4s/^@/>/p;2~4p' unzips/$line.fastq > fastas/$line.fasta
    grep -E -n '[@+]' fastas/$line.txt > grepresults/$line.txt
done < $file
