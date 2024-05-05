#!/bin/bash
for ((i=1; i<=49; i++)); do
    h=$(head -c 16 /dev/urandom | md5sum)
    echo "$h" | tr -d "  -"
done