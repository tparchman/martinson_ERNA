# UNM GBS data processing

Library prep started on 12/14, 3.25 plates total.


Sample orientation and sample ID information illustrated in `UNM_plate_maps_working.xlsx`.


**CRITICAL NOTE: mistake made in barcode pipetting on plate 2. Row E of DNA got barcode from row D, so corrected by putting barcode from E with row D of DNA. To fix, switch sample IDs in the plate maps/barcode keys.

## Notes on cleaning NovaSeq flow cell from 12/22, barcode parsing, splitting fastqs, directory organization, and initial analyses.


We generated one lanes of S2 chemistry NovaSeq data at UTGSAF in December of 2022.



## This file contains code and notes for
1) cleaning contaminants using tapioca
2) parsing barcodes
3) splitting fastqs 
4) de novo assembly
5) reference based assembly
6) calling variants
7) filtering
8) entropy for genotype probabilities.

## 1. Cleaning contaminants

Being executed on ponderosa using tapioca pipeline. Commands in bash script (cleaning_bash_UNM.sh), executed as below (2/N/23). This was for one S2 NovaSeq lanes generated in December 2022.

Decompress fastq file:

    $ gunzip *fastq

# BELOW ARE SIMILAR COMMANDS FROM OTHER PROJECTS

Number of reads **before** cleaning:

    $ grep -c "^@" CADE1_S1_L001_R1_001.fastq.gz > CADE_number_of_rawreads.txt
    $ grep -c "^@" sample-2_S2_L002_R1_001.fastq > S2_number_of_rawreads.txt


    $ module load fqutils/0.4.1
    $ module load bowtie2/2.2.5
    
    $ bash cleaning_bash.sh &


After .clean.fastq has been produced, recompress raw data:

    $ gzip sample-1_S1_L001_R1_001.fastq &
    $ gzip sample-2_S2_L002_R1_001.fastq &

Raw data will stay stored in: /archive/parchman_lab/rawdata_to_backup/CALFE_AMEX_GSAF_12_22/

Number of reads **before** cleaning:

    $ grep -c "^@" sample-1_S1_L001_R1_001.fastq > S1_number_of_rawreads.txt
    $ grep -c "^@" sample-2_S2_L002_R1_001.fastq > S2_number_of_rawreads.txt

Number of reads **after** cleaning:

    $ grep "^@" S1_11_20.clean.fastq -c > S1_No_ofcleanreads.txt &
    $ less S1_No_ofcleanreads.txt
    # lane 1: 1,520,946,461

    $ grep "^@" S2_11_20.clean.fastq -c > S2_No_ofcleanreads.txt &
    $ less S2_No_ofcleanreads.txt
    # lane 2: 1,521,453,849

####################################################################################
## 2. Barcode parsing:
####################################################################################

Barcode keyfile are `/mnt/UTGSAF_11_20/11_20_GSAF_lane1BCODEKEY.csv` and `/mnt/UTGSAF_11_20/11_20_GSAF_lane1BCODEKEY.csv`

Parsing library 1:

    $ perl parse_barcodes768.pl 11_20_GSAF_lane1BCODEKEY.csv S1_11_20.clean.fastq A00 &

Parsing library 2:

    $ perl parse_barcodes768.pl 11_20_GSAF_lane2BCODEKEY.csv S2_11_20.clean.fastq A00 &

`NOTE`: the A00 object is the code that identifies the sequencer (first three characters after the @ in the fastq identifier).

    $ less parsereport_S1_11_20.clean.fastq
    Good mids count: 1484409965
    Bad mids count: 36536312
    Number of seqs with potential MSE adapter in seq: 337486
    Seqs that were too short after removing MSE and beyond: 184

    $ less parsereport_S1_11_20.clean.fastq
    Good mids count: 1475831187
    Bad mids count: 45622449
    Number of seqs with potential MSE adapter in seq: 332950
    Seqs that were too short after removing MSE and beyond: 213


Cleaning up the LIB1 directory:

    $ rm S1_11_20.clean.fastq
    $ rm miderrors_S1_11_20.clean.fastq
    $ rm parsereport_S1_11_20.clean.fastq

Cleaning up the LIB2 directory:

    $ rm S2_11_20.clean.fastq
    $ rm miderrors_S2_11_20.clean.fastq
    $ rm parsereport_S2_11_20.clean.fastq
    
Parsing BHS_PIMU library :

 	$ perl parse_barcodes768.pl barcodeKey_lib6_bighorns_pines.csv BHS_PIMU.clean.fastq A00 &

Parsing TICR_PIMU library:

	$ perl parse_barcodes768.pl barcodeKey_lib4_timema_pines.csv TICR_PIMU.clean.fastq A00 &

`NOTE`: the A00 object is the code that identifies the sequencer (first three characters after the @ in the fastq identifier).

    $ less parsereport_S1_11_20.clean.fastq
    Good mids count: 1484409965
    Bad mids count: 36536312
    Number of seqs with potential MSE adapter in seq: 337486
    Seqs that were too short after removing MSE and beyond: 184

    $ less parsereport_S1_11_20.clean.fastq
    Good mids count: 1475831187
    Bad mids count: 45622449
    Number of seqs with potential MSE adapter in seq: 332950
    Seqs that were too short after removing MSE and beyond: 213


Cleaning up the LIB1 directory:

    $ rm S1_11_20.clean.fastq
    $ rm miderrors_S1_11_20.clean.fastq
    $ rm parsereport_S1_11_20.clean.fastq

Cleaning up the LIB2 directory:

    $ rm S2_11_20.clean.fastq
    $ rm miderrors_S2_11_20.clean.fastq
    $ rm parsereport_S2_11_20.clean.fastq
####################################################################################
## 3. splitting fastqs
####################################################################################

Make ids file

    $ cut -f 3 -d "," 11_20_GSAF_lane1BCODEKEY.csv | grep "_" > L1_ids_noheader.txt

    $ cut -f 3 -d "," 11_20_GSAF_lane2BCODEKEY.csv | grep "_" > L2_ids_noheader.txt

    $ cut -f 3 -d "," barcodeKey_lib4_timema_pines.csv | grep "_" > TICR_PIMU_ids_noheader.txt

    $ cut -f 3 -d "," barcodeKey_lib6_bighorns_pines.csv | grep "_" > BHS_PIMU_ids_noheader.txt

Split fastqs by individual

    $ perl splitFastq_universal_regex.pl L1_ids_noheader.txt parsed_S1_11_20.clean.fastq &

    $ perl splitFastq_universal_regex.pl L2_ids_noheader.txt parsed_S2_11_20.clean.fastq &

    $ perl splitFastq_universal_regex.pl TICR_PIMU_ids_noheader.txt parsed_TICR_PIMU.clean.fastq &

    $ perl splitFastq_universal_regex.pl BHS_PIMU_ids_noheader.txt parsed_BHS_PIMU.clean.fastq & 

Zip the parsed*fastq files for now, but delete once patterns and qc are verified:

    $ gzip parsed_S1_11_20.clean.fastq
    $ gzip parsed_S2_11_20.clean.fastq

Total reads for muricata, radiata, and attenuata

    $ grep -c "^@" *fastq > seqs_per_ind.txt

### Moving fastqs to project specific directories