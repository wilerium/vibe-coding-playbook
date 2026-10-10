# ⚖️ 06. Governance, Two-Axis Review & Wayfinding

> *"You can't inspect quality into a product, you have to build it in."* — W. Edwards Deming

---

## 🎯 The Core Problem: The "Decision Fog & Chaotic PR" Trap

In fast-paced, multi-session engineering environments:
1. **Unclear Operational Risk**: PRs are opened without declaring whether changes are easily reversible or involve irreversible state migrations.
2. **Conflated Code Reviews**: Reviewers mix up checking basic repository standards (linting, file layout, data isolation) with auditing functional requirement compliance, leading to superficial reviews.
3. **Multi-Session Decision Fog**: Large initiatives stall across multiple sessions because teams begin writing code before charting out foundational architectural dependencies.
4. **Documentation Desynchronization**: Code evolves while documentation, architecture diagrams, and multi-language translations rot, creating documentation drift.

---

## 📜 Rule 6.1: One-Way vs Two-Way Doors & Blast Radius
*(Attribution: Jeff Bezos Amazon Shareholder Letters)*

**Core Mandate**: Every architectural proposal and Pull Request must explicitly declare its **Door Type** and **Blast Radius**.

### 1. Door Type Classification
* **Two-Way Door (Reversible)**:
  - Changes that can be undone quickly with zero residual data corruption or downtime.
  - *Examples*: Pure UI styling updates, internal helper functions, unit tests, reversible business logic.
  - *Action*: Empower fast execution with minimal review ceremony.
* **One-Way Door (Irreversible / High Stakes)**:
  - Changes that alter database schemas, rewrite baseline snapshots, modify public API contracts, or mutate external remote state.
  - *Action*: Requires explicit architectural pre-flight review, rollback plans, and strict verification.

### 2. Blast Radius Assessment
* **Isolated**: Confined to a single script, utility, or standalone component.
* **Pipeline-Wide / Subsystem**: Affects an entire business pipeline, ingestion flow, or major feature module.
* **Global**: Touches shared core engines, database connections, CLI dispatchers, or top-level authentication.

---

## 📜 Rule 6.2: Structured Pull Request Review Template

**Core Mandate**: Standardize all PR descriptions with explicit proof and risk declarations.

```markdown
## Summary
<Concise description of the change, architectural rationale, and component flow>

## Evidence
- **Before:** <Screenshot of baseline / failing test output / error log>
- **After:**  <Screenshot of updated UI / passing test suite output / verified CLI log>

## Merge Danger & Blast Radius
- **Door Type**: `Two-way Door` (Reversible) OR `One-way Door` (Irreversible migration/state change)
- **Blast Radius**: `Isolated` (Single component) | `Subsystem` (Pipeline-wide) | `Global` (Core framework)
- **Rollback Plan**: <Exact steps to revert if an incident occurs>

## Knowledge Integration
- **Lessons Learned**: <Did this resolve a tricky pitfall? Added to lessons learned doc?>
- **Documentation Sync**: <Are documentation and multi-language twins updated synchronously?>
```

---

## 📜 Rule 6.3: Two-Axis Code Review
*(Attribution: Matt Pocock `code-review`)*

**Core Mandate**: Separate code review into two orthogonal evaluation axes to ensure thoroughness.

```
                         ▲ Axis 2: Functional Spec (Requirements)
                         │
     "Technically sound, │  🎯 IDEAL PULL REQUEST
      wrong business     │  (Passes both axes with
      behavior"          │   strong evidence)
                         │
  ───────────────────────┼────────────────────────► Axis 1: Engineering Standards
                         │                          (Surgical diff, Deep modules,
     ❌ REJECT           │  "Meets the requirements,
     (Fails on both      │   but violates architecture
      axes)              │   and pollutes codebase"
                         │
```

### Axis 1: Engineering Standards & Safety (The Health Axis)
- **Surgical Diff**: Does the PR contain zero unsolicited refactoring or whitespace noise?
- **Data Isolation**: Does the code keep the repository strictly stateless?
- **Language & Types**: Does the code adhere to strict type checking and language standards?
- **Seams & Modules**: Are external dependencies properly adapted and hidden?

### Axis 2: Functional Specification (The Requirement Axis)
- **Fidelity**: Does the implementation satisfy 100% of the requested business logic?
- **Edge Cases**: Are null states, empty collections, timeouts, and boundary conditions tested?
- **Zero Scope Creep**: Did the PR avoid introducing unrequested features or premature flexibility?

---

## 📜 Rule 6.4: Multi-Session Initiative Wayfinding
*(Attribution: Matt Pocock `wayfinder`)*

**Core Mandate**: Chart complex, multi-PR initiatives into a Directed Acyclic Graph (DAG) of atomic Decision Tickets before coding.

```text
Decision Ticket DAG Example:
[Ticket 1: Core Domain Entity Schema] ──► [Ticket 2: Storage Adapter Interface]
                                                     │
                                                     ▼
[Ticket 3: In-Memory Implementation]  ◄─── [Ticket 4: Database Driver Adapter]
              │
              ▼
[Ticket 5: REST API / CLI Dispatcher]
```

### The Wayfinding Rules
1. **Decision Tickets Before Code Tickets**:
   - Resolve prerequisite architectural questions first.
   - Never write code for downstream features while foundational schemas remain unconfirmed.
2. **Context Independence**:
   - Each ticket in the DAG must contain sufficient context so that a fresh engineer (or clean agent session) can execute it without prior memory.
3. **Atomic Verification**:
   - Each ticket must have an independent, automated verification gate.

---

## 📜 Rule 6.5: Documentation Twin Synchronization

**Core Mandate**: Any modification to user-facing guides, API specs, or PRDs must be updated synchronously across all supported languages (e.g., `README.md` and `README.zh.md`) in a **single atomic commit**.

* Asynchronous documentation updates are strictly forbidden.
* Stale documentation is worse than no documentation.
* The pre-commit or CI pipeline must enforce parity across language files.

---

## 🚨 Governance Checklist

- [ ] Does the PR explicitly state its Door Type (One-way vs Two-way) and Blast Radius?
- [ ] Is concrete Before and After evidence provided in the PR description?
- [ ] Has the review evaluated both Axis 1 (Standards) and Axis 2 (Functional Spec)?
- [ ] Are multi-session initiatives mapped into a DAG of decision tickets before coding?
- [ ] Are all documentation twins updated synchronously in the same commit?
- [ ] Is an explicit rollback plan defined for any One-way Door changes?
