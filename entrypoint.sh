#!/bin/bash
set -e  # Exit immediately if any command fails

echo "Starting pcscd service..."
/etc/init.d/pcscd start

# Verify pcscd is running (optional)
sleep 1
if ! pgrep pcscd > /dev/null; then
    echo "Failed to start pcscd" >&2
    exit 1
fi

echo "Starting mirakc with args: $@"
exec /usr/local/bin/mirakc "$@"
