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

#Create a conda environment from the NCBI.yml file
#conda env create -f NCBI.yml
module load anaconda
conda activate phylotags_env

#Make a folder for the raw sequencing data 
cd NCBI_files
mkdir GyrB_Sequencing_data
cd GyrB_Sequencing_data

#Download the SRA toolkit 
wget https://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/3.1.1/sratoolkit.3.1.1-ubuntu64.tar.gz
tar -zxvf sratoolkit.3.1.1-ubuntu64.tar.gz

#Download the raw sequencing reads from the SRA

esearch -db sra -query PRJNA1055511 | efetch -format runinfo | cut -d ',' -f 1 | grep SRR  | xargs ./sratoolkit.3.1.1-ubuntu64/bin/fastq-dump  --split-files  --gzip

#Match the SRR file with the appropriate name id

#First we create a file matching the SRR name to the sample name 
esearch -db sra -query PRJNA1055511 | efetch -format runinfo | cut -d ',' -f 1,12 -> rename.txt
cat rename.txt | cut -d ',' -f 1 -> SRR.txt
cat rename.txt | cut -d ',' -f 2 -> name.txt
mapfile -t SRR < SRR.txt
mapfile -t name < name.txt

#We next want to create an array to use as the loop variable 
nl SRR.txt > SRR.numb.txt
awk '{sub(/^ +/, ""); print $0}' SRR.numb.txt > SRR.numb.no_white.txt
cat SRR.numb.no_white.txt |sed 's/|/ /' | awk '{print $1}' > SRR.numb.only.txt
mapfile -t SRRn < SRR.numb.only.txt 

#We can now loop and change the SRR names to the provided sample names 
for i in "${SRRn[@]}";
do
	mv ${SRR[i]}_1.fastq.gz ${name[i]}_1.fastq.gz;
	mv ${SRR[i]}_2.fastq.gz ${name[i]}_2.fastq.gz;
done

#Unzip the files
gunzip *

#We now prepare for rarifying the reads
ls *fastq > fastq.txt
mapfile -t fq < fastq.txt

#Again we want to create an array to use as the loop variable for the rarifying loop
nl fastq.txt > fastq.numb.txt
awk '{sub(/^ +/, ""); print $0}' fastq.numb.txt > fastq.numb.no_white.txt
cat fastq.numb.no_white.txt |sed 's/|/ /' | awk '{print $1}' > fastq.numb.only.txt
sed -i '1s/^/0 \n/' fastq.numb.only.txt
mapfile -t fqn < fastq.numb.only.txt 

#We can make an array to use to rename the samples. This code removes the '.fastq' from the sample names to not have redundent sample names
sed "s/.\{0,6\}$//; /^$/d" fastq.txt > fastq.name.txt
mapfile -t fqname< fastq.name.txt

#Rarify the reads to 28000 reads per sample 
for i in "${fqn[@]}";
do
	seqtk sample -s100 ${fq[i]} 28000 > ${fqname[i]}.rare.fastq;
done

#Create foldes for the rarified reads (rare) and the raw reads (raw) and move the appropriate reads to each folder

mkdir rare
mkdir raw
mv *rare* ./rare
mv *fastq ./raw

#move to the rarified folder and create folders for each specific primer pair and sequencign technology. Then move the appropriate reads into each folder

cd rare

mkdir PacBio
cd PacBio
mkdir Bac
mkdir Bif
mkdir Lac
mkdir 16S
cd ..

mkdir MiSeq
cd MiSeq
mkdir Bac
mkdir Bif
mkdir Lac
mkdir 16S
cd ..

mv *Bac_pac* ./PacBio/Bac
mv *Bif_pac* ./PacBio/Bif
mv *Lac_pac* ./PacBio/Lac
mv *16S_pac* ./PacBio/16S

mv *Bac_miseq* ./MiSeq/Bac
mv *Bif_miseq* ./MiSeq/Bif
mv *Lac_miseq* ./MiSeq/Lac
mv *16S_miseq* ./MiSeq/16S

#After this the rare folder can be used as the input folder for the GyrB_dada2_analysis.RMD file to analyze the rarified reads.


