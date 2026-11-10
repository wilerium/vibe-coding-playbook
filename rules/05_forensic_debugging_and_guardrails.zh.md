# 🔍 05. 法医级调试纪律与安全护栏 (Forensic Debugging & Safety Guardrails)

**[English](05_forensic_debugging_and_guardrails.md)** | **[简体中文](05_forensic_debugging_and_guardrails.zh.md)**

> *“调试代码的难度是写代码的两倍。因此，如果你在写代码时已经发挥了极致的聪明才智，按定义你将不够聪明去调试它。”* — 布莱恩·柯林汉 (Brian Kernighan)

---

## 🎯 核心问题：“瞎猜式打补丁”陷阱 (The Speculative Patch Trap)

在面对交付压力或突发生产 Bug 时，开发者和 AI 助手往往容易滑向极度危险的野路子：
1. **猜测式修复 (Shooting in the Dark)**：在没有摸清根本原因（Root Cause）的情况下，凭直觉东改一下西改一下，看似解决了当前表面现象，却埋下了严重的未知回归缺陷。
2. **凭据意外泄露**：为了快速排查，直接把包含 Bearer Token、密码或 Cookie 的原始请求体打印到终端日志或输入给 AI，造成严重安全漏洞。
3. **毁灭性 Git 误操作**：为了“重头来过”，盲目执行 `git reset --hard` 或 `git checkout .`，彻底抹杀了开发者本地尚未提交的珍贵成果。
4. **粗糙的 CLI 初始化向导**：要求用户在控制台明文输入密码，或以覆盖方式粗暴写入用户配置文件。

---

## 📜 规则 5.1：反馈环先行原则（红绿闭环纪律）
*(思想溯源：Kent Beck & Matt Pocock `diagnosing-bugs`)*

**核心铁律**：在建立起能够百分之百稳定复现问题的红灯测试闭环前，**绝对禁止直接修改任何业务代码**。

### 四阶段法医式排障周期
1. **阶段 1：隔离与稳定复现 (红灯态 Red)**：
   - 先写出一个极简的单元测试、curl 探测命令或独立复现脚本，能够稳定触发该报错。
   - 运行它，亲眼观察到失败。如果你无法复现失败，说明你根本没有掌握 Bug 的触发机理。
2. **阶段 2：法医级根因定位**：
   - 顺着调用栈和数据流向下深挖。务必严格区分**症状 (Symptom)**（异常在哪一行爆发）与**根因 (Root Cause)**（非法数据究竟是在哪里被制造出来的）。
3. **阶段 3：外科手术式修复 (绿灯态 Green)**：
   - 做出使失败测试转为绿灯所必需的最小代码修改。
   - 运行复现反馈环，验证红灯已被扑灭，变成绿灯。
4. **阶段 4：全量回归扫描**：
   - 跑通整个项目的自动化测试套件，证明此次修复没有引发任何次生灾害。

---

## 📜 规则 5.2：确定性敏感数据脱敏 (Sensitive Data Redaction)

**核心铁律**：绝对严禁在终端、控制台日志或大模型上下文中输出明文敏感信息。所有凭证在打印前必须确定性脱敏为 `<REDACTED>`。

### 强制脱敏模式清单
在向控制台输出日志或组织诊断报告前，必须运行确定性的脱敏清洗器：
1. **Bearer 令牌**：`Bearer\s+[A-Za-z0-9_\-\.~+/]+=*` ➔ `Bearer <REDACTED>`
2. **API 密钥与私钥**：`(ghp_|gho_|sk-|AIza|token=)[A-Za-z0-9_\-]+` ➔ `$1<REDACTED>`
3. **Basic Auth 密码**：`https?://([^:]+):([^@]+)@` ➔ `https://$1:<REDACTED>@`
4. **敏感请求头与 Cookie**：`(Authorization|Set-Cookie|Cookie|token|password):\s*([^\r\n]+)` ➔ `$1: <REDACTED>`

