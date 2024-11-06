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

#These are the SLURM parameters used to run the script


#This is needed to load the usearch package 
export PATH="$PATH:/storage/group/exd44/default/rgn5011/.local/bin/"

#We want to make a new directory for the creation of Pseudo Miseq Reads

mkdir ./NCBI_files/Psuedo_Miseq
cd ./NCBI_files/Psuedo_Miseq


#We need to create a primer files of each of the orginal Moeller Primer sets.
#Moeller Bacteroidaceae
echo '>Prim1F ' > Moeller_bac_primer.txt
echo 'CGGAGGTAARTTCGAYAAAGG'>> Moeller_bac_primer.txt
echo '>Prim1R'>> Moeller_bac_primer.txt
echo 'GCRTATTTYTTCARHGTACGG'>> Moeller_bac_primer.txt

#Moeller Bifidobacteriaceae.
echo '>Prim1F ' > Moeller_bif_primer.txt
echo 'GACRACGGNCGNGGCATYCC'>> Moeller_bif_primer.txt
echo '>Prim1R'>> Moeller_bif_primer.txt
echo 'AGNCCCTTGTTNAGGAAVGCC'>> Moeller_bif_primer.txt

#Moeller Lachnospiraceae
echo '>Prim1F ' > Moeller_lac_primer.txt
echo 'GGHGGAGGATAYAAGGTATCC'>> Moeller_lac_primer.txt
echo '>Prim1R'>> Moeller_lac_primer.txt
echo 'TRTANGAATCRTTRTGCTGC'>> Moeller_lac_primer.txt

#We need to make folders for each of the famillies of interest 
mkdir Psuedo_Bac
mkdir Psuedo_Bif
mkdir Psudo_Lac

mv Moeller_bac_primer.txt ./Psuedo_Bac
mv Moeller_bif_primer.txt ./Psuedo_Bif
mv Moeller_lac_primer.txt ./Psuedo_Lac

#Start with Bacteroidaceae
cd ./Psuedo_Bac

#I am assuming all data is a folder called Pacbio_data in the Directory NCBI_Scripts

usearch -search_pcr ../../Pacbio_data/Bac_H1_pac.fastq -db ./Moeller_bac_primer.txt -strand both -maxdiffs 3 -minamp 30 -maxamp 2000  -ampoutq Bac_H1_pac.cut.fastq

usearch -search_pcr ../../Pacbio_data/Bac_H2_pac.fastq -db ./Moeller_bac_primer.txt -strand both -maxdiffs 3 -minamp 30 -maxamp 2000  -ampoutq Bac_H2_pac.cut.fastq

usearch -search_pcr ../../Pacbio_data/Bac_H3_pac.fastq -db ./Moeller_bac_primer.txt -strand both -maxdiffs 3 -minamp 30 -maxamp 2000  -ampoutq Bac_H3_pac.cut.fastq

usearch -search_pcr ../../Pacbio_data/Bac_H4_pac.fastq -db ./Moeller_bac_primer.txt -strand both -maxdiffs 3 -minamp 30 -maxamp 2000  -ampoutq Bac_H4_pac.cut.fastq

usearch -search_pcr ../../Pacbio_data/Bac_H5_pac.fastq -db ./Moeller_bac_primer.txt -strand both -maxdiffs 3 -minamp 30 -maxamp 2000  -ampoutq Bac_H5_pac.cut.fastq

usearch -search_pcr ../../Pacbio_data/Bac_M1_pac.fastq -db ./Moeller_bac_primer.txt -strand both -maxdiffs 3 -minamp 30 -maxamp 2000  -ampoutq Bac_M1_pac.cut.fastq

usearch -search_pcr ../../Pacbio_data/Bac_M2_pac.fastq -db ./Moeller_bac_primer.txt -strand both -maxdiffs 3 -minamp 30 -maxamp 2000  -ampoutq Bac_M2_pac.cut.fastq

