#!/bin/bash
#PBS -l walltime=135:00:00
#PBS -N test_run
#PBS -l nodes=1:ppn=10
#PBS -l pvmem=18gb 
#PBS -o log.txt 
#PBS -A exd44_e_g_sc_default

export PATH="$PATH:/gpfs/group/exd44/default/rgn5011/.local/bin"

cd /gpfs/group/exd44/default/rgn5011/NCBI_files/Primer_Check/

mkdir Hum_Microbiome_db
cd Hum_Microbiome_db
mkdir raw_data
mkdir fasta_seqs
cd raw_data

wget https://ftp.ncbi.nlm.nih.gov/genomes/HUMAN_MICROBIOM/Bacteria/all.fna.tar.gz
tar -zxvf all.fna.tar.gz
rm all.fna.tar.gz
cd ..

ls raw_data/ > hmd.txt

mapfile -t hmd < hmd.txt
wc -l hmd.txt 

for ((i=0; i<941; i++));
	do
		cd /gpfs/group/exd44/default/rgn5011/NCBI_files/Primer_Check/Hum_Microbiome_db/raw_data/${hmd[i]}/; 
		tar -zxvf *; 
		 mv *fna* ../../fasta_seqs;
	done

cd /gpfs/group/exd44/default/rgn5011/NCBI_files/Primer_Check/Hum_Microbiome_db
rm fasta_seqs/*tgz*
cat fasta_seqs/*fna* > Human_Microbiom_complete.fa

pwd 
echo "Job started"
sleep 60
echo "Job ended"
