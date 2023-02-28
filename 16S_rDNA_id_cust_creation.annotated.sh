#!/bin/bash
#PBS -l walltime=135:00:00
#PBS -N test_run
#PBS -l nodes=1:ppn=10
#PBS -l pvmem=18gb 
#PBS -o log.txt 
#PBS -A exd44_e_g_sc_default

export PATH="$PATH:/gpfs/group/exd44/default/rgn5011/.local/bin/"

cd /gpfs/group/exd44/default/rgn5011/NCBI_files



#* For pyhlotags we need a custom 16S rDNA id file that gives the percent identity between all bacterial species used to create the gyrB database. We can use usearch to make this file with the dereplicated 16S database we generated in the gyrB_database_Creation.sh file. This command takes about 11 hours to run and creates a file that is about 5gb large 

usearch -allpairs_global 16S_refseq.fa -userout 16S_rDNA_id_cust.txt -userfields query+target+id -acceptall

pwd 
echo "Job started"
sleep 60
echo "Job ended"
