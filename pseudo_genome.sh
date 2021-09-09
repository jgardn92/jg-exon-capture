#!/bin/bash
set -e
set -u
set -o pipefail
individual="CAMB_UW152101_S459"
if test "!" -f ./12_bowtie/ref_genomes/"${individual}.fasta"
then
    >./12_bowtie/ref_genomes/"${individual}.fasta"
else
    echo "genome_file exists"
fi
echo "Enter assembled_loci.txt"
read file
while IFS= read -r line
do
    echo $line
    sequence=$(grep -A1 $individual 2_assemble_result/nf/$line || [[ $? == 1 ]])
    if test -z "$sequence"
    then
      echo "\$sequence is empty"
    else
      gene=">${line}"
      echo $gene >> ./12_bowtie/ref_genomes/"${individual}.fasta"
      set -- $sequence
      echo $2 >> ./12_bowtie/ref_genomes/"${individual}.fasta"
    fi
done < $file
