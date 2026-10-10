# 🚨 07. Master Checklist & The Ten Red Lines

**[English](07_master_checklist_and_redlines.md)** | **[简体中文](07_master_checklist_and_redlines.zh.md)**

> *"Discipline equals freedom."* — Jocko Willink

---

## ⛔ The Ten Non-Negotiable Red Lines

These ten red lines are absolute. Any violation by a human developer or an AI coding agent must immediately halt the pull request, fail CI checks, and require remediation before proceeding.

```text
╔════════════════════════════════════════════════════════════════════════════════════╗
║                         THE TEN NON-NEGOTIABLE RED LINES                           ║
╠════════════════════════════════════════════════════════════════════════════════════╣
║  1. NO SILENT GUESSING        Never guess an ambiguous architecture or requirement.║
║  2. NO CODE EDITS WITHOUT REPRO Never edit business code without a failing test.   ║
║  3. NO UNSOLICITED REFACTORING Never reformat or clean up unrelated legacy code.   ║
║  4. NO BLEEDING SEAMS         Never couple core business logic to third-party SDKs.║
║  5. NO STATE IN CODE REPOS    Never store cache, session data, or logs in git.     ║
║  6. NO PLAINTEXT SECRETS      Never output unredacted tokens, cookies, or secrets. ║
║  7. NO DESTRUCTIVE FORCE GIT  Never execute push --force, reset --hard, or clean -f║
║  8. NO DOCUMENTATION DRIFT    Never leave language twins or docs out of sync.      ║
║  9. NO BLIND TEMPLATE TRUST   Never assume rendered markup succeeded without check.║
║ 10. NO PREDICTIVE OVERKILL    Never add unrequested flexibility or generic fluff.  ║
╚════════════════════════════════════════════════════════════════════════════════════╝
```

---

### Detailed Red Line Specifications

### 1. ❌ Red Line 1: No Silent Guessing
* **Violation**: Choosing an architectural approach, storage backend, or business interpretation without human confirmation when multiple valid choices exist.
* **Remediation**: Halt immediately. Compute the decision frontier. Batch up to 4 questions in a single round with explicit `(Recommended)` tags.

### 2. ❌ Red Line 2: No Code Edits Without Repro
* **Violation**: Modifying production code to "fix" a bug before establishing an automated test or minimal CLI probe that reliably reproduces the bug in red-light state.
* **Remediation**: Revert speculative edits. Author the failing reproduction test first.

### 3. ❌ Red Line 3: No Unsolicited Refactoring
* **Violation**: "Conveniently" reformatting whitespace, cleaning up neighboring old comments, or renaming variables outside the direct scope of the active task.
* **Remediation**: Discard unrelated diffs. Ensure every line in the diff traces back to the user's explicit objective.

### 4. ❌ Red Line 4: No Bleeding Seams
* **Violation**: Importing external cloud SDKs, payment gateways, or database drivers directly inside core business logic or presentation components.
* **Remediation**: Encapsulate the vendor behind an adapter interface that passes the Deletion Test.

### 5. ❌ Red Line 5: No State Inside Code Repos
* **Violation**: Hardcoding relative paths to write logs, cache files, temporary test outputs, or user configurations directly into the git repository tree.
* **Remediation**: Resolve all stateful paths through an Environment Manager to an external user data root.

### 6. ❌ Red Line 6: No Plaintext Secrets
* **Violation**: Printing Bearer tokens, private API keys, basic auth passwords, or session cookies in terminal logs, diagnostics, or commit messages.
* **Remediation**: Run deterministic credential sanitization to replace sensitive substrings with `<REDACTED>`.

### 7. ❌ Red Line 7: No Destructive Force Git Operations
* **Violation**: Running `git push --force`, `git reset --hard`, `git clean -fd`, `git checkout .`, `git branch -D`, or `git stash clear`.
* **Remediation**: Intercept via safety guardrail scripts. Treat developer working tree states as sacrosanct.

### 8. ❌ Red Line 8: No Documentation Drift
* **Violation**: Updating English documentation while leaving Chinese twins outdated, or modifying code contracts without updating user guides.
* **Remediation**: Commit code changes and synchronized bilingual documentation twins together in an atomic commit.

### 9. ❌ Red Line 9: No Blind Template Trust
* **Violation**: Assuming a template-rendered HTML, Markdown, or JSON file is valid simply because the generator script exited with code 0.
* **Remediation**: Run automated post-generation assertions verifying that zero error strings (e.g., `UndefinedError`, `Error rendering`) exist in the output.

### 10. ❌ Red Line 10: No Predictive Over-Engineering
* **Violation**: Introducing generic interfaces, dynamic plugin systems, abstract factory layers, or speculative configuration options for one-off features.
* **Remediation**: Strip code down to the simplest concrete implementation that cleanly solves the current problem.

---

## 📋 The Master Pre-Flight Checklist

Before opening a PR, tagging a release, or declaring a multi-step task complete, execute this comprehensive checklist:

### Phase A: Architecture & Code Quality
- [ ] Is every module deep (small interface, encapsulated complexity)?
- [ ] Does every external dependency sit behind an adapter passing the Deletion Test?
- [ ] Is the codebase strictly stateless with externalized data roots?
- [ ] Is the diff surgical with zero drive-by reformatting?
- [ ] Are all functions and variables named clearly according to project conventions?

### Phase B: Verification & Safety
- [ ] Did you create a reproducible test before fixing any bug?
- [ ] Are all unit tests, integration tests, and linters passing (100% green)?
- [ ] Were all destructive Git commands completely avoided?
- [ ] Are all terminal logs and error transcripts sanitized of secrets (`<REDACTED>`)?
- [ ] Did you verify that rendered templates contain zero silent errors?

### Phase C: Language & Prompts (If AI-assisted)
- [ ] Do all prompt instructions adhere to ASD-STE100 (≤ 25 words per sentence, active voice, no semicolons)?
- [ ] Are static prompt prefixes frozen to maximize KV-cache hit rates?
- [ ] Are schema parsers defensively unwrapping nested JSON envelopes?
- [ ] Are critical classifications backed by deterministic regex / dictionary rules?

### Phase D: Governance & Documentation
- [ ] Does the PR description declare Door Type (One-way vs Two-way) and Blast Radius?
- [ ] Does the PR include explicit Before and After verification evidence?
- [ ] Are documentation twins (`*.md` and `*.zh.md`) synchronously updated?
- [ ] Were tricky bug fixes or new architectural patterns recorded in lessons learned?

---

## 🛑 The "Stop the Line" (Andon Cord) Protocol

Whenever you, your peer, or an autonomous AI agent encounters:
1. Ambiguous requirements with competing trade-offs, OR
2. An unexpected failure in a previously passing test suite, OR
3. A potential violation of any of the Ten Red Lines:

**Pull the virtual Andon Cord**:
1. **Stop execution immediately**. Do NOT write speculative code or try to "hack around" the issue.
2. Formulate the exact facts observed.
3. Compute the decision frontier with a clear recommendation.
4. Present the decision to human reviewers before proceeding.
