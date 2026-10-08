## The Genome Project: Searching for Lineage-Specific Adaptations in Vertebrates

We are starting our comparative genomics project! Mammals, birds, reptiles, amphibians and fishes share a common ancestor, but each group evolved its own adaptations. We can find evidence of these adaptaions in the genome.

**Our biological question:**

> *Which genes show evidence of adaptive evolution (positive selection) in each of the five major vertebrate groups, and which genes may have been lost in only one group?*

Each team will focus on one group (your "focal group") and compare it with the other four.

>[!CAUTION]Disclaimer: 
The species in this project were chosen **randomly**, not because they share a biological feature or were picked for a specific scientific hypothesis. A real comparative genomics study needs a representative number of species for each group, selected with a clear biological rationale, and a more complex experimental design that considers phylogenetic relationships, life history, diet, behavior, environmental adaptions, etc. With only 3 randomly chosen species per group, our results are **not well-supported conclusions**. This project is meant to practice our coding skills and how to build a bioinformatics workflow. Interpret your results as **preliminary candidates**, not as definitive evidence.


### Our pipeline design

We will build a **pipeline**: a series of connected scripts, where the output of one step is the input of the next one.

1. **Orthology inference (OrthoFinder):** identify groups of orthologous genes across our 15 species.
2. **Single-copy orthologs:** keep only the genes present as **one copy** in **all** species, so we compare equivalent genes.
3. **Alignments:** align the sequences of each ortholog (protein and codon alignments).
4. **Selection analysis:** detect candidate genes with more amino acid-changing mutations (nonsynonymous, dN) than silent mutations (synonymous, dS) than we would expect under neutral evolution (dN/dS > 1) in your focal group.
5. **Validation:**
   - Genes under positive selection: add orthologs from at least 10 more species of your group and repeat the alignment and selection analysis. Are they still under selection?
   - Candidate gene losses: genes present in the other groups but absent in yours. We will run a **preliminary** BLAST search against more species of your group to check whether the gene is really absent.

>[!CAUTION] 
>A gene that is missing from our dataset is not necessarily lost! As you saw in **Assignment2** It could be a gap in the genome assembly, or a gene the annotation missed. This is why we call them **candidate** gene losses, and why we validate them with BLAST. A real gene loss analysis requires more evidence (synteny, pseudogenes...), which is out of the scope of this course.

At the end of the project, each team will give a **10-minute presentation** with their findings.

### Deliverables

For this project, you will document not only your scripts, but also a **step-by-step Markdown document** like the ones we have been working with. As a team, you are writing your own tutorial: someone who has never seen your project should be able to read it and reproduce your analysis.

1. **Well-documented scripts** (one per pipeline step), saved in `scripts/`.
2. **Well-documented step-by-step Markdown documents**, saved in `docs/`, which include:
   - a) The workflow and the logic of each analysis (step by step).
   - b) The syntax of the commands you used.
   - c) A brief description of what each analysis is doing.
   - d) Your main results (tables in `results/`).
   - e) A brief interpretation of your results.
3. **Your team GitHub repository**, with all your scripts, Markdown documents and results.
4. **Final presentation (10 min):** your findings, your conclusions, and final comments: where did you struggle, and what did you learn from developing a complete bioinformatics pipeline?

:point_right: For each step, I will tell you which software we will use, and I will guide you through it during class. We will keep using the same basic commands and learning new ones during the process. But the main goal is that, **as a team**, you learn how to look for information in the software manuals, write your own tutorial, and create your own scripts. I will give you a Markdown template as an idea, but remember that you already have many templates: all the documents from this course!

### Working as a team

Be mindfull with your team members and work as a group. **All members must be involved in all the steps**: scripts, analysis, Markdown documents and presentation.

- :rotating_light: On presentation day, I will run the "random group" code from the beginning of the semester to choose **which team member gives the presentation**. Every member must understand the whole project and be ready to present it.
- GitHub keeps track of who wrote what and when. And everyone can see and track the changes.
- At the end of the project, you will answer an **anonymous questionnaire regarding the participation of your peers**. The questions are in the syllabus, so you know the expectations in advance.

From now on, your genome project is a **team project**. Each team works on one vertebrate class, and each member will be in charge of one step of the pipeline (OrthoFinder → single-copy orthologs → alignment → selection analysis → BLAST and Enrichment (website)). To work together without running everything five times on the server, you will share your scripts and results through **one GitHub repository per team**, and each of you will run **just ONE of the steps** in your server.

