# AGENTS.zh.md — 通用 Coding Agent 运行准则

**[English](AGENTS.md)** | **[简体中文](AGENTS.zh.md)**

> **致各大自主 Coding Agent（Claude Code, Cursor, Windsurf, Aider, Codex, Devin, Copilot）**：
> 本仓库及任何采纳本规范的项目，均严格强制执行 **Vibe Coding Playbook** 工程标准。在执行任何交互、规划、代码编辑和工具调用时，你必须阅读、理解并严格遵守以下准则。

---

## 🎯 核心行动指令

1. **先思考后编码 (Think Before Coding)**：
   - 彻底分析需求。面对模糊需求或技术路线分歧时，**严禁静默瞎猜**。
   - 若存在多种可行架构，必须停止代码编写，计算决策前沿（Decision Frontier），单轮打包提出最多 4 个编号问题，并始终明确给出 `(推荐)` 方案。
2. **外科手术式精确度 (Surgical Precision)**：
   - 将所有改动严格限制在用户请求的必要范围内。
   - 除非获得明确授权，**绝对禁止**顺带重构、重新格式化周围陈旧代码或无端修改无关注释。
   - 保持代码 Diff 极简、纯粹，每一行均可直接追溯至用户目标。
3. **深模块设计与架构接缝 (Deep Modules & Seams)**：
   - 保持接口微小、清晰且直观；将实现复杂性封印于内部。
   - 将外部第三方 API 与供应商封装在适配器中，确保业务核心 100% 通过“删除测试（The Deletion Test）”。
4. **反馈环先行 (Feedback Loop First)**：
   - 排查修复 Bug 时，在修改任何业务代码之前，必须先写出一个可稳定复现问题的红灯测试或最小 CLI 探测脚本。
   - 修复后必须证明该测试已转为绿灯。
5. **仓库零污染与无状态原则 (Stateless Repository)**：
   - 严禁向 Git 跟踪的工程目录写入运行日志、缓存数据库、临时抓取文件或测试产物。
   - 统一使用专用沙箱目录（如 `/tmp/` 或外部数据根目录）。
6. **安全底线与凭据保护 (Safety & Security First)**：
   - **严禁**执行破坏性 Git 命令（`git push --force`、`git reset --hard`、`git clean -fd`、`git checkout .`、`git branch -D`）。
   - **严禁**在终端输出或提交历史中明文打印任何 Token、密码、Cookie 或私钥。敏感信息必须脱敏为 `<REDACTED>`。
7. **双语文档原子级同步 (Documentation Twin Rule)**：
   - 修改任何具有双语版本的文档（`*.md` 和 `*.zh.md`）时，**必须在同一个 Commit 中原子级同步更新双语版本**。

---

## 🗺️ 渐进式规则索引导航 (Rules Index)

在此仓库或遵循本手册的项目中执行具体任务时，请针对性阅读 `rules/` 下的细分规约：

- **技术决策与前沿逼问** ➔ 阅读 `rules/01_cognitive_discipline.zh.md`
- **模块设计、接缝与解耦** ➔ 阅读 `rules/02_architecture_and_deep_modules.zh.md`
- **提示词编写与技术规范** ➔ 阅读 `rules/03_controlled_language_and_prompts.zh.md`
- **前端、HTML 与 UI/UX** ➔ 阅读 `rules/04_ui_ux_information_architecture.zh.md`
- **问题排障与安全护栏** ➔ 阅读 `rules/05_forensic_debugging_and_guardrails.zh.md`
- **PR 审查与大型工单寻路** ➔ 阅读 `rules/06_governance_and_reviews.zh.md`
- **发版前核对与绝对红线** ➔ 阅读 `rules/07_master_checklist_and_redlines.zh.md`
- **思想溯源与工程流派** ➔ 阅读 `rules/00_attributions_and_origins.zh.md`
