#!/bin/bash
#SBATCH --time=135:00:00
#SBATCH --job-name=phylotags
#SBATCH --nodes=1
#SBATCH --mem=18G
#SBATCH --ntasks=10
#SBATCH --output=phylotags.out
#SBATCH --error=phylotags_log.out
#SBATCH --partition=sla-prio
#SBATCH --account=one

#These are the SLURM parameters used to run the script

#Activate the conda enviornment. This enviornment was created in the gyrB_database_creation.sh script
module load anaconda
conda activate phylotags_env


#Download the phylotags package from source and move it to the directory you have the gyrB database in. Create a directory inside the PhyloTags/PhyloTAGs_package folder where you want to run and keep the output files for phlyotags. Also move the ‘gyr_refseq.fa’ and the ‘16S_rDNA_id_cust.txt’ files to this new directory. 
cd ./NCBI
wget https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4700968/bin/supp_evv234_suppl_data.zip
unzip supp_evv234_suppl_data.zip
unzip PhyloTAGs_package.zip
rm PhyloTAGs_package.zip
rm supp_evv234_suppl_data.zip
cd PhyloTAGs_package

#Remove example id map and gyrB genes so we dont accidently use them
rm 16S_rDNA_id_.txt
rm gyrB_genes.fas
rm NC_names.txt
cd ../ 


#Use the file created from the Taxonomy_id_lookup.sh file (NC_Tax.txt) to look for a reference file for the bacteria of interest. This can be easily done by extracting the taxonomy codes and bacterial names of the bacteria of interest with this code: 
cat NC_Tax.txt | grep  -A 2 "Bifidobacterium"  > bifido_ref.txt
#And then picking a Taxonomy code from the bifido_ref.txt file to use as a reference for phylotags.  

#Run Phylotags. IDhigh should always be 100 because this will include identical species. IDlow is used to determine how specific the primers will be, the higher idlow is, the more specific the primers will be. For the purposes of this experiment idlow values ranged from 95 to 92
#specific run parameters are noted in the manuscript 

perl PhyloTAGs_package/01_phyloTAGs_align.pl -in gyr_refseq.fa -distance 16S_rDNA_id_cust.txt -reference NC_008618 -idlow 95 -idhigh 100
perl PhyloTAGs_package/02_phyloTAGs_primer.pl -in aligned_by_codons.fas -format fasta -codons 7 -consensus 90 -greedy

#This will export a file called phyloTAGs_primers_table.txt which can be copy and pasted into excel to pick primers at low degeneracy sites 

