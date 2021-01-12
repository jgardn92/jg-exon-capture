Blast for contamination/COI
### Step 1: `grep` for contaminated sequence
- None found

### Step 2: Make database
Can't use `cat *.fas > mydb.fas` because list too long so
Do for each spp
`cat 2_assemble_result/nf/Danio.reriro.* > 0_Other/blast/myDanio.fas`
`cat 2_assemble_result/nf/Gasterosteus.acculeatus.* > 0_Other/blast/myGastero.fas`
`cat 2_assemble_result/nf/Danio.reriro.* > 0_Other/blast/myDanio.fas`
`cat 2_assemble_result/nf/Oryzias_latipes.* > 0_Other/blast/myOryz.fas`
`cat 2_assemble_result/nf/Tetraodon_nigroviridis.* > 0_Other/blast/myTetra.fas`

Then cat all to one persdb.fasta_file
`cd 0_Other/blast`
`cat my* > persdb.fas`

Now make into a database
`makeblastdb -in persdb.fas -dbtype nucl -out mydb`

### Step 3: `blastn` for C melanurus COI

`blastn -db mydb -query C_mel_coi.fas -out results.out`

**Results no hits found**

### Step 4: `blastn` for contaminated sequences

`blastn -db mydb -query contam_goby_seq.fas -out results.out`

**Results: No hits found**

*Note: test sequence blast worked so both results above correct, no COI or contaminated sequence in the assembed data*

## Blast Raw Data Update
- need to make a script that:
  - loops over each file in directory to search within each spp
  - unzips each file `gunzip file`
  - converts fastq to fasta
  original code from Robert's lab: `zcat input_file.fastq.gz | awk 'NR%4==1{printf ">%s\n", substr($0,2)}NR%4==2{print}' > output_file.fa`
   `cat 0_raw/lane7-s385-index-TCTATTCG-PPEN_UW119192_S385_L007_R1_001.fastq | awk 'NR%4==1{printf ">%s\n", substr($0,2)}NR%4==2{print}' > 0_raw/lane7-s385-index-TCTATTCG-PPEN_UW119192_S385_L007_R1_001.fa`
   `cat test.fastq | awk 'NR%4==1{printf ">%s\n", substr($0,2)}NR%4==2{print}' > test.fa`
   -code from Robert's lab github but using zcat and .gz file but zcat was throwing an error for me but it works with cat on already unzipped file and keeps the fastq and .fa
  - makes the fasta into a blast db
  - blasts a COI sequence against that blast db
  - saves successful blast sequences somewhere listed by spp found in and sequence found
- test run mostly worked *but* two of the db files are corrupt and won't commit .nhr and .nsq. No idea why so added to gitignore instead
