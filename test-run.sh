#!/bin/bash
#SBATCH --job-name=check-first
#SBATCH --account=researchers
#SBATCH --partition=scavenge
#SBATCH --gres=gpu:1
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
# uv run run.py \
#     --model_name llama-3.1-8b \
#     --dataset sarcasm \
#     --dataset_path data/sarc/sarcasm.csv \
#     --repetition 10 \
#     --round 1 \
#     --slurm_output "${SLURM_OUTPUT_FILE}" \
#     -limit 100

# uv run run.py \
#     --model_name gemma-3-4b \
#     --dataset sarcasm \
#     --dataset_path data/sarc/sarcasm.csv \
#     --repetition 10 \
#     --round 1 \
#     --slurm_output "${SLURM_OUTPUT_FILE}" \
#     -limit 100


# uv run -m src.make_second_round_input \
#     --dataset sarcasm \
#     --output_root /home/fril/InfluenceDynamicsMAS/results/input_round2 \
#     --input_dir /home/fril/InfluenceDynamicsMAS/results/first

# uv run -m src.make_second_round_input \
#     --dataset sarcasm \
#     --self_interaction \
#     --output_root /home/fril/InfluenceDynamicsMAS/results/input_round2 \
#     --input_dir /home/fril/InfluenceDynamicsMAS/results/first


uv run src/make_subsample.py \
    --suffix disagree \
    --cap 2 \ 
    --dataset sarcasm \
    --input_dir $HOME/InfluenceDynamicsMAS/results/input_round2 \
    --output_dir $HOME/InfluenceDynamicsMAS/results/input_round2_subsampled

# Or for self-interaction agreeing
uv run src/make_subsample.py \
    --glob_pattern *_self_interaction_agree.csv \
    --cap 2 \
    --dataset sarcasm \
    --input_dir $HOME/InfluenceDynamicsMAS/results/input_round2 \
    --output_dir $HOME/InfluenceDynamicsMAS/results/input_round2_subsampled


# uv run run.py \
#     --model_name llama-3.1-8b \
#     --dataset sarcasm \
#     --dataset_path $HOME/results/subsampled_input_round2/sarcasm/llama-3.1-8b_disagree.csv
#     --repetition 1 \  #1 repetition, since the opinion sets have 10 repetitions.
#     --round 2 \
#     --history \
#     --slurm_output "${SLURM_OUTPUT_FILE}"