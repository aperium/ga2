#!/bin/bash

#SBATCH --account=PAS1855
#SBATCH --time=20
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --ntasks=1

set -u -e -o pipefail
set -x

module load python/3.6-conda5.2
source activate cutadaptenv

# get arguments from commandline
RONE=$1
OUT=$2
FORWARD=$3
REVERSE=$4

F_REVC=$(echo "$FORWARD" | tr ATCGYRKMBVDH TAGCRYMKVBHD | rev)
R_REVC=$(echo "$REVERSE" | tr ATCGYRKMBVDH TAGCRYMKVBHD | rev)

RTWO=$(echo "$RONE" | tr _R1_ _R2_)

RONE_OUT=$("$OUT"/$(basename "$RONE" .fastq)_trimmed.fastq)
RTWO_OUT=$("$OUT"/$(basename "$RTWO" .fastq)_trimmed.fastq)

echo RONE_OUT: "$RONE_OUT"
echo RTWO_OUT: "$RTWO_OUT"

mkdir -p "$OUT"

cutadapt -a "$FORWARD"..."$R_REVC" -A "$REVERSE"..."$F_REVC" --discard-untrimmed --pair-filter=any -o "$RONE_OUT" -p "$RTWO_OUT" "$RONE" "$RTWO"

