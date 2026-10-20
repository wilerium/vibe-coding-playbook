# 变更日志 (Changelog)

**[English](CHANGELOG.md)** | **[简体中文](CHANGELOG.zh.md)**

本文件记录 **Vibe Coding Playbook** 项目的所有重要演进与版本变更。

本格式基于 [Keep a Changelog](https://keepachangelog.com/zh-CN/1.1.0/)，并严格遵循 [语义化版本规范 (Semantic Versioning)](https://semver.org/lang/zh-CN/)。

---

## [1.2.0] - 2026-10-20

### 新增
- **规则 09：移动端与渲染界面验证**（`rules/09_mobile_render_verification.zh.md` 及英文孪生）：
  - 渲染即事实、视口契约声明、机读测量记录。
  - 区分浏览器外壳与全屏两个渲染面，并检测安全区布局是否缺失。
  - 把传输方式纳入被测范围（临时回环 HTTP 替代 file 协议）、夹具幂等、运行时兼容性探测、盲态检测与失败关闭。
  - 四级验证预算、五条提示词模板、专用检查清单。
  - 与规则 04、05、07 的边界声明。

### 变更
- `README.md` 与 `README.zh.md`：八大核心支柱改为九大核心支柱。
- 索引登记：支柱 09 已加入 `README.md`、`SKILL.md`、`AGENTS.md` 与 `adapters/claude-code/CLAUDE.md`。

---

## [1.1.0] - 2026-10-13

### 新增 (Added)
- **规则 08：交互状态与动效工程**（`rules/08_interaction_and_motion.md` 及中文同步版）：
  - 状态位移化、单一展开态不变量、状态外置、导航占位预算、检索优先于层级，以及动效可访问性与性能红线。
  - 动效参数速查表，以及 5 条面向 AI Agent 的框架中立提示词模板。
  - 交互与动效核对清单，并明确与规则 04 的分工边界。
- **溯源更新**：在 `00_attributions_and_origins` 登记交互与动效谱系（苹果 HIG、Material Design、WAI-ARIA 创作实践、WCAG 2.2、尼尔森诺曼集团、命令面板谱系）。
- **索引注册**：在 `README.md`、`SKILL.md` 与 `AGENTS.md` 规则索引中登记支柱 08。

### 变更 (Changed)
- `README.md` 与 `README.zh.md`：七大核心支柱更名为八大核心支柱。

---

## [1.0.0] - 2026-10-10

### 新增 (Added)
- **核心工程规约体系**：
  - `AGENTS.md` 与 `SKILL.md`：通用智能体操作系统规范与核心技能规约。
  - `rules/` 目录下 8 大核心规则模块：
    - `00_attributions_and_origins`：哲学起源与思想先驱致敬。
    - `01_cognitive_discipline`：认知纪律、决策前沿、外科手术式 Diff 与打包提问协议。
    - `02_architecture_and_deep_modules`：深模块架构、适配器接缝与删除测试。
    - `03_controlled_language_and_prompts`：ASD-STE100 受控英语、受控技术中文与前缀缓存（Prefix Cache）优化。
    - `04_ui_ux_information_architecture`：Apple HIG 工业质感、Bento Box 排版与零静默崩溃渲染断言。
    - `05_forensic_debugging_and_guardrails`：反馈环先行、确定性秘钥脱敏（`<REDACTED>`）与破坏性 Git 安全联锁。
    - `06_governance_and_reviews`：单向门/双向门决策模型、爆炸半径声明、标准化 PR 模板、双轨代码审查与 DAG 寻路。
    - `07_master_checklist_and_redlines`：十大不可触碰核心红线、起飞前终极核对清单与安灯拉绳（Andon Cord）协议。
- **多智能体生态适配器 (Multi-Agent Adapters)**：
  - 提供针对 Claude Code、Cursor IDE、Windsurf (Cascade)、GitHub Copilot 的完整接入指引与规约模板（位于 `adapters/` 目录）。
- **全量中英文双语文档孪生**：
  - 全库所有规约文件、指南与总览实现 100% 同步镜像的中文版本（`*.zh.md`）。
- **工程纯净保障**：
  - 提供标准 `.gitignore`，杜绝操作系统、编辑器与运行缓存对代码库的污染。
