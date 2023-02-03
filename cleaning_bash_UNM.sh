#!/bin/bash

##########################################################################################
##  
##########################################################################################

/working/jahner/tapioca/src/tap_contam_analysis --db  /archive/parchman_lab/rawdata_to_backup/contaminants/illumina_oligos --pct 20 /working/parchman/frog_connie_erigeron/PE1_S1_L001_R1_001.fastq > PE1.readstofilter.ill.txt 

echo "Illumina filtering done for lane 1"

/working/jahner/tapioca/src/tap_contam_analysis --db /archive/parchman_lab/rawdata_to_backup/contaminants/phix174 --pct 80 /working/parchman/frog_connie_erigeron/PE1_S1_L001_R1_001.fastq > PE1.readstofilter.phix.txt 

echo "PhiX filtering done for lane 1"


/working/jahner/tapioca/src/tap_contam_analysis --db  /archive/parchman_lab/rawdata_to_backup/contaminants/ecoli-k-12 --pct 80 /working/parchman/frog_connie_erigeron/PE1_S1_L001_R1_001.fastq > PE1.readstofilter.ecoli.txt

echo "ecoli filtering done for lane 1"


cat /working/parchman/frog_connie_erigeron/PE1_S1_L001_R1_001.fastq | fqu_cull -r PE1.readstofilter.ill.txt PE1.readstofilter.phix.txt PE1.readstofilter.ecoli.txt > PE1.clean.fastq

echo "Clean copy of lane 1 done"

