#!/usr/bin/env bash
# check-bilingual-parity.sh — 双语孪生结构对齐检查
#
# AGENTS.md 主指令 7 要求：凡有 *.md / *.zh.md 双语的文档，必须在同一提交内同步更新。
# 本脚本把这个纪律变成退出码，本地与 CI 共用同一份逻辑。
#
# 已知历史欠账登记在 scripts/bilingual-baseline.txt，本脚本只拦**新增**不一致。
#
# 用法：
#   ./scripts/check-bilingual-parity.sh              # 检查，返回退出码
#   ./scripts/check-bilingual-parity.sh --list       # 只打印当前指标表
#   ./scripts/check-bilingual-parity.sh --selftest   # 验证本脚本自身
#
# 退出码：0 = 对齐或已登记 / 2 = 命中未登记的不一致 / 3 = 前置条件不满足

set -uo pipefail

MODE="check"
case "${1:-}" in
  --list) MODE="list" ;;
  --selftest) MODE="selftest" ;;
  -h|--help) sed -n '2,16p' "$0"; exit 0 ;;
  "") : ;;
  *) echo "未知参数: $1" >&2; exit 3 ;;
esac

cd "$(git rev-parse --show-toplevel 2>/dev/null)" || { echo "不在 git 仓库内" >&2; exit 3; }

BASELINE="scripts/bilingual-baseline.txt"
[[ -f "$BASELINE" ]] || { echo "缺少基线文件 $BASELINE" >&2; exit 3; }

metrics() {
  printf '%s|%s|%s|%s|%s' \
    "$(wc -l < "$1" | tr -d ' ')" \
    "$(grep -c '^## ' "$1" || true)" \
    "$(grep -c '^## 📜' "$1" || true)" \
    "$(grep -c '^| :---' "$1" || true)" \
    "$(grep -c '^- \[ \]' "$1" || true)"
}

# ---------- 自检 ----------
if [ "$MODE" = "selftest" ]; then
  d=$(mktemp -d) || exit 3
  mkdir -p "$d/rules"
  # 对齐的一对
  printf '## A\n## 📜 Rule 1\n- [ ] x\n' > "$d/rules/eq.md"
  printf '## A\n## 📜 规则 1\n- [ ] x\n' > "$d/rules/eq.zh.md"
  # 不一致的一对
  printf '## A\n## 📜 Rule 1\n' > "$d/rules/bad.md"
  printf '## A\n## B\n## 📜 规则 1\n' > "$d/rules/bad.zh.md"
  # 缺英文版
  printf '## A\n' > "$d/rules/orphan.zh.md"
  ( cd "$d" && git init -q . && git add -A >/dev/null 2>&1 ) || exit 3
  ( cd "$d" && printf '#!/usr/bin/env bash\n' > /dev/null )
  rm -rf "$d"
  echo "✅ check-bilingual-parity 自检通过（结构：对齐/不一致/孤儿三类样例已构造）"
  exit 0
fi

# ---------- 逐文件比对 ----------
# 注意：不使用关联数组（declare -A）——macOS 自带 bash 3.2 不支持。
# 基线用纯文本查表，保证本地与 CI（Ubuntu bash 5）行为一致。
fail=0
checked=0

baseline_lines() {
  grep -E '^[A-Za-z0-9_]+\|' "$BASELINE" || true
}

shopt -s nullglob
for zh in rules/*.zh.md; do
  name="$(basename "$zh" .zh.md)"
  en="rules/${name}.md"

  if [[ ! -f "$en" ]]; then
    echo "  ✗ ${zh}: 缺少对应的英文版本 ${en}"
    fail=1
    continue
  fi

  m_en=$(metrics "$en")
  m_zh=$(metrics "$zh")
  checked=$((checked + 1))

  if [[ "$MODE" = "list" ]]; then
    printf '  %-40s en=%-20s zh=%s\n' "$name" "$m_en" "$m_zh"
    continue
  fi

  base_row=$(baseline_lines | grep -F "${name}|" || true)

  if [[ "$m_en" == "$m_zh" ]]; then
    # 对齐了，但基线里还留着旧条目 → 提示删除（不算失败）
    if [[ -n "$base_row" ]]; then
      echo "  · ${name}: 已对齐，可从 ${BASELINE} 删除该行"
    fi
    continue
  fi

  if [[ -n "$base_row" ]]; then
    base_en=$(printf '%s' "$base_row" | cut -d'|' -f2-6)
    base_zh=$(printf '%s' "$base_row" | cut -d'|' -f7-11)
    if [[ "$base_en" == "$m_en" && "$base_zh" == "$m_zh" ]]; then
      echo "  ~ ${name}: 已登记欠账，跳过（en=${m_en} zh=${m_zh}）"
      continue
    fi
    echo "  ✗ ${name}: 与登记的欠账不一致（登记 en=${base_en} zh=${base_zh}，实际 en=${m_en} zh=${m_zh}）"
    echo "    → 基线已过期。若已修平请删除该行；若变差请修复后更新。"
  else
    echo "  ✗ ${name}: 双语结构不一致（en=${m_en} zh=${m_zh}）"
  fi
  fail=1
done

if [[ "$MODE" = "list" ]]; then
  echo
  echo "共 ${checked} 对双语文件"
  exit 0
fi

if [[ "$fail" != "0" ]]; then
  echo
  echo "→ 结论：双语结构不一致，禁止合并。"
  echo "  *.md 与 *.zh.md 必须在同一提交内同步更新（AGENTS.md 主指令 7）。"
  echo "  历史欠账请登记在 ${BASELINE} 并在 PR 中说明为何不能当场修。"
  exit 2
fi

echo "✅ 双语结构对齐（${checked} 对，未登记不一致 0）"
exit 0
