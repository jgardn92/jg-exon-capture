#Exon Capture Pipeline on Windows

##### Tornabene Lab of Systematics and Biodiveristy

Author: Jennifer Gardner  
University of Washington  
School of Aquatic and Fishery Sciences  
jgardn92@uw.edu  

Created: July 5, 2020  

Last modified: ~  

***
##Introduction
This document has specific instructions for installing and running the Exon Capture pipeline on a windows computer where many dependencies (including a linux environment and perl) had to be installed from scratch. These notes are what worked for getting the pipeline to run on my personal computer. All steps here were run locally on my machine. These steps start after sequence data went through the assembly pipeline, as run by Calder Atta on the Shanghai Oceanus cluster. As of 2020-07-05, still need to work on getting set up to run the pipeline on the UW cluster (either Mox or Hyak). 

##Overview
* Unbuntu subsystem for Windows
* Installing Perl
* Installing Perl Modules
* Installing/running Pipeline scripts
* Installing MAFFT
* Installing RAxML
* Installing ASTRAL

***
##Setting up Ubuntu subsystem for Windows
* Installed Ubuntu subsystem for Windows following [instructions]() from Carolyn Tarpey
***
## Installing Perl
* **NEED TO UPDATE NOTES ON INSTALLING PERL. At this time I don't remember how it went.**
***
## Installing Perl Modules on Ubuntu Subsystem
* Got most modules as a zip file from Calder
###Installing Moo properly
* didn't install properly from zip file from Calder
	* Method::Generate modules missing. Instead needed to install full Moo-2.004000
* Download the folder for Moo-2.004000 following the instructions on [Calder's GitHub](https://github.com/calderatta/ca-exon-capture/blob/master/Installation_Guide.md#perl-modules)
	* downloaded to my version of Exon-Capture/perl_modules folder
*  navigate to folder where downloaded and then unzip using `tar -xzvf Moo-2.004000.tar.gz`
* navigate into the newly created Moo-2.004000 folder then run `sudo cp -r ./lib/ -T /usr/local/share/perl/5.26.1/` 
	* check that it worked by using `ls /usr/local/share/perl/5.26.1/` and looking for both Moo and Method folders 
  
***
## Installing and Running Pipeline Scripts
* Pipeline scrips downloaded from the [GitHub](https://github.com/calderatta/ca-exon-capture/tree/master/pipeline_scripts)  
* Change shebang (first line of scripts) to work on my computer
 * my shebang is `#!/usr/bin/perl`  
* Copy scripts to folder in path: 

	```sudo cp\```  
	```/mnt/c/Users/jrgar/Documents/GitHub/Exon-Cap/pipeline_scripts/postprocess/script.pl\	```  
	```/usr/local/bin/```

* run `script.pl --help` to make sure it worked

***
## Installing MAFFT
* Downloaded MAFFT [here](https://mafft.cbrc.jp/alignment/software/) and followed the instructions
* **POTENTIALLY NEED TO UPDATE**

***
## Installing RAxML
* not installed as of 2020-07-05

***
## Installing ASTRAL
* not installed as of 2020-07-05
* 
