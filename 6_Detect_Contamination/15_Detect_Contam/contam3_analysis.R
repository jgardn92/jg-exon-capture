library(tidyverse)

contam <- read.delim("../jg-exon-capture/6_Detect_Contamination/15_Detect_Contam/contamination_stat3_full.txt")

per.con <- contam$Percentage.of.contaminated.pair...
hist(per.con, xlim = c(0,30), breaks = 30)
length(per.con)
per.con <- sort(per.con)
sum(per.con>=15)/length(per.con)
0.95*length(per.con)
per.con[4235]