## Let's start our collaborative GitHub

So far you used GitHub Desktop on your computer. On the server we don't have a graphical interface, so today you will use `git` **from the command line**.



Activity goals:

- Connect your account on tule to your GitHub account.
- Create a shared team repository and organize it.
- Understand the everyday `git` cycle: `pull` → edit → `add` → `commit` → `push`.
- See how GitHub keeps track of **who** wrote **what** and **when**.
- Learn how to coordinate with your team so nobody breaks anybody's work.

> For today's class exercise, we will:
>
>- Configure `git` and create an SSH key on tule.
>- Create your team repository with the `scripts`, `docs` and `results` directories.
>- Write your team `README.md`, one member at a time.
>- Create (on purpose!) a conflict and solve it.

| Team | Repository name | Members
| --- | --- | ---
| Birds | `aves_group1` | Dhanya, Anesu, Brooke, Andrés, Joshua
| Mammals | `mammalia_group2` | Amber, Nomthandazo, Jason, Ciara, Enkhdul
| Amphibians | `amphibia_group3` | Ellieka, Anthony, Sagar, Haley, Sheridan
| Reptiles | `reptilia_group4` | Naidni, Diana, Jane, Samuel
| Fishes | `actinopterygii_group5` | Cassandra, Sophie, Ashleen, Ivona, Noah

>[!NOTE] Note:
We use the scientific (Latin) names of each class so that all names follow the same convention. And remember: **no spaces** in names!

<br>


---

### 1. Connect Tule to your github

Log in to tule as usual. Every change you save with `git` is signed with your name and email. **This is how GitHub knows who did what**, so do it carefully.

>[!TIP] **Syntax: `git config`**
>
>```bash
>git config --global user.name "Your Name"
>git config --global user.email "the_email_of_your_github_account@example.com"
>```
>
>- `--global` saves the setting for **all** your repositories on this account.
>- The email **must be the same one you used to create your GitHub account**. If it is different, GitHub will not link your work to your profile.
>- If you set your email as private on GitHub, use the "noreply" email that appears in GitHub → Settings → Emails.

**Code:**

```bash
git config --global user.name "Your Name"
git config --global user.email "your_github_email"

# Two extra settings that will make your life easier:
git config --global core.editor nano        # use nano (not vim) when git asks you to write a message
git config --global pull.rebase false       # when you pull, merge your teammates' changes with yours

# Check
git config --list
```

### 2. Connect tule to your GitHub account with an SSH key (everyone)

GitHub doesn't accept your password from the terminal. Instead, we create an **SSH key**: a pair of files that works like a lock and its key.

- **Private key** (`id_ed25519`): stays on tule. **Never** share it with anybody.
- **Public key** (`id_ed25519.pub`): you give it to GitHub.

>[!TIP] **Syntax: `ssh-keygen`**
>
>```bash
>ssh-keygen -t ed25519 -C "your_github_email"
>```
>
>- `-t ed25519` is the type of key (the one recommended by GitHub).
>- `-C` adds a comment (your email) to identify the key.


>[!IMPORTANT] PLEASE READ
>
>When you type the command below is going to ask you two questions, one the filename and location and then a passphrase. **Ignore the questions and  just press** `Enter` to accept the default location and skip the passphrase.

**Code:**

```bash
ssh-keygen -t ed25519 -C "your_github_email"

# Print your PUBLIC key (the one ending in .pub)
cat ~/.ssh/id_ed25519.pub
```

:point_right: Copy the whole line that starts with `ssh-ed25519`.

:point_right: On GitHub, go to your profile picture → **SSH and GPG keys** → **New SSH key**. Title: `tule`. Paste your key and click **Add SSH key**.

:point_right: Back on tule, test the connection:

```bash
ssh -T git@github.com
```

If it asks "Are you sure you want to continue connecting?", type `yes`. You should see:

```
Hi YOUR_USERNAME! You've successfully authenticated, but GitHub does not provide shell access.
```

That message means **it worked** :tada:


### 3. Create the team repository (only ONE member)

:point_right: Choose a **team rep**. Only this person does step 3.

:point_right: On your **GitHub web**, create a **New repository**:

- **Repository name**: your team name from the table above (e.g. `aves_group1`).
- **Private**.
- :white_check_mark: Check **Add a README file**.
- Click **Create repository**.

:point_right: Go to **Settings** → **Collaborators** → **Add people**, and add:

- Your teammates' GitHub usernames.
- My GitHub username: `moreno-santillan-lab`.

