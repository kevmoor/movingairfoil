#!/bin/bash

current_time=$(date +%s)
interval=$((2 * 3600)) # 2 hours in sec

current_time_formatted=$(date -d @$current_time "+%Y-%m-%dT%H:%M:%S")
echo "Current time: $current_time_formatted"

for i in {1..5}; do
    job_start=$((current_time + (i - 1) * interval+30))
    job_start_formatted=$(date -d @$job_start "+%Y-%m-%dT%H:%M:%S")

    echo "Submitting job $i to start at $job_start_formatted"

    sbatch --begin=${job_start_formatted} runtest.slurm

done
