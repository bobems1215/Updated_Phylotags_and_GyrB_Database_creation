#!/bin/bash
#PBS -l walltime=35:00:00
#PBS -N test_run
#PBS -l nodes=1:ppn=10
#PBS -l pvmem=18gb 
#PBS -o log.txt 
#PBS -A exd44_e_g_sc_default
#Above are the PBS parameters used to run this command 

#This is needed to load extra packages hosted in my local directory

export PATH="$PATH:/gpfs/group/exd44/default/rgn5011/.local/bin/"

#Navigate to the directory with the gyrB reference database
cd /gpfs/group/exd44/default/rgn5011/NCBI_files/

conda activate NCBI

#We want to extract all of the taxonomy codes from the gyrB reference database
cat ../gyr_refseq.fa | grep ">" >names.txt

#We want to make the list of taxonomy codes an array 
mapfile -t NC < names.txt 

#The i limit should be the same as the one used for gyrB_database_creation.clean.sh 
for ((i=0; i<18389; i++)); 
	do 
		#We use the esearch package to search each taxonomy code on the nuccore (nucleotide) NCBI database. We can then pull out the taxonomy annotation and save it to a separate file called NC_Tax.txt. 
		esearch -db nuccore -query ${NC[i]}|elink -target taxonomy |efetch -format text >> NC_Tax.txt; 
		#We then print the taxonomy code under the annotated taxonomy. This can be changed to above by moving the code above the previous line
		echo ${NC[i]} >> NC_Tax.txt;
	 done
 

pwd 
echo "Job started"
sleep 60
echo "Job ended"
