#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
批量将仓库中的 raw.githubusercontent.com / rawcdn.githack.com / raw.githack.com 链接迁移为 jsDelivr 格式：
  https://cdn.jsdelivr.net/gh/<user>/<repo>@<branch>/<path>
并自动追加缓存破坏参数（?v=20251022 或 &v=20251022）。

用法：
  python migrate_to_jsdelivr.py

说明：
- 遍历当前目录（blood-test-dashboard）下所有文本文件，尝试替换出现的原始链接。
- 针对 .html/.css/.js/.md/.sh/.py 等常见文本文件；若遇到其他文本文件也会处理。
- 不修改二进制图片文件内容（.png/.jpg/.jpeg/.gif等）。
"""
import os
import re

CACHE_BUSTER = "v=20251022"
TEXT_EXTS = {".html", ".css", ".js", ".md", ".sh", ".py"}
BINARY_EXTS = {".png", ".jpg", ".jpeg", ".gif", ".webp", ".svg"}

pat_rawgh = re.compile(r"https://raw\.githubusercontent\.com/([^/]+)/([^/]+)/([^/]+)/(.+)")
pat_githack = re.compile(r"https://raw(?:cdn\.)?githack\.com/([^/]+)/([^/]+)/([^/]+)/(.+)")


def to_jsdelivr(user: str, repo: str, branch: str, path: str) -> str:
    url = f"https://cdn.jsdelivr.net/gh/{user}/{repo}@{branch}/{path}"
    # 追加防缓存参数
    return url + ("&" + CACHE_BUSTER if "?" in url else "?" + CACHE_BUSTER)


def rewrite_text(text: str) -> str:
    def _rawgh(m):
        return to_jsdelivr(m.group(1), m.group(2), m.group(3), m.group(4))

    def _githack(m):
        return to_jsdelivr(m.group(1), m.group(2), m.group(3), m.group(4))

    text = pat_rawgh.sub(_rawgh, text)
    text = pat_githack.sub(_githack, text)
    return text


def is_probably_text(ext: str) -> bool:
    if ext.lower() in BINARY_EXTS:
        return False
    return True


def main():
    root = os.path.dirname(os.path.abspath(__file__))
    changed = 0
    for dirpath, _, filenames in os.walk(root):
        for fn in filenames:
            ext = os.path.splitext(fn)[1].lower()
            if not is_probably_text(ext):
                continue
            # 仅处理常见文本文件，若需扩展可加入更多后缀
            if ext and ext not in TEXT_EXTS:
                continue
            p = os.path.join(dirpath, fn)
            try:
                with open(p, "r", encoding="utf-8", errors="ignore") as f:
                    t = f.read()
                nt = rewrite_text(t)
                if nt != t:
                    with open(p, "w", encoding="utf-8") as f:
                        f.write(nt)
                    changed += 1
                    print(f"[rewrite] {p}")
            except Exception as e:
                print(f"[skip] {p}: {e}")
    print(f"done. files changed: {changed}")


if __name__ == "__main__":
    main()