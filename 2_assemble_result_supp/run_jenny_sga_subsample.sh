 #!/bin/bash

#PBS -l nodes=1:ppn=24
#PBS -l walltime=240:00:00
#PBS -N CA_sga_subsample
#PBS -q avant

cd /home/users/cli/ocean/Calder/jenny1

assemble.pl \
--samplelist samplelist_sga_rerun.txt \
--restart_from_sga_assemble \
--stop_after_sga_assemble

exit 0