#!/bin/bash
#
#--------------------
#assignment2_script.sh
#--------------------
#
#Author: Diana Seelinger
#
#V1. 10 7 2026
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

mkdir -p ~/Documents/btec-640_TEST/assignment_2/input_data ~/Documents/btec-640_TEST/assignment_2/final_output ~/Documents/btec-640_TEST/assignment_2/src ~/Documents/btec-640_TEST/assignment_2/analysis/gene_survey ~/Documents/btec-640_TEST/assignment_2/analysis/blast ~/Documents/btec-640_TEST/assignment_2/analysis/proteins

cd ~/Documents/btec-640_TEST
touch README
echo "this is assignment 2 for btec 640" > README
cd ~/Documents/btec-640_TEST/input_data

curl -o mouse.gtf.gz "https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/001/635/GCF_000001635.27_GRCm39/GCF_000001635.27_GRCm39_genomic.gtf.gz"

curl -o chicken.gtf.gz "https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/016/699/485/GCF_016699485.2_bGalGal1.mat.broiler.GRCg7b/GCF_016699485.2_bGalGal1.mat.broiler.GRCg7b_genomic.gtf.gz"

curl -o frog.gtf.gz "https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/004/195/GCF_000004195.4_UCB_Xtro_10.0/GCF_000004195.4_UCB_Xtro_10.0_genomic.gtf.gz"

curl -o zebrafish.gtf.gz "https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/049/306/965/GCF_049306965.1_GRCz12tu/GCF_049306965.1_GRCz12tu_genomic.gtf.gz"

ls -lh

for f in *.gz; do
    gunzip "$f"
done

cd ~/Documents/btec-640_TEST/assignment_2/analysis/gene_survey
ln -s ~/Documents/btec-640_TEST/assignment_2/input_data/chicken.gtf
ln -s ~/Documents/btec-640_TEST/assignment_2/input_data/frog.gtf
ln -s ~/Documents/btec-640_TEST/assignment_2/input_data/mouse.gtf
ln -s ~/Documents/btec-640_TEST/assignment_2/input_data/zebrafish.gtf

awk -F'\t' '$3=="gene"' mouse.gtf > mouse_genes.gtf
awk -F'\t' '$3=="gene"' zebrafish.gtf > zebrafish_genes.gtf
awk -F'\t' '$3=="gene"' frog.gtf > frog_genes.gtf
awk -F'\t' '$3=="gene"' chicken.gtf > chicken_genes.gtf
wc -l mouse_genes.gtf
wc -l zebrafish_genes.gtf
wc -l frog_genes.gtf
wc -l chicken_genes.gtf

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
done > gene_survey.txt

for SPECIES in mouse chicken frog zebrafish
do
    for GENE in tp53 aim2 tlr9 tlr21 gulo
    do
        FILE="${GENE}_${SPECIES}.gtf"

        PROTEIN=$(grep -o 'protein_id "[NX]P_[^"]*"' "$FILE" |
                  grep -o '[NX]P_[^"]*' |
                  sort -u)

        if [ -n "$PROTEIN" ]
        then
            echo "$GENE $SPECIES $PROTEIN" >> protein_list.txt
        fi
    done
done


cd ~/Documents/btec-640_TEST/assignment_2/analysis/proteins

while read -r gene species accession
do
    curl -o "${gene}_${species}.faa" "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=protein&id=${accession}&rettype=fasta&retmode=text"
    sleep 1
done < ../gene_survey/protein_list.txt

cat tp53_*.faa > tp53_all.faa
cat aim2_*.faa > aim2_all.faa
cat tlr9_*.faa > tlr9_all.faa
cat tlr21_*.faa > tlr21_all.faa
cat gulo_*.faa > gulo_all.faa

curl -o mouse.fna.gz "https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/001/635/GCF_000001635.27_GRCm39/GCF_000001635.27_GRCm39_genomic.fna.gz"

curl -o chicken.fna.gz "https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/016/699/485/GCF_016699485.2_bGalGal1.mat.broiler.GRCg7b/GCF_016699485.2_bGalGal1.mat.broiler.GRCg7b_genomic.fna.gz"

curl -o frog.fna.gz "https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/004/195/GCF_000004195.4_UCB_Xtro_10.0/GCF_000004195.4_UCB_Xtro_10.0_genomic.fna.gz"

curl -o zebrafish.fna.gz "https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/049/306/965/GCF_049306965.1_GRCz12tu/GCF_049306965.1_GRCz12tu_genomic.fna.gz"

for f in *.gz; do
    gunzip "$f"
done

makeblastdb -in ~/Documents/btec-640_TEST/assignment_2/analysis/proteins/mouse.fna -dbtype nucl -out ~/Documents/btec-640_TEST/assignment_2/analysis/proteins/mouse_db
makeblastdb -in ~/Documents/btec-640_TEST/assignment_2/analysis/proteins/frog.fna -dbtype nucl -out ~/Documents/btec-640_TEST/assignment_2/analysis/proteins/frog_db
makeblastdb -in ~/Documents/btec-640_TEST/assignment_2/analysis/proteins/zebrafish.fna -dbtype nucl -out ~/Documents/btec-640_TEST/assignment_2/analysis/proteins/zebrafish_db
makeblastdb -in ~/Documents/btec-640_TEST/assignment_2/analysis/proteins/chicken.fna -dbtype nucl -out ~/Documents/btec-640_TEST/assignment_2/analysis/proteins/chicken_db

while read -r gene species accession
do
   tblastn -db ~/Documents/btec-640_TEST/assignment_2/analysis/proteins/chicken_db -query ~/Documents/btec-640_TEST/assignment_2/analysis/proteins/${gene}_${species}.fasta -out ~/Documents/btec-640_TEST/assignment_2/final_output/${gene}_${species}_output.tsv -outfmt 6  
 done < ../gene_survey/protein_list.txt

