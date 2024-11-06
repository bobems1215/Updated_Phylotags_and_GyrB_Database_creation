#!/bin/bash
#SBATCH --time=135:00:00
#SBATCH --job-name=Tax_info
#SBATCH --nodes=1
#SBATCH --mem=18G
#SBATCH --ntasks=10
#SBATCH --output=Tax_info.out
#SBATCH --error=Tax_info_log.out
#SBATCH --partition=sla-prio
#SBATCH --account=one

#Above are the SLURM  parameters used to run this command 


#Navigate to the directory with the gyrB reference database
cd ./NCBI_files/

#Activate the conda enviornment. This enviornment was created in the gyrB_database_creation.sh script
module load anaconda
conda activate phylotags_env

#We want to extract all of the taxonomy codes from the gyrB reference database
cat gyr_refseq.fa | grep ">" >names.txt

#We want to make the list of taxonomy codes an array 
mapfile -t NC < names.txt 

#These next steps are used to set up the loop. We will first be numbering the lines of GCF.txt, which gives us the number of bacteria used in the database. Then we will be extracting those numbers and creating an array to use as the loop variable

#add row lines to names.txt

nl names.txt > names.numb.txt

#Remove white space before the first column

awk '{sub(/^ +/, ""); print $0}' names.numb.txt > names.numb.no_white.txt

#extract the first column with row numbers

cat names.numb.no_white.txt |sed 's/|/ /' | awk '{print $1}' > names.numb.only.txt

#use mapfile to create an array based on the number of bacteria downloaded

 mapfile -t NCN < names.numb.only.txt

#The i limit should be the same as the one used for gyrB_database_creation.clean.sh 
for i in "${NCN[@]}";  
	do 
		#We use the esearch package to search each taxonomy code on the nuccore (nucleotide) NCBI database. We can then pull out the taxonomy annotation and save it to a separate file called NC_Tax.txt. 
		esearch -db nuccore -query ${NC[i]}|elink -target taxonomy |efetch -format text >> NC_Tax.txt; 
		#We then print the taxonomy code under the annotated taxonomy. This can be changed to above by moving the code above the previous line
		echo ${NC[i]} >> NC_Tax.txt;
	 done
 
