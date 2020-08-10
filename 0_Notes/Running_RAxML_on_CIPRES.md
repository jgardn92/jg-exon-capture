# Running RAxML on CIPRES

Currently Planning to run RAxML on [CIPRES](http://www.phylo.org/) instead of locally due to issues installing RAxML locally on a Windows machine

### Next Steps

1. Concatenations -> ideal output nexus format
	- ID single locus to run as test  
	- Concatenate all data to run as big tree  
	- Concatenate filtered data to run as main tree
	- Send concatenations to Luke to run locally  

2. Email Jay, Duane, Ingrid, Gary, and Luke for COI and RADSeq data run on RAxML to make comparison trees  

3. Run on CIPRES
	- Log in to account
	- Upload data
	- Tasks -> create new task -> name task -> choose data
	- Tools -> Select RAxML-HPC2 (for now)
	- Parameters: change time to 24 hours, leave rest as default (for now)
	- Save Parameters
	- Save and Run Task
	- Can check on task using intermediate results

**Use the Test Queue to your advantage**:  
The test queue is a common feature for large HPC resources. Each of the XSEDE resources we use has a test queue. The idea is to allow very short runs just to be sure you have the command line correct. That way, you avoid waiting in the queue for 8 hours, only to receive a trivial error due to a duplicate taxon label, or submission of a Nexus format matrix to RAxML when it finally begins to execute. So, the first time you create a job, set the time to some number less than 0.5 hours and submit. The test queue is (almost) always pretty fast, and you will discover your errors immediately.  Once you have it worked out, you can use the “Clone” feature to open the job up, set a long time limit and deploy.

 
	