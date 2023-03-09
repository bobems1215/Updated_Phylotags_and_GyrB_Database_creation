#!/bin/bash
#PBS -l walltime=135:00:00
#PBS -N test_run
#PBS -l nodes=1:ppn=10
#PBS -l pvmem=18gb 
#PBS -o log.txt 
#PBS -A exd44_e_g_sc_default
#Above are the PBS parameters used to run this command 

#This is needed to load extra packages hosted in my local directory
export PATH="$PATH:/gpfs/group/exd44/default/rgn5011/.local/bin"

#This is used to navigate to the folder where the GYRB database is downloaded and make a directory called Primer_Check
cd /gpfs/group/exd44/default/rgn5011/NCBI_files/Primer_Check/

#Making directories for the database and the fasta files 
mkdir Hum_Microbiome_db
cd Hum_Microbiome_db
mkdir raw_data
mkdir fasta_seqs
cd raw_data

#Use wget to download the human microbiome bacterial database from the NCBI 
wget https://ftp.ncbi.nlm.nih.gov/genomes/HUMAN_MICROBIOM/Bacteria/all.fna.tar.gz

#Use tar to unzip the file
tar -zxvf all.fna.tar.gz
rm all.fna.tar.gz
cd ..

#We want to get a list of all the downloaded files and make that variable an array
ls raw_data/ > hmd.txt
mapfile -t hmd < hmd.txt

#Make sure to count how many bacteria were downloaded (it should be 940)
wc -l hmd.txt 

#In this loop we will be going to each downloaded bacteria’s directory, unzipping the contents and then moving the .fna files to a separate directory 
for ((i=0; i<941; i++));
	do
		cd /gpfs/group/exd44/default/rgn5011/NCBI_files/Primer_Check/Hum_Microbiome_db/raw_data/${hmd[i]}/; 
		tar -zxvf *; 
		 mv *fna* ../../fasta_seqs;
	done

#we need to make sure to change directories 
cd /gpfs/group/exd44/default/rgn5011/NCBI_files/Primer_Check/Hum_Microbiome_db

#remove all the .tgz files from the fasta_seqs directory 
rm fasta_seqs/*tgz*

#concatenate all the .fna files into one file called Human_Microbiome_complete.fa. This will be used for in silico PCR
cat fasta_seqs/*fna* > Human_Microbiom_complete.fa

pwd 
echo "Job started"
sleep 60
echo "Job ended"
