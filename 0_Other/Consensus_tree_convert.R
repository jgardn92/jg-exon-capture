#Script to fix format issues with consensus trees
#Goal is to switch scores from :x.x[yyy] to yyy:x.x
library(tidyverse)

consensus_tree_convert <- function(in_tree){
  tree_in<-read_file(in_tree)
  split_tree <-as.data.frame(strsplit(tree_in, ":"))
  fill_tree <- split_tree
  final_tree <- NULL
  
  for(i in 1:length(split_tree[,1])){
    if(grepl('\\[', split_tree[i,1])){
      x <- split_tree[i,1]
      y <- str_split(x, "\\[", simplify = TRUE)
      z <- str_split(y, "\\]", simplify = TRUE)
      fill_tree[i,1] <- paste(z[2,1],":",z[1,1],z[2,2], sep = "")
    }
    final_tree <- paste(final_tree,fill_tree[i,1], sep = "")
  }
  
  return(final_tree)
}


write_file(consensus_tree_convert("9_RAxML_consensus_trees/RAxML_MajorityRuleConsensusTree.consensus_test"), 
           "Consensus_tree1.tree")
write_file(consensus_tree_convert("9_RAxML_consensus_trees/RAxML_MajorityRuleExtendedConsensusTree.consensus_test2"), 
           "Consensus_tree2.tree")
write_file(consensus_tree_convert("9_RAxML_consensus_trees/RAxML_MajorityRuleExtendedConsensusTree.consensus_test3"), 
           "Consensus_tree3.tree")
write_file(consensus_tree_convert("RAxML_MajorityRuleConsensusTree.contest"), "Run4_consensus.tree")
