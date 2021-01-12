#!/bin/bash
set -e
set -u
set -o pipefail
echo "Enter genetreetest.txt"
read file
while IFS= read -r line
do
    echo $line
    taxnameconvert.pl rename_table.txt 10_Gene_Trees/30_full_taxa_aligned_ml/$line 10_Gene_Trees/30_gene_trees_renamed/$line
done < $file
