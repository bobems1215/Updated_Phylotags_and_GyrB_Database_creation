#!/bin/bash
#PBS -l walltime=135:00:00
#PBS -N test_run
#PBS -l nodes=1:ppn=10
#PBS -l pvmem=18gb 
#PBS -o log.txt 
#PBS -A exd44_e_g_sc_default

export PATH="$PATH:/gpfs/group/exd44/default/rgn5011/.local/bin/"

cd /gpfs/group/exd44/default/rgn5011/NCBI_files/Primer_Check

usearch -search_pcr ./Hum_Microbiome_db/Human_Microbiom_complete.fa -db prim_bac2.txt -strand both -maxdiffs 3 -minamp 30 -maxamp 2000 -pcrout Bacteroides_hits.txt -ampout Bacteroides_amp_out.txt
