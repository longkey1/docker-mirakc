#!/bin/bash
# pcscdをバックグラウンドで起動
if [ -x /usr/sbin/pcscd ]; then
    echo "Starting pcscd..."
    pcscd
    sleep 2

    # 起動確認
    if pgrep pcscd > /dev/null; then
        echo "pcscd is running"
    else
        echo "Warning: pcscd failed to start"
    fi
fi

# 元のmirakc entrypointを実行
exec /usr/local/bin/mirakc "$@"
