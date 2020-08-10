#!/bin/bash

#PBS -l nodes=1:ppn=24
#PBS -l walltime=240:00:00
#PBS -N CA_exonerate
#PBS -q avant

cd /home/users/cli/ocean/Calder/jenny1

assemble.pl \
--queryp /home/users/cli/ocean/reference_and_genome/Oreochromis_niloticus_17675/Oreochromis_niloticus_4434.aa.fas \
--queryn /home/users/cli/ocean/reference_and_genome/Oreochromis_niloticus_17675/Oreochromis_niloticus_4434.dna.fas \
--db /home/users/cli/ocean/reference_and_genome/Oreochromis_niloticus_17675/Oreochromis_niloticus.sm_genome.fa \
--dbtype nucleo \
--ref_name Oreochromis_niloticus \
--samplelist samplelist.txt \
--outdir assemble_result \
--restart_from_exonerate_best


exit 0