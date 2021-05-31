# mutation_library_analysis
Aligns multiple Fasta sequences of a gene library, for each varinat, identifies the type, the amount, and the location of the mutations. Additionally, the script also identifies the corresponding amino acid residue exchanges. 

#####################################################################################
## [Introduction]                                                                  ##
## This tool aligns a set of sample DNA sequences to a reference sequence,         ##
## finds the mutations in each sample sequences, and then export a csv file with   ##
## each row being each sample sequence and their amino acid substitutions.         ##
## Please contact Muen Chung (chungmuen@gmail.com) if you have any questions.      ##
################################################################################################################ 
## [ATTENTION!]                                                                                                #
## 0. Before running this tool, you must install the package "msa".                                            #
##    You can do this with the other script named: "install_msa_pkg_cleaned".                                  #
## 1. This tool only process forward DNA sequences (5' to 3')                                                  # 
## 2. The reference sequence should be in frame and shorter than the sample sequences in the following manner: # 
##    reference:   AATTCCGGCCAT                                                                                #
##    sample1:   TTAATTTCGGCCATGGCC                                                                            #
##    sample2:  ATTAATTCCGACCATGGC                                                                             #
## 3. Reference sequence and sample sequences need to be fasta files with a file name (your_file_name.fasta)   #
## 4. The tool assumes the first nucleotide is the start point for DNA translation,                            #
##    so please make sure your reference sequence in in frame.                                                 #
## 5. Please save all your sample sequences fasta files in one folder,                                         #
##    and don't put any other fasta files in the same folder.                                                  #
## 6. Please name your reference sequence as: reference.fasta                                                  #
## 7. Please make another folder named as "reference" inside the folder where you store your sample sequences. #
## 8. Please store your reference sequence file "reference.fasta" inside the folder you made in step 7.        #
## 9. The output csv file will be saved in a new folder called "mutation_analysis" under the folder you store  #
##    your sample sequences                                                                                    #
## 10.Please assign the location of the folder where you store all the sample sequences in the section below.  #
## 11.Finally, press ctrl+A to select all scripts, and then press ctrl+enter to run the whole script.          #
################################################################################################################
