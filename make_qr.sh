#!/usr/bin/env bash
set -euo pipefail

# 一键生成二维码脚本
# 用法：
#   ./make_qr.sh [url]
# 不传url时默认： https://ericzhou_math.gitee.io/blood-test-dashboard/

URL_DEFAULT="https://ericzhou_math.gitee.io/blood-test-dashboard/"
URL_INPUT="${1:-$URL_DEFAULT}"

# 优先使用父目录的虚拟环境，否则在当前目录创建
if [ -f "../.venv/bin/activate" ]; then
  . ../.venv/bin/activate
else
  if [ ! -d ".venv" ]; then
    python3 -m venv .venv
  fi
  . .venv/bin/activate
fi

pip install --quiet "qrcode[pil]"
python generate_qr.py "$URL_INPUT"

echo "二维码已生成: $(pwd)/qrcode.png"