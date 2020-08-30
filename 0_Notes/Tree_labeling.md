# Renaming Branch Tips

1. Get all names from Fasta file
`grep ">" fasta_file.fas > fasta_names.txt`

2. Remove > from names
`cat fasta_names.txt | cut -b 2- > rename_table.txt`

3. Use rename_table to make tab delimited table with names.
Check settings in atom (cmd+,) -> Editor
	* Turn off soft tab to make sure tab delimited table is actually tab delimited
	* Turn on show invisibles to double check tabs are working

4. Use `taxnameconvert.pl` to rename tree
` taxnameconvert.pl rename_table.txt tree_to_rename renamed_tree.tree`
