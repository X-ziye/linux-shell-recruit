#!/usr/bin/env bash

# Task 07: complete this script.
# Usage: ./scripts/analyze.sh FILE

# TODO: validate arguments
# TODO: validate file existence
# TODO: print:
# Total ERROR: <number>
# Top Code: <code>

if [[ $# -eq 0 ]]; then
    echo "Usage: $0 FILE" >&2
    exit 1
fi

FILE="$1"

if [[ ! -f "$FILE" ]]; then
    echo "Error: File $FILE does not exist" >&2
    exit 1
fi

TOTAL_ERR=$(grep "ERROR" "$FILE" | wc -l)
# 匹配 code=数字，提取数字
TOP_CODE=$(grep "ERROR" "$FILE" | grep -oE 'code=[0-9]+' | grep -oE '[0-9]+' | sort | uniq -c | sort -nr | head -n1 | awk '{print $2}')

if [[ -z "$TOP_CODE" ]]; then
    TOP_CODE=0
fi

echo "Total ERROR: $TOTAL_ERR"
echo "Top Code: $TOP_CODE"