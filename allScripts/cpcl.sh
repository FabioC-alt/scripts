#!/bin/bash

# Check if filename is provided
if [ -z "$1" ]; then
    echo "Usage: $0 filename"
    exit 1
fi

# Copy file content to clipboard using wl-copy
cat "$1" | wl-copy

