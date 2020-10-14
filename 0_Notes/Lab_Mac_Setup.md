# Setting Up Lab Mac
***
##  Perl Modules and Scripts
* use `which perl` to determine what the shebang should be and where to put modules
* put Perl Modules in /luketornabene/miniconda3/lib/5.26.2/
* change shebang on perl scripts to `#!/Users/luketornabene/miniconda3/bin/perl/`
* create a folder called biotools in `/usr/local/bin/` and add to path following [Calder’s instructions](https://github.com/calderatta/ca-exon-capture/blob/master/Installation_Guide.md)
* move scripts with updated shebangs here using `sudo mv ~/pipeline_scripts/postprocess/*.pl /usr/local/bin/biotools/``
* **NOTE** Only the post processing scripts have been loaded on the Mac, since the assembly scripts need to be run on a cluster


## Note on Scripts
* based on running scriptname.pl -h all scripts are working *except*
	*  `clocklikeness_test.pl` - need to install the Statistics::Distributions module
	*  `gatk.sh` - need to install Java runtime (I think)
* downloaded [taxnameconvert.pl](http://www.cibiv.at/software/taxnameconvert/)

***
## Installing RAxML and ASTRAL  
* both installed
* RAxML has been added to path and can be called with `raxmlHPC-PTHREADS-AVX` *note: tab complete works after rax*
* Astral could not be added to path and instead can be run by `java -jar /Users/luketornabene/Astral/astral.5.7.3.jar`

***
## Git in Command line
Use when moving folders with lots of files (atom doesn't like to do this itself)
`git -status` to make sure your changes are staged
`git commit -m "Commit message here"` to commit with in line commit message. Otherwise opens a text editor when moving a lot of files it's a mess. Use -m for in line.
