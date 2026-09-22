##download_ch21_diana.sh

#Author: Diana R. Seelinger
#Version: 16 Sept 26

#Description
    
#   This file desribes the steps to download the chr21 gtf file from UCSC, filter for protein coding genes, and download the FASTA sequences for the first 10 protein coding genes.
#   1. Move and make working directory
#   2. Download, unzip and move to input_data the chr21 gtf file from UCSC
#   3. Further process this data to obtain the first 10 protein coding genes and get their Fasta sequences
#   4. Verification by listing fasta files

##Move and make working directory
cd #moves to root
cd Documents/ #moves into to Documents
mkdir btec_640_TEST #makes folder btec_640
cd btec_640_TEST/ #moves into folder btec_640
mkdir exercises #makes folder exercises
cd exercises/ #moves into folder exercises
mkdir 09_14_26 #makes folder 09_14_26
cd 09_14_26/ #  moves into folder 09_14_26
mkdir input_data #makes folder input_data
mkdir analysis #makes folder analysis

##Download, unzip and move to input_data the chr21 gtf file from UCSC
curl -o hg38.ncbiRefSeq.gtf.gz "https://hgdownload.soe.ucsc.edu/goldenPath/hg38/bigZips/genes/hg38.ncbiRefSeq.gtf.gz" #downloads the hg38.ncbiRefSeq.gtf.gz file from UCSC
gunzip hg38.ncbiRefSeq.gtf.gz #unzips the hg38.ncbiRefSeq.gtf.gz file
mv hg38.ncbiRefSeq.gtf input_data/ #    moves the hg38.ncbiRefSeq.gtf file to input_data folder

##Moves into analysis for further processing
cd analysis/ #moves into folder analysis

##Further processing to obtain the first 10 protein coding genes and get their FASTA sequences
ln -s ../input_data/hg38.ncbiRefSeq.gtf #makes a soft link to the hg38.ncbiRefSeq.gtf file

grep "chr21" hg38.ncbiRefSeq.gtf > chr21.gtf #filter for lines with chr21 into a new file called chr21.gtf

grep "NM_" chr21.gtf > refseq_chr21.gtf #filter for lines with NM_, indicating they are protein coding, into a new file called chr21.gtf

awk -F '\t' '{print $9}' refseq_chr21.gtf  | awk -F'"' '!seen[$2]++ {print $2, $4}' refseq_chr21.gtf > gene_accession.txt #extract gene names and accession numbers into a new file called gene_accession.txt

head -n 10 gene_accession.txt > 10_genes.txt #extract the first 10 genes into a new file called 10_genes.txt

while read -r gene accession; do curl -o "${gene}.fasta" "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore&id=${accession}&rettype=fasta&retmode=text"; done < 10_genes.txt #download the FASTA sequences for these first 10 protein coding genes using their accession numbers

##Verification by listing fasta files
ls -l *.fasta #lists all the FASTA files downloaded
