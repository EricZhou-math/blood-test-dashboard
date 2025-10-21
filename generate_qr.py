#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
生成血常规仪表盘的二维码PNG。
用法：
    python generate_qr.py [url]
不传url时默认： https://ericzhou_math.gitee.io/blood-test-dashboard/
输出：在当前目录生成 qrcode.png
"""
import sys
import qrcode

DEFAULT_URL = "https://ericzhou_math.gitee.io/blood-test-dashboard/"


def main():
    url = sys.argv[1] if len(sys.argv) > 1 else DEFAULT_URL
    qr = qrcode.QRCode(
        version=None,  # 自动选择版本
        error_correction=qrcode.constants.ERROR_CORRECT_M,
        box_size=10,
        border=2,
    )
    qr.add_data(url)
    qr.make(fit=True)
    img = qr.make_image(fill_color="black", back_color="white")
    out = "qrcode.png"
    img.save(out)
    print(f"已生成二维码: {out}\n链接: {url}")


if __name__ == "__main__":
    main()