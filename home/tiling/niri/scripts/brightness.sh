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

# Determine which brightness control tool to use
if command -v ddcutil >/dev/null 2>&1; then
    # Get current brightness
    current=$(ddcutil getvcp 10 | grep -oP 'current value =\s+\K\d+')

    if [ -z "$current" ]; then
        echo "Error: failed to read current brightness from ddcutil" >&2
        exit 1
    fi

    # Calculate new brightness (ddcutil uses absolute 0-100 scale)
    new=$((current + value))

    # Clamp to valid range
    [ "$new" -lt 0 ] && new=0
    [ "$new" -gt 100 ] && new=100

    # Set new brightness
    ddcutil setvcp 10 "$new" >/dev/null 2>&1
else
    # Fallback to brightnessctl
    if [ "$value" -gt 0 ]; then
        brightnessctl s "+${value}%" >/dev/null
    elif [ "$value" -lt 0 ]; then
        brightnessctl s "${value#-}%-" >/dev/null
    fi
fi

# Notify Waybar to refresh
pkill -RTMIN+"$WAYBAR_SIGNAL" waybar
