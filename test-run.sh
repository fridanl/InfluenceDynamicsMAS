#!/bin/bash
#SBATCH --job-name=check-first
#SBATCH --account=researchers
#SBATCH --partition=scavenge
#SBATCH --gres=gpu:l40s:1
#SBATCH --cpus-per-task=4
#SBATCH --mem=80G
#SBATCH --time=05:00:00
#SBATCH --output=logs/%x.%j.out
#SBATCH --mail-type=BEGIN,END

echo "Host: $(hostname)"

set -euo pipefail

nvidia-smi

uv sync 

SLURM_OUTPUT_FILE="logs/${SLURM_JOB_NAME}.${SLURM_JOB_ID}.out"

# First run
# uv run run.py 
#     --model_name llama-3.1-8b \
#     --dataset sarcasm \
#     --dataset_path data/sarc/sarcasm.csv \
#     --repetition 10 \
#     --round 1 \
#     --slurm_output "${SLURM_OUTPUT_FILE}" \
#     -limit 100

# uv run run.py 
#     --model_name gemma-3-4b \
#     --dataset sarcasm \
#     --dataset_path data/sarc/sarcasm.csv \
#     --repetition 10 \
#     --round 1 \
#     --slurm_output "${SLURM_OUTPUT_FILE}" \
#     -limit 100


uv run -m src.make_second_round_input \
    --dataset sarcasm

uv run -m src.make_second_round_input \
    --dataset sarcasm \
    --self_interaction