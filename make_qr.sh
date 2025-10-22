#!/usr/bin/env bash
set -euo pipefail

VENV=".venv"
REQS="requirements.txt"

URL_DEFAULT="https://ericzhou-math.github.io/blood-test-dashboard/"
URL_INPUT=${1:-$URL_DEFAULT}

if [ ! -d "$VENV" ]; then
  python3 -m venv "$VENV"
fi

source "$VENV/bin/activate"

pip install -q --upgrade pip
pip install -q qrcode[pil]

python generate_qr.py --link "$URL_INPUT" --size 200 --output "qrcode.png" --base64

echo "二维码已生成：qrcode.png；Base64 已输出：qrcode_base64.txt"