#####################################################################################
## [Introduction]                                                                  ##
## This tool aligns a set of sample DNA sequences to a reference sequence,         ##
## finds the mutations in each sample sequences, and then export a csv file with   ##
## each row being each sample sequence and their amino acid substitutions.         ##
## Please contact Muen Chung if you have any questions.                            ##
############################################################################################################### 
## [ATTENTION!]                                                                                               #
## 0. Before running this tool, you must install the package "msa".                                           #
##    You can do this with the other script named: "install_msa_pkg".                                             #
## 1. This tool only process forward DNA sequences (5' to 3')                                                 # 
## 2. The reference sequence should be shorter than the sample sequences in the following manner:             # 
##    reference:   AATTCCGGCCAT                                                                               #
##    sample1:   TTAATTTCGGCCATGGCC                                                                           #
##    sample2:  ATTAATTCCGACCATGGC                                                                            #
## 3. Reference sequence and sample sequences need to be fasta files with a file name (your_file_name.fasta)  #
## 4. The tool assumes the first nucleotide is the start point for DNA translation,                           #
##    so please make sure your reference sequence in in frame.                                                #
## 5. Please save all your sample sequences fasta files in one folder,                                        #
##    and don't put any other fasta files in the same folder.                                                 #
## 6. Please name your reference sequence as: reference.fasta                                                 #
## 7. Please make another folder named as "reference" inside the folder where you store your sample sequences.#
## 8. Please store your reference sequence file "reference.fasta" inside the folder you made in step 7.       #
## 9. The output csv file will be saved in a new folder called "mutation_analysis" under the folder you store #
##    your sample sequences                                                                                   #
## 10.Please assign the location of the folder where you store all the sample sequences in the section below.  #
## 11.Finally, press ctrl+A to select all scripts, and then press ctrl+enter to run the whole script.         #
###############################################################################################################

##import package msa
library(msa)

###run example provided by msa package
mySequenceFile <- system.file("examples", "exampleAA.fasta", package="msa")
mySequences <- readAAStringSet(mySequenceFile)
mySequences
myFirstAlignment <- msa(mySequences)
myFirstAlignment

##run example DNA alignment
myDNAFile <- system.file("examples", "exampleDNA.fasta", package="msa")
mySequencesDNA <- readDNAStringSet(myDNAFile)
mySequencesDNA

exDNA_Alignment <- msa(mySequencesDNA)
exDNA_Alignment
######################REAL#RUN############################################################################
##enter the path to the folder containing the sequencing results between "", to set the working directory#                            
##########################################################################################################
setwd("D:/Cloudplan/Customers/gevo_18GO01US/Projects/20J020/sequencing_results/30variants+86_87/Fragment2")

#setwd("D:/Cloudplan/Customers/gevo_18GO01US/Projects/20J020/sequencing_results/PCR_cloning_lib/Fragment3")


##concatenate the fasta files
refSeq <- readDNAStringSet("./reference/reference.fasta")
SeqFile_list <- list.files(path = ".", pattern = ".*.fasta")
print(SeqFile_list)
fa_seq = sapply(SeqFile_list,readDNAStringSet,USE.NAMES = F)
print(fa_seq)
fa_seq_c = do.call(c,fa_seq)
print(fa_seq_c)
ref_fa_seq_c <- c(refSeq,fa_seq_c)
print(ref_fa_seq_c)

##run my alignment
myDNA_Alignment <- msa(ref_fa_seq_c)

#The print() function provided by the msa package provides some ways for customizing the output, such as, showing the entire alignment split over multiple blocks of sub-sequences
print(myDNA_Alignment, show="complete")

#convert alignment to a list of vectors and matrix 
convert <- msaConvert(myDNA_Alignment,type= "bio3d::fasta")

alignment_mat <- convert$ali
alignment_df <- as.data.frame(alignment_mat)

alignment_df_dREF <- alignment_df[-grep("reference",row.names(alignment_df)),]
alignment_df_dREF <- alignment_df_dREF[order(row.names(alignment_df_dREF)),]

alignment_df_reorder <- as.data.frame(rbind(alignment_df[grep("reference",row.names(alignment_df)),],alignment_df_dREF))

#remove columns extruding the reference sequence
keep_columns <- as.data.frame(which(alignment_df_reorder[1,]!= "-"))
trim_before <- keep_columns[1,1]-1
trim_after <- keep_columns[length(keep_columns[,1]),1]+1
trim_alignment <- alignment_df_reorder[,-c(1:trim_before,trim_after:ncol(alignment_df_reorder))]
trim_alignment[1,]

#identify the position of "-" in the reference 
reference_row <- trim_alignment[1,]
print("afer alignment, the positions of - in the reference sequence are:")
which(reference_row == "-")

