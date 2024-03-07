#!/bin/bash

current_time=$(date +%s)
interval=$((2 * 3600)) # 2 hours in sec

for i in {1..5}; do
    job_start=$((current_time + (i - 1) * interval))
    job_start_formatted=$(date -d @$job_start "+%Y-%m-%d %H:%M:%S")

    echo "Submitting job $i to start at $job_start_formatted"

    sbatch --begin=now+${job_start-current_time}seconds runtest.slurm

done