:point_right: Teammates: accept the invitation (you will get an email and a notification on GitHub).

### 4. Clone the repository to tule (everyone)

:point_right: Make sure you are inside Tule, then move with `cd` into your `btec_640` directory. <br>
:point_right: Create a new directory named `genomics_project` 


We are going to copy (Clone) our team repository to our Tule, for this we will use `git clone`

>[!IMPORTANT] Cloning a repository:
>Fromg [Git website](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository): Cloning a repository pulls down a full copy of all the repository data that GitHub.com has at that point in time, including all versions of every file and folder for the project. **You can push your changes to the remote repository on GitHub.com, or pull other people's changes from GitHub.com**

:point_right: **Everyone:** On the repository page, click the green **Code** button → **SSH** and copy the address. For the birds team it will look something like this: `git@github.com:TEAMREP_USERNAME/aves_group1.git`.

>[!TIP] **Syntax: `git clone`**
>
>```bash
>git clone git@github.com:OWNER/REPOSITORY.git
>```
>
>- `clone` downloads a **copy** of the repository to your current directory, together with its whole history.
>- Your copy stays **connected** to GitHub, so you can send (`push`) and receive (`pull`) changes.
>- Use the **SSH** address (starts with `git@`), not the HTTPS one, so `git` uses your SSH key.


**Code:**

```bash
cd genomics_project

#MODIFY THE REP_USERNAME/aves_group1.git accordingly
git clone git@github.com:REP_USERNAME/aves_group1.git

#aves_group1 will not necessarily be the name of the cloned directory
cd aves_group1/

ls -la
```

### 5. Organize the repository (only the team rep)

Our repository will have three directories:

| Directory | What goes inside |
| --- | --- |
| `scripts` | All the scripts (`.sh`) of the pipeline |
| `docs` | All the Markdown documents: notes, protocols, that you will generate |
| `results` | Tables and small results files (no sequences or fasta files, just specific files) |

**Problem: `git` does not save empty directories.** It only saves **files**. So we put a small `README.md` inside each directory explaining the content of each directory.

We will also create a `.gitignore` file: a list of files that `git` must **ignore**. GitHub does not accept files larger than 100 MB, and sequence files and genomes are much bigger. **Big data stays on tule, never on GitHub.**

:point_right: Choose **one person** (different person from the team rep) to do the following steps:

:point_right: Make sure you are **inside the cloned directory from github**

**Code:**

```bash

pwd #To make sure you are inside the cloned directory
mkdir -p scripts docs results

echo "# Scripts: all the scripts of the pipeline" > scripts/README.md

echo "# Docs: Markdown documents, notes and protocols" > docs/README.md

echo "# Results: tables and small results files" > results/README.md

nano .gitignore
```

Inside `.gitignore`, paste:

```
# Big data: stays on tule, NEVER on GitHub
input_data/
*.fna
*.faa
*.fa
*.fasta
*.zip
*.gz
```

Now save these changes to GitHub in the **comand line**. 

First let's see the syntax of the steps you will repeat **every time** you want to commit something to github:

>[!TIP] **Syntax: the `git` cycle**
>
>```bash
>#To see what changed:
>git status 
>#1. choose what you want to save (git add . = everything)                       
>git add FILE   
># 2. save a version, with a message               
>git commit -m "Comment with your changes"
># 3.push it to GitHub     
>git push 
>#4. receive your teammates' changes
>git pull   
>#5. Print history: who did what                       
>git log --oneline                  
>```
>
>- **`add`** is like putting things in a box. **`commit`** is closing and labeling the box (a version). **`push`** is mailing the box to GitHub.
>- A `commit` only saves the change **on tule**. Your teammates **don't** see anything until you `push`.
>- Your teammates **don't** get your changes automatically: they need to `pull`.

:point_right: After reading the sytanx of `git` the person that created the directories, is the one in charge to commit and push the changes to the github repository:


**Code:**
>[!IMPORTANT]:
> Since you will be using these commands frequently, save them in your personal notes.


```bash
git status
git add .
git commit -m "Create scripts, docs and results directories and .gitignore"
git push
```

:point_right: **EVERYONE** Refresh the repository page on GitHub. Can you see the directories?

:point_right: **EVERYONE** run `git pull` inside your `cloned` directory and check with `ls`.

### 6. Write the team README, one member at a time

The `README.md` is the front page of your project, we will write all the documents in your github with Markdown. Each member will add their own information, **one at a time**, and then we will see how GitHub keeps track of who wrote each line.

