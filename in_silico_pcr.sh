#!/bin/bash
#SBATCH --time=135:00:00
#SBATCH --job-name=NCBI_to_gyrb
#SBATCH --nodes=1
#SBATCH --mem=18G
#SBATCH --ntasks=10
#SBATCH --output=NCBI_to_gyrB.out
#SBATCH --error=NCBI_log.out
#SBATCH --partition=sla-prio
#SBATCH --account=one

#These are the SLURM parameters used to run the script


#This is needed to load the usearch package 
export PATH="$PATH:/storage/group/exd44/default/rgn5011/.local/bin/"

#We want to make sure we are in the directory where we downloaded the NCBI human microbiome dataset
cd ./NCBI_files/Primer_Check

#We need to create a primer file to test with in silico PCR. These primers are the ones used for the Nichols Bacteroidaceae long read primers

echo '>Prim1F ' > bac_primer.txt
echo 'CCYGCGATGTAYATYGGTGAC'>> bac_primer.txt
echo '>Prim1R'>> bac_primer.txt
echo 'ACYTGYTTCAGCATACGGTTT'>> bac_primer.txt

#we use usearch to run in silico pcr on the concatenated NCBI human microbiome file that was created in the Human_Microbiome_db_download.clean.sh file. The -db (database) option is used for whatever primers we are testing. We have the max diffs set as 3 to give some flexibility to the in silico pcr. We also want to amplify as much as possible so we set the min amp to 30 bp and the max amp to 2000 bp. The Bacteroides_amp_out.txt file will have all of the bacterial species that are predicted to amplify after in silico PCR 
usearch -search_pcr ./Hum_Microbiome_db/Human_Microbiom_complete.fa -db bac_primer.txt -strand both -maxdiffs 3 -minamp 30 -maxamp 2000 -pcrout Bacteroides_hits.txt -ampout Bacteroides_amp_out.txt
