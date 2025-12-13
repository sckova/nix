#!/usr/bin/env bash

day=$(date +%-d)

case "$day" in
    11|12|13) suffix="th" ;;
    *1)       suffix="st" ;;
    *2)       suffix="nd" ;;
    *3)       suffix="rd" ;;
    *)        suffix="th" ;;
esac

date +"%a, %b $day$suffix %Y @ %I:%M%P"
