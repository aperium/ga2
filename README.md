# README for Graded Assignment 2

My OSC working directory for this project is `/fs/ess/PAS1855/users/$USER/week06/ga2`

Instructions copied from assignment ([source](https://mcic-osu.github.io/pracs-sp21/w06_GA_scripts.html))

> ## Introduction
> 
> This assignment will work with 6 FASTQ files with sequences from the V4 region of 16S rRNA, generated in a metabarcoding experiment.
> 
> The FASTQ files come in pairs: for every sample, there is a FASTQ file with forward reads (or “read 1” reads) that contains `_R1_` in its file name, and a FASTQ file with corresponding reverse reads (or “read 2” reads) that contains `_R2_` in its file name. So, our 6 FASTQ files consist of 3 pairs of `R1`-`R2` files for 3 biological samples.
> 
> The sequences were generated by first amplifying environmental samples with a pair of universal 16S primers, and these primer sequences are expected to be present in the FASTQ sequences. **You will remove these primer sequences with the program Cutadapt**, and there are two things to be aware of:
> - A primer can also be present in the FASTQ sequence as its reverse complement, so we will search for reverse complements too.
> - The primers contain a few variable sites for which ambiguity codes are used. For instance, an R means that the site can be either an A or a G, and an N means that the site can be any of the four bases. See [here](https://droog.gs.washington.edu/parc/images/iupac.html) for a complete overview of these ambiguity codes.
> 
> These are the primer sequences :
> - Forward primer (“515F”): `GAGTGYCAGCMGCCGCGGTAA`.
> - Reverse primer (“806R”): `ACGGACTACNVGGGTWTCTAAT`.
> 
> ## General instructions
> - For each numbered step below, you should create at least one Git commit.
> - All files should be added to your repository, unless mentioned otherwise.

## Steps

### Getting set up

- [X] Create a new directory for this assignment, and inside it, initialize a Git repository. Add a very brief `README.md` describing that this is a repository for such-and-such assignment. (You can also use this README to further document your workflow, but you don’t have to.) [0.5]
- [X] Copy the FASTQ files from `/fs/ess/PAS1855/data/week05/fastq` into a directory `data/fastq/` inside your assignment’s directory. [0.5]
- [X] Create a `.gitignore` file and add a line to make Git ignore all `.fastq` files. [0.5]
- [X] Load the Conda module at OSC and create a Conda environment for Cutadapt following [these](https://cutadapt.readthedocs.io/en/stable/installation.html#installation-with-conda) instructions (i.e. just the section “Installation with Conda”). [1]
  - hint availible at source.
  - [X] `module load python/3.6-conda5.2`
  - [X] install new environment with `conda create -n cutadaptenv cutadapt`
  - [X] activate new environment with `source activate cutadaptenv`
  - [X] check with `cutadapt --version`
- [X] Export the environment description for your Cutadapt environment to a YAML (`.yml`) file. [0.5]
  - [X] export with `conda env export > cutadaptenv.yml`

### Cutadapt script for one sample

- [X] Now, you will write a script called `cutadapt_single.sh` that runs Cutadapt for one pair of FASTQ files: a file with forward (`R1`) reads and a file with reverse (`R2`) reads for the same sample.
  - The following instructions all refer to what you should write **inside the script**:
- [X] Start with the shebang line followed by SLURM directives. Specify at least the following SLURM directives [0.5]
  - [X] The class’s OSC project number, `PAS1855`.
  - [X] A 20-minute wall-time limit.
  - [X] Explicitly ask for one node, one process (task), and one core (these are three separate directives).
- [X] Next, include the familiar set settings for robust bash scripts, load OSC’s Conda module and then activate your own Cutadapt Conda environment. [0.5]
  - hint availible at source.
- [X] Let the script take 4 arguments that can be passed to it on the command-line: [1]
  1. The path to a FASTQ file with forward reads (whose value, when passed to the script from the shell will e.g. be `data/fastq/201-S4-V4-V5_S53_L001_R1_001.fastq`).
  2. The name of the output directory for trimmed FASTQ files (whose value, when passed to the script from the shell will be whatever you pick, e.g. `results/trim`).
  3. The sequence of the forward primer (whose value when passed to the script from the shell, will be `GAGTGYCAGCMGCCGCGGTAA` in this case).
  4. The sequence of the reverse primer (whose value when passed to the script from the shell, will be `TTACCGCGGCKGCTGRCACTC` in this case).
  - Give each of these variables a descriptive name rather than directly using the placeholder variables (`$1`, etc) – that will make your life easier when writing the rest of the script.
- [X] Compute the reverse complement for each primer. The hint below in fact has the answer, but please take a moment to think how you might do this with `tr` and a new command called `rev` that simply reverses a string.
  - hint availible at source.
- [X] From the file name of the input FASTQ file with forward reads (which is one of the arguments to the script), infer the name of the corresponding FASTQ file with reverse reads, which will have an identical name except that `_R1_` is replaced by `_R2_`. [0.5]
- [X] Assign output file paths (output dir + file name) for the `R1` and `R2` output file, inserting `_trimmed` before the `.fastq` file extension (that is, the output file paths should be along the lines of `<output-dir>/<old-file-basename>_trimmed.fastq`). [1]
- [X] Create the output directory if it doesn’t already exist. [0.5]
- [X] The actual call to the Cutadapt program should be as follows – just change any variable names as needed:
  > ```
  > cutadapt -a "$primer_f"..."$primer_r_revcomp" \
  >     -A "$primer_r"..."$primer_f_revcomp" \
  >     --discard-untrimmed --pair-filter=any \
  >     -o "$R1_out" -p "$R2_out" "$R1_in" "$R2_in"
  > ```
  - [ ] *Optional (ungraded): Touch up the scripts with additional echo statements, date commands, and tests such as whether 4 arguments were provided.*

### Running the script and finishing up

- [X] Submit the script as a SLURM job for one pair of FASTQ files – don’t forget to provide it with the appropriate arguments. Check the SLURM log file and the output files. If it didn’t work, troubleshoot until you get it working. [2]
  - [X] `sbatch cutadapt_single.sh /fs/ess/PAS1855/users/$USER/week06/ga2/data/fastq/201-S4-V4-V5_S53_L001_R1_001.fastq /fs/ess/PAS1855/users/$USER/week06/ga2/data/trimmed GAGTGYCAGCMGCCGCGGTAA TTACCGCGGCKGCTGRCACTC` 
  - [X] debug as needed.
- [X] Do any necessary cleaning up of files, e.g. move your SLURM log file to an appropriate place, and make sure everything is committed to the Git repository. (I’ll need to see the SLURM log file in your repository to see if the script worked.) [0.5]
- [X] Create a GitHub repository and push your local Git repository to GitHub. Like last time, start an issue and in the issue, tag @jelmerp. [0.5]

### *Optional (ungraded) - Loop over all samples*

*Creating a script like we did above is worth the trouble mostly if we plan to run it for multiple/many samples. Now, you will create a second script `cutadapt_submit.sh` that loops over all FASTQ files in a specified directory. It doesn’t need to be a “proper” script with a robust header and so on, and shouldn’t contain any SLURM directives: this script merely functions to submit SLURM jobs and can be run interactively.*

- [ ] Loop over a globbing pattern that accepts all `.fastq` files with `R1` in the name in the input directory (recall: we don’t want to loop over the `R2` files explicitly, because they will be automatically included in our previous script).
- [ ] Inside the loop, the `cutadapt_single.sh` script should be submitted as a SLURM job, similar to your single submission of the script above.
- [ ] Run the loop.
- [ ] Check the SLURM log files and the output directory. If it didn’t work, remove all these files, troubleshoot, and try again until it is working.

---

