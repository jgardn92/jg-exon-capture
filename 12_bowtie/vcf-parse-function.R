vcf.parser <- function(vcf.name) {
  #my.vcf <- read.vcfR(paste("all_recoded_vcfs/",vcf.name, sep = ""), verbose = FALSE)
  my.vcf <- read.vcfR(vcf.name, verbose = FALSE)
  ID.name <- str_sub(vcf.name, 1, nchar(vcf.name)-12)
  dp <- extract.gt(my.vcf, element = "DP", as.numeric = TRUE)
  ad <- extract.gt(my.vcf, element = "AD")
  ad.allele1 <- masplit(ad, sort = 0, record = 1)
  ad.allele2 <- masplit(ad, sort = 0, record = 2)
  dp.ad.tbl <- as.data.frame(cbind(dp, ad.allele1, ad.allele2))
  colnames(dp.ad.tbl) <- c("Depth", "A1_Count", "A2_Count")
  dp.ad.tbl$Minor_Allele <- ifelse(dp.ad.tbl$A1_Count > dp.ad.tbl$A2_Count, dp.ad.tbl$A2_Count,
                                   ifelse(dp.ad.tbl$A1_Count < dp.ad.tbl$A2_Count, dp.ad.tbl$A1_Count, dp.ad.tbl$A2_Count))
  dp.ad.tbl$Third_Allele <- dp.ad.tbl$Depth - (dp.ad.tbl$A1_Count + dp.ad.tbl$A2_Count)
  dp.ad.tbl$MA_Freq <- dp.ad.tbl$Minor_Allele/dp.ad.tbl$Depth
  dp.ad.tbl$TA_Freq <- dp.ad.tbl$Third_Allele/dp.ad.tbl$Depth
  n <- length(dp.ad.tbl$Depth)
  depth.hist.gg <- ggplot(dp.ad.tbl, aes(x = Depth)) + geom_histogram(binwidth = 20, fill = "grey50", color = "white") +
                   ggtitle(paste(ID.name, ". Total reads =",n)) +
                    xlab("Raw Depths before filtering")
  dp.ad.filt1 <- dp.ad.tbl %>% filter(Depth > 20)
  if(length(dp.ad.filt1$Depth)>1){
    ma.filt1.hist.gg <- ggplot(dp.ad.filt1, aes(x = MA_Freq)) + geom_histogram(binwidth = 0.05, fill = "grey50", color = "white") +
                        ggtitle(paste(ID.name)) + xlim(0, 0.5) +
                        xlab("Minor Allele Frequency after depth filter")
    ta.filt1.hist.gg <- ggplot(dp.ad.filt1, aes(x = TA_Freq)) + geom_histogram(binwidth = 0.01, fill = "grey50", color = "white") +
                        ggtitle(paste(ID.name)) + xlim(0,0.5) +
                        xlab("Third Allele Frequency after depth filter")
    tbl.filt2 <- dp.ad.filt1 %>% filter(MA_Freq > 0.1)
    n.filt2 <- length(tbl.filt2$Depth)
    ma.filt2.hist.gg <- ggplot(tbl.filt2, aes(x = MA_Freq)) + geom_histogram(binwidth = 0.05, fill = "grey50", color = "white") +
                               ggtitle(paste(ID.name, "from", n.filt2, "snps", sep = " ")) + xlim(0, 0.5) +
                               xlab("Minor Allele Frequency after depth and MA freq filter")
    tbl.filt2$Locus <- rownames(tbl.filt2)
    tbl.filt2$Locus <- sub('\\.fas.*', '', tbl.filt2$Locus)
    tbl.by.loc <- tbl.filt2 %>% group_by(Locus) %>% summarize(n = n(), mean(Depth), mean(MA_Freq), mean(TA_Freq))
    n.loc <- length(tbl.by.loc$Locus)
    depth.filt2.hist.gg <- ggplot(tbl.by.loc, aes(x = `mean(Depth)`)) + geom_histogram(binwidth = 20, fill = "grey50", color = "white") +
                           ggtitle(paste(ID.name, "with", n.loc, "genes")) +
                           xlab("Average Depth")
    MAfreq.filt2.hist.gg <- ggplot(tbl.by.loc, aes(x = `mean(MA_Freq)`)) + geom_histogram(binwidth = 0.05, fill = "grey50", color = "white") +
                            ggtitle(paste(ID.name, "with", n.loc, "genes")) + xlim(0, 0.5) +
                            xlab("Minor Allele Frequency")
    TAfreq.filt2.hist.gg <- ggplot(tbl.by.loc, aes(x = `mean(TA_Freq)`)) + geom_histogram(binwidth = 0.01, fill = "grey50", color = "white") +
                            ggtitle(paste(ID.name, "with", n.loc, "genes")) + xlim(0,0.5) +
                            xlab("Third Allele Frequency")
    output.data <- list(depth.hist.gg, ma.filt1.hist.gg, ta.filt1.hist.gg, depth.filt2.hist.gg, MAfreq.filt2.hist.gg, TAfreq.filt2.hist.gg,
                        ma.filt2.hist.gg, dp.ad.tbl, dp.ad.filt1, tbl.by.loc)
  } else {
    dp.filt1.result <- paste(ID.name, "had no reads with depth >20")
    output.data <- list(dp.ad.tbl, depth.hist.gg, dp.filt1.result)
  }
  return(output.data)
}
