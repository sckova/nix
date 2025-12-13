#!/usr/bin/env bash

last=""

while :; do
  current=$(
    niri msg focused-window | awk -F'"' '
      /App ID:/ { app = $2 }
      /Title:/  { title = $2 }
      END {
        if (app && title) {
          print app " - " title
        }
      }
    '
  )

  if [[ -n "$current" && "$current" != "$last" ]]; then
    printf '%s\n' "$current"
    last="$current"
  fi

  sleep 0.01
done

