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

#Note that raw reads can be downloaded in the rarify.reads.sh script

#We want to make a new directory for the creation of Pseudo Miseq Reads
#cd ./NCBI_files/GyrB_Sequencing_data

cd /storage/group/exd44/default/rgn5011/NCBI_files/no_path_test/test_down/GyrB_Sequencing_data

#Note if this file does not exist make sure to run the rarify.reads.sh script to download the raw data from the NCBI

mkdir Psuedo_Miseq
cd Psuedo_Miseq


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
mkdir Bac
mkdir Bif
mkdir Lac

mv Moeller_bac_primer.txt ./Bac
mv Moeller_bif_primer.txt ./Bif
mv Moeller_lac_primer.txt ./Lac

#Start with Bacteroidaceae
cd ./Bac

usearch -search_pcr ../../raw/GM_Bac_pac_1.fastq  -db ./Moeller_bac_primer.txt -strand both -maxdiffs 3 -minamp 30 -maxamp 2000  
-ampoutq Bac_GM_pac.cut.fastq

usearch -search_pcr ../../raw/H1_Bac_pac_1.fastq  -db ./Moeller_bac_primer.txt -strand both -maxdiffs 3 -minamp 30 -maxamp 2000  
-ampoutq Bac_H1_pac.cut.fastq
usearch -search_pcr ../../raw/H2_Bac_pac_1.fastq  -db ./Moeller_bac_primer.txt -strand both -maxdiffs 3 -minamp 30 -maxamp 2000  -ampoutq Bac_H2_pac.cut.fastq

usearch -search_pcr ../../raw/H3_Bac_pac_1.fastq -db ./Moeller_bac_primer.txt -strand both -maxdiffs 3 -minamp 30 -maxamp 2000  -ampoutq Bac_H3_pac.cut.fastq

usearch -search_pcr ../../raw/H4_Bac_pac_1.fastqq -db ./Moeller_bac_primer.txt -strand both -maxdiffs 3 -minamp 30 -maxamp 2000  -ampoutq Bac_H4_pac.cut.fastq

usearch -search_pcr ../../raw/H5_Bac_pac_1.fastq -db ./Moeller_bac_primer.txt -strand both -maxdiffs 3 -minamp 30 -maxamp 2000  -ampoutq Bac_H5_pac.cut.fastq

usearch -search_pcr ../../raw/M1_Bac_pac_1.fastq -db ./Moeller_bac_primer.txt -strand both -maxdiffs 3 -minamp 30 -maxamp 2000  -ampoutq Bac_M1_pac.cut.fastq

usearch -search_pcr ../../raw/M2_Bac_pac_1.fastq -db ./Moeller_bac_primer.txt -strand both -maxdiffs 3 -minamp 30 -maxamp 2000  -ampoutq Bac_M2_pac.cut.fastq

#Move to Bifidobacteriaceae
cd ../Bif

#I am assuming all data is a folder called Pacbio_data in the Directory NCBI_Scripts

usearch -search_pcr ../../raw/GM_Bif_pac_1.fastq -db ./Moeller_bif_primer.txt -strand both -maxdiffs 3 -minamp 30 -maxamp 2000  -ampoutq Bif_GM_pac.cut.fastq

usearch -search_pcr ../../raw/H1_Bif_pac_1.fastq -db ./Moeller_bif_primer.txt -strand both -maxdiffs 3 -minamp 30 -maxamp 2000  -ampoutq Bif_H1_pac.cut.fastq

usearch -search_pcr ../../raw/H2_Bif_pac_1.fastq -db ./Moeller_bif_primer.txt -strand both -maxdiffs 3 -minamp 30 -maxamp 2000  -ampoutq Bif_H2_pac.cut.fastq

usearch -search_pcr ../../raw/H3_Bif_pac_1.fastq -db ./Moeller_bif_primer.txt -strand both -maxdiffs 3 -minamp 30 -maxamp 2000  -ampoutq Bif_H3_pac.cut.fastq

usearch -search_pcr ../../raw/H4_Bif_pac_1.fastq -db ./Moeller_bif_primer.txt -strand both -maxdiffs 3 -minamp 30 -maxamp 2000  -ampoutq Bif_H4_pac.cut.fastq

usearch -search_pcr ../../raw/H5_Bif_pac_1.fastq -db ./Moeller_bif_primer.txt -strand both -maxdiffs 3 -minamp 30 -maxamp 2000  -ampoutq Bif_H5_pac.cut.fastq

usearch -search_pcr ../../raw/M1_Bif_pac_1.fastq -db ./Moeller_bif_primer.txt -strand both -maxdiffs 3 -minamp 30 -maxamp 2000  -ampoutq Bif_M1_pac.cut.fastq

usearch -search_pcr ../../raw/M2_Bif_pac_1.fastq -db ./Moeller_bif_primer.txt -strand both -maxdiffs 3 -minamp 30 -maxamp 2000  -ampoutq Bif_M2_pac.cut.fastq


#Move to Lachnospiraceae
cd ../Lac

#I am assuming all data is a folder called Pacbio_data in the Directory NCBI_Scripts

usearch -search_pcr ../../raw/GM_Lac_pac_1.fastq -db ./Moeller_lac_primer.txt -strand both -maxdiffs 3 -minamp 30 -maxamp 2000  -ampoutq Lac_GM_pac.cut.fastq

usearch -search_pcr ../../raw/H1_Lac_pac_1.fastq -db ./Moeller_lac_primer.txt -strand both -maxdiffs 3 -minamp 30 -maxamp 2000  -ampoutq Lac_H1_pac.cut.fastq

usearch -search_pcr ../../raw/H2_Lac_pac_1.fastq -db ./Moeller_lac_primer.txt -strand both -maxdiffs 3 -minamp 30 -maxamp 2000  -ampoutq Lc_H2_pac.cut.fastq

usearch -search_pcr ../../raw/H3_Lac_pac_1.fastq -db ./Moeller_lac_primer.txt -strand both -maxdiffs 3 -minamp 30 -maxamp 2000  -ampoutq Lac_H3_pac.cut.fastq

usearch -search_pcr ../../raw/H4_Lac_pac_1.fastq -db ./Moeller_lac_primer.txt -strand both -maxdiffs 3 -minamp 30 -maxamp 2000  -ampoutq Lac_H4_pac.cut.fastq

usearch -search_pcr ../../raw/H5_Lac_pac_1.fastq -db ./Moeller_lac_primer.txt -strand both -maxdiffs 3 -minamp 30 -maxamp 2000  -ampoutq Lac_H5_pac.cut.fastq

usearch -search_pcr ../../raw/M1_Lac_pac_1.fastq -db ./Moeller_lac_primer.txt -strand both -maxdiffs 3 -minamp 30 -maxamp 2000  -ampoutq Lac_M1_pac.cut.fastq

usearch -search_pcr ../../raw/M2_Lac_pac_1.fastq -db ./Moeller_lac_primer.txt -strand both -maxdiffs 3 -minamp 30 -maxamp 2000  -ampoutq Lac_M2_pac.cut.fastq