```python
# 通用确定性脱敏工具实现参考
import re

SENSITIVE_PATTERNS = [
    (re.compile(r"(Bearer\s+)[A-Za-z0-9_\-\.~+/]+=*", re.IGNORECASE), r"\1<REDACTED>"),
    (re.compile(r"((?:token|secret|password|apikey|api_key)\s*[:=]\s*['\"])[^'\"]+(['\"])", re.IGNORECASE), r"\1<REDACTED>\2"),
    (re.compile(r"gh[pousr]_[A-Za-z0-9_]{36,255}"), "<REDACTED_GH_TOKEN>"),
]

def redact_sensitive_text(text: str) -> str:
    if not text:
        return text
    for pattern, replacement in SENSITIVE_PATTERNS:
        text = pattern.sub(replacement, text)
    return text
```

---

## 📜 规则 5.3：多阶段 CLI 向导架构 (Multi-Stage Terminal Wizard)
*(思想溯源：Matt Pocock `wizard`)*

**核心铁律**：编写交互式终端配置脚本或向导程序时，必须保障体验优雅与操作幂等。

1. **阶段指示器 (`[Stage i/N]`)**：
   - 始终展示当前处于第几阶段（如 `[Stage 1/4] 环境探测`, `[Stage 2/4] 凭证配置`），消解用户在黑盒终端中的焦虑感。
2. **静默隐蔽输入密码**：
   - 在用户输入 API 密钥或密码时，终端绝不回显任何明文（Bash 中使用 `read -s`，Node/Python 中使用静默密码捕获器）。
3. **落盘前的二次确认门禁**：
   - 在向磁盘写入配置前，列出脱敏后的参数总览。
   - 要求用户显式确认（`确认保存上述配置？[y/N]`）。
4. **幂等合并写入 (Idempotent Upsert)**：
   - 绝不暴力覆盖已存在的配置文件。读取现有配置，保留未改动的字段，只对变更项进行幂等更新。

---

## 📜 规则 5.4：破坏性 Git 操作拦截护栏

**核心铁律**：必须在工具层或钩子层物理拦截自主 Agent 或脚本运行破坏性 Git 命令。

### 绝对黑名单命令
在自动化脚本或 AI 辅助编程会话中，以下命令被永久封杀：
* `git push --force` 或 `git push -f`：暴力重写远端共享历史。
* `git reset --hard`：彻底抹杀未提交的本地工作区改动。
* `git clean -fd`：彻底删除未跟踪的新增文件与目录，无法回收。
* `git checkout .` 或 `git restore .`：强行丢弃当前工作树所有修改。
* `git branch -D`：强行删除可能包含未合并 Commit 的本地分支。
* `git stash clear`：一锅端清空所有存储的暂存工作现场。

### 零依赖纯 Shell 拦截器范式
在工具链中配置轻量级的前置拦截脚本：
```bash
#!/usr/bin/env bash
# 拦截并阻断危险的 Git 命令
cmd="$*"

if [[ "$cmd" =~ git[[:space:]]+push[[:space:]]+.*(-f|--force) ]]; then
  echo "🚨 [安全护栏拦截] 严禁执行强制推送 (force-push)！" >&2
  exit 1
fi

if [[ "$cmd" =~ git[[:space:]]+reset[[:space:]]+--hard ]]; then
  echo "🚨 [安全护栏拦截] git reset --hard 会永久摧毁未提交成果，已拦截！" >&2
  exit 1
fi

if [[ "$cmd" =~ git[[:space:]]+clean[[:space:]]+.*-f ]]; then
  echo "🚨 [安全护栏拦截] git clean -f 会永久删除未跟踪文件，已拦截！" >&2
  exit 1
fi
```

---

## 📜 规则 5.5：裁量隔离律与示踪弹测试契约 (Maker-Checker & Tracer Bullets)
*(思想溯源：规范驱动型自主 Agent 工程范式 & 《程序员修炼之道》)*

**核心铁律**：写代码的 Agent 绝不能同时当裁判。机械命令验证与语义契约审查必须在 Agent 角色与工具权限上物理隔离。

