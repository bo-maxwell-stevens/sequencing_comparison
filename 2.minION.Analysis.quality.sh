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


# Filter and classify sequences
#############################################################

fastq_dir="../fastq/fastq_demultiplexed"
mkdir $fastq_dir

for val in ${AllBarcodes[@]}; do
  sample="barcode"$val
  echo "Starting $sample..."

   echo "Filtering $sample for quality..."
   /project/akron/Filtlong/bin/filtlong \
     --min_length 1000 \
     --min_mean_q 70 \
     $fastq_dir/$sample.fastq > $fastq_dir/$sample.f.fastq

   echo "Filtering $sample for length..."
   cutadapt -m 1000 -M 2500 \
     -o $fastq_dir/$sample.ft.fastq \
     $fastq_dir/$sample.f.fastq

   echo "Checking $sample for chimeras"
   vsearch --derep_fulllength \
     $fastq_dir/$sample.ft.fastq \
     --fasta_width 0 \
     --output $fastq_dir/$sample.ftu.fasta \
     --sizeout --minuniquesize 1

   vsearch --uchime_denovo \
     $fastq_dir/$sample.ftu.fasta \
     --fasta_width 0 \
     --nonchimeras $fastq_dir/$sample.ftuc.fasta
  awk 'BEGIN {RS = ">"; FS = ";|\n|=";} {for (i = 1 ; i <= $3 ; i++) {print ">"$1"\n"$4;} }' \
    $fastq_dir/$sample.ftuc.fasta > $fastq_dir/$sample.final.fasta
done

# ### Get summary statistics
#############################################################
echo "sample,reads,f,ft,ftu,ftuc,final" > demultiplex.log
for val in ${AllBarcodes[@]}; do
  DIR=../fastq/fastq_demultiplexed
  count1=$(( $(cat $DIR/barcode$val.fastq | wc -l) / 4 | bc))
  count2=$(( $(cat $DIR/barcode$val.f.fastq | wc -l) / 4 | bc))
  count3=$(( $(cat $DIR/barcode$val.ft.fastq | wc -l) / 4 | bc))
  count4=$(( $(grep ">" $DIR/barcode$val.ftu.fasta | wc -l) ))
  count5=$(( $(grep ">" $DIR/barcode$val.ftuc.fasta | wc -l) ))
  count6=$(( $(grep ">" $DIR/barcode$val.final.fasta | wc -l) ))
  echo "barcode"$val","$count1","$count2","$count3","$count4","$count5","$count6 >> demultiplex.log
done
#############################################################

# <end of file>
