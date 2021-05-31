##-----------------------------------------------------
##Install required packages by running following code
##-----------------------------------------------------

if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("msa")

##----------------------------------------------------------------------------------------------------------------------
##if you encounter the error: "Installation path not writable, unable to update packages: codetools, KernSmooth, nlme",
##then locate the folders where all R packages are installed using the command: .libPaths()
##and then manually install the missing packages to targeted path using following script:
##----------------------------------------------------------------------------------------------------------------------

install.packages(c("codetools", "KernSmooth", "nlme"), Lib = "here enter path for packages")

##---------------------------------------
##test if the installed package works
##---------------------------------------

##---------------------------------------
##import the package msa
##---------------------------------------
library(msa)

##---------------------------------------
##run example amino acid alignment
##---------------------------------------
mySequenceFile <- system.file("examples", "exampleAA.fasta", package="msa")
mySequences <- readAAStringSet(mySequenceFile)
mySequences
myFirstAlignment <- msa(mySequences)
myFirstAlignment

##---------------------------------------
##run example DNA alignment
##---------------------------------------
myDNAFile <- system.file("examples", "exampleDNA.fasta", package="msa")
mySequencesDNA <- readDNAStringSet(myDNAFile)
mySequencesDNA

exDNA_Alignment <- msa(mySequencesDNA)
exDNA_Alignment


