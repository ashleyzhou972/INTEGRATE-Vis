#!/bin/bash
fusion=$1
gene5=$2
gene3=$3
bp5=$4
bp3=$5 
tx5=$6 
tx3=$7
output=$8
folder=$(dirname "$0")
echo "plotting" $fusion
mkdir -p $output/$fusion
python2 $folder/bin/pa.py -5 $gene5 -3 $gene3 -f $bp5 -t $bp3 -p " 0 0 $tx5;$tx3;" -d $folder/data/ideogram/Ideogram.38.tsv -m $folder/data/gene_model/Homo_sapiens.GRCh38.88.gtf -o $output/"$fusion"/"$fusion"_A.png
    
python2 $folder/bin/pb.py -5 $gene5 -3 $gene3 -f $bp5 -t $bp3 -p " 0 0 $tx5;$tx3;" -d $folder/data/domain_table/Domain_table.38.88.tsv  -m $folder/data/gene_model/Homo_sapiens.GRCh38.88.gtf -o $output/"$fusion"/"$fusion"_B.png done 
