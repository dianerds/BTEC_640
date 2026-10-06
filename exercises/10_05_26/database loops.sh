#!/bin/bash
#
#--------------------
#database.sh
#--------------------
#
#Author: Diana Seelinger
#
#V1. 05 Oct 26
#
#Description:
#
#
#
#Usage:
#
#
#Required input files:


#------Edit-----------

WORKDIR=~/Documents/btec-640_TEST/exercises/10_06_26 #Or whatever you named your $WORKDIR variable for the previous excercise
INPUTDIR=input_data
OUTDIR=output_data
ANALYSIS=analysis
##NEW VARIABLE!!!
DATADIR=datasets #THIS IS A NEW DIRECTORY THAT YOU WILL CREATE FOR TODAY

#Data variables
GENE=LSS #Because we are testing this in one single gene first.

#Start your actual script:

mkdir -p $WORKDIR/$INPUTDIR
mkdir -p $WORKDIR/$OUTDIR
mkdir -p $WORKDIR/$ANALYSIS
mkdir -p $WORKDIR/$DATADIR/orthologs

#1. Download LSS data from ncbi using datasets instead of curl
while read -r GENE ID
do
    datasets download gene symbol $GENE --ortholog 'homo sapiens,pan troglodytes,mus musculus,sus scrofa,canis lupus familiaris' --filename $WORKDIR/$DATADIR/orthologs/${GENE}_orthologs.zip
    unzip $WORKDIR/$DATADIR/orthologs/${GENE}_orthologs.zip -d $WORKDIR/$DATADIR/orthologs/${GENE}_orthologs
    mv $WORKDIR/$DATADIR/orthologs/${GENE}_orthologs/ncbi_dataset/data/protein.faa $WORKDIR/$DATADIR/orthologs/${GENE}_orthologs/ncbi_dataset/data/${GENE}_protein.faa 
    mv $WORKDIR/$DATADIR/orthologs/${GENE}_orthologs/ncbi_dataset/data/rna.fna $WORKDIR/$DATADIR/orthologs/${GENE}_orthologs/ncbi_dataset/data/${GENE}_rna.fna
done < $WORKDIR/$INPUTDIR/10_genes.txt