```
       ┌────────────────────────────────────────────────────────┐
       │                Developer 编码者 (Write 权限)           │
       │                TDD 先红后绿编写代码，提交数 ≤ 2 次       │
       └───────────────────────────┬────────────────────────────┘
                                   │ 输出补丁 (Patch) 与交接清单
                                   ▼
       ┌────────────────────────────────────────────────────────┐
       │                  MAKER-CHECKER 裁量隔离律              │
       ├───────────────────────────┬────────────────────────────┤
       │ Verify 机械守门员         │  Judge 语义裁判官          │
       │ - 工具: 仅限 Shell/Bash   │  - 工具: 仅限 Read/Grep    │
       │ - 剥夺文件编辑/写权限     │  - 严禁执行任何 Shell 命令 │
       │ - 仅校验系统退出状态码    │  - 3 轴契约审查:           │
       │ - 基线容差感知 (Baseline) │    1. Standards 工程规范轴 │
       │ - 重跑示踪弹 (Tracer)     │    2. Spec 验收标准 (阻断) │
       │                           │    3. Parent 顶层意图(告警)│
       └───────────────────────────┴────────────────────────────┘
```

### 1. 机械物理门禁 vs 语义契约门禁
* **Verify 机械守门员 (Physical Mechanical Gate)**：
  * *工具权限*：仅被赋予 Shell 执行工具，**完全剥夺文件编辑与写入权限**。
  * *核心职责*：亲自落地物化 Patch，在独立环境中重跑测试与 Lint 命令，直接检查物理退出状态码（Exit Code）。绝不采信编码者的自评报告。
  * *基线容差感知 (Baseline-Aware)*：同时跑当前代码与基线代码（`merge-base`）。主干上原本已红灯的非相关测试予以容忍，唯有本次变更引入的全新失败才会阻断流水线。
* **Judge 语义裁判官 (Semantic Judgment Gate)**：
  * *工具权限*：仅拥有只读检索工具（Read / Grep / Glob），**严禁执行 Shell 命令，严禁写文件**。
  * *核心职责*：逐行比对 Patch 与工单中白纸黑字写下的验收标准，按 3 轴输出裁决：
    1. **Standards 轴**：是否违反代码深模块、架构接缝与安全基线。
    2. **Spec 轴**：是否 100% 达成该工单切片的具体验收条件。未达成项归类为 **Blocking Findings**（阻断项，必须打回修复）。
    3. **Parent 轴**：是否偏离总目标架构初衷。不一致项归类为 **Advisory Findings**（参考告警，底层无权擅自扩充业务范围）。

### 2. 示踪弹测试契约与“先红后绿”合同 (Tracer Bullet & Red-Before-Green)
* **每切片唯一示踪弹**：每个垂直切片必须且仅包含一颗贯穿全链路的“示踪弹测试（Tracer Bullet Test）”，用于自顶向下证明该切片物理打通。
* **先红后绿强制声明 (Red-before-green)**：工单中必须在开工前，白纸黑字写明该用例在未实现状态下的具体报错签名或失败模式。
* 机械守门员（Verify）必须在代码就绪前独立验证该失败特征真实出现，随后见证其转绿，防止测试沦为无效空跑。

---

## 🚨 调试与安全核对清单 (Debugging Checklist)

- [ ] 在动手改代码前，是否先写出了稳定可复现的红灯测试/探测脚本？
- [ ] 是否亲眼观察到了测试失败（红灯），并在修复后见证它通过（绿灯）？
- [ ] 审查过程中是否严格恪守了 Maker-Checker 隔离（实现者与验证者为不同 Agent）？
- [ ] 机械命令验证（Bash/状态码）与语义契约审查（只读/3 轴比对）是否彻底解耦？
- [ ] 每个垂直切片是否均包含具有显式“先红后绿”合同的端到端示踪弹？
- [ ] 终端日志与排障诊断中，是否已将所有凭证与 Cookie 脱敏为 `<REDACTED>`？
- [ ] 是否彻底杜绝了使用 `push --force`、`reset --hard` 等危险 Git 命令？
- [ ] CLI 初始化向导是否实现了隐蔽密码输入与幂等写入？
- [ ] 在宣布 Bug 修复完成前，是否执行了全量测试回归扫描？
