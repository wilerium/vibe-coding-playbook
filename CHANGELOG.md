# Changelog

**[English](CHANGELOG.md)** | **[简体中文](CHANGELOG.zh.md)**

All notable changes to the **Vibe Coding Playbook** project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

---

## [1.5.0] - 2026-11-10

### Added
- **Spec-Driven Autonomous Agent Engineering Standards**:
  - `rules/01_cognitive_discipline`: Added Rule 1.5 "The Anti-Dumb-Zone Protocol" enforcing mandatory Session Breaks (`/clear`) between planning and implementation, 80-sentence work order budgets, proactive split gates, and 150K token ceiling warnings.
  - `rules/02_architecture_and_deep_modules`: Upgraded Rule 2.2 into "Seams Golden Rules" featuring the Two-Adapter Law, enabling points, 6-step seam decision procedure, functional core decoupling, and replace-don't-layer testing.
  - `rules/03_controlled_language_and_prompts`: Added Rule 3.4 "The Two-Surface House Style" standardizing documentation registers vs ephemeral registers and mandating the Fixed 5-Slot Order for human-facing reports.
  - `rules/05_forensic_debugging_and_guardrails`: Added Rule 5.5 "Maker-Checker Role Isolation & The Tracer Bullet Contract" splitting mechanical execution (Verify) from semantic contract review (Judge) and enforcing Red-before-green test declarations.
  - `rules/06_governance_and_reviews`: Added Rule 6.6 "Asymmetric Git Topology & Sovereign Human Gate" with fail-closed merge guards on default branch, and Rule 6.7 "Single Source of Truth & The Typed Reason Ledger" with 4-tier failure classifications.
  - `rules/00_attributions_and_origins`: Updated lineage matrix and deep dive with Michael Feathers, Andrew Hunt, David Thomas, W. Edwards Deming, and spec-driven agent pipeline engineering.
  - `rules/07_master_checklist_and_redlines`: Updated master pre-flight checklists across all 4 phases.
  - Synchronized across `AGENTS.md`, `SKILL.md`, `README.md`, and all Chinese documentation twins.

## [1.4.0] - 2026-10-22

## [1.0.0] - 2026-10-10

### Added
- **Core Engineering Playbook**:
  - `AGENTS.md` & `SKILL.md`: Universal agent operating standards and core skill definition.
  - 8 core rule modules under `rules/`:
    - `00_attributions_and_origins`: Philosophical lineage and foundational attributions.
    - `01_cognitive_discipline`: Decision frontiers, surgical diffs, and inquiry protocols.
    - `02_architecture_and_deep_modules`: Deep modules, adapter seams, and the Deletion Test.
    - `03_controlled_language_and_prompts`: ASD-STE100 technical English, controlled technical Chinese, and prefix-cache optimization.
    - `04_ui_ux_information_architecture`: Apple HIG-inspired styling, Bento Box layouts, and zero-crash template rendering assertions.
    - `05_forensic_debugging_and_guardrails`: Feedback-loop-first debugging, deterministic secret sanitization (`<REDACTED>`), and destructive git command interlocks.
    - `06_governance_and_reviews`: Two-way vs. one-way door models, blast radius declarations, structured PR templates, two-axis code reviews, and DAG wayfinding.
    - `07_master_checklist_and_redlines`: The Ten Red Lines, pre-flight master checklist, and the Andon Cord protocol.
- **Multi-Agent Adapters**:
  - Integration guides and rule files for Claude Code, Cursor IDE, Windsurf (Cascade), and GitHub Copilot under `adapters/`.
- **Bilingual Documentation Twins**:
  - 100% mirrored Chinese documentation twins (`*.zh.md`) for all rules, guides, and specifications.
- **Repository Hygiene**:
  - Comprehensive `.gitignore` to prevent OS, IDE, and temporary cache pollution.
