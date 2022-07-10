##-----------------------------------------------------
##Install required packages by running following code
##-----------------------------------------------------

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


