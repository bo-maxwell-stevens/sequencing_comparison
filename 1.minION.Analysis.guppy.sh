#!/bin/bash
# Created: February 23, 2021
# Author: Dan Manter, USDA-ARS
# usage: bash minION.Analysis.sh

#### Specify the barcodes you will be looking for...
#############################################################
AllBarcodes=( \
"01" "02" "03" "04" "05" "06" "07" "08" "09" "10" \
"11" "12" "13" "14" "15" "16" "17" "18" "19" "20" \
"21" "22" "23" "24" "25" "26" "27" "28" "29" "30" \
"31" "32" "33" "34" "35" "36" "37" "38" "39" "40" \
"41" "42" "43" "44" "45" "46" "47" "48" "49" "50" \
"51" "52" "53" "54" "55" "56" "57" "58" "59" "60" \
"61" "62" "63" "64" "65" "66" "67" "68" "69" "70" \
"71" "72" "73" "74" "75" "76" "77" "78" "79" "80" \
"81" "82" "83" "84" "85" "86" "87" "88" "89" "90" \
"91" "92" "93" "94" "95" "96")
#############################################################
#
#
# ### Basecalling with Guppy - v6.0.6
# #############################################################

guppy_basecaller \
   -i ../fast5 \
   -s ../fastq/fastq_basecalled \
   -c dna_r9.4.1_450bps_hac.cfg \
   -r \
   -x "cuda:0"
# #############################################################
#
#
# ### Demultiplexing with Guppy - v6.0.6
# #############################################################
guppy_barcoder \
   -i ../fastq/fastq_basecalled/pass \
   -s ../fastq/fastq_demultiplexed \
   --config configuration.cfg \
   --barcode_kits "EXP-PBC096" \
   --require_barcodes_both_ends \
   --trim_barcodes \
   -x "cuda:0"

for val in ${AllBarcodes[@]}; do
   DIR=../fastq/fastq_demultiplexed
   cat $DIR/barcode$val/*.fastq > $DIR/barcode$val.fastq
 done
#############################################################

# <end of file>
