#!/bin/bash
set -e
set -u
set -o pipefail
for INDIVIDUAL in `cat specimen_list.txt`
do
  if test "!" -f ./12_bowtie/ref_genomes/fastas/"${INDIVIDUAL}.fasta"
  then
      >./12_bowtie/ref_genomes/fastas/"${INDIVIDUAL}.fasta"
    else
      echo "genome_file exists"
    fi
#echo "Enter assembled_loci.txt"
  for LINE in `cat assembled_loci.txt`
  do
      echo $LINE
      sequence=$(grep -A1 $INDIVIDUAL 2_assemble_result/nf/$LINE || [[ $? == 1 ]])
      if test -z "$sequence"
      then
        echo "\$sequence is empty"
      else
        gene=">${LINE}"
        echo $gene >> ./12_bowtie/ref_genomes/fastas/"${INDIVIDUAL}.fasta"
        set -- $sequence
        echo $2 >> ./12_bowtie/ref_genomes/fastas/"${INDIVIDUAL}.fasta"
      fi
  done
done
