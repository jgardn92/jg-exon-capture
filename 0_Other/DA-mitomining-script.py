# Script to extract mitochondrial markers from raw data

module load BWA/0.7.17-foss-2018b

bwa index -a is REFS.fasta -p REF_bwa

for filename in $(ls *.fastq)
do
bwa mem -t 11 REF_bwa $filename | cut -f 1-15 > $filename.sam
done

for filename in $(ls *.fastq.sam)
do
grep -v '^@' $filename  | awk '$3 != "*" {print $3}' | sort -n | uniq -c | awk '{print $2" "$1}' | sed 's// /' | sort -k3,3nr | sort -k1,1n -u | awk '{print $1""$2}' | fgrep -wf - $filename > $filename.besthits
done

for filename in $(ls *.fastq.sam.besthits)
do
samtools view -bT REFS.fasta $filename | samtools sort - $filename
done

for filename in $(ls *.fastq.sam.besthits)
do
samtools rmdup -s $filename $filename.rmdup.bam
done
