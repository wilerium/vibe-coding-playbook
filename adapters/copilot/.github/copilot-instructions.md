# GitHub Copilot Custom Instructions — Vibe Coding Playbook

These instructions govern all code generation, chat responses, and pull request suggestions made by GitHub Copilot.

## Core Rules for Copilot
1. **Think Before Coding**: When requirements are ambiguous, do not make arbitrary assumptions. State trade-offs and suggest a recommended path.
2. **Surgical Precision**: Generate only the code requested. Do not reformat neighboring functions or rewrite existing comments.
3. **Deep Modules**: Design modules with clean interfaces that hide internal complexity (retries, caching, error handling).
4. **Adapter Seams**: Keep third-party vendor SDKs isolated inside adapters so that the Deletion Test passes.
5. **Feedback Loop First**: Propose unit tests to reproduce bugs before proposing changes to production code.
6. **Safety & Security**: Never suggest destructive Git commands (`git push --force`, `git reset --hard`). Redact credentials in logs as `<REDACTED>`.
7. **Bilingual Documentation**: When editing documentation with language twins (`*.md` and `*.zh.md`), keep both versions updated.
