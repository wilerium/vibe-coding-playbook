# 🥋 Vibe Coding Playbook（心流编码工程实战手册）

> **从混沌的黑客乱写，走向高度克制与优雅的软件工匠之道。**
> 一份专为人类工程师与自主 Coding Agent（AI 编程助手）设计的通用、纯文档型软件工程规范与行为守则。

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Standards: ASD-STE100](https://img.shields.io/badge/Language-ASD--STE100-success.svg)](rules/03_controlled_language_and_prompts.md)
[![Architecture: Deep Modules](https://img.shields.io/badge/Architecture-Deep%20Modules-purple.svg)](rules/02_architecture_and_deep_modules.md)
[![Agents: Multi-Agent Ready](https://img.shields.io/badge/Agents-Claude%20%7C%20Cursor%20%7C%20Windsurf%20%7C%20Copilot-orange.svg)](#-主流-coding-agent-全生态适配)

**[English](README.md)** | **[简体中文](README.zh.md)**

---

## 🧭 为什么需要这份手册？

**“Vibe Coding”（氛围感/心流编码）**时代已经到来：开发者借助基础大模型，能够以百倍于以往的速度生成代码。然而，缺乏约束的心流极易滑向无法维护的技术泥潭：
* **静默盲猜 (Silent Guesswork)**：Agent 在面对模糊需求时悄悄自行下注选择技术路径，导致后期发生大面积重构与返工。
* **肤浅封装与逻辑泄露 (Shallow Wrappers)**：写出庞大而脆弱的浅层接口，将外部服务与业务核心高度耦合。
* **Prompt 膨胀与漂移 (Token Inflation)**：充满口语化、松散指示的提示词严重破坏前缀缓存（Prefix Caching），推高成本且推理结果不稳。
* **猜测性修 Bug (Speculative Bug Fixes)**：在没有建立可稳定复现的红灯测试反馈环之前，盲目修改业务代码。
* **状态与分支误伤 (Accidental Blast Damage)**：破坏性 Git 命令在缺乏单双向门评估的情况下被误触，导致代码或数据被抹除。

**《Vibe Coding Playbook》旨在将不可控的 AI 交互，转化为高确定性、高品质交付的系统化工程。** 全文档无任何代码运行时依赖，纯 Markdown 沉淀，随时可以引入任何新项目，即插即用。

---

## 🏛️ 七大核心支柱

| 支柱规约 | 核心关注点 | 核心哲学 |
| :--- | :--- | :--- |
| **[00. 思想流派与致敬溯源](rules/00_attributions_and_origins.zh.md)** ([EN](rules/00_attributions_and_origins.md)) | 溯源与工程传承 | 站在巨人的肩膀上：详尽标注所有核心工程思想的原始出处与灵感源泉。 |
| **[01. 认知决策与行为铁律](rules/01_cognitive_discipline.zh.md)** ([EN](rules/01_cognitive_discipline.md)) | 决策前沿与审慎推演 | 思考优于编码；计算决策前沿拓扑；单轮提问必带明确推荐；严禁静默决策。 |
| **[02. 深模块设计与架构接缝](rules/02_architecture_and_deep_modules.zh.md)** ([EN](rules/02_architecture_and_deep_modules.md)) | 架构深度与隔离 | 极简接口、深邃实现；仓库严格保持无状态；彻底通过“删除测试（Deletion Test）”。 |
| **[03. 受控技术语言与提示词](rules/03_controlled_language_and_prompts.zh.md)** ([EN](rules/03_controlled_language_and_prompts.md)) | 精准沟通与防漂移 | 严格遵循 ASD-STE100 规范；最大化 Prefix Cache 命中率；绝对防御性 AI。 |
| **[04. 工业级 UI/UX 与信息架构](rules/04_ui_ux_information_architecture.zh.md)** ([EN](rules/04_ui_ux_information_architecture.md)) | 渐进式披露美学 | 极高数据密度；纯 CSS 交互黑魔法（零脚本依赖）；高管级首屏即决断。 |
| **[05. 法医级调试与安全护栏](rules/05_forensic_debugging_and_guardrails.zh.md)** ([EN](rules/05_forensic_debugging_and_guardrails.md)) | 反馈环与破坏性拦截 | 反馈环先行（无红灯测试绝不改代码）；凭据强制脱敏；拦截破坏性 Git 操作。 |
| **[06. 研发治理与双轨审查](rules/06_governance_and_reviews.zh.md)** ([EN](rules/06_governance_and_reviews.md)) | 单双向门与规范评审 | 单向门 vs 双向门评估；双轨代码审查（规范轴 vs 需求轴）；DAG 工单任务寻路。 |
| **[07. 终极核对清单与十大红线](rules/07_master_checklist_and_redlines.zh.md)** ([EN](rules/07_master_checklist_and_redlines.md)) | 零容忍铁律 | 十大约束绝对红线，触犯任何一条直接阻断合入与发版。 |

---

## 🌳 思想溯源与工程流派谱系（致敬先驱）

本手册融合并提炼了多位先驱工程师与开源领袖的思想精髓：

```text
思想源流谱系
├── Andrej Karpathy (大模型编程行为守则：先想再写、外科手术式修改、极简主义)
├── John Ousterhout (《软件设计哲学》：深模块哲学、信息隐藏、接口与实现深度比)
├── Matt Pocock (Agent Skills 系列：逼问决策前沿、法医式调试、双轨代码审查、工单寻路)
├── ASD-STE100 欧洲航天与防务标准 (简化受控技术语言，消除从句与模棱两可)
├── Martin Fowler & Eric Evans (重构理论、领域驱动设计 DDD、干净的架构接缝与适配器)
├── Jeff Bezos / 亚马逊管理原则 (单向门与双向门决策模型、爆炸半径显式声明)
├── Kent Beck (测试驱动开发 TDD：反馈环先行、红绿重构周期)
├── 迪特·拉姆斯 (Dieter Rams) & 史蒂夫·乔布斯 (少即是多、渐进式信息披露、高密度克制美学)
└── Adam Wiggins 等 (The Twelve-Factor App：状态外部化、代码仓库绝对无状态)
```
*详见 [rules/00_attributions_and_origins.md](rules/00_attributions_and_origins.md) 了解更详细的学术与工程溯源。*

---

## 🤖 主流 Coding Agent 全生态适配

本仓库原生设计为支持各大 AI 编码助手的通用规范：

### 1. Claude Code 与标准 Agent Skills 命令行
* **官方 Agent Skill**: [SKILL.md](SKILL.md) 严格符合 Anthropic Agent Skill 标准规范。
  ```bash
  # 安装为全局技能（所有项目通用）：
  mkdir -p ~/.agents/skills/vibe-coding-playbook
  cp SKILL.md ~/.agents/skills/vibe-coding-playbook/
  
  # 或在当前项目中软链接：
  ln -s /path/to/vibe-coding-playbook/SKILL.md .claude/skills/vibe-coding-playbook.md
  ```
* **项目指令**: 直接将 [AGENTS.md](AGENTS.md) 软链接为项目根目录的 `CLAUDE.md`。

### 2. Cursor IDE
* 在项目根目录放入 [adapters/cursor/.cursorrules](adapters/cursor/.cursorrules)，或将 [adapters/cursor/.cursor/rules/](adapters/cursor/.cursor/rules/) 复制到项目 `.cursor/rules/` 目录以支持精细化文件规则匹配。

### 3. Windsurf (Codeium Cascade)
* 在项目根目录放入 [adapters/windsurf/.windsurfrules](adapters/windsurf/.windsurfrules)。

### 4. GitHub Copilot & Workspace
* 将 [adapters/copilot/.github/copilot-instructions.md](adapters/copilot/.github/copilot-instructions.md) 放置于项目的 `.github/copilot-instructions.md`。

### 5. Aider / OpenAI Codex / Devin / OpenDevin
* 将根目录的 [AGENTS.md](AGENTS.md) 作为系统的通用 System Prompt 指令或上下文注入。

---

## ⚡ 60 秒极速质检清单（快速心智自查）

在合入任何 AI 生成的 PR 或执行关键改动前，快速核对以下 4 个灵魂拷问：

1. **【决策】** 遇到模糊需求时，Agent 是否私自下注盲猜？还是计算了决策前沿并附带了明确推荐？
2. **【外科手术】** 当前代码 Diff 中是否夹带了未经请求的陈旧代码重构、格式化或顺带修饰？
3. **【反馈环】** 在动手修改业务代码前，是否先写出了能够稳定复现问题的红灯测试或最小探测脚本？
4. **【接缝】** 如果明天将调用的外部服务彻底删除并替换为另一家，调用方的业务代码和测试是否无需改动任何一行？（删除测试）

---

## 📄 开源许可证
本工程遵循宽松的 [MIT License](LICENSE)，欢迎自由 Fork、调整并在团队中推行使用。
