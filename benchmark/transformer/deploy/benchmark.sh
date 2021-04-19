#!/bin/bash
model_dir=$1
log_path="output_pipeline"

for batch_size in "1" "2" "4"; do
    python3.6 python/inference.py \
        --config="../configs/transformer.base.yaml" \
        --model_dir=${model_dir} \
        --batch_size=${batch_size} \
        --profile > ${log_path}/transformer_base_cpu_nomkl_bs${batch_size}_inference.log 2>&1

    for threads in "1" "6"; do
        python3.6 python/inference.py \
            --config="../configs/transformer.base.yaml" \
            --model_dir=${model_dir} \
            --use_mkl \
            --threads=${threads} \
            --batch_size=${batch_size} \
            --profile > ${log_path}/transformer_base_cpu_mkl_threads${threads}_bs${batch_size}_inference.log 2>&1 
    done

    python3.6 python/inference.py \
        --config="../configs/transformer.base.yaml" \
        --model_dir=${model_dir} \
        --use_gpu \
        --batch_size=${batch_size} \
        --profile > tee ${log_path}/transformer_base_gpu_bs${batch_size}_inference.log 2>&1 
done