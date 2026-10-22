# Changelog

**[English](CHANGELOG.md)** | **[简体中文](CHANGELOG.zh.md)**

All notable changes to the **Vibe Coding Playbook** project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [1.4.0] - 2026-10-22

### Added
- **Automated guards for this repository** (`.github/workflows/public-safety.yml`, `scripts/`):
  - *Public-repo red line* (`scripts/check-public-safety.sh`): blocks internal project names, real user paths, credentials, personal data roots and account handles. This repository is public, so "the red line is a matter of conscience" was not good enough — and the hazard is not hypothetical: an internal tool name reached Rule 10's body during the very session that wrote it, caught only by manual re-reading.
  - *Bilingual parity* (`scripts/check-bilingual-parity.sh`): a `*.md` may not change without its `*.zh.md` twin. Five structural metrics (lines, `##` headings, rule clauses, table separators, checklist items) must stay equal.
  - *Dead links* (`scripts/check-links.sh`): every relative Markdown link must resolve.
- All three scripts are shared verbatim between local runs and CI, so green locally means green in CI. Each carries a `--selftest`.

### Notes
- **Baseline exemptions.** The bilingual check found four rule files whose two language versions already disagreed before this guard existed. Failing CI from day one would have turned the check into noise nobody reads, and a guard everyone ignores is worse than none. Those mismatches are registered in `scripts/bilingual-baseline.txt`; the check blocks only *new* mismatches, and a stale baseline entry is itself an error. The file is a list of debts to repay, not a licence.
- One of those debts is a real defect rather than mere line-count drift: in `rules/06_governance_and_reviews.zh.md` the label "Rule 6.5" is used twice, once for twin-document synchronisation and once for the commit gate, while the English file has only the former. Fixing it requires renumbering, which ripples into references outside this repository, so it is deliberately left to its own change rather than smuggled into an infrastructure commit.

## [1.3.0] - 2026-10-21

### Added
- **Rule 10: Task Decomposition & Agent-Team Delegation** (`rules/10_agent_team_decomposition.md` plus the Chinese twin):
  - A one-line decomposition verdict emitted before the first write, instead of a plan essay.
  - The parallelizability test: five criteria that argue for a team, and three counter-criteria that force a single agent.
  - The coordination cost gate: context rebuild, write-scope arbitration, harvest and review, and integration are named costs.
  - Disjoint write scopes, declared as path prefixes on every task ticket, with one writer per file at a time.
  - Independent verdicts: the writer never declares completion, and the verdict carries raw command output and an exit code.
  - Harvest and close: every teammate and background job is collected or cancelled before the final answer, and every ticket ends in PASS, FAIL, BLOCKED, or NOT DELIVERED.
  - An eight-row anti-pattern table, four prompt templates, and a dedicated checklist.
  - An explicit boundary statement against Rules 01, 06, and 07.
  - A decidable non-trivial threshold: Rule 10.1 defines it (two or more files or directories, two or more acceptance commands, two or more repositories, or writes alongside read-only research), closing the verbal-exemption gap.
  - Priority arbitration: counter-criteria outrank criteria and act on the unit, not the request, so dependency order cannot demote a multi-deliverable request to a single agent.
  - A mechanical check: the interface contract for a decomposition gate script (ticket array plus verdict line to exit code 0/2/3, fail-closed on malformed input), mirroring the mechanised commit gate of Rule 6.5. The contract distinguishes a **top-level area** from a **level of nesting** (a path inside a repository is still one area), states plainly that the downstream end is strong while the upstream end rests on three mechanical signals only, keeps version-control cross-checking advisory by default so the gate does not cry wolf, and concedes that an executor who declares "single agent" from the outset cannot be contradicted by any gate.

### Changed
- `README.md` and `README.zh.md`: The Nine Pillars became The Ten Pillars.
- Index registration: Pillar 10 added to `README.md`, `SKILL.md`, `AGENTS.md`, and `adapters/claude-code/CLAUDE.md`.
- `rules/00_attributions_and_origins.md` and its Chinese twin: registered the team-delegation lineage (Fred Brooks, Melvin Conway, the Amazon two-pizza team convention).

---

## [1.2.0] - 2026-10-20

### Added
- **Rule 09: Mobile & Rendered-UI Verification** (`rules/09_mobile_render_verification.md` plus the Chinese twin):
  - Render-is-truth mandate, declared viewport contracts, and machine-readable measurement records.
  - Separation of browser-chrome and full-screen rendering surfaces, with safe-area detection.
  - Transport as a test concern (ephemeral loopback HTTP instead of file URLs), idempotent fixtures, runtime-compatibility probing, blindness detection, and fail-closed behaviour.
  - A four-level verification budget, five prompt templates, and a dedicated checklist.
  - An explicit boundary statement against Rules 04, 05, and 07.

### Changed
- `README.md` and `README.zh.md`: The Eight Pillars became The Nine Pillars.
- Index registration: Pillar 09 added to `README.md`, `SKILL.md`, `AGENTS.md`, and `adapters/claude-code/CLAUDE.md`.

---

## [1.1.0] - 2026-10-13

### Added
- **Rule 08: Interaction State & Motion Engineering** (`rules/08_interaction_and_motion.md` plus the Chinese twin):
  - Continuity over cut, the single-expansion invariant, externalized state, the navigation pixel budget, retrieval over hierarchy, and motion accessibility and performance red lines.
  - A motion parameter quick-reference table and five framework-neutral prompt templates for AI agents.
  - An interaction and motion checklist, plus an explicit boundary between Rule 04 and Rule 08.
- **Attribution Update**: Registered the interaction and motion lineage in `00_attributions_and_origins` (Apple HIG, Material Design, WAI-ARIA Authoring Practices, WCAG 2.2, Nielsen Norman Group, and the command palette lineage).
- **Index Registration**: Added Pillar 08 to `README.md`, `SKILL.md`, and the rules index in `AGENTS.md`.

### Changed
- `README.md` and `README.zh.md`: The Seven Pillars became The Eight Pillars.

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
