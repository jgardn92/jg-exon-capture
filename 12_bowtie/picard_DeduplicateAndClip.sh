#picard v2.18.7 and bamUtil v1.0.15

##### ENVIRONMENT SETUP ####################################################
## Specify the directory containing data
DATADIR=/gscratch/scrubbed/elpetrou/bam #directory containing bam files
SUFFIX1=_minq20_sorted.bam # suffix to sorted and quality-filtered bam files produced in previous step of pipeline.

###### CODE FOR ANALYSIS ####################################################
## Move into the working directory
cd $DATADIR

## Run picard and bamutils (remove pcr duplicates and clip overlapping reads). 
## Please note that picard can't handle newline breaks in the code (\) - so that is why all the commands are hideously written on one line.

for MYSAMPLEFILE in *$SUFFIX1
do
    echo $MYSAMPLEFILE
    MYBASE=`basename --suffix=$SUFFIX1 $MYSAMPLEFILE`
    echo $MYBASE
    picard MarkDuplicates INPUT=$MYBASE'_minq20_sorted.bam' OUTPUT=$MYBASE'_minq20_sorted_dedup.bam' METRICS_FILE=$MYBASE'_minq20_sorted_dupstat.txt' VALIDATION_STRINGENCY=SILENT REMOVE_DUPLICATES=true
    bam clipOverlap --in $MYBASE'_minq20_sorted_dedup.bam' --out $MYBASE'_minq20_sorted_dedup_overlapclipped.bam' --stats
done 
