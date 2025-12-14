#!/usr/bin/env bash

WAYBAR_SIGNAL=8   # SIGRTMIN+8

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <integer -100..100>" >&2
    exit 1
fi

value="$1"

# Validate integer range
if ! [[ "$value" =~ ^-?[0-9]+$ ]] || [ "$value" -lt -100 ] || [ "$value" -gt 100 ]; then
    echo "Error: argument must be an integer between -100 and 100" >&2
    exit 1
fi

# Apply brightness change with correct syntax
if [ "$value" -gt 0 ]; then
    brightnessctl s "+${value}%" >/dev/null
elif [ "$value" -lt 0 ]; then
    brightnessctl s "${value#-}%-" >/dev/null
else
    : # no-op for 0
fi

# Notify Waybar to refresh
pkill -RTMIN+"$WAYBAR_SIGNAL" waybar

