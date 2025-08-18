#!/bin/bash
CACHE_DIR="$HOME/.cache"
CACHE_FILE="$CACHE_DIR/tmux-weather"
CACHE_TTL=$((15*60))  # 15 minutes in seconds

mkdir -p "$CACHE_DIR"

# If cache exists and is fresh, read it
if [ -f "$CACHE_FILE" ]; then
    now=$(date +%s)
    mtime=$(stat -c %Y "$CACHE_FILE")
    age=$((now - mtime))
    if [ $age -lt $CACHE_TTL ]; then
        cat "$CACHE_FILE"
        exit 0
    fi
fi

# Otherwise fetch new data
weather=$(wttrbar --location "Berlin" | jq -r '.text')

# Save to cache
echo "$weather" > "$CACHE_FILE"

# Print result
echo "$weather"
