#!/bin/bash
#PBS -l walltime=135:00:00
#PBS -N test_run
#PBS -l nodes=1:ppn=10
#PBS -l pvmem=18gb 
#PBS -o log.txt 
#PBS -A exd44_a_g_sc_default
#Above are the PBS parameters used to run this command 

#This is needed to load extra packages hosted in my local directory
export PATH="$PATH:/gpfs/group/exd44/default/rgn5011/.local/bin/"

#This is used to navigate to the folder where the GYRB database is downloaded
cd /gpfs/group/exd44/default/rgn5011/NCBI_files

#In this conda enviornment we use the seqtk, ncbi-genome-download, entrez-direct, gffread, clustalw, and perl packages
conda activate NCBI

#We download all current complete bacterial genomes in fasta, gfff, and ran-fasta format from the NCBI
ncbi-genome-download --assembly-levels complete -F fasta,gff,rna-fasta bacteria

#We take all of the GCF bacterial directory names and put them into a text file called GCF.txt
ls refseq/bacteria/ > GCF.txt

#We use mapfile to turn the GCF.txt file into an array 
mapfile -t GCF < GCF.txt

#This loop has a limit of the number of bacterial genomes downloaded +1. This can be obtained by running 
#wc -l GCF.txt
#and then adding 1 to the number obtained
for (( i=0; i<18997; i++)); 
	do 
		#Since GCF is an array of all the bacterial genome directories that were downloaded from the NCBI, we can go into each bacterial directory one at a time in the loop
		cd /gpfs/group/exd44/default/rgn5011/NCBI_files/refseq/bacteria/${GCF[i]}/;

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
		gffread -w $(head -n 1 name.txt).transcripts.fa -g *fna* *.gff*; 

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
done

#Combine the fasta files in the GryB and 16S folders
cat ./Gyr/*.fa > gyr_refseq.fa
cat ./16S/*.fa > 16S_refseq.fa

 

pwd 
echo "Job started"
sleep 60
echo "Job ended"
