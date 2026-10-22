# CLAUDE.md — Project Engineering Guide (Vibe Coding Standard)

> This project strictly enforces the **Vibe Coding Playbook** engineering guidelines.

## 🧠 Core Behavior Rules
1. **Think Before Coding**:
   - Never guess silently when requirements or architectures have multiple options.
   - Compute the decision frontier, batch questions in a single round (≤ 4 questions), and always provide an explicit `(Recommended)` tag.
2. **Simplicity First**:
   - Solve problems with minimal code. Avoid speculative generics, factories, or premature abstractions.
3. **Surgical Changes**:
   - Only touch lines necessary for the task. Zero unsolicited refactoring or formatting of neighboring legacy code.
4. **Feedback Loop First**:
   - Always establish a failing automated test or CLI reproduction probe before modifying production code to fix a bug.
5. **Stateless Repository**:
   - Never write cache, session data, or runtime logs into the git-tracked tree. Use externalized data directories.
6. **Safety & Security**:
   - Strictly avoid destructive Git operations (`push --force`, `reset --hard`, `clean -fd`).
   - Redact all tokens and secrets in logs as `<REDACTED>`.

## 🗺️ Progressive Context Pointers
- **Ambiguous Architecture / Trade-offs** ➔ Read `rules/01_cognitive_discipline.md`
- **Designing Modules / Seams / Adapters** ➔ Read `rules/02_architecture_and_deep_modules.md`
- **Authoring Prompts / Tech Summaries** ➔ Read `rules/03_controlled_language_and_prompts.md`
- **Building UI / HTML / Dashboards** ➔ Read `rules/04_ui_ux_information_architecture.md`
- **Interaction States / Navigation / Motion** ➔ Read `rules/08_interaction_and_motion.md`
- **Mobile / Emulator / Rendered-UI Verification** ➔ Read `rules/09_mobile_render_verification.md`
- **Task Decomposition / Agent-Team Delegation** ➔ Read `rules/10_agent_team_decomposition.md`
- **Debugging Bugs / Handling Secrets** ➔ Read `rules/05_forensic_debugging_and_guardrails.md`
- **Pull Requests / Reviews / Planning** ➔ Read `rules/06_governance_and_reviews.md`
- **Pre-Merge Audit / Red Lines** ➔ Read `rules/07_master_checklist_and_redlines.md`
