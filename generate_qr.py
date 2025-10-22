#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
生成指定链接的二维码图片（默认指向 jsDelivr 入口），支持：
- 指定尺寸（默认 200x200）
- 输出 PNG 文件
- 额外输出 Base64 文本，便于直接嵌入 README 或 HTML

用法：
  python generate_qr.py --link "https://cdn.jsdelivr.net/gh/EricZhou-math/blood-test-dashboard@main/index.html" \
                        --size 200 --output qrcode.png --base64

兼容旧用法：
  python generate_qr.py "<URL>"
若不提供参数，默认生成 jsDelivr 主链接二维码。
"""
import argparse
import base64
import io
import sys

import qrcode

DEFAULT_LINK = "https://cdn.jsdelivr.net/gh/EricZhou-math/blood-test-dashboard@main/index.html?v=20251022"


def make_qr(link: str, size: int = 200):
    qr = qrcode.QRCode(
        version=None,
        error_correction=qrcode.constants.ERROR_CORRECT_M,
        box_size=2,
        border=2,
    )
    qr.add_data(link)
    qr.make(fit=True)
    img = qr.make_image(fill_color="black", back_color="white")
    # 统一调整到 size x size
    try:
        from PIL import Image
        img = img.convert("RGB")
        img = img.resize((size, size), resample=Image.LANCZOS)
    except Exception:
        # 若 PIL 不可用，保持原尺寸
        pass
    return img


def img_to_base64_png(img) -> str:
    buf = io.BytesIO()
    img.save(buf, format="PNG")
    b64 = base64.b64encode(buf.getvalue()).decode("ascii")
    return "data:image/png;base64," + b64


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("positional_link", nargs="?", help="兼容旧用法的URL位置参数")
    parser.add_argument("--link", dest="link", help="要生成二维码的链接")
    parser.add_argument("--size", type=int, default=200, help="二维码尺寸，默认200")
    parser.add_argument("--output", default="qrcode.png", help="输出PNG文件名")
    parser.add_argument("--base64", action="store_true", help="同时输出Base64到 qrcode_base64.txt")

    args = parser.parse_args()
    link = args.link or args.positional_link or DEFAULT_LINK

    img = make_qr(link, size=args.size)
    img.save(args.output, format="PNG")
    print(f"[ok] QR saved => {args.output}")

    if args.base64:
        b64 = img_to_base64_png(img)
        with open("qrcode_base64.txt", "w", encoding="utf-8") as f:
            f.write(b64)
        print("[ok] Base64 saved => qrcode_base64.txt")

if __name__ == "__main__":
    sys.exit(main())