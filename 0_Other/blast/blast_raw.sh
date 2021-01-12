#!/bin/bash
set -e
set -u
set -o pipefail
echo "Enter rawfiles.txt"
read file
while IFS= read -r line
do
    echo $line
    gunzip -k $line.fastq.gz
    mv $line.fastq unzips/
    cat unzips/$line.fastq | awk 'NR%4==1{printf ">%s\n", substr($0,2)}NR%4==2{print}' > fastas/$line.fa
    makeblastdb -in fastas/$line.fa -dbtype nucl -out blastdbs/$line
    blastn -db mydb -query C_mel_coi.fas -out results.out
done < $file


cat unzips/lane7-s385-index-TCTATTCG-PPEN_UW119192_S385_L007_R2_001.fastq | awk 'NR%4==1{printf ">%s\n", substr($0,2)}NR%4==2{print}' > fastas/lane7-s385-index-TCTATTCG-PPEN_UW119192_S385_L007_R2_001.fa
lane7-s385-index-TCTATTCG-PPEN_UW119192_S385_L007_R2_001.fastq
gsed -n '1~4s/^@/>/p;2~4p' test.fastq > test.fasta
gsed -n '1~4s/^@/>/p;2~4p' unzips/lane7-s385-index-TCTATTCG-PPEN_UW119192_S385_L007_R2_001.fastq > fastas/lane7-s385-index-TCTATTCG-PPEN_UW119192_S385_L007_R2_001.fa
