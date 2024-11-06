#!/bin/bash
#SBATCH --time=135:00:00
#SBATCH --job-name=NCBI_to_gyrb
#SBATCH --nodes=1
#SBATCH --mem=18G
#SBATCH --ntasks=10
#SBATCH --output=NCBI_to_gyrB.out
#SBATCH --error=NCBI_log.out
#SBATCH --partition=sla-prio
#SBATCH --account=one
#Above are the SLURM parameters used to run this command 

#Create a conda environment from the NCBI.yml file. Note that this only needs to be run once and for subsequent scripts we will assume the conda environment has been created.
module load anaconda
conda env create -f phylotags.yml
conda activate phylotags_env

#In this conda enviornment we use the seqtk, ncbi-genome-download, entrez-direct, gffread, clustalw, and perl packages
#conda activate phylotags_env

#We first want to make a directory to download all the NCBI files
mkdir NCBI_files
cd NCBI_files

#We also want to make directories for both the GyrB and 16S sequences
mkdir Gyr
mkdir 16S

#Finally we need to make two text files used to pull out the GyrB and 16S sequences
echo 'gene=gyrB' > interest1.txt 
echo 'product=16S ribosomal RNA' > interest2.txt

#We download all current complete bacterial genomes in fasta, gfff, and ran-fasta format from the NCBI. 
ncbi-genome-download --assembly-levels complete -F fasta,gff,rna-fasta bacteria

#We take all of the GCF bacterial directory names and put them into a text file called GCF.txt
ls refseq/bacteria/ > GCF.txt

#We use mapfile to turn the GCF.txt file into an array 
mapfile -t GCF < GCF.txt

#These next steps are used to set up the loop. We will first be numbering the lines of GCF.txt, which gives us the number of bacteria used in the database. Then we will be extracting those numbers and creating an array to use as the loop variable

#add row lines to GCF.txt

nl GCF.txt > GCF.numb.txt

#Remove white space before the first column

awk '{sub(/^ +/, ""); print $0}' GCF.numb.txt > GCF.numb.no_white.txt

#extract the first column with row numbers

cat GCF.numb.no_white.txt |sed 's/|/ /' | awk '{print $1}' > GCF.numb.only.txt

#use mapfile to create an array based on the number of bacteria downloaded

 mapfile -t GCFN < GCF.numb.only.txt

#This loop will open and pick out the gyrb and 16s sequences from the bacterial genomes downloaded

for i in "${GCFN[@]}"; 
	do 
	
		#Since GCF is an array of all the bacterial genome directories that were downloaded from the NCBI, we can go into each bacterial directory one at a time in the loop
 		cd ./refseq/bacteria/${GCF[i]}/;
		
		#Gunzip everything in the directory
		gunzip *.gz*;

		#Change the extension for the RNA file from fna to frn
		mv *rna_from_genomic.fna* test.frn ;

		#This command gets the taxonomy code for each GCF Bacterial genome 
		grep "^>" *.fna* | cut -b 2-12 > name.txt ; 

		#Change the file names from GCF to the taxonomy code to make the Bacteria easier to identify 
		mv test.frn $(head -n 1 name.txt)_genomic.frn; 
		mv *fna* $(head -n 1 name.txt)_genomic.fna; 
		mv *gff* $(head -n 1 name.txt)_genomic.gff; 

		#Then extract the annotated fasta sequences between the genome and the gff files
		gffread -w $(head -n 1 name.txt).transcripts.fa -g *fna* *.gff* -F; 

		#Make the transcripts file (and the frn file) into single line, this makes it easier to extract the sequences.
		awk '!/^>/ { printf "%s", $0; n = "\n" } /^>/ { print n $0; n = "" } END { printf "%s", n }' $(head -n 1 name.txt).transcripts.fa > $(head -n 1 name.txt).transcripts.single.fa; 
		awk '!/^>/ { printf "%s", $0; n = "\n" } /^>/ { print n $0; n = "" } END { printf "%s", n }' $(head -n 1 name.txt)_genomic.frn > $(head -n 1 name.txt).single.genomic.frn; 

		#Bring in the query files (interest1.txt is "gene=gyrB"  and interest2.txt is "product=16S ribosomal RNA")
		cp ../../../interest1.txt .; 
		cp ../../../interest2.txt .; 

		#Extract the GryB sequence from the genome
		grep -w -A 1 -f interest1.txt $(head -n 1 name.txt).transcripts.single.fa > gyrB.txt; 

		#Extract the 16S sequence(s) from the genome
		grep -w -A 1 -f interest2.txt $(head -n 1 name.txt).single.genomic.frn > 16S.txt ; 
		
		#Extract only the first 16S sequence. This means we don’t need to dereplicate the file
		awk "/^>/ {n++} n>1 {exit} {print}" 16S.txt >temp.txt;
		
		#Change the fasta sequence name to match the NC number (this is needed to make the combined file)
		awk '/^>/{print ">'$(head -n 1 name.txt)'" ; next}{print}' < gyrB.txt > $(head -n 1 name.txt).gyr.fa;
		awk '/^>/{print ">'$(head -n 1 name.txt)'" ; next}{print}' < temp.txt > $(head -n 1 name.txt).16S.frn;
		
		#Move the 16S and Gry B sequences to a separate folder
		mv $(head -n 1 name.txt).gyr.fa ../../../Gyr; 
		mv $(head -n 1 name.txt).16S.frn ../../../16S;

		#Move back to the starting directory 
		cd ../../../	
done

cd ./NCBI_files
#Combine the fasta files in the GryB and 16S folders
cat ./Gyr/*.fa > gyr_refseq.fa
cat ./16S/*.frn > 16S_refseq.fa
