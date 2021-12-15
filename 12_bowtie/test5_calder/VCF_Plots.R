#VCF Parser on three from Calder
library(vcfR)
library(tidyverse)
library(stringr)
library(gridExtra)
library(ggpubr)
library(cowplot)

setwd("~/Documents/GitHub/jg-exon-capture/12_bowtie/test5_calder/")
source("../vcf-parse-function.R")

#9 objects in each list as follows
# [1] = Raw Depth Histogram
# [2] = Minor Allele Freq after filtering for depth but before filtering for Allele Freqs
# [3] = Third Allele Freq after filtering for depth but before filtering for Allele Freqs
# [4] = Depth by Locus after filtering for depth and allele freqs and averaging at each locus
# [5] = Minor Allele Freq by Locus after filtering for depth and allele freqs and averaging at each locus
# [6] = Third Allele Freq by Locus after filtering for depth and allele freqs and averaging at each locus
# [7] = Table 1 before any filters
# [8] = Table 2 after filtering by depth
# [9] = Table 3 after filtering by depth and allele frequencies and averaging by locus


calder.vcf.names <- readLines("all_recoded_vcfs_calder.txt")
hist1.ca.list <- list()
hist2.ca.list <- list()
hist3.ca.list <- list()
hist4.ca.list <- list()
hist5.ca.list <- list()
hist6.ca.list <- list()
hist7.ca.list <- list()

for(i in 1:length(calder.vcf.names)){
  save.name <- str_sub(calder.vcf.names[i], 1, nchar(calder.vcf.names[i])-12)
  my.vcf <- vcf.parser(calder.vcf.names[i])
  hist1.ca.list[[i]] <- my.vcf[[1]]
  hist2.ca.list[[i]] <- my.vcf[[2]]
  hist3.ca.list[[i]] <- my.vcf[[3]]
  hist4.ca.list[[i]] <- my.vcf[[4]]
  hist5.ca.list[[i]] <- my.vcf[[5]]
  hist6.ca.list[[i]] <- my.vcf[[6]]
  hist7.ca.list[[i]] <- my.vcf[[7]]
  assign(save.name, my.vcf)
}

pdf("hist1_depth1.ca.pdf", width = 11, height = 8.5, onefile = TRUE)
do.call(grid.arrange, c(hist1.ca.list, ncol = 2))
dev.off()

pdf("hist2_maf1.ca.pdf", width = 11, height = 8.5, onefile = TRUE)
do.call(grid.arrange, c(hist2.ca.list, ncol = 2))
dev.off()

pdf("hist3_taf1.ca.pdf", width = 11, height = 8.5, onefile = TRUE)
do.call(grid.arrange, c(hist3.ca.list, ncol = 2))
dev.off()

pdf("hist4_depth2.ca.pdf", width = 11, height = 8.5, onefile = TRUE)
do.call(grid.arrange, c(hist4.ca.list, ncol = 2))
dev.off()

pdf("hist5_maf2.ca.pdf", width = 11, height = 8.5, onefile = TRUE)
do.call(grid.arrange, c(hist5.ca.list, ncol = 2))
dev.off()

pdf("hist6_taf2.ca.pdf", width = 11, height = 8.5, onefile = TRUE)
do.call(grid.arrange, c(hist6.ca.list, ncol = 2))
dev.off()

pdf("hist7_maf2.ca.pdf", width = 11, height = 8.5, onefile = TRUE)
do.call(grid.arrange, c(hist7.ca.list, ncol = 2))
dev.off()
