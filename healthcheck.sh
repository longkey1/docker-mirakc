#!/bin/bash

FLAG_FILE="/tmp/healthcheck_succeeded"

# もしすでに成功済みなら即 healthy 扱い
if [ -f "$FLAG_FILE" ]; then
  exit 0
fi

# 通常のチェック（curlで依存サービス確認）
if curl -fs http://127.0.0.1:40772/api/version > /dev/null; then
  touch "$FLAG_FILE"  # 成功記録
  exit 0
else
  exit 1
fi
