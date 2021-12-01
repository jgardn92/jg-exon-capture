
# The purpose of this script is to plot the output of vcftools:

# Use vcftools to calculate the following summary stats about your cf file: 
#--depth: Generates a file containing the mean depth per individual. This file has the suffix ".idepth". 
#--site-mean-depth: Generates a file containing the mean depth per site averaged across all individuals. This output file has the suffix ".ldepth.mean".
#--site-quality: Generates a file containing the per-site SNP quality, as found in the QUAL column of the VCF file. This file has the suffix ".lqual".
#--missing-indv: Generates a file reporting the missingness on a per-individual basis. The file has the suffix ".imiss".
#--missing-site: Generates a file reporting the missingness on a per-site basis. The file has the suffix ".lmiss".


# load necessary libraries
library(dplyr)
library(ggplot2)

# Specify the directories:
BASEDIR <- "~/Documents/GitHub/jg-exon-capture/12_bowtie/test1/5_variants_paired"
#DATADIR <- "/ancient_call_results.header.tidy.snpid.RADloci.qual100.miss20_plots" unsure how to use this line right now

# Set the working directory:
#mypath <- (paste0(BASEDIR, DATADIR)) also unsure of this line
#setwd(mypath)
setwd(BASEDIR)
list.files()

BASENAME <- "out"

#read in data
indiv_mean_depth <- read.table(paste0(BASENAME, ".idepth"), header = TRUE)
site_mean_depth <- read.table(paste0(BASENAME, ".ldepth.mean"), header = TRUE)
site_quality <- read.table(paste0(BASENAME,".lqual") , header = TRUE)
miss_indiv<- read.table(paste0(BASENAME, ".imiss"), header = TRUE)
miss_site <- read.table(paste0(BASENAME, ".lmiss"), header = TRUE)
#locus_stats <- read.table(paste0(BASENAME, ".INFO"), header = TRUE)



## Make some histograms to assist in filtering the data:
plot1 <- ggplot(miss_site, aes(F_MISS)) +
  geom_histogram(fill = "slateblue")+
  xlab("percent missing data per SNP")+
  ylab("Number of occurences") +
  theme_bw()
plot1
#ggsave("site_missingdata.pdf", plot = plot1, path = mypath)

plot2 <- ggplot(site_quality, aes(QUAL)) +
  geom_histogram(bins = 20, fill = "slateblue")+
  xlab("Phred QUAL score")+
  ylab("Number of occurences") +
  theme_bw()
plot2
#ggsave("site_qual.pdf", plot = plot2, path = mypath)


# plot2b <- ggplot(locus_stats, aes(MQ)) +
#   geom_histogram(bins = 20, fill = "slateblue")+
#   xlab("mapping quality")+
#   ylab("Number of occurences") +
#   theme_bw()
# plot2b
# ggsave("site_mappingqual.pdf", plot = plot2, path = mypath)

plot3 <- ggplot(site_mean_depth, aes(MEAN_DEPTH)) +
  geom_histogram(bins = 40, fill = "slateblue")+
  geom_vline(xintercept=20, color = "red")+
  xlab("Mean depth")+
  ylab("Number of occurences") +
  theme_bw()
plot3
ggsave("site_depth.pdf", plot = plot3, path = "~/Documents/GitHub/jg-exon-capture/12_bowtie/test1/")

# What is the range of sequencing depth per site?
min(site_mean_depth$MEAN_DEPTH)
max(site_mean_depth$MEAN_DEPTH)
mean(site_mean_depth$MEAN_DEPTH)
mean(site_mean_depth$MEAN_DEPTH, trim  = 0)

# Is there a correlation between mean sequencing depth and QUAL at each site?

site_df <- left_join(site_quality, site_mean_depth, by = c("CHROM" = "CHROM", "POS" = "POS"))
site_df <- left_join(site_df, miss_site, by = c("CHROM" = "CHR", "POS" = "POS"))
head(site_df)


######################################################################################
#### make histograms- per individual
head(miss_indiv)
head(indiv_mean_depth)

plot4 <- ggplot(miss_indiv, aes(F_MISS)) +
  geom_histogram(bins = 20, fill = "goldenrod")+
  xlab("Percent missing data per individual")+
  ylab("Number of occurences") +
  theme_bw()
plot4
#ggsave("indiv_miss.pdf", plot = plot4, path = mypath)


plot5 <- ggplot(indiv_mean_depth, aes(MEAN_DEPTH)) +
  geom_histogram(bins = 20, fill = "goldenrod")+
  xlab("Mean sequencing depth per individual")+
  ylab("Number of occurences") +
  theme_bw()
plot5
#ggsave("indiv_depth.pdf", plot = plot5, path = mypath)



#########################################################################################
#EXTRAS for final filtering#
# calculate a standard deviation from the mean
read_depth <- site_df$MEAN_DEPTH
head(read_depth)
mean_read_depth <- mean(read_depth)
mean_read_depth

three_sd <- 3*sd(read_depth)

cutoff <- mean_read_depth + three_sd
cutoff


