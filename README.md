# Updated_Phylotags_and_GyrB_Database_creation
These scripts are used to prepare and run the PhyloTAGS program in order to create family-specific primers for the bacterial _gyrB_ gene. It is also our hope that these scripts can be modified easily enough to help create taxa-specific primers for other genes of interest. Please note the conda environment used for these scripts is the _phylotags.yml_ file. The code to activate this conda environment is in the _gyrB_database_creation.sh_ script.

## Download Bacterial Genomes from NCBI Refseq Database and Isolate the 16S and _gyrB_ Genes
The first script to run is the _gyrB_database_creation.sh_ script. This script utilizes Entrez and ncbi-genome-download programs to pull bacterial genomes from the NCBI Refseq database. Please note that this database is constantly changing so it is likely a current download will be different than the one used for this project. If one would like to use the bacterial_refseq database that was used for this project, it has been uploaded to Zenodo in two parts [Part1](https://zenodo.org/records/10452184) and [Part2](https://zenodo.org/records/10452279). Instructions for recombining the two parts are on each Zenodo link. 

The major part of this first script involves isolating the _gyrB_ and 16S genes from the NCBI Refseq database to create a 16S database (16S_refseq.fa) and a _gyrB_ database (gyr_refseq.fa). Both databases are uploaded to Zenodo, [16S database](https://zenodo.org/records/10451935) and [_gyrB_ database](https://zenodo.org/records/10451935). 

## Creation of the 16S_rDNA_cust.txt File 
The _16S_rDNA_id_cust_creation.sh_ script creates one of the necessary files for PhyloTAGS, the 16S_rDNA_cust.txt file. This is used to see relationships between all the bacterial taxa used in the _gyrB_ database. Please note that this script uses usearch which needs an individual license to use. Also please note that this file takes ~11 hours to make with the provided parameters. The 16S_rDNA_cust.txt file used for this project can be found on Zenodo, [16S_rDNA_cust.txt](https://zenodo.org/records/10778467)  

## Extract Taxonomy Information from the gyr_refseq.fa file 
The _Taxonomy_id_lookup.sh_ script is needed to create a list of all of the taxonomies present in the _gyrB_ database. It is from this list that the user will pick one representative species for each family of interest when running PhyloTAGS. Taxonomy is obtained by using the esearch package to lookup every taxonomy code used in the _gyrB_ database. The resulting file is NC_Tax.txt and has bacterial taxonomic information for all members of the _gyrB_ database. 

## Use PhyloTAGS to Create Degeneracy Tables Which are Used to Pick Family Specific Primer Sets
To download the PhyloTAGS program please see the supplemental files from the [PhyloTAGS manuscript](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4700968/). The _Phylotags.sh_ script contains how to use the NC_Tax.txt file to look up a reference species for each bacterial family. For this project, we used taxonomy codes NZ_CP036539, NC_008618.1 and NZ_LR699005 as our reference species for the Bacteroidacea, Bifidobacteriaceae, and Lachnospiraceae, respectively. PhyloTAGS uses the gyrb_refseq.fa file as the input, the 16S_rDNA_id_cust.txt file as the distance, and the chosen reference taxa as the reference. The idlow and idhigh determine the specificity of the primer. The output of PhyloTags will be Excel tables showing primer sequences for the entire _gyrB_ gene with degeneracy scores, for this project we chose the primers with the lowest degeneracy scores that also provided the longest read.

Please note that the Phylotags script, _01_phyloTAGs_align.pl_, requires the path to the Pal2nal program to be specified on line 11. The replaced line should be as follows:  my$pal2nal="perl _Path/to/pal2nal_";#~/pal2nal/pal2nal\.pl where the user edits _Path/to/pal2nal_ and leaving the rest.

## Download a Separate Database to Check For Potential Off-target Amplification
The _Human_Microbiome_db_download.sh_ script is used to download the Human_Microbiom database on the NCBI found [here](https://ftp.ncbi.nlm.nih.gov/genomes/HUMAN_MICROBIOM/Bacteria). This script sets up the database to be used for _in silico_ PCR to check the chosen primers for off-target amplifications. The _in_silico_pcr.sh_ script uses the usearch program to run _in silico_ pcr with the chosen primers on the Human_Microbiom NCBI database. This technique was also used to fine-tune the 'idlow' value for phylotags. The primer sets that resulted in the longest read with the fewest off-target amplifications were chosen to be used for sequencing.   

## Create Pseudo Miseq reads from the PacBio data
In one of our analyses, we create trimmed PacBio reads using the original Moeller primers, we call these Pseudo Miseq reads. This involves using in silico PCR and the ampoutq flag to get fastq output data. The _psuedo_Miseq_creation.sh_ script includes our own file names so these will need to be replaced. Additionally, this script assumes that the raw PacBio data has been placed in a folder called _Pacbio_data_ in the _NCBI_Scripts_ directory.  

## Analyze the Sequencing Results with Dada2.
The _GyrB_dada2_analysis.rmd_ script can be used to analyze all sequenced reads and psuedo_MiSeq reads with the DADA2 pipeline. 

## Rarefying sequencing data to 28,000 reads.
In order to create **Supplemental Table 2** we rarified the Bacteroidaceae, Bifidobacteriaceae, and Lachnospiraceae PacBio and Illumina sequencing results to 28,000 reads. The bash script _rarify.reads.sh_ was used to rarify the sequencing data. The resulting reads can be used with the _GyrB_dada2_analysis.rmd_ script to analyze all rarified reads.

