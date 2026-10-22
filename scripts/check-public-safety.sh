#!/usr/bin/env bash
# check-public-safety.sh — 公开仓库红线检查
#
# 本仓库是 PUBLIC。任何内容在合并前必须通过这道检查：
#   陌生人看到它，不应看到任何内部项目名、真实路径、凭据、个人数据。
#
# 同一份脚本被两处调用，保证「本地能过 = CI 能过」：
#   1. 本地：dsh-config/bin/install-hooks 安装的 pre-commit hook
#   2. CI：.github/workflows/public-safety.yml
#
# 用法：
#   ./scripts/check-public-safety.sh                 # 检查工作树全部跟踪文件
#   ./scripts/check-public-safety.sh --staged        # 只检查暂存区（pre-commit 用）
#   ./scripts/check-public-safety.sh --base <rev>    # 只检查相对于 <rev> 的改动（CI 用）
#   ./scripts/check-public-safety.sh --selftest      # 验证本脚本自身有效
#
# 退出码：0 = 干净 / 2 = 命中红线 / 3 = 前置条件不满足（fail-closed）

set -uo pipefail

MODE="worktree"
BASE=""
SELFTEST=0

while [ $# -gt 0 ]; do
  case "$1" in
    --staged) MODE="staged"; shift ;;
    --base) if [ $# -lt 2 ]; then echo "--base 需要一个 revision" >&2; exit 3; fi; BASE="$2"; MODE="range"; shift 2 ;;
    --selftest) SELFTEST=1; shift ;;
    -h|--help) sed -n '2,20p' "$0"; exit 0 ;;
    *) echo "未知参数: $1" >&2; exit 3 ;;
  esac
done

# ---------- 红线规则 ----------
# 每条：<说明>|<扩展名正则>|<grep -E 正则>
# 只扫文本文件；二进制与图片跳过。
readonly RULES=(
  "内部项目名###PulseKit|a_share_tool|fic-football|dsh-video-tools|dsh-config|personal-workspace"
  "内部团队目录###\\.dsh-team"
  "真实用户路径###/Users/[A-Za-z0-9._-]+|/home/[A-Za-z0-9._-]+|C:\\\\Users\\\\"
  "个人数据根###PersonalData"
  "GitHub 账号名###github\\.com[:/]wilerium|wiler\\.he@"
  "疑似凭据###gh[pousr]_[A-Za-z0-9]{20,}|sk-[A-Za-z0-9]{20,}|AKIA[0-9A-Z]{16}|-----BEGIN [A-Z ]*PRIVATE KEY-----"
)

# 允许例外：本脚本自身必然包含红线词（它要拿这些词去搜），需显式白名单。
readonly ALLOWLIST=(
  "scripts/check-public-safety.sh"
)

is_allowlisted() {
  local f="$1"
  for a in "${ALLOWLIST[@]}"; do
    [ "$f" = "$a" ] && return 0
  done
  return 1
}

# ---------- 自检 ----------
if [ "$SELFTEST" = "1" ]; then
  d=$(mktemp -d) || exit 3
  ok=0; bad=0

  mkdir -p "$d/clean" "$d/dirty"
  printf '# 干净的文档\n\n这是一条规则。\n' > "$d/clean/a.md"
  printf '# 泄漏\n\n参考 PulseKit 的实现。\n' > "$d/dirty/a.md"
  printf '# 路径\n\n见 /Users/someone/code/x\n' > "$d/dirty/b.md"
  printf 'PRIVATE KEY\n-----BEGIN RSA PRIVATE KEY-----\n' > "$d/dirty/c.md"
  printf '# 账号\n\nhttps://github.com/wilerium/x\n' > "$d/dirty/e.md"
  printf 'email: someone@example.com\n' > "$d/clean/b.md"

  # 用只含自身脚本的独立 repo 验证，避免与本仓库耦合
  # 自检会 cd 到临时目录，$0 的相对路径会失效，必须先固化为绝对路径
  SELF=$(cd "$(dirname "$0")" && pwd)/$(basename "$0")

  probe() { # dir expected desc
    ( cd "$1" && git init -q . 2>/dev/null; git add -A 2>/dev/null
      "$SELF" --staged >/dev/null 2>&1 ) ; local rc=$?
    if [ "$rc" = "$2" ]; then ok=$((ok+1)); else echo "  ✗ $3: 期望 $2 实得 $rc"; bad=$((bad+1)); fi
  }
  # 干净样例需不含 allowlist 文件名
  probe "$d/clean" 0 "干净样例应通过"
  probe "$d/dirty" 2 "含红线样例应拦下"

  rm -rf "$d" 2>/dev/null
  if [ "$bad" = "0" ]; then echo "✅ check-public-safety 自检通过（$ok 项）"; exit 0; fi
  echo "❌ check-public-safety 自检失败：$bad 项"; exit 3
fi

# ---------- 收集待检查文件 ----------
FILES=""
case "$MODE" in
  worktree)
    FILES=$(git ls-files 2>/dev/null) || { echo "不是 git 仓库" >&2; exit 3; }
    ;;
  staged)
    FILES=$(git diff --cached --name-only --diff-filter=ACMR 2>/dev/null) || { echo "读取暂存区失败" >&2; exit 3; }
    ;;
  range)
    [ -n "$BASE" ] || { echo "--base 为空" >&2; exit 3; }
    FILES=$(git diff --name-only --diff-filter=ACMR "$BASE"...HEAD 2>/dev/null) \
      || { echo "无法比对 $BASE...HEAD" >&2; exit 3; }
    ;;
esac

if [ -z "$FILES" ]; then
  echo "✅ 公开仓库红线检查：无待检查文件"
  exit 0
fi

# 只扫文本文件（二进制/图片无意义，且 grep 会误报）
TEXTRE='\.(md|markdown|yml|yaml|json|jsonc|txt|sh|bash|zsh|py|js|mjs|cjs|ts|tsx|jsx|toml|cfg|ini|conf|html|css|xml|csv)$'
FILES=$(printf '%s\n' "$FILES" | grep -E "$TEXTRE" || true)

# ---------- 逐条规则扫描 ----------
VIOLATIONS=""
COUNT=0

while IFS= read -r f; do
  [ -n "$f" ] || continue
  [ -f "$f" ] || continue
  is_allowlisted "$f" && continue

  for rule in "${RULES[@]}"; do
    desc="${rule%%###*}"
    pattern="${rule#*###}"

    # -I 跳过二进制；-n 行号
    hits=$(grep -InE "$pattern" "$f" 2>/dev/null | cut -d: -f1 | sort -un | tr '\n' ' ')
    if [ -n "$hits" ]; then
      VIOLATIONS="${VIOLATIONS}  ✗ ${desc}: ${f} (行 ${hits% })\n"
      COUNT=$((COUNT + 1))
    fi
  done
done <<< "$FILES"

if [ "$COUNT" -gt 0 ]; then
  echo "── 公开仓库红线检查 ─────────────────────────────"
  echo
  echo "本仓库是 PUBLIC。以下内容不得进入："
  printf '%b' "$VIOLATIONS"
  echo
  echo "→ 结论：命中 $COUNT 处红线，禁止合并。"
  echo "  内部项目信息请迁移到对应的私人仓库；确属误报时在脚本 ALLOWLIST 里显式登记（需 PR 说明理由）。"
  exit 2
fi

echo "✅ 公开仓库红线检查通过（扫描 $(printf '%s\n' "$FILES" | grep -c . ) 个文件，零命中）"
exit 0
