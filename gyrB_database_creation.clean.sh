#!/bin/bash
#PBS -l walltime=135:00:00
#PBS -N test_run
#PBS -l nodes=1:ppn=10
#PBS -l pvmem=18gb 
#PBS -o log.txt 
#PBS -A exd44_a_g_sc_default

export PATH="$PATH:/gpfs/group/exd44/default/rgn5011/.local/bin/"
cd /gpfs/group/exd44/default/rgn5011/NCBI_files

conda activate NCBI
ncbi-genome-download --assembly-levels complete -F fasta,gff,rna-fasta bacteria

ls refseq/bacteria/ > GCF.txt

mapfile -t GCF < GCF.txt

for (( i=0; i<18997; i++)); 
	do 
		cd /gpfs/group/exd44/default/rgn5011/NCBI_files/refseq/bacteria/${GCF[i]}/;
		gunzip *.gz*;
		mv *rna_from_genomic.fna* test.frn ;
		grep "^>" *.fna* | cut -b 2-12 > name.txt ; 
		mv test.frn $(head -n 1 name.txt)_genomic.frn; 
		mv *fna* $(head -n 1 name.txt)_genomic.fna; 
		mv *gff* $(head -n 1 name.txt)_genomic.gff; 
		gffread -w $(head -n 1 name.txt).transcripts.fa -g *fna* *.gff*; 
		awk '!/^>/ { printf "%s", $0; n = "\n" } /^>/ { print n $0; n = "" } END { printf "%s", n }' $(head -n 1 name.txt).transcripts.fa > $(head -n 1 name.txt).transcripts.single.fa; 
		awk '!/^>/ { printf "%s", $0; n = "\n" } /^>/ { print n $0; n = "" } END { printf "%s", n }' $(head -n 1 name.txt)_genomic.frn > $(head -n 1 name.txt).single.genomic.frn; 
		cp ../../../interest1.txt .; 
		cp ../../../interest2.txt .; 
		grep -w -A 1 -f interest1.txt $(head -n 1 name.txt).transcripts.single.fa > gyrB.txt; 
		grep -w -A 1 -f interest2.txt $(head -n 1 name.txt).single.genomic.frn > 16S.txt ; 
		awk "/^>/ {n++} n>1 {exit} {print}" 16S.txt >temp.txt; 
		awk '/^>/{print ">'$(head -n 1 name.txt)'" ; next}{print}' < gyrB.txt > $(head -n 1 name.txt).gyr.fa;
		awk '/^>/{print ">'$(head -n 1 name.txt)'" ; next}{print}' < temp.txt > $(head -n 1 name.txt).16S.frn;
		mv $(head -n 1 name.txt).gyr.fa ../../../Gyr; 
		mv $(head -n 1 name.txt).16S.frn ../../../16S; 
done


cat ./Gyr/*.fa > gyr_refseq.fa
cat ./16S/*.fa > 16S_refseq.fa



 

pwd 
echo "Job started"
sleep 60
echo "Job ended"
