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
  - converts fastq to fasta
  - makes the fasta into a blast db
  - blasts a COI sequence against that blast db
  - saves successful blast sequences somewhere listed by spp found in and sequence found
