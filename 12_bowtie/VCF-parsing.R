#VCF Parser on all My Data

library(vcfR)
library(tidyverse)
library(stringr)
setwd("~/Documents/GitHub/jg-exon-capture/12_bowtie/")
source("vcf-parse-function.R")

#9 objects in each list as follows
# [1] = Raw Depth Histogram
# [2] = Minor Allele Freq after filtering for depth but before filtering for Allele Freqs
# [3] = Third Allele Freq after filtering for depth but before filtering for Allele Freqs
# [4] = Depth by Locus after filtering for depth and allele freqs and averaging at each locus
# [5] = Minor Allele Freq by Locus after filtering for depth and allele freqs and averaging at each locus
# [6] = Third Allele Freq by Locus after filtering for depth and allele freqs and averaging at each locus
# [7] = Minor Allele Freq after both filters but by snp not locus
# [8] = Table 1 before any filters
# [9] = Table 2 after filtering by depth
# [10] = Table 3 after filtering by depth and allele frequencies and averaging by locus

vcf.names <- readLines("all_recoded_vcfs_list.txt")
vcf.names.noM <- vcf.names[-44]
vcf.onlyM <- vcf.names[44]

indiv.names <- c()
hist1.list <- list()
hist2.list <- list()
hist3.list <- list()
hist4.list <- list()
hist5.list <- list()
hist6.list <- list()
hist7.list <- list()
dp.ad.list <- list()
lengths <- c()
dp.filt.list <- list()
filt.SNP.num <- c()
Gene.per.indivi <- c()


for(i in 1:length(vcf.names.noM)){
  save.name <- str_sub(vcf.names.noM[i], 1, nchar(vcf.names.noM[i])-12)
  indiv.names[i] <- save.name
  my.vcf <- vcf.parser(vcf.names.noM[i])
  hist1.list[[i]] <- my.vcf[[1]]
  hist2.list[[i]] <- my.vcf[[2]]
  hist3.list[[i]] <- my.vcf[[3]]
  hist4.list[[i]] <- my.vcf[[4]]
  hist5.list[[i]] <- my.vcf[[5]]
  hist6.list[[i]] <- my.vcf[[6]]
  hist7.list[[i]] <- my.vcf[[7]]
  dp.ad.list[[i]] <- my.vcf[[8]]
  lengths[i] <- length(my.vcf[[8]]$Depth)
  dp.filt.list[[i]] <- my.vcf[[9]]
  filt.SNP.num[i] <- length(my.vcf[[9]]$Depth)
  Gene.per.indivi[i] <- nrow(my.vcf[[10]])
  assign(save.name, my.vcf)
}

all.depth <- do.call("rbind", dp.ad.list)
all.filt <- do.call("rbind", dp.filt.list)

names.column <- c()
for(j in 1:length(indiv.names)){
  name.to.paste <- indiv.names[j]
  name.reps <- rep(name.to.paste, lengths[j])
  names.column <- c(names.column,name.reps)
}
all.depth$Spec.Name <- names.column

names.filt <- c()
for(k in 1:length(indiv.names)){
  name.to.paste <- indiv.names[k]
  name.reps <- rep(name.to.paste, filt.SNP.num[k])
  names.filt <- c(names.filt,name.reps)
}
all.filt$Spec.Name <- names.filt

mean(all.depth$Depth) #total mean depth = 74.2
length(which(all.depth$Depth <= 20))/length(all.depth$Depth) #percent sites removed because 20 or fewer reads= 42.2%
mean(all.filt$Depth) #filtered mean depth = 122.2
mean(as.numeric(filt.SNP.num)) #mean number of SNP sites after filtering = 637.5
mean(as.numeric(Gene.per.indivi)) #mean number of genes(SNPs combined) per individual = 72.1

write.csv(all.depth, "All_Dp_AD_combined.csv")
write.csv(all.filt, "All_Dp_AD_filtered.csv")

pdf("hist1_depth1.pdf", width = 11, height = 8.5, onefile = TRUE)
for(k in seq(1,96, by = 6)){  
  l <- k+5
  do.call(grid.arrange, c(hist1.list[k:l], ncol = 2))
  }
dev.off()

pdf("hist2_maf1.pdf", width = 11, height = 8.5, onefile = TRUE)
for(k in seq(1,96, by = 6)){  
  l <- k+5
  do.call(grid.arrange, c(hist2.list[k:l], ncol = 2))
}
dev.off()

pdf("hist3_taf1.pdf", width = 11, height = 8.5, onefile = TRUE)
for(k in seq(1,96, by = 6)){  
  l <- k+5
  do.call(grid.arrange, c(hist3.list[k:l], ncol = 2))
}
dev.off()

pdf("hist4_depth2.pdf", width = 11, height = 8.5, onefile = TRUE)
for(k in seq(1,96, by = 6)){  
  l <- k+5
  do.call(grid.arrange, c(hist4.list[k:l], ncol = 2))
}
dev.off()

pdf("hist5_maf2.pdf", width = 11, height = 8.5, onefile = TRUE)
for(k in seq(1,96, by = 6)){  
  l <- k+5
  do.call(grid.arrange, c(hist5.list[k:l], ncol = 2))
}
dev.off()

pdf("hist6_taf2.pdf", width = 11, height = 8.5, onefile = TRUE)
for(k in seq(1,96, by = 6)){  
  l <- k+5
  do.call(grid.arrange, c(hist6.list[k:l], ncol = 2))
}
dev.off()

pdf("hist7_maf2.pdf", width = 11, height = 8.5, onefile = TRUE)
for(k in seq(1,96, by = 6)){  
  l <- k+5
  do.call(grid.arrange, c(hist7.list[k:l], ncol = 2))
}
dev.off()