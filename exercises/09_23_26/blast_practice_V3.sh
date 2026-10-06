#!/bin/bash
#
#--------------------
#blast_practice.sh
#--------------------
#
#Author: Diana Seelinger
#
#V1. 23 Sept 26
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
#Working dir variables:
#1. Create directories
#2. Read the date FASTA format (nucleotide, aminoacids)
#3. Call BLAST
#4. Search 
#5. Save in an output file
#6. Check the data

####VARIABLES
WORKDIR=~/btec-640_TEST/exercises/09_28_26
INPUTDIR="input_data"
OUTDIR="output_data"
ANALYSISDIR="analysis"

#input should be fasta file
INPUT=LSS.fasta
#

mkdir -p $WORKDIR
mkdir -p $WORKDIR/$INPUTDIR
mkdir -p $WORKDIR/$OUTDIR
mkdir -p $WORKDIR/$ANALYSISDIR

curl -o $WORKDIR/$INPUTDIR/chr21.fa.gz "https://hgdownload.soe.ucsc.edu/goldenPath/hg38/chromosomes/chr21.fa.gz"
gunzip $WORKDIR/$INPUTDIR/chr21.fa.gz

makeblastdb -in $WORKDIR/$INPUTDIR/chr21.fa -dbtype nucl -out $WORKDIR/$ANALYSISDIR/output_database

### This code is going to run blastn (Nucletotides)
blastn -db $WORKDIR/$ANALYSISDIR/output_database -query $WORKDIR/$INPUTDIR/$INPUT -out $WORKDIR/$OUTDIR/blast_results.txt 

###Check your data
less $WORKDIR/$OUTDIR/blast_results.txt