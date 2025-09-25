#!/bin/bash

echo "Executing: /etc/init.d/pcscd start"
/etc/init.d/pcscd start

echo "Starting mirakc with args: $@"
exec /usr/local/bin/mirakc "$@"
