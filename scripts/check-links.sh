#!/usr/bin/env bash
# check-links.sh — 相对 Markdown 链接可达性检查
#
# 本地与 CI 共用同一份逻辑。
#
# 用法：
#   ./scripts/check-links.sh            # 检查所有被 git 跟踪的 *.md
#   ./scripts/check-links.sh --selftest # 验证本脚本自身
#
# 退出码：0 = 无死链 / 2 = 有死链 / 3 = 前置条件不满足

set -uo pipefail

case "${1:-}" in
  --selftest)
    d=$(mktemp -d) || exit 3
    mkdir -p "$d/docs"
    printf '[ok](docs/a.md)\n[bad](docs/missing.md)\n[ext](https://example.com/x.md)\n' > "$d/README.md"
    printf '# a\n' > "$d/docs/a.md"
    ( cd "$d" && git init -q . && git add -A >/dev/null 2>&1 )
    # 自检会 cd 到临时目录，$0 的相对路径会失效，先固化为绝对路径
    SELF="$(cd "$(dirname "$0")" && pwd)/$(basename "$0")"
    rc=0
    ( cd "$d" && "$SELF" >/dev/null 2>&1 ) || rc=$?
    rm -rf "$d"
    if [ "$rc" = "2" ]; then echo "✅ check-links 自检通过（正确识别死链）"; exit 0; fi
    echo "❌ check-links 自检失败：期望 2 实得 $rc"; exit 3
    ;;
  -h|--help) sed -n '2,12p' "$0"; exit 0 ;;
  "") : ;;
  *) echo "未知参数: $1" >&2; exit 3 ;;
esac

cd "$(git rev-parse --show-toplevel 2>/dev/null)" || { echo "不在 git 仓库内" >&2; exit 3; }

python3 - <<'PY'
import os, re, subprocess, sys

try:
    out = subprocess.run(["git", "ls-files", "*.md"], capture_output=True, text=True, check=True).stdout
except subprocess.CalledProcessError as e:
    print("读取文件列表失败：%s" % e)
    sys.exit(3)

files = [f for f in out.split() if f]
bad = []

for f in files:
    try:
        text = open(f, encoding="utf-8").read()
    except (OSError, UnicodeDecodeError) as e:
        print("::error file=%s::无法读取：%s" % (f, e))
        bad.append((f, "<unreadable>"))
        continue
    base = os.path.dirname(f)
    # 只校验相对 .md 链接；带协议的跳过
    for m in re.finditer(r'\]\(([^)#]+\.md)(?:#[^)]*)?\)', text):
        t = m.group(1)
        if t.startswith(("http://", "https://", "mailto:")):
            continue
        p = os.path.normpath(os.path.join(base, t))
        if not os.path.exists(p):
            bad.append((f, t))

for f, t in bad:
    print("::error file=%s::死链 %s" % (f, t))

print("检查 %d 个 Markdown 文件，死链 %d 处" % (len(files), len(bad)))
sys.exit(2 if bad else 0)
PY
