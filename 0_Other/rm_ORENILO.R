#rmORENILO
library(ape)

seqs.in.here <- "../16_nf_filtered_selected" # <===== ENTER PATH TO DIRECTORY CONTAINING FASTA FILES HERE!

data <- list.files(seqs.in.here)

system(paste("mkdir ",seqs.in.here,"_rmORENILO",sep=""))

to.rm <- c("Oreochromis_niloticus")

for (file in data){
  align <- read.dna(paste(seqs.in.here,"/",file,sep=""),format = "fasta")  # Import a tree
  rm_ORENILO <- align[-which(row.names(align) %in% to.rm),]
  write.dna(x = rm_ORENILO,file = paste(seqs.in.here,"_rmORENILO/",file,sep=""),format = "fasta")
}

concat <- read.dna("../jg-exon-capture/12_concatinate_v2/12_concat_nf_v2.fas",format = "fasta")
unique(concat)
unique(as.vector(concat[1,]))