#identify the mutations and create a matrix of mutations (0=mutation, 1=no mutation)
mutation_count <- trim_alignment

for (i in 1:nrow(trim_alignment)) 
{
  for (j in 1:ncol(trim_alignment)) 
  {
    if (trim_alignment[i, j] == trim_alignment[1, j]) 
    {
      mutation_count[i, j] <- 1
    } 
    else 
    {
      mutation_count[i, j] <- 0
    }
  }
}

################################################

#classfy the mutations and create a matrix of mutations
mutation_count_TvTs <- trim_alignment

for (i in 1:nrow(trim_alignment)) 
{
  for (j in 1:ncol(trim_alignment)) 
  {
    if (trim_alignment[i,j] == trim_alignment[1,j]) 
    {
      mutation_count_TvTs[i,j] <- "-"
    } 
    else if (trim_alignment[i,j] == "A")
    {
      if (trim_alignment[1,j] == "T")
      {
        mutation_count_TvTs[i, j] <- "TA"
      }
      else if (trim_alignment[1,j] == "C")
      {
        mutation_count_TvTs[i, j] <- "CA"
      }
      else if (trim_alignment[1,j] == "G")
      {
        mutation_count_TvTs[i, j] <- "GA"
      }
      else if (trim_alignment[1,j] == "-")
      {
        mutation_count_TvTs[i, j] <- "Ins"
      }
    }
    else if (trim_alignment[i,j] == "T")
    {
      if (trim_alignment[1,j] == "A")
      {
        mutation_count_TvTs[i, j] <- "AT"
      }
      else if (trim_alignment[1,j] == "C")
      {
        mutation_count_TvTs[i, j] <- "CT"
      }
      else if (trim_alignment[1,j] == "G")
      {
        mutation_count_TvTs[i, j] <- "GT"
      }
      else if (trim_alignment[1,j] == "-")
      {
        mutation_count_TvTs[i, j] <- "Ins"
      }
    }
    else if (trim_alignment[i,j] == "C")
    {
      if (trim_alignment[1,j] == "A")
      {
        mutation_count_TvTs[i, j] <- "AC"
      }
      else if (trim_alignment[1,j] == "T")
      {
        mutation_count_TvTs[i, j] <- "TC"
      }
      else if (trim_alignment[1,j] == "G")
      {
        mutation_count_TvTs[i, j] <- "GC"
      }
      else if (trim_alignment[1,j] == "-")
      {
        mutation_count_TvTs[i, j] <- "Ins"
      }
    }
    else if (trim_alignment[i,j] == "G")
    {
      if (trim_alignment[1,j] == "A")
      {
        mutation_count_TvTs[i, j] <- "AG"
      }
      else if (trim_alignment[1,j] == "T")
      {
        mutation_count_TvTs[i, j] <- "TG"
      }
      else if (trim_alignment[1,j] == "C")
      {
        mutation_count_TvTs[i, j] <- "CG"
      }
      else if (trim_alignment[1,j] == "-")
      {
        mutation_count_TvTs[i, j] <- "Ins"
      }
    }
    else if (trim_alignment[i,j] == "-")
    {
      mutation_count_TvTs[i, j] <- "Del"
    }  
    else
    {
      mutation_count_TvTs[i, j] <- "?"
    }  
  }
}

#check if all the elements are assigned as "-", "S", "V", "Del", "Ins", "?"
for(i in 1:nrow(mutation_count_TvTs))
{
  a <- table(as.character(mutation_count_TvTs[i,]))
  print(a)
}

#show row names
rownames <- as.data.frame(row.names(mutation_count))

#count the mutations in each sequence
#output: 
#id - S V Ins Del ?
mutation_count_row <- t(as.matrix(table(as.character(mutation_count_TvTs[1,]))))
addition <- matrix(c(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0), nrow = 1, ncol = 15)
mutation_count_row <- as.data.frame(cbind(mutation_count_row,addition))
colnames(mutation_count_row) <- c("-","AG", "GA", "AT", "TA", "AC", "CA", "GC", "CG", "GT", "TG", "CT", "TC", "Del", "Ins", "?")

