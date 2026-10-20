# 🥋 Vibe Coding Playbook

> **From Chaotic Hacking to Disciplined Craftsmanship.**
> A universal, pure-documentation engineering standard and behavioral playbook for human developers and autonomous coding agents.

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Standards: ASD-STE100](https://img.shields.io/badge/Language-ASD--STE100-success.svg)](rules/03_controlled_language_and_prompts.md)
[![Architecture: Deep Modules](https://img.shields.io/badge/Architecture-Deep%20Modules-purple.svg)](rules/02_architecture_and_deep_modules.md)
[![Agents: Multi-Agent Ready](https://img.shields.io/badge/Agents-Claude%20%7C%20Cursor%20%7C%20Windsurf%20%7C%20Copilot-orange.svg)](#-multi-agent-ecosystem-adapters)

**[English](README.md)** | **[简体中文](README.zh.md)**

---

## 🧭 Why This Playbook Exists

The era of **"Vibe Coding"** has arrived: developers converse with foundation models at 100x speed. However, unconstrained vibe coding easily degrades into an unmaintainable swamp:
* **Silent Guesswork**: Agents quietly assume architecture and business requirements, causing massive rewrites.
* **Shallow Modules & Leakage**: Fragile wrappers with wide interfaces that couple business logic directly to external vendors.
* **Token Inflation & Hallucinations**: Verbose, conversational prompt instructions that break prefix caching and drift over time.
* **Speculative Bug Fixes**: Modifying production code before establishing a reproducible failing test loop.
* **Accidental Blast Damage**: Destructive Git operations wiping branches or state without reversibility classification.

**The Vibe Coding Playbook converts chaotic AI interactions into predictable, high-precision engineering.** It is zero-dependency, 100% pure documentation, and works seamlessly across human engineers and all mainstream coding agents.

---

## 🏛️ The Nine Pillars

| Pillar | Focus | Core Philosophy |
| :--- | :--- | :--- |
| **[00. Attribution Tree](rules/00_attributions_and_origins.md)** ([中文](rules/00_attributions_and_origins.zh.md)) | Lineage & Credit | Stand on the shoulders of giants; explicit citation of foundational ideas. |
| **[01. Cognitive Discipline](rules/01_cognitive_discipline.md)** ([中文](rules/01_cognitive_discipline.zh.md)) | Decision Frontiers | Think before coding; single-round Socratic questions with explicit recommendations. |
| **[02. Deep Modules & Seams](rules/02_architecture_and_deep_modules.md)** ([中文](rules/02_architecture_and_deep_modules.zh.md)) | Architectural Depth | Simple interfaces, deep implementations, stateless repos, and the Deletion Test. |
| **[03. Controlled Language & Prompts](rules/03_controlled_language_and_prompts.md)** ([中文](rules/03_controlled_language_and_prompts.zh.md)) | Precision Communication | ASD-STE100 rules, maximum prefix cache hits, and deterministic AI defensiveness. |
| **[04. Industrial UI/UX Aesthetics](rules/04_ui_ux_information_architecture.md)** ([中文](rules/04_ui_ux_information_architecture.zh.md)) | Progressive Disclosure | Information density, zero-script interaction hacks, and Apple-grade craft. |
| **[05. Forensic Debugging & Safety](rules/05_forensic_debugging_and_guardrails.md)** ([中文](rules/05_forensic_debugging_and_guardrails.zh.md)) | Ironclad Guardrails | Feedback loop first, deterministic secret redaction, and destructive Git interceptors. |
| **[06. Governance & Review](rules/06_governance_and_reviews.md)** ([中文](rules/06_governance_and_reviews.zh.md)) | Two-Axis Rigor | Two-way vs One-way doors, Two-Axis Review (Standards vs Spec), and DAG Wayfinding. |
| **[07. Master Checklist & Red Lines](rules/07_master_checklist_and_redlines.md)** ([中文](rules/07_master_checklist_and_redlines.zh.md)) | Zero Tolerance | 10 non-negotiable red lines that immediately block merge or deployment. |
| **[08. Interaction & Motion](rules/08_interaction_and_motion.md)** ([中文](rules/08_interaction_and_motion.zh.md)) | Continuity & Timing | State continuity over hard cuts, single-expansion invariant, externalized state, navigation pixel budget, and motion parameter budgets. |
| **[09. Mobile & Rendered-UI Verification](rules/09_mobile_render_verification.md)** ([中文](rules/09_mobile_render_verification.zh.md)) | Render Is Truth | Declared viewport contracts, machine-readable measurements, transport as part of the test, idempotent fixtures, and layered verification budgets. |

---

## 🌳 Attribution Tree (Honoring Foundational Thinkers)

This playbook synthesizes battle-tested philosophies from pioneering engineers and open-source contributors:

```text
Foundational Lineage
├── Andrej Karpathy (Core LLM behavioral guidelines: Think first, surgical changes, simplicity)
├── John Ousterhout ("A Philosophy of Software Design": Deep modules, information hiding, seams)
├── Matt Pocock (Agent skills: Grilling decision frontiers, diagnosing bugs, two-axis code review, wayfinder)
├── ASD-STE100 European Aerospace Standard (Simplified Technical English, constrained vocabulary)
├── Martin Fowler & Eric Evans (Refactoring, Domain-Driven Design, clean adapter boundaries)
├── Jeff Bezos / Amazon Leadership Principles (One-way vs Two-way doors, blast radius classification)
├── Kent Beck (Test-Driven Development: Feedback loop first, red-green-refactor)
├── Dieter Rams & Steve Jobs (Less but better, progressive disclosure, high-density craftsmanship)
├── Apple HIG (Motion) & Material Design (Motion as spatial explanation, shared-element continuity)
├── W3C WAI-ARIA & WCAG 2.2 (Exclusive-open disclosure, reduced motion, frame budget)
└── Adam Wiggins et al. (The Twelve-Factor App: Externalized state, stateless repositories)
```
*See [rules/00_attributions_and_origins.md](rules/00_attributions_and_origins.md) for detailed academic and engineering lineage.*

---

## 🤖 Multi-Agent Ecosystem Adapters

This repository is built to be loaded directly by any AI coding environment:

### 1. Claude Code & Agent Skills CLI
* **Native Agent Skill**: [SKILL.md](SKILL.md) complies with the official Anthropic Agent Skill specification.
  ```bash
  # Install as a global skill for all projects:
  mkdir -p ~/.agents/skills/vibe-coding-playbook
  cp SKILL.md ~/.agents/skills/vibe-coding-playbook/
  
  # Or symlink into a local project:
  ln -s /path/to/vibe-coding-playbook/SKILL.md .claude/skills/vibe-coding-playbook.md
  ```
* **Project Guide**: Symlink [AGENTS.md](AGENTS.md) as your project's `CLAUDE.md`.

### 2. Cursor IDE
* Place [adapters/cursor/.cursorrules](adapters/cursor/.cursorrules) in your project root, or copy [adapters/cursor/.cursor/rules/](adapters/cursor/.cursor/rules/) into `.cursor/rules/` for fine-grained rule matching.

### 3. Windsurf (Codeium Cascade)
* Place [adapters/windsurf/.windsurfrules](adapters/windsurf/.windsurfrules) into your project root.

### 4. GitHub Copilot & Workspace
* Place [adapters/copilot/.github/copilot-instructions.md](adapters/copilot/.github/copilot-instructions.md) into `.github/copilot-instructions.md`.

### 5. Aider / OpenAI Codex / Devin / OpenDevin
* Point the agent to [AGENTS.md](AGENTS.md) in your project root as the universal system prompt instruction.

---

## ⚡ Quick Start Checklist (The 60-Second Sanity Check)

Before merging any PR or executing any AI-generated change, ask these four questions:

1. **[Decision]** Was an ambiguous requirement guessed silently, or was a decision frontier computed with an explicit recommendation?
2. **[Surgical]** Does this diff contain any unsolicited reformatting or cleanup of neighboring old code?
3. **[Loop]** Was a failing reproduction test or verification probe established before editing production logic?
4. **[Seam]** If this external API or vendor is deleted tomorrow, does the caller code need to change? (The Deletion Test)

---

## 📄 License
Released under the permissive [MIT License](LICENSE). Feel free to adapt, fork, and embed into your engineering teams and personal AI toolchains.