#Move to Bifidobacteriaceae
cd ../Psuedo_Bif

#I am assuming all data is a folder called Pacbio_data in the Directory NCBI_Scripts

usearch -search_pcr ../../Pacbio_data/Bif_H1_pac.fastq -db ./Moeller_bac_primer.txt -strand both -maxdiffs 3 -minamp 30 -maxamp 2000  -ampoutq Bif_H1_pac.cut.fastq

usearch -search_pcr ../../Pacbio_data/Bif_H2_pac.fastq -db ./Moeller_bac_primer.txt -strand both -maxdiffs 3 -minamp 30 -maxamp 2000  -ampoutq Bif_H2_pac.cut.fastq

usearch -search_pcr ../../Pacbio_data/Bif_H3_pac.fastq -db ./Moeller_bac_primer.txt -strand both -maxdiffs 3 -minamp 30 -maxamp 2000  -ampoutq Bif_H3_pac.cut.fastq

usearch -search_pcr ../../Pacbio_data/Bif_H4_pac.fastq -db ./Moeller_bac_primer.txt -strand both -maxdiffs 3 -minamp 30 -maxamp 2000  -ampoutq Bif_H4_pac.cut.fastq

usearch -search_pcr ../../Pacbio_data/Bif_H5_pac.fastq -db ./Moeller_bac_primer.txt -strand both -maxdiffs 3 -minamp 30 -maxamp 2000  -ampoutq Bif_H5_pac.cut.fastq

usearch -search_pcr ../../Pacbio_data/Bif_M1_pac.fastq -db ./Moeller_bac_primer.txt -strand both -maxdiffs 3 -minamp 30 -maxamp 2000  -ampoutq Bif_M1_pac.cut.fastq

usearch -search_pcr ../../Pacbio_data/Bif_M2_pac.fastq -db ./Moeller_bac_primer.txt -strand both -maxdiffs 3 -minamp 30 -maxamp 2000  -ampoutq Bif_M2_pac.cut.fastq


#Move to Lachnospiraceae
cd ../Psuedo_Lac

#I am assuming all data is a folder called Pacbio_data in the Directory NCBI_Scripts

usearch -search_pcr ../../Pacbio_data/Lac_H1_pac.fastq -db ./Moeller_bac_primer.txt -strand both -maxdiffs 3 -minamp 30 -maxamp 2000  -ampoutq Lac_H1_pac.cut.fastq

usearch -search_pcr ../../Pacbio_data/Lac_H2_pac.fastq -db ./Moeller_bac_primer.txt -strand both -maxdiffs 3 -minamp 30 -maxamp 2000  -ampoutq Lc_H2_pac.cut.fastq

usearch -search_pcr ../../Pacbio_data/Lac_H3_pac.fastq -db ./Moeller_bac_primer.txt -strand both -maxdiffs 3 -minamp 30 -maxamp 2000  -ampoutq Lac_H3_pac.cut.fastq

usearch -search_pcr ../../Pacbio_data/Lac_H4_pac.fastq -db ./Moeller_bac_primer.txt -strand both -maxdiffs 3 -minamp 30 -maxamp 2000  -ampoutq Lac_H4_pac.cut.fastq

usearch -search_pcr ../../Pacbio_data/Lac_H5_pac.fastq -db ./Moeller_bac_primer.txt -strand both -maxdiffs 3 -minamp 30 -maxamp 2000  -ampoutq Lac_H5_pac.cut.fastq

usearch -search_pcr ../../Pacbio_data/Lac_M1_pac.fastq -db ./Moeller_bac_primer.txt -strand both -maxdiffs 3 -minamp 30 -maxamp 2000  -ampoutq Lac_M1_pac.cut.fastq

usearch -search_pcr ../../Pacbio_data/Lac_M2_pac.fastq -db ./Moeller_bac_primer.txt -strand both -maxdiffs 3 -minamp 30 -maxamp 2000  -ampoutq Lac_M2_pac.cut.fastq


