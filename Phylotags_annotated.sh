#!/bin/bash
#PBS -l walltime=135:00:00
#PBS -N test_run
#PBS -l nodes=1:ppn=10
#PBS -l pvmem=18gb 
#PBS -o log.txt 
#PBS -A exd44_a_g_sc_default
#Above are the PBS parameters used to run this command 

#This is needed to load extra packages hosted in my local directory
export PATH="$PATH:/gpfs/group/exd44/default/rgn5011/.local/bin"


conda activate NCBI

#Download the phylotags package from source and move it to the directory you have the gyrB database in. Create a directory inside the PhyloTags/PhyloTAGs_package folder where you want to run and keep the output files for phlyotags. Also move the ‘gyr_refseq.fa’ and the ‘16S_rDNA_id_cust.txt’ files to this new directory. 
cd /gpfs/group/exd44/default/rgn5011/NCBI_files/PhyloTags/PhyloTAGs_package/NCBI

#Use the file created from the Taxonomy_id_lookup.sh file (NC_Tax.txt) to look for a reference file for the bacteria of interest. This can be easily done by extracting the taxonomy codes and bacterial names of the bacteria of interest with this code: 
#cat NC_Tax.txt | grep  -A 2 "Bifidobacterium"  > bifido_ref.txt
#And then picking a Taxonomy code from the bifido_ref.txt file to use as a reference for phylotags.  

#Run Phylotags. IDhigh should always be 100 because this will include identical species. IDlow is used to determine how specific the primers will be, the higher idlow is, the more specific the primers will be. For the purposes of this experiment idlow values ranged from 95 to 92

perl ../01_phyloTAGs_align.pl -in gyr_refseq.fa -distance 16S_rDNA_id_cust.txt -reference NC_008618 -idlow 95 -idhigh 100
perl ../02_phyloTAGs_primer.pl -in aligned_by_codons.fas -format fasta -codons 7 -consensus 90 -greedy

#This will export a file called phyloTAGs_primers_table.txt which can be copy and pasted into excel to pick primers at low degeneracy sites 

pwd 
echo "Job started"
sleep 60
echo "Job ended"