for(i in 2:nrow(mutation_count_TvTs))
{
  mutation_count_row2 <- as.data.frame(t(as.matrix(table(as.character(mutation_count_TvTs[i,])))))
  if(!('AG' %in% names(mutation_count_row2)))
  {
    addition <- as.data.frame(matrix(0, nrow = 1, ncol = 1))
    colnames(addition) <- 'AG'
    mutation_count_row2 <- as.data.frame(cbind(mutation_count_row2,addition))
  }
  if(!('GA' %in% names(mutation_count_row2)))
  {
    addition <- as.data.frame(matrix(0, nrow = 1, ncol = 1))
    colnames(addition) <- 'GA'
    mutation_count_row2 <- as.data.frame(cbind(mutation_count_row2,addition))
  }
  if(!('AT' %in% names(mutation_count_row2)))
  {
    addition <- as.data.frame(matrix(0, nrow = 1, ncol = 1))
    colnames(addition) <- 'AT'
    mutation_count_row2 <- as.data.frame(cbind(mutation_count_row2,addition))
  }
  if(!('TA' %in% names(mutation_count_row2)))
  {
    addition <- as.data.frame(matrix(0, nrow = 1, ncol = 1))
    colnames(addition) <- 'TA'
    mutation_count_row2 <- as.data.frame(cbind(mutation_count_row2,addition))
  }
  if(!('AC' %in% names(mutation_count_row2)))
  {
    addition <- as.data.frame(matrix(0, nrow = 1, ncol = 1))
    colnames(addition) <- 'AC'
    mutation_count_row2 <- as.data.frame(cbind(mutation_count_row2,addition))
  }
  if(!('CA' %in% names(mutation_count_row2)))
  {
    addition <- as.data.frame(matrix(0, nrow = 1, ncol = 1))
    colnames(addition) <- 'CA'
    mutation_count_row2 <- as.data.frame(cbind(mutation_count_row2,addition))
  }
  if(!('GC' %in% names(mutation_count_row2)))
  {
    addition <- as.data.frame(matrix(0, nrow = 1, ncol = 1))
    colnames(addition) <- 'GC'
    mutation_count_row2 <- as.data.frame(cbind(mutation_count_row2,addition))
  }
  if(!('CG' %in% names(mutation_count_row2)))
  {
    addition <- as.data.frame(matrix(0, nrow = 1, ncol = 1))
    colnames(addition) <- 'CG'
    mutation_count_row2 <- as.data.frame(cbind(mutation_count_row2,addition))
  }
  if(!('GT' %in% names(mutation_count_row2)))
  {
    addition <- as.data.frame(matrix(0, nrow = 1, ncol = 1))
    colnames(addition) <- 'GT'
    mutation_count_row2 <- as.data.frame(cbind(mutation_count_row2,addition))
  }
  if(!('TG' %in% names(mutation_count_row2)))
  {
    addition <- as.data.frame(matrix(0, nrow = 1, ncol = 1))
    colnames(addition) <- 'TG'
    mutation_count_row2 <- as.data.frame(cbind(mutation_count_row2,addition))
  }
  if(!('CT' %in% names(mutation_count_row2)))
  {
    addition <- as.data.frame(matrix(0, nrow = 1, ncol = 1))
    colnames(addition) <- 'CT'
    mutation_count_row2 <- as.data.frame(cbind(mutation_count_row2,addition))
  }
  if(!('TC' %in% names(mutation_count_row2)))
  {
    addition <- as.data.frame(matrix(0, nrow = 1, ncol = 1))
    colnames(addition) <- 'TC'
    mutation_count_row2 <- as.data.frame(cbind(mutation_count_row2,addition))
  }
  if(!('Del' %in% names(mutation_count_row2)))
  {
    addition <- as.data.frame(matrix(0, nrow = 1, ncol = 1))
    colnames(addition) <- 'Del'
    mutation_count_row2 <- as.data.frame(cbind(mutation_count_row2,addition))
  }
  if(!('Ins' %in% names(mutation_count_row2)))
  {
    addition <- as.data.frame(matrix(0, nrow = 1, ncol = 1))
    colnames(addition) <- 'Ins'
    mutation_count_row2 <- as.data.frame(cbind(mutation_count_row2,addition))
  }
  if(!('?' %in% names(mutation_count_row2)))
  {
    addition <- as.data.frame(matrix(0, nrow = 1, ncol = 1))
    colnames(addition) <- '?'
    mutation_count_row2 <- as.data.frame(cbind(mutation_count_row2,addition))
  }
  mutation_count_row2
  
  mutation_count_row <- rbind(mutation_count_row,mutation_count_row2)
}
row.names(mutation_count_row) <- row.names(mutation_count_TvTs)

################################################
#identify the row with the most mutations
n_mut <- sum(mutation_count[1,]==0)
for(i in 2:nrow(mutation_count))
{
  n_mut2 <- sum(mutation_count[i,]==0)
  if(n_mut2 >= n_mut)
  {
    n_mut <- n_mut2
  }
}
###############################################
#identify mutation locations
mutation_locations <- rep(NA,n_mut)

