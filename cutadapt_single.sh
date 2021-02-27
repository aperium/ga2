#!/bin/bash

#SBATCH --account=PAS18655
#SBATCH --time=20
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1

set -u -e -o pipefail

module load python/3.6-conda5.2
source activate cutadaptenv

# get arguments from commandline
IN=$1
OUT=$2
FORWARD=$3
REVERSE=$4


