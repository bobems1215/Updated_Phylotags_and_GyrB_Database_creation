#!/bin/bash
#PBS -l walltime=135:00:00
#PBS -N test_run
#PBS -l nodes=1:ppn=10
#PBS -l pvmem=18gb 
#PBS -o log.txt 
#PBS -A exd44_e_g_sc_default

export PATH="$PATH:/gpfs/group/exd44/default/rgn5011/.local/bin/"

cd /gpfs/group/exd44/default/rgn5011/NCBI_files


usearch -allpairs_global 16S_refseq.fa -userout 16S_rDNA_id_cust.txt -userfields query+target+id -acceptall

pwd 
echo "Job started"
sleep 60
echo "Job ended"
