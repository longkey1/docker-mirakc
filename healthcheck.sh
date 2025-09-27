#!/bin/bash
FLAG_FILE="/tmp/healthcheck_succeeded"

# If already succeeded before, immediately return healthy
if [ -f "$FLAG_FILE" ]; then
  exit 0
fi

# Perform actual health check by testing API endpoint
if curl -fs http://127.0.0.1:40772/api/version > /dev/null; then
  touch "$FLAG_FILE"  # Record success
  exit 0
else
  exit 1
fi
