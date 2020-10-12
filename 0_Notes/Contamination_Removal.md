# Contaminated Taxa Selection

###2020-09-15 Notes
* Drop one crystallichthys -> whichever is more contaminated based on detect_contam.pl
* Drop the *Paraliparis mento* at the base of the tree  
**Select contaminated taxa by:**
* Look for species with two reps in two diff spots
	* Remove one in wrong spot.
* Start with ones very obviously wrong
* Only remove a few at a time (4-5)
* For each screening, write down taxa that get pulled out

## Contamination Removal 1
Removed based on detect contamination = Run 4
Samples Removed

* ATAN_UW150813_S404
* AUNA_UW150790_S402
* AUNA_UW150804_S403
* CSIM_UW154482_2_S421
* CSTA_UW155711_S387

## Contamination Removal 2
Remove based on Run 4 Tree = Run 5

* Crystallichthys 151026 = CCYC_UW151026_S409
* Paraliparis mento 150606 = PMEN_UW150606_S400
* Paraliparis rosaceus 153323 = PROS_UW153323_S419

## CONTAMINTATION REMOVAL 3
BASED ON RUN 5 TREE = RUN6
  
* AJOR_UW153152_S416   
* RBAR_UW157184_S476  
* LNAN_UW119179_2_S452  
* CCYC_UW150847_S408  
* LCUR_UW44504_S439

## Notes after Run 6 
Notes on next steps from meeting on 2020-10-09

* tree isn't getting better, widespread contamination still appears to be an issue
* Step 1: check to make sure the index primer matching is ok
	* 2020-10-12 Checked index primers, no apparent matching issues
* Create trees based on 251 genes with full (97 taxa) sampling
	* Make all trees in RAxML
	* Create gene trees for each individual gene
	* Create concatenated tree from all 251 genes
	* Compare those trees
	