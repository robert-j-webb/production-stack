#!/bin/bash

if [[ $# -ne 3 ]]; then
    echo "Usage: $0 <model> <base url> <save file key>"
    exit 1
fi

MODEL=$1
BASE_URL=$2

# CONFIGURATION
NUM_USERS=15
NUM_ROUNDS=20

SYSTEM_PROMPT=1000 # Shared system prompt length
CHAT_HISTORY=8000 # User specific chat history length
ANSWER_LEN=100 # Generation length per round

run_benchmark() {
    # $1: qps
    # $2: output file
    python3 ./multi-round-qa.py \
        --num-users $NUM_USERS \
        --num-rounds $NUM_ROUNDS \
        --qps "$1" \
        --shared-system-prompt "$SYSTEM_PROMPT" \
        --user-history-prompt "$CHAT_HISTORY" \
        --answer-len $ANSWER_LEN \
        --model "$MODEL" \
        --base-url "$BASE_URL" \
        --output "$2" \
        --log-interval 30 \
        --time 100
}

KEY=$3

# Run benchmarks for different QPS values
for qps in 0.1 0.5 1.0 2.0 4.0 8.0 16.0; do
    output_file="${KEY}_output_${qps}.csv"
    run_benchmark "$qps" "$output_file"
done
