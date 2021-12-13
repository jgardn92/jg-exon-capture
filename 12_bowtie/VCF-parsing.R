#Trying my own VCF parser

library(vcfR)
library(tidyverse)
library(stringr)

setwd("~/Documents/GitHub/jg-exon-capture/12_bowtie/")

#### Practice 1 ####
test1.vcf <- read.vcfR("test1/5_variants_paired/call_results_paired_filt.recode.vcf", verbose = FALSE)
head(test1.vcf)

test2.vcf <- read.vcfR("test2/5_variants/CAMB_UW152101_S459_call.q30.m20.recode.vcf")
head(test2.vcf)
dp.test2 <- extract.gt(test2.vcf, element = "DP", as.numeric = TRUE)
queryMETA(test2.vcf, element =  'FORMAT.+DP')
queryMETA(test2.vcf, element =  'FORMAT.+ADR')
queryMETA(test2.vcf, element = 'INFO.+AD')
queryMETA(test2.vcf, element = 'FORMAT.+AD')
queryMETA(test2.vcf, element = 'FORMAT.+GT')
queryMETA(test2.vcf)
head(dp.test2, n = 20)

dp.test2 <- extract.gt(test2.vcf, element = "DP", as.numeric = TRUE)
ad.test2 <- extract.gt(test2.vcf, element = "AD")
ad.sep1.test2 <- masplit(ad.test2, sort = 0, record = 1)
ad.sep2.test2 <- masplit(ad.test2, sort = 0, record = 2)
ad.test2[15:20,]
ad.sep1.test2[15:20,]
ad.sep2.test2[15:20,]

full.dat.test2 <- as.data.frame(cbind(dp.test2, ad.sep1.test2, ad.sep2.test2))
head(full.dat.test2)
colnames(full.dat.test2) <- c("Depth", "A1_Count", "A2_Count")
full.dat.test2$Tot_Alleles <- full.dat.test2$A1_Count + full.dat.test2$A2_Count
head(full.dat.test2)

full.data.dep20 <- full.dat.test2 %>% filter(Depth > 20)

more.than.1.allele<-full.dat.test2[full.dat.test2$Depth!=full.dat.test2$Tot_Alleles,]
head(more.than.1.allele)
length(more.than.1.allele$Depth)
full.data.dep20$minor.allele.freq <- full.data.dep20$A1_Count/full.data.dep20$Tot_Alleles
more.than.1.allele$A1_Count/more.than.1.allele$Tot_Alleles
hist(full.data.dep20$minor.allele.freq)

full.dat.hetero <- full.data.dep20 %>% filter(minor.allele.freq>0.1)
length(full.dat.hetero$minor.allele.freq)
hist(full.dat.hetero$minor.allele.freq)

cyc.vcf <- read.vcfR("test2/5_variants/CCYC_UW150847_S408_call.q30.m20.recode.vcf", verbose = F)
head(cyc.vcf)
dp.cyc <- extract.gt(cyc.vcf, element = "DP", as.numeric = TRUE)
ad.cyc <- extract.gt(cyc.vcf, element = "AD")
ad.sep1.cyc <- masplit(ad.cyc, sort = 0, record = 1)
ad.sep2.cyc <- masplit(ad.cyc, sort = 0, record = 2)
full.dat.cyc <- as.data.frame(cbind(dp.cyc, ad.sep1.cyc, ad.sep2.cyc))
colnames(full.dat.cyc) <- c("Depth", "A1_Count", "A2_Count")
full.dat.cyc$Tot_Alleles <- full.dat.cyc$A1_Count + full.dat.cyc$A2_Count
more.than.1.allele.cyc<-full.dat.cyc[full.dat.cyc$Depth!=full.dat.cyc$Tot_Alleles,]
length(more.than.1.allele$Depth.cyc)


#### Practice 2 ####
genome_list <- read.table("test3/specimen_list.txt")
genomes <- genome_list$V1
head(genomes)

vcf.grp <- list()

for(i in 1:length(genomes)){
  genome.name <- genomes[i]
  vcf.grp[[i]] <- read.vcfR(paste("test3/6_recoded_vcfs/",genome.name,"_results.vcf", sep = ""), verbose = FALSE)
}

head(vcf.grp)

tbls.raw.grp <- list()
tbls.filt.grp <- list()
raw.depth.hist.grp <- list()

for(i in 1:length(vcf.grp)){
  dp <- extract.gt(vcf.grp[[i]], element = "DP", as.numeric = TRUE)
  dp.whole.name <- colnames(dp)
  ID.name <- str_sub(dp.whole.name, 39, -20)
  ad <- extract.gt(vcf.grp[[i]], element = "AD")
  ad.allele1 <- masplit(ad, sort = 0, record = 1)
  ad.allele2 <- masplit(ad, sort = 0, record = 2)
  dp.ad.tbl <- as.data.frame(cbind(dp, ad.allele1, ad.allele2))
  colnames(dp.ad.tbl) <- c("Depth", "A1_Count", "A2_Count")
  dp.ad.tbl$Minor_Allele <- ifelse(dp.ad.tbl$A1_Count > dp.ad.tbl$A2_Count, dp.ad.tbl$A2_Count,
                                   ifelse(dp.ad.tbl$A1_Count < dp.ad.tbl$A2_Count, dp.ad.tbl$A1_Count, dp.ad.tbl$A2_Count))
  dp.ad.tbl$Third_Allele <- dp.ad.tbl$Depth - (dp.ad.tbl$A1_Count + dp.ad.tbl$A2_Count)
  dp.ad.tbl$MA_Freq <- dp.ad.tbl$Minor_Allele/dp.ad.tbl$Depth
  dp.ad.tbl$TA_Freq <- dp.ad.tbl$Third_Allele/dp.ad.tbl$Depth
  depth.hist <- hist(dp.ad.tbl$Depth, xlab = "Raw Depths before filtering", main = paste("Raw depth histogram for", ID.name, sept =""))
  tbls.raw.grp[[i]] <- dp.ad.tbl
  raw.depth.hist.grp[[i]] <- depth.hist
}






