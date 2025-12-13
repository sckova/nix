#!/usr/bin/env bash

MAX=500

current=$(brightnessctl g)

# Guard against empty or non-numeric output
if ! [[ "$current" =~ ^[0-9]+$ ]]; then
    echo "brightnessctl returned invalid value" >&2
    exit 1
fi

percentage=$(( current * 100 / MAX ))

echo "bright ${percentage}%"

