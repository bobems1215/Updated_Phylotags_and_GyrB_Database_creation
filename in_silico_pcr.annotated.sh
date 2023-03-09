#!/bin/bash
#PBS -l walltime=135:00:00
#PBS -N test_run
#PBS -l nodes=1:ppn=10
#PBS -l pvmem=18gb 
#PBS -o log.txt 
#PBS -A exd44_e_g_sc_default
#Above are the PBS parameters used to run this command 

#This is needed to load the usearch package 
export PATH="$PATH:/gpfs/group/exd44/default/rgn5011/.local/bin/"

#We want to make sure we are in the directory where we downloaded the NCBI human microbiome dataset
cd /gpfs/group/exd44/default/rgn5011/NCBI_files/Primer_Check

#we use usearch to run in silico pcr on the concatenated NCBI human microbiome file that was created in the Human_Microbiome_db_download.clean.sh file. The -db (database) option is used for whatever primers we are testing. In this example they are the primers created for the Bacteroidaceae family. We have the max diffs set as 3 to give some flexibility to the in silico pcr. We also want to amplify as much as possible so we set the min amp to 30 bp and the max amp to 2000 bp. The Bacteroides_amp_out.txt file will have all of the bacterial species that are predicted to amplify after in silico PCR 
usearch -search_pcr ./Hum_Microbiome_db/Human_Microbiom_complete.fa -db prim_bac2.txt -strand both -maxdiffs 3 -minamp 30 -maxamp 2000 -pcrout Bacteroides_hits.txt -ampout Bacteroides_amp_out.txt
