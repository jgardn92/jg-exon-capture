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

### Step 3: `blastn` for C melanurus COI

`blastn -db 2_assemble_result/nf -query 0_Other/C_mel_coi.fas -out results.out`