:point_right: **A THIRD MEMBER OF THE GROUP WILL DO THE FOLLOWING**: open `README.md` with `nano` and replace its content with this template.

>[!DANGER] Copy and modify this template with your group information.

```markdown
# Genome Project: Aves (Group 1)

Write the description of the repository

## Pipeline

1. Single-copy orthologs 
2. Protein Alignments
3. Selection analysis
4. BLAST validation of putative gene losses
5. Enrichment analysis

## Team

| Name | GitHub username | Pipeline step | My favorite species of our class, and why |
| --- | --- | --- | --- |
| Student 1 | username | 3. Alignments | Hummingbirds, because is an aztec God |

```
:point_right: After you modified the README.md file, `add`, `commit` and `push`.

:point_right: **Another member** (wait for the previous student "pushed!"):

```bash
git pull                                   # 1. ALWAYS get the latest version first
nano README.md                             # 2. add YOUR row to the Team table
git add README.md #3. Because you only modified one file
git commit -m "Add YOUR_NAME to the team table"  # 4. write your real name instead of YOUR_NAME
git push                                   # 5. send it
```

:point_right: Each member shoud add their own row and complete the `git` cycle When everyone is done, open your repository on GitHub and explore:

- Click on **commits** (the clock icon): who made each change, and when?
- Open `README.md` and click **Blame**: who wrote each line?
- Go to **Insights** → **Contributors**.

>❓ **Question**: Your professor can see all of this too. Why is this useful for a team project? 

```
Type your answer:




```

### 7. What happens if two people push at the same time?

In real life you won't always take turns. Let's break things on purpose, in a safe way, to learn how to fix them.

#### 7a. Two people, different lines

:point_right: Choose **two** members. At the **same time**, both run `git pull`, then:

- Student A adds a line at the **end** of `README.md`
- Member B adds an extra step in the **Pipeline** section: `6.Create our Markdown documents`

:point_right: Both `add` and `commit`. Then student A pushes first, and student B pushes second. Student B will get an error:

```
! [rejected]        main -> main (fetch first)
error: failed to push some refs
hint: Updates were rejected because the remote contains work that you do not have locally.
```

`git` is protecting student A's work. Student B needs to get it first:

```bash
git pull      # git merges both changes. If nano opens, just save and exit (Ctrl+O, Enter, Ctrl+X)
git push
```

Because they edited **different lines**, `git` merged both changes automatically.

#### 7b. Two people, the SAME line (a conflict)

:point_right: Two other students `git pull`, and both edit **the same line**: the title of `README.md`. Each writes a different title, then `add`, `commit`, and push one after the other.

The second person runs `git pull` and gets:

```
CONFLICT (content): Merge conflict in README.md
Automatic merge failed; fix conflicts and then commit the result.
```

**EVERYONE** Open `README.md`. on the GitHub web,`git` marked the conflict like this:

```
<<<<<<< HEAD
# Your title
=======
# Your teammate's title
>>>>>>> 3f2a1c9...
```

>[!TIP] **How to fix a conflict**
>
>1. Open the file with `nano`.
>2. Talk with your teammate and decide which version stays (or combine them).
>3. Delete the markers `<<<<<<<`, `=======` and `>>>>>>>`, and leave only the final text.
>4. Save, then:
>
>```bash
>git add README.md
>git commit -m "Solve README title conflict"
>git push
>```

### 8. Our team rules

**Don't** create `script_v1.sh`, `script_v2.sh`, `script_final.sh`, `script_final_FINAL.sh`... **`git` is your version control.** Every commit is a version, and you can always see or recover any old version with `git log`. Keep **one** file per script and let `git` remember its history.


### 9. Brest practices for group projects

1. **`git pull` before you start working.** Always!!!!
2. **Everyone** has to write the script for each step, just one person is going to run it, but **everyone must be involved in writing and debugging the scripts and the markdown documentations**.
3. When running the script, if something fails, the person who tested it needs to open an **Issue** in the GitHub website (tab "Issues" → "New issue"), which also stay signed with your name.
4. **Small and frequent commits with clear messages.** For example: `"Fix input path in 02_single_copy.sh"` is a good message.
5. **Push when you finish, and tell your team** (group chat or email communication: "pushed 03_alignment.sh").
6. **Never push big data** (sequences, genomes, OrthoFinder's whole output directory). Big files stay on tule. Push scripts, docs and small tables.
7. **Never delete or rename a teammate's file** without talking with them first.
