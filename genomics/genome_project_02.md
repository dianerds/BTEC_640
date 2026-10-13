# Genome Project: Part II



### Project standards 

This is the most important project of the semester and the largest part of your grade. It is **one big project** where each team builds one part, so to succeed we need to work as a scientific community and follow the same methodology.

Each working group will analyze a different group of vertebrates, but **all the class will use the same data and the same methods**. 

The first analyses (OrthoFinder, single-copy orthologs and alignments) are identical for everyone. Your team's own analysis and unique results come during the selection analysis and the search for putative gene losses.

**What everyone keeps the same:**

1. The same data, software and **software versions**.
2. The same parameters, `-flags`, and statistical parameters.
3. The same working environment: all the analyses are done from the terminal on tule not at your local computer (I am working to figure out the VPN issue).
4. The same GitHub directory structure.

**Where you have freedom:**

1. How you write your code syntax (loops, variables, sanity checks)
2. How you organize your script, just make sure you are **following the best practices we covered in class** (e.g #comment your code, write down authorship, use variables, etc.)
3. The name your output files, sub_directories (except `input_data`, `output_data` and `analysis`)
4. The structure of your Markdown report document. **Just make sure is readable and that you are putting all the information that is being asked for each activity**.
5. If you use AI :robot: to **improve** (not create) your code. :warning: **mention which one did you use and give credit. Explain in your Markdown report document the syntax of that code and what it does.** 

>**Important note regarding the software we are using:**
>
>I will always encourage you to look for new software and alternative ways to build your pipelines. **There is more than one way to do an analysis**, and exploring other tools and strategies is an important skill to train. </br>
>However, to make our project reproducible and scalable (following the FAIR principles), and given our limited time and resources, in this project we will all use the same strategy. This way I can help you fix and debug errors quickly, and evaluate everyone's work with the same rubric.</br>
>**This does not mean this is the only way to do it, when you continue exploring on your own in the future, and you start feeling more confident using the terminal and basic coding skills, exploring alternative tools by your own will be a great skill to have.**
>




**Deliverables for this project:**
1. A markdown report document where you describe each step in a tutorial style (like the ones that I have been giving you in class):
   - It will be one single markdown per activity, this is a group file, individual documents are not going to be cosidered for grading.
   - I will give you documents with instructions for each week activities. In those documents you will find specific questions that you **need to include on your markdown report file**, these sections are mandatory for getting full completness score.  
2. The script in `.sh` extension. All the scripts generated i this project are going to be part of a main pipeline. In some activities you will need to generate multiple scripts, in some just one. **Remember that I will grade if you followed the best practices for your script**.
   
:handshake: Effective teamwork relies on strong organization and a clear division of tasks:

   - Split the tasks: some members work on the script, others on the Markdown document (for the next activity you swithc roles). **This is not an individual task**: communicate with respect with yor team mates, and make sure everyone agrees, understands and follows the project.
 - Once the script and the markdown are done, **JUST ONE PERSON IS GOING TO RUN THE SCRIPT ON THE SERVER**.
  - Upload both the final script and the Markdown report to your team's GitHub repository.
  
  

### Week 2 Activity goals:

- Download genomic data from NCBI with `datasets`, choosing **only** the files you need.
- Use a loop to download data for many species.
- Keep track of which genome you used for each species (All of this information should be written in the markdown document).
- Start exploring and understanding `seqkit` tool, [documentation](https://bioinf.shenwei.me/seqkit/) to manipulate your data. 
- Rename the files and the fasta headers using `seqkit`, get your file statiscs with `seqtkit`


<br>


### 1. Go to your working directory

Our working directory for the entire genome project is the one you all created last class. Inside that directory you must have these:

| Directory | What goes inside |
| --- | --- |
| `input_data` | Raw data that you download. **Never** modify it. Everything from NCBI goes here. |
| `analysis` | Intermediate files: the work in progress. |
| `output_data` | Final results: tables, files you will report. |


### 2. Our 15 species

Inside `input_data`, create a file named `species.txt` write down **ONLY** the scientific name per line:
(You can do this either with `nano` or with your VS_code mounted in Tule).


**Table 1**
| Class | Species | Common name |
| --- | --- | --- |
| Mammals | *Homo sapiens* | Human |
| | *Mus musculus* | Mouse |
| | *Bos taurus* | Cow |
| Birds | *Gallus gallus* | Chicken |
| | *Taeniopygia guttata* | Zebra finch |
| | *Anas platyrhynchos* | Mallard duck |
| Reptiles | *Anolis carolinensis* | Green anole lizard |
| | *Alligator mississippiensis* | American alligator |
| | *Chrysemys picta* | Painted turtle |
| Amphibians | *Xenopus tropicalis* | Western clawed frog |
| | *Rana temporaria* | Common frog |
| | *Bufo bufo* | Common toad |
| Fishes | *Danio rerio* | Zebrafish |
| | *Oryzias latipes* | Medaka |
| | *Takifugu rubripes* | Pufferfish |


Check your file:
```bash
cat species.txt
wc -l species.txt
```

### 3. Download only CDS and proteins



A genome data package can contain many files, we don't need to download everything.
NCBI's `datasets` package, has a flag `--include` that allow us to choose exactly which files we want.


>[!TIP] **Syntax: `datasets download genome`**
>
>```bash
>datasets download genome taxon "SPECIES NAME" --reference --assembly-source RefSeq --include cds,protein --filename OUTPUT.zip
>```
>
>- `genome taxon "SPECIES NAME"` asks for the genome of a species by its name. Use quotes, because the name has a space!
>- `--reference` gives you only the **reference genome** of that species. Without it, you could get **all** the genomes available for that species (some have hundreds!).
>- `--assembly-source RefSeq` asks for the RefSeq (`GCF_`) version of the genome, the one annotated by NCBI. Without an annotation, there are no CDS or proteins to download.
>- `--include` chooses the files. The default is `genome`, so if you don't use `--include` you download the **whole genome sequence**. Options:
>
>| Option | File you get | What is inside |
>| --- | --- | --- |
>| `genome` | `*_genomic.fna` | The whole genome sequence (DNA) |
>| **`cds`** | **`cds_from_genomic.fna`** | **Nucleotide coding sequences: from start to stop codon** |
>| **`protein`** | **`protein.faa`** | **Amino acid sequences** |
>| `rna` | `rna.fna` | Transcripts (including UTRs) |
>| `gff3` / `gtf` | `genomic.gff` / `genomic.gtf` | Annotation files (like the GTF from the Chromosome 21 exercise) |
>| `none` | Only the reports | No sequences |
>
>- You can combine options with commas, **no spaces**: `--include cds,protein`.
>- Add `--preview` to see how big the download is, **without** downloading it.

**UNDERSTAND THE CODE LINE FIRST**

Before writing your code in the script, **ALL OF YOU** try with one species first, and save it into `input_data`:

**Code:**

This is how you would download human data. Copy and paste this command line in your terminal. </br>
:stop_sign: Pay attention where you should run this command **look where I am asking to save the output file** `iput_data/Homo_sapiens.zip`. 


```bash

datasets download genome taxon "Homo sapiens" --reference --assembly-source RefSeq --include cds,protein --filename input_data/Homo_sapiens.zip

unzip input_data/Homo_sapiens.zip -d input_data/Homo_sapiens
ls -R input_data/Homo_sapiens
```

Explore all the files and directories that were downloaded, pay special attention to the paths and filenames. 

>[!Note] Script Step 1: Download and rename  cds and protein files for all the species, using with datasets
 **For your script**: 
>
>1. Use the previous code as a reference for your own script, but make it scalable for all the species. i.e use variables and use a loop that reads the information inside `species.txt` file.
>
>2. Remember that the files from every species will have the **same names** (`cds_from_genomic.fna` and `protein.faa`), which is confusing. <br>
Usig your variables, add two lines inside your loop so that every time `datasets` downloads and unzips a package, the CDS and protein files are copied into `input_data` and renamed with the `$NAME` variable (e.g. `Homo_sapiens_cds.fna` and `Homo_sapiens_protein.faa`). 

>[!IMPORTANT] Markdown report
Explain the logic of the workflow that you need to follow to add the species name to `cds_from_genomic.fna` and `protein.faa`.

>[!CAUTION] TEST YOUR SCRIPT
>There is a way we ca test our script so far without actually run anything:
> ```
> bash -n yourscript.sh
>```
>
>This will just check and read a Bash script for syntax errors without executing any of its commands. If you have any bugs or syntax errors discuss with your team to try to fix it. If everything looks good continue.
> The text "yourscript.sh" is just an example you need to put the name of your script instead.

### 4. Which genome did we use for each species?

As we saw in our `datasets` activity, every ncbi directory includes an `assembly_data_report.jsonl` file with all the metadata.

This json file can be converted to a human readable table file, using  another NCBI's package that is named `dataformat`.  

We can concateate all of our json files i a single file. This would be easy here because all the ncbi directories have the same name. For this we will use the command `cat`. Yes, the same one that we use to "print" the content of a file.

>[!Note] Script step 2: Get the accession number from each species, using the metadata from NCBI. 
> On your script: Add this code right after your loop where you downloaded and unzipped the files:
> **Look in which directory we are saving the files**
>
>**Code:**
>
>```bash
>cat input_data/*/ncbi_dataset/data/assembly_data_report.jsonl > output_data/all_assembly_reports.jsonl
>
>dataformat tsv genome --inputfile input_data/all_assembly_reports.jsonl --fields accession,organism-name,assminfo-name,annotinfo-featcount-gene-protein-coding > output_data/genomes_summary.tsv
>```

>[!IMPORTANT] Markdown report
> - On your markdown tutorial/report document, explain the syntax for `cat` and `dataformat` code that you copied, and explain with your own words what this code is doing. <br>
> - After running your script, open your `genomes_summary.tsv` file, and use the information to complete **Table 1** on your document (copy Table 1 from this document, and paste it to your Markdown report, add a new column with the accession number for each scpecies on your Markdown report file).

### 5. Get the statistics for each protein and cds file

We will use `seqkit` to get basic statistics data for our proteins and cds files, including format, type, number of sequences, leght of the sequences etc. 

`seqkit` is a bioinformatic tool that is designed to maipulate and edit your fasta and fastq files. This tool authomatize many important tasks such as change headers, rename files, get basic statiscs, split fasta files in similar lenght etc etc. You don't need to reinvet the wheel, before developing a complicated script to edit fasta or fastq files, check if `seqkit` can do it :)

Another important skill to develop is **how to read tools and software documetation**


>[!IMPORTANT] Markdown report
> - Go to the seqkit documentation and look how to use `stats`. 
> - Write a syntax block explaining how to run `seqkit stats` (i.e. what type of input do you need, what output is generated etc)
> - On your markdown make a step by step tutorial of how to run `seqkit stats` in your data using a loop. The loop should save save the statistics from ALL the species on a single file named `protein_statistics.txt`, and one for `cds_statistics.txt`.
>  - After you run the complete script, add a table with all the statiscis for each file, this will be **Table 2** on your Markdown report.
> - After the table explain the information that each column is giving you
> - Discuss with your group and explain in the markdown document why the statistics differ between the protein and cds files.

>[!Note] Script Step 3: Get basic statistics for cds and protein files from each species
> Right after the `dataformat` step, add the loop to calculate the statistics with `seqkit stats` for all your files. Double check that you are following the logic and syntax YOUR team is documenting on the markdown report. The two output files: (`protein_statistics.txt` and `cds_statistics.txt`) should be saved inside `output_dir`
> 

One member of the group, will run the complete script.
Use the output to complete the markdown report. 
Both,the script and the markdown report, together with the output tables should be uploaded to your team github repository. On the markdown report write the `git` commands to load, commit and push.




