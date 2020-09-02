# Ape delete.gaps test
library(ape)
library(tidyverse)

#Read in 
full_concat <- read.dna("../jg-exon-capture/12_concatinate_v2/12_concat_nf_v2.fas",format = "fasta")
#97 seq of 433,323 bases
full_concat_count <- del.colgapsonly(full_concat, freq.only = TRUE)
as.matrix(table(full_concat_count))
full_concat_delete <- del.colgapsonly(full_concat, threshold = 0.5)
full_delete_count <- del.colgapsonly(full_concat_delete, freq.only = TRUE)
as.matrix(table(full_delete_count))
head(full_concat_delete)
#97 seq of 430,998 baeses
write.FASTA(full_concat_delete, "../jg-exon-capture/12_concatinate_v2/12_concat_filtered.fas")

partial_concat <- full_concat[1:20,50000:60000]
image(partial_concat, what = "-", col = "black", bg = "pink")

partial_concat_count<- del.colgapsonly(partial_concat, freq.only = TRUE)
sort(unique(partial_concat_count))
table(partial_concat_count)

partial_delete <- del.colgapsonly(partial_concat, threshold = 0.5)
image(partial_delete, what = "-", col = "black", bg = "pink")
partial_delete_count<- del.colgapsonly(partial_delete, freq.only = TRUE)
table(partial_delete_count)
