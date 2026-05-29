#!/usr/bin/env python3
"""Smoke-check cho bộ rule/agent của **Làm Mướn Team**.

Kiểm tra:
1. Frontmatter: mỗi file .md (agents) / .mdc (rules) phải có block `---ânn---` ở đầu.
2. Code fence cân bằng: hỗ trợ fence 4 backtick bọc fence 3 backtick (kiểu Cursor template).
3. Reference: mọi token `lammuon-xxx` được nhắc tới phải tồn tại dưới dạng file agent/rule.

Exit code 0 nếu pass, 1 nếu có lỗi.
"""
from __future__ import annotations

import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
AGENTS_DIR = ROOT / ".cursor" / "agents"
RULES_DIR = ROOT / ".cursor" / "rules"

FENCE_RE = re.compile(r"^(`{3,})(.*)$")
REF_RE = re.compile(r"lammuon-[a-z0-9-]+")
VERSION_RE = re.compile(r"^\d+\.\d+\.\d+\s*$")


def known_rule_names() -> set[str]:
    names: set[str] = set()
    for d in (AGENTS_DIR, RULES_DIR):
        if d.is_dir():
            for f in d.iterdir():
                if f.suffix in (".md", ".mdc"):
                    names.add(f.stem)
    return names


def check_frontmatter(lines: list[str]) -> list[str]:
    errors: list[str] = []
    if not lines or lines[0].strip() != "---":
        errors.append("thiếu frontmatter mở đầu (--- ở dòng 1)")
        return errors
    if "---" not in [l.strip() for l in lines[1:]]:
        errors.append("frontmatter không có dòng --- đóng")
    return errors


def check_fences(lines: list[str]) -> list[str]:
    """Một fence đang mở (độ dài L) chỉ đóng bởi dòng chỉ gồm >= L backtick."""
    errors: list[str] = []
    open_len: int | None = None
    open_line = 0
    for i, line in enumerate(lines, start=1):
        m = FENCE_RE.match(line.rstrip())
        if not m:
            continue
        ticks = len(m.group(1))
        rest = m.group(2).strip()
        if open_len is None:
            open_len = ticks
            open_line = i
        else:
            # đang mở: chỉ đóng khi dòng toàn backtick và >= độ dài mở
            if rest == "" and ticks >= open_len:
                open_len = None
    if open_len is not None:
        errors.append(f"code fence mở ở dòng {open_line} không được đóng")
    return errors


def check_refs(stem: str, text: str, known: set[str]) -> list[str]:
    errors: list[str] = []
    missing = set()
    for token in REF_RE.findall(text):
        if token == stem:
            continue
        if token not in known:
            missing.add(token)
    for token in sorted(missing):
        errors.append(f"reference `{token}` không tồn tại (không có file agent/rule tương ứng)")
    return errors


def check_version() -> list[str]:
    version_file = ROOT / "VERSION"
    if not version_file.is_file():
        return ["thiếu file VERSION ở root"]
    text = version_file.read_text(encoding="utf-8").strip()
    if not VERSION_RE.fullmatch(text):
        return [f"VERSION không đúng semver (ví dụ 0.2.0): {text!r}"]
    return []


def main() -> int:
    known = known_rule_names()
    files = sorted(AGENTS_DIR.glob("*.md")) + sorted(RULES_DIR.glob("*.mdc"))
    if not files:
        print("Không tìm thấy file agent/rule nào.")
        return 1

    total_errors = 0
    ver_errors = check_version()
    if ver_errors:
        total_errors += len(ver_errors)
        print("❌ VERSION")
        for e in ver_errors:
            print(f"   - {e}")
    else:
        ver = (ROOT / "VERSION").read_text(encoding="utf-8").strip()
        print(f"✅ VERSION ({ver})")

    for f in files:
        text = f.read_text(encoding="utf-8")
        lines = text.splitlines()
        errors = (
            check_frontmatter(lines)
            + check_fences(lines)
            + check_refs(f.stem, text, known)
        )
        rel = f.relative_to(ROOT)
        if errors:
            total_errors += len(errors)
            print(f"❌ {rel}")
            for e in errors:
                print(f"   - {e}")
        else:
            print(f"✅ {rel}")

    print()
    if total_errors:
        print(f"FAIL: {total_errors} lỗi.")
        return 1
    print("PASS: tất cả file hợp lệ.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
