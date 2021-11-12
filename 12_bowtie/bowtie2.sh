#bowtie2 v2.4.2

##### ENVIRONMENT SETUP ###################################################
DATADIR=/gscratch/scrubbed/elpetrou/fastq # The directory containing all of your fastq files
GENOMEDIR=/gscratch/merlab/genomes/atlantic_herring #The directory containing the genome
GENOME_PREFIX=GCF_900700415.1_Ch_v2.0.2 #prefix of .bt2 files made by bowtie2 (the name of the genome, without the suffixes)
SUFFIX1=_R1_001.trim.fastq # Suffix to the fastq files -  The forward reads with paired-end data.
SUFFIX2=_R2_001.trim.fastq # Suffix to the fastq files - The reverse reads with paired-end data.
OUTDIR=/gscratch/scrubbed/elpetrou/bam #directory where output files should go
MYTHREADS=8 # Specify how many threads (CPUs) you would like to use
MINFRAG=0 #Minimum fragment length for bowtie2
MAXFRAG=1000 #Maximum fragmment length for bowtie2
##############################################################################
## Save the sample names of the forward reads into a text file (for looping thru samples later)

# Make directory for output files
mkdir $OUTDIR

# Move into the directory containing the fastq files and run bowtie2 every sample in that directory
cd $DATADIR

# Run bowtie
for MYSAMPLEFILE in *$SUFFIX1
do
	echo $MYSAMPLEFILE
	MYBASE=`basename --suffix=$SUFFIX1 $MYSAMPLEFILE`
	echo $MYBASE
	bowtie2 -x $GENOMEDIR'/'$GENOME_PREFIX \
	--phred33 -q \
	-1 $MYBASE$SUFFIX1 \
	-2 $MYBASE$SUFFIX2 \
	-S $MYBASE'.sam' \
	--very-sensitive \
	--minins $MINFRAG --maxins $MAXFRAG --fr \
	--threads $MYTHREADS \
	--rg-id $MYBASE --rg SM:$MYBASE --rg LB:$MYBASE --rg PU:Lane1 --rg PL:ILLUMINA
done

