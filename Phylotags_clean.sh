#!/bin/bash
#PBS -l walltime=135:00:00
#PBS -N test_run
#PBS -l nodes=1:ppn=10
#PBS -l pvmem=18gb 
#PBS -o log.txt 
#PBS -A exd44_a_g_sc_default

export PATH="$PATH:/gpfs/group/exd44/default/rgn5011/.local/bin"
conda activate NCBI

cd /gpfs/group/exd44/default/rgn5011/NCBI_files/PhyloTags/PhyloTAGs_package/NCBI

perl ../01_phyloTAGs_align.pl -in gyr_refseq.fa -distance 16S_rDNA_id_cust.txt -reference NC_008618 -idlow 95 -idhigh 100
perl ../02_phyloTAGs_primer.pl -in aligned_by_codons.fas -format fasta -codons 7 -consensus 90 -greedy

pwd 
echo "Job started"
sleep 60
echo "Job ended"
