#!/bin/bash
folder=$(pwd)
input=$1
IFS=','
{
read
while read gene_5 gene_3 bp5 bp3 tx5 tx3 fusion gene5 gene3 
do
    echo $fusion
    mkdir -p $folder/$fusion
    python2 $folder/bin/pa.py -5 $gene5 -3 $gene3 -f $bp5 -t $bp3 -p " 0 0 $tx5;$tx3;" -d $folder/data/ideogram/Ideogram.38.tsv -m $folder/data/gene_model/Homo_sapiens.GRCh38.88.gtf -o $folder/"$fusion"/"$fusion"_A.png
    
    python2 $folder/bin/pb.py -5 $gene5 -3 $gene3 -f $bp5 -t $bp3 -p " 0 0 $tx5;$tx3;" -d $folder/data/domain_table/Domain_table.38.88.tsv  -m $folder/data/gene_model/Homo_sapiens.GRCh38.88.gtf -o $folder/"$fusion"/"$fusion"_B.png done 
done
}< $input


