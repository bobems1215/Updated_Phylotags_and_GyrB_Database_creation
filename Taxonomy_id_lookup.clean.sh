#!/bin/bash
#PBS -l walltime=35:00:00
#PBS -N test_run
#PBS -l nodes=1:ppn=10
#PBS -l pvmem=18gb 
#PBS -o log.txt 
#PBS -A exd44_e_g_sc_default

export PATH="$PATH:/gpfs/group/exd44/default/rgn5011/.local/bin/"

cd /gpfs/group/exd44/default/rgn5011/NCBI_files/scripts

conda activate NCBI

cat ../gyr_refseq.fa | grep ">" >names.txt

mapfile -t NC < names.txt 


for ((i=0; i<18389; i++)); 
	do 
		esearch -db nuccore -query ${NC[i]}|elink -target taxonomy |efetch -format text >> NC_Tax.txt; 
		echo ${NC[i]} >> NC_Tax.txt;
	 done
 

pwd 
echo "Job started"
sleep 60
echo "Job ended"
