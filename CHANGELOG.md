# Changelog

**[English](CHANGELOG.md)** | **[简体中文](CHANGELOG.zh.md)**

All notable changes to the **Vibe Coding Playbook** project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

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
