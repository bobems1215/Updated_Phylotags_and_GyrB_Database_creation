#!/bin/bash
#SBATCH --time=135:00:00
#SBATCH --job-name=16S_creation
#SBATCH --nodes=1
#SBATCH --mem=18G
#SBATCH --ntasks=10
#SBATCH --output=16S_creation.out
#SBATCH --error=16S_creation.log.out
#SBATCH --partition=sla-prio
#SBATCH --account=one

#This is needed to load my version of USEARCH. Please note that individual licenses of usearch are needed.
export PATH="$PATH:/storage/group/exd44/default/rgn5011/.local/bin/"

#This is used to nagivate to the directory that the NCBI GYRB database will be located
cd ./NCBI_files



#For pyhlotags we need a custom 16S rDNA id file that gives the percent identity between all bacterial species used to create the gyrB database. We can use usearch to make this file with the dereplicated 16S database we generated in the gyrB_database_Creation.sh file. This command takes about 11 hours to run and creates a file that is about 5gb large. Also note that individual licenses are needed of Usearch and this program is not included in the conda environment.  

usearch -allpairs_global 16S_refseq.fa -userout 16S_rDNA_id_cust.txt -userfields query+target+id -acceptall
