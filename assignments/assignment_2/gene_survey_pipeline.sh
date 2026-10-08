#!/bin/bash
#
#--------------------
#gene_survey_pipeline.sh
#--------------------
#
#Author: Diana Seelinger
#
#V1. 10 7 2026
#
#Description:
#
# This is a program which 
#
#Usage:
#
#


#------Edit-----------
#Steps:
#0: Make working directories
#1. Download and unzip annotated genomes
#2. Isolate gene sequences
#3. Filter to genes of interest
#4. Pull out and download proteins of interest
#5. Make blast databases from genomes
#6. Run protein sequences via tblastn against blast databases

#VARIABLES
WORKDIR=~/Documents/btec-640_TEST/assignment_2

#Step 0: make working directories

#make all directories with one command
mkdir -p $WORKDIR/input_data $WORKDIR/final_output $WORKDIR/src $WORKDIR/analysis/gene_survey $WORKDIR/analysis/blast $WORKDIR/analysis/proteins


cd $WORKDIR #enter directory
touch README #make readme
echo "this is assignment 2 for btec 640 and a script for creating a sample gene survey pipeline" > README #write readme
cd $WORKDIR/input_data #enter input directory

#Step 1: download annotated genomes (gunzipped) from NCBI
curl -o mouse.gtf.gz "https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/001/635/GCF_000001635.27_GRCm39/GCF_000001635.27_GRCm39_genomic.gtf.gz"

curl -o chicken.gtf.gz "https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/016/699/485/GCF_016699485.2_bGalGal1.mat.broiler.GRCg7b/GCF_016699485.2_bGalGal1.mat.broiler.GRCg7b_genomic.gtf.gz"

curl -o frog.gtf.gz "https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/004/195/GCF_000004195.4_UCB_Xtro_10.0/GCF_000004195.4_UCB_Xtro_10.0_genomic.gtf.gz"

curl -o zebrafish.gtf.gz "https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/049/306/965/GCF_049306965.1_GRCz12tu/GCF_049306965.1_GRCz12tu_genomic.gtf.gz"


ls -lh #check file sizes for download verification


for f in *.gz; do
    gunzip "$f"
done #unzip all genomes as loop

cd $WORKDIR/analysis/gene_survey #enter analysis part 1 directory

#create softlinks
ln -s $WORKDIR/input_data/chicken.gtf
ln -s $WORKDIR/input_data/frog.gtf
ln -s $WORKDIR/input_data/mouse.gtf
ln -s $WORKDIR/input_data/zebrafish.gtf

#Step 2: Isolate gene sequences from annotated genomes
awk -F'\t' '$3=="gene"' mouse.gtf > mouse_genes.gtf
awk -F'\t' '$3=="gene"' zebrafish.gtf > zebrafish_genes.gtf
awk -F'\t' '$3=="gene"' frog.gtf > frog_genes.gtf
awk -F'\t' '$3=="gene"' chicken.gtf > chicken_genes.gtf

#count genes for each genome for verification
wc -l mouse_genes.gtf
wc -l zebrafish_genes.gtf
wc -l frog_genes.gtf
wc -l chicken_genes.gtf

#Step 3: Filter out genes of interest

for SPECIES in mouse chicken frog zebrafish
do
    for GENE in tp53 aim2 tlr9 tlr21 gulo
    do
        grep -i "gene_id \"${GENE}\";" ${SPECIES}.gtf > ${GENE}_${SPECIES}.gtf

        if [ -s ${GENE}_${SPECIES}.gtf ]
        then
            echo "${GENE} ${SPECIES} FOUND"
        else
            echo "${GENE} ${SPECIES} NOT_FOUND"
            rm ${GENE}_${SPECIES}.gtf
        fi
    done
done > gene_survey.txt #search for annotated gene copies of genes of interest in each species genome's genes and save their information in new files if it exists (technically, it creates a file for each gene whether or not it finds anything, but deletes empty files)

#Step 4: Pull out and download proteins of interest

for SPECIES in mouse chicken frog zebrafish
do
    for GENE in tp53 aim2 tlr9 tlr21 gulo
    do
        FILE="${GENE}_${SPECIES}.gtf"

        PROTEIN=$(grep -o 'protein_id "[NX]P_[^"]*"' "$FILE" |
                  sort -u)

        if [ -n "$PROTEIN" ]
        then
            echo "$GENE $SPECIES $PROTEIN" >> protein_list.txt
        fi
    done
done #from each a species' gene of interest file, isolate the protein coding "NP_" and "XP_" genes removing duplicates and post accession numbers to a list txt


cd $WORKDIR/analysis/proteins #move to part 2 of analysis directory

while read -r gene species accession
do
    curl -o "${gene}_${species}.faa" "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=protein&id=${accession}&rettype=fasta&retmode=text"
    sleep 1
done < ../gene_survey/protein_list.txt #read the list, and use the accession numbers to download each protein coding gene into a new FASTA file from NCBI denoted with the gene and species information

#combine all protein coding gene sequences of a specific gene of interest into a new FASTA file covering the range of its identity
cat tp53_*.faa > tp53_all.faa
cat aim2_*.faa > aim2_all.faa
cat tlr9_*.faa > tlr9_all.faa
cat tlr21_*.faa > tlr21_all.faa
cat gulo_*.faa > gulo_all.faa

#Step #5: Make blast databases from genomes

#Download raw unannotated nucleotide genomes (gunzipped) from NCBI
curl -o mouse.fna.gz "https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/001/635/GCF_000001635.27_GRCm39/GCF_000001635.27_GRCm39_genomic.fna.gz"

curl -o chicken.fna.gz "https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/016/699/485/GCF_016699485.2_bGalGal1.mat.broiler.GRCg7b/GCF_016699485.2_bGalGal1.mat.broiler.GRCg7b_genomic.fna.gz"

curl -o frog.fna.gz "https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/004/195/GCF_000004195.4_UCB_Xtro_10.0/GCF_000004195.4_UCB_Xtro_10.0_genomic.fna.gz"

curl -o zebrafish.fna.gz "https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/049/306/965/GCF_049306965.1_GRCz12tu/GCF_049306965.1_GRCz12tu_genomic.fna.gz"

#Unzip all gz as a loop
for f in *.gz; do
    gunzip "$f"
done

#Make a BLAST database out of each nucleotide genome
makeblastdb -in $WORKDIR/analysis/proteins/mouse.fna -dbtype nucl -out $WORKDIR/analysis/proteins/mouse_db
makeblastdb -in $WORKDIR/analysis/proteins/frog.fna -dbtype nucl -out $WORKDIR/analysis/proteins/frog_db
makeblastdb -in $WORKDIR/analysis/proteins/zebrafish.fna -dbtype nucl -out $WORKDIR/analysis/proteins/zebrafish_db
makeblastdb -in $WORKDIR/analysis/proteins/chicken.fna -dbtype nucl -out $WORKDIR/analysis/proteins/chicken_db

#6. Run protein sequences via tblastn against blast databases
for SPECIES in mouse chicken frog zebrafish
do
    for GENE in tp53 aim2 tlr9 tlr21 gulo
    do
        tblastn -db $WORKDIR/analysis/proteins/${SPECIES}_db -query $WORKDIR/analysis/proteins/${GENE}_all.faa -out $WORKDIR/final_output/${GENE}_${SPECIES}_output.tsv -outfmt 6  
        sleep 1
    done
done > blast_comparisons.txt #runs a blast search against each newly minted animal genome database for each gene of interest's combined sequences to detect similar sequences regardless of annotation