# 🧠 01. Cognitive Discipline & Decision Frontiers

> *"The first 90% of the code accounts for the first 90% of the development time. The remaining 10% of the code accounts for the other 90% of the development time."* — Tom Cargill

---

## 🎯 The Core Problem: The "Vibe Coding" Trap

When developers or AI agents work at rapid conversational speeds, they succumb to the **Vibe Coding Trap**:
1. **Silent Guesswork**: When a requirement is ambiguous, the agent guesses an approach, writes hundreds of lines of code, and only reveals the mismatch when the user tests the result.
2. **Scattered Trade-off Questions**: Asking piecemeal questions over multiple conversation turns, fatiguing human reviewers and stalling momentum.
3. **Diff Pollution**: While fixing a 2-line bug, the agent "helpfully" reformats whitespace, cleans up imports, or rewrites variable names across 15 files, making code review impossible.
4. **Premature Over-Engineering**: Adding abstract base classes, generic factory functions, and configuration knobs for features that were never requested.

---

## 📜 Rule 1.1: Think Before Coding (Decision Frontier Computation)
*(Attribution: Andrej Karpathy & Matt Pocock `grilling`)*

**Core Mandate**: You are strictly forbidden from silently choosing an architectural path or business interpretation when requirements have multiple viable options.

### The Decision Frontier Protocol
Before writing a single line of production code or creating files:
1. **Facts First (Search Local Context)**:
   - Check local files, configuration files, and existing tests first. Never ask the user for information already present in the workspace.
2. **Compute the Decision Frontier**:
   - The *Decision Frontier* represents the boundary of open decisions whose prerequisite assumptions have been resolved.
   - Do NOT ask questions whose answers depend on earlier, unmade decisions.
3. **Single-Round Batched Inquiries (Maximum 4 Questions)**:
   - Group all critical architectural choices into a single inquiry.
   - Present each question with clear numbered options.
4. **Mandatory Recommendation Tag**:
   - Every question must provide an explicit recommendation:
     `➡️ **Recommendation**: [Option X] (Recommended)`
   - State the trade-off rationale in one crisp sentence.
5. **The One-Word "Yes" Standard**:
   - Structure the prompt so that a human reviewer can reply with `"Yes"` or `"Proceed with defaults"` to approve the entire plan immediately.

### Anti-Pattern vs Best Practice Example
```markdown
❌ Anti-Pattern (Silent Guessing):
User: "Add a caching layer for user queries."
Agent: (Silently implements Redis without asking, even though the project uses SQLite and in-memory caches everywhere else.)

✅ Best Practice (Decision Frontier Grilling):
Agent: "I have analyzed the query workload. Before implementing the caching layer, here is the decision frontier:

1. Cache Storage Backend:
   [1] In-Memory LRU Cache (Zero dependencies, ideal for single-instance, transient data) (Recommended)
   [2] File-backed SQLite Cache (Persistent across restarts, zero network overhead)
   [3] External Redis instance (Distributed, requires external infrastructure)
   ➡️ **Recommendation**: [1] In-Memory LRU Cache because the app is currently a single-node service.

Reply 'Yes' to proceed with the recommendation, or specify your preferred option."
```

---

## 📜 Rule 1.2: Simplicity First (Occam's Razor for Code)
*(Attribution: Andrej Karpathy)*

**Core Mandate**: Solve the user's problem with the absolute minimum amount of code. Predictive flexibility is strictly prohibited.

1. **No Speculative Generics**:
   - Do not write generic types or abstract base classes for one-off features.
   - Write concrete code first. Abstract only when the third distinct concrete use case appears (Rule of Three).
2. **No Unrequested Configuration Knobs**:
   - Hardcode sane defaults initially unless the user explicitly requested dynamic configuration.
   - Do not add CLI flags, environment variables, or config fields "just in case".
3. **The 50 vs 200 Soul-Searching Question**:
   - Before presenting code, ask: *"Would a principal engineer look at this and say it is over-engineered?"*
   - If a solution can be implemented reliably in 50 lines, it is an engineering failure to deliver 200 lines.

---

## 📜 Rule 1.3: Surgical Changes (Diff Purity)
*(Attribution: Andrej Karpathy)*

**Core Mandate**: Only touch what you must touch. Only clean up what you introduced.

1. **The Diff Traceability Test**:
   - Every single line in your `git diff` must be directly traceable to the user's prompt or bug report.
2. **No "Drive-By" Refactoring**:
   - **ABSOLUTELY FORBIDDEN**: Reformatting surrounding code, sorting unrelated imports, fixing typos in unrelated comments, or modernizing syntax in neighboring functions while working on a feature.
   - Even if the legacy code is an eyesore, leave it alone. Unsolicited edits obscure review diffs and risk breaking subtle historical invariants.
3. **Mimic Existing Conventions**:
   - Adopt the project's prevailing indentation, naming conventions, and file structure, even if it contradicts your personal stylistic preferences.
4. **Clean Your Own Trash**:
   - Remove any temporary debug logs, print statements, exploratory scripts, or unused imports introduced during your session.

---

## 📜 Rule 1.4: Goal-Driven Execution & Micro-Verification
*(Attribution: Kent Beck)*

**Core Mandate**: Convert vague imperative tasks into verifiable goals with explicit pass/fail checks.

1. **Define Verification Before Implementation**:
   - Transform *"Add validation to user email input"* into:
     - `[Step 1]` Write test for malformed email -> verify: test fails (Red).
     - `[Step 2]` Implement validation regex -> verify: test passes (Green).
     - `[Step 3]` Run existing auth test suite -> verify: 0 regressions.
2. **Micro-Verification Loop Plan**:
   - For multi-step tasks (3 or more steps), formulate an explicit plan:
     ```text
     [Step 1: Scaffolding] -> verify: file exists and exports expected symbol
     [Step 2: Core Logic]  -> verify: unit test passes
     [Step 3: Integration] -> verify: CLI command returns exit code 0
     ```

---

## 🚨 Cognitive Discipline Checklist

- [ ] Was the decision frontier computed before choosing between non-trivial architectures?
- [ ] Were inquiries batched in a single turn with explicit recommendations?
- [ ] Can every single line in the diff be traced back to the user's objective?
- [ ] Was unsolicited refactoring or reformatting of neighboring code completely avoided?
- [ ] Is the solution implemented with minimal lines without premature abstractions?
- [ ] Did you clean up all temporary test files, debug logs, and exploratory artifacts?
