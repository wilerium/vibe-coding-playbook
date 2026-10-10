# AGENTS.md — Universal Agent Operating Standards

**[English](AGENTS.md)** | **[简体中文](AGENTS.zh.md)**

> **Notice to Autonomous Coding Agents (Claude Code, Cursor, Windsurf, Aider, Codex, Devin, Copilot)**:
> This repository and any project adopting this file strictly mandates the **Vibe Coding Playbook** engineering standards. You are required to read, understand, and adhere to the guidelines below for every interaction, plan, code edit, and tool call.

---

## 🎯 Primary Directives

1. **Think Before Coding**:
   - Analyze requirements thoroughly. Never make silent guesses when requirements or technical choices are ambiguous.
   - If a choice has multiple architectural options, halt, compute the decision frontier, present a single-round inquiry with up to 4 numbered questions, and always provide an explicit `(Recommended)` option.
2. **Surgical Precision**:
   - Limit all modifications to the exact scope of the user request.
   - Do NOT touch, reformat, or refactor surrounding legacy code, comments, or whitespace unless explicitly instructed.
   - Keep diffs minimal, clean, and directly traceable to the user's requirements.
3. **Deep Modules & Clean Seams**:
   - Keep interfaces small, obvious, and clean; hide complexity inside implementation.
   - Wrap external APIs and vendors in adapters so that the calling code passes the Deletion Test.
4. **Feedback Loop First (Defect Triage)**:
   - When debugging, create a failing automated test or minimal reproduction script before altering production code.
   - Verify that the test turns green after your change.
5. **Zero-Pollution & Stateless Repository**:
   - Do NOT write logs, caches, scratch files, or test outputs into the root repository.
   - Use dedicated sandbox directories (`/tmp/` or an external data root).
6. **Safety & Security First**:
   - NEVER run destructive Git commands (`git push --force`, `git reset --hard`, `git clean -fd`, `git checkout .`, `git branch -D`).
   - NEVER print or log credentials, Bearer tokens, cookies, or secrets in terminal output or commit history. Redact sensitive values with `<REDACTED>`.
7. **Documentation Twin Synchronization**:
   - Whenever modifying user-facing documentation, specifications, or guides that have dual-language versions (`*.md` and `*.zh.md`), you MUST update both files synchronously in the same commit.

---

## 🗺️ Rules Index & Progressive Disclosure

When performing specific tasks in this codebase or projects governed by this playbook, refer to the detailed rules under `rules/`:

- **Decisions & Questioning**: Read `rules/01_cognitive_discipline.md`
- **Module Design & Refactoring**: Read `rules/02_architecture_and_deep_modules.md`
- **Writing Prompts or Tech Specs**: Read `rules/03_controlled_language_and_prompts.md`
- **Frontend, HTML & UI/UX**: Read `rules/04_ui_ux_information_architecture.md`
- **Debugging & Safety Guardrails**: Read `rules/05_forensic_debugging_and_guardrails.md`
- **Pull Requests & Code Reviews**: Read `rules/06_governance_and_reviews.md`
- **Verification & Pre-Merge Audit**: Read `rules/07_master_checklist_and_redlines.md`
- **Lineage & Philosophical Foundations**: Read `rules/00_attributions_and_origins.md`
