#!/bin/bash

##########################################################################################
##  
##########################################################################################

/working/jahner/tapioca/src/tap_contam_analysis --db  /archive/parchman_lab/rawdata_to_backup/contaminants/illumina_oligos --pct 20 /working/parchman/UNM_ERNA/UNM_S2_L002_R1_001.fastq > UNM_ERNA.readstofilter.ill.txt 

echo "Illumina filtering done for lane 1"

/working/jahner/tapioca/src/tap_contam_analysis --db /archive/parchman_lab/rawdata_to_backup/contaminants/phix174 --pct 80 /working/parchman/UNM_ERNA/UNM_S2_L002_R1_001.fastq > UNM_ERNA.readstofilter.phix.txt 

echo "PhiX filtering done for lane 1"


/working/jahner/tapioca/src/tap_contam_analysis --db  /archive/parchman_lab/rawdata_to_backup/contaminants/ecoli-k-12 --pct 80 /working/parchman/UNM_ERNA/UNM_S2_L002_R1_001.fastq > UNM_ERNA.readstofilter.ecoli.txt

echo "ecoli filtering done for lane 1"


cat /working/parchman/UNM_ERNA/UNM_S2_L002_R1_001.fastq | fqu_cull -r UNM_ERNA.readstofilter.ill.txt UNM_ERNA.readstofilter.phix.txt UNM_ERNA.readstofilter.ecoli.txt > UNM_ERNA.clean.fastq

echo "Clean copy of lane 1 done"

