# Mutation Library Analysis Tool

## Introduction
Analyses DNA sequences of a given library and then generates following summaries for each variant:
1. DNA mutation counts of each mutation type (e.g., A->G, T->C) 
2. The location of the mutations on the reference DNA sequence
3. The corresponding amino acid residue exchanges 

## Input for the tool
1. concatenated DNA sequences of a given library and its reference DNA sequence (wild-type sequence)

## Output for the tool
Three csv files:
1. "mutation_analysis_results/AAmutations.csv"          
2. "mutation_analysis_results/DNAmutation_counts.csv"   
3. "mutation_analysis_results/DNAmutation_locations.csv"

## Please note                                                                                     
1. The tool assumes that the first nucleotide of the provided reference sequence is the starting point for DNA translation, so please make sure your reference sequence is in frame. 

## Vignette
https://chungmuen.github.io/mutation_library_analysis/

## Contact
Dr. Mu-En Chung
chungmuen@gmail.com    

 
                                          