for(i in 2:nrow(mutation_count))
{
  mutation_locations2 <- rep(NA,n_mut)
  mutations <- t(as.data.frame(which(mutation_count[i,]==0)))
  for (j in 1:n_mut)
  {
    if (j <= ncol(mutations))
    {
      mutation_locations2 [j] <- mutations[1,j]
    }
  }
  mutation_locations <-  rbind(mutation_locations, mutation_locations2)
}
row.names(mutation_locations) <- row.names(mutation_count)

###########################################################################
#identify the amino acid mutations
if(sum(trim_alignment[1,]=="-")!= 0)
{
  trim_dash <- trim_alignment[,-c(which(trim_alignment[1,]=="-"))] 
}else
{
  trim_dash <- trim_alignment
}

modulo_mut_loc_df <- mutation_locations 
AAmutations_df <- mutation_locations
for(i in 1:nrow(mutation_locations))
{
  mutation_location_location <- which(mutation_locations[i,] != "NA")
  if(length(mutation_location_location) > 0)
  {
    for(j in 1:length(mutation_location_location))
    {
      print("-----start------")
      print("i=")
      print(i)
      print("j=")
      print(j)
      print("mutation_locations[i,j]=")
      print(mutation_locations[i,j])
      mutation_location_x <- as.numeric(mutation_locations[i,j]) 
      print("mutation_location_x=")
      print(mutation_location_x)
      mutation_location_remove_dash <- mutation_location_x - sum(trim_alignment[1,1:(mutation_location_x-1)] == "-")
      print("mutation_location_remove_dash=")
      print(mutation_location_remove_dash)
      modulo_mut_loc <- mutation_location_remove_dash %% 3
      modulo_mut_loc_df[i,j] <- modulo_mut_loc
      
      if(trim_alignment[1,mutation_location_x] == "-")
      {
        #print("plop")
        AAmutations_df[i,j] <- "frame_shift_ins"
        #print(AAmutations_df[i,j])
      }   
      
      else if (modulo_mut_loc == 0)
      {
        codon_start <- mutation_location_remove_dash-2
        codon_end <- mutation_location_remove_dash
      }
      else if (modulo_mut_loc == 1)
      {
        codon_start <- mutation_location_remove_dash
        codon_end <- mutation_location_remove_dash+2
      }
      else if (modulo_mut_loc == 2)
      {
        codon_start <- mutation_location_remove_dash-1
        codon_end <- mutation_location_remove_dash+1
      }
      
      aa_position <- ceiling(mutation_location_remove_dash/3)
      print("aaPosition")
      print(aa_position)
      
      WTcodon <- paste(c(trim_dash[1,codon_start:codon_end]), collapse="")
      WTcodon_DNAstr <- DNAString(WTcodon)
      WTaa <- translate(WTcodon_DNAstr)
      print("WTcodon and aa")
      print(WTcodon_DNAstr)
      print(WTaa)
      
      MUTcodon <- c(trim_dash[i,codon_start:codon_end])
      print("MUTcodon")
      print(MUTcodon)
      
      if (sum(MUTcodon[]== "-") != 0)
      {
        MUTaa <- "frame_shift_del"
        print("frame_shift_del")
      }
      
      
      else if (sum(MUTcodon[] %in% c("A","T","C","G")) == 3)
      {
        MUTcodon_DNAstr <- DNAString(paste(MUTcodon, collapse = ""))
        print("MUTcodon_DNAstr")
        print(MUTcodon_DNAstr)
        MUTaa <- translate(MUTcodon_DNAstr)
        print("translation!MUTaa")
        print(MUTaa)
      }
      
      else if (sum(MUTcodon[] %in% c("A","T","C","G","-")) != 3)
      {
        MUTaa <- "unidentifiable base"
        print("unidentifiable base :(")
      }
      
      WTaa_cha <- as.character(WTaa)
      MUTaa_cha <- as.character(MUTaa)
      aa_position_cha <- as.character(aa_position)
      AAmutations <- c(WTaa_cha,aa_position_cha,MUTaa_cha)
      AAmutations_df[i,j] <- paste(AAmutations, collapse="")
      print("-----END-----")
    }
  }
}

##turn "NA" to nothing for output csv
AAmutations_removeNA <- AAmutations_df
AAmutations_removeNA[is.na(AAmutations_removeNA)] <- ""
mutation_locations_removeNA <- mutation_locations
mutation_locations_removeNA[is.na(mutation_locations_removeNA)] <- ""
##create a new folder in the current working directory 
dir.create("mutation_analysis", recursive = T)

##Save the dataframes 
write.csv(mutation_count_row,"mutation_analysis/DNAmutation_counts.csv", row.names = TRUE)
write.csv(mutation_locations_removeNA,"mutation_analysis/DNAmutation_locations.csv", row.names = TRUE)
write.csv(AAmutations_removeNA,"mutation_analysis/AAmutations.csv", row.names = TRUE)

