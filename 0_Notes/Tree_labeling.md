# Renaming Branch Tips

1. Get all names from Fasta file
`grep ">" fasta_file.fas > fasta_names.txt`

2. Remove > from names
`cat fasta_names.txt | cut -b 2- > rename_table.txt`

3. Use rename_table to make tab delimited table with names.

4. Use `taxnameconvert.pl` to rename tree
`code here`
