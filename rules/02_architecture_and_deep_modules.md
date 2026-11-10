# 🏛️ 02. Architecture Patterns & Deep Modules

**[English](02_architecture_and_deep_modules.md)** | **[简体中文](02_architecture_and_deep_modules.zh.md)**

> *"Modules should be deep: the best modules provide powerful functionality yet have simple interfaces."* — John Ousterhout, *A Philosophy of Software Design*

---

## 🎯 The Core Problem: The "Shallow Module" Trap

In fast-paced AI-assisted development, a common failure mode is generating **Shallow Modules**:
* Classes or functions that are thin, leaky wrappers around external libraries.
* Interfaces that expose 20 parameters, configuration flags, and low-level internal data structures to the caller.
* Direct coupling: business logic calls external vendor SDKs directly throughout the codebase, making replacement a multi-week nightmare.
* Stateful pollution: writing logs, cache databases, and temporary artifacts directly into the git-tracked codebase.

---

## 📜 Rule 2.1: The Deep Module Principle
*(Attribution: John Ousterhout)*

**Core Mandate**: Maximize module depth. Hide complex mechanics behind simple, intuitive interfaces.

### The Depth Metric
$$\text{Module Depth} = \frac{\text{Encapsulated Implementation Complexity}}{\text{Exposed Interface Complexity}}$$

* **Deep Module (Ideal)**: An interface that is small and simple, yet encapsulates immense internal value (retry policies, fallback logic, rate-limit backoffs, schema validation, error normalization, and caching).
* **Shallow Module (Anti-Pattern)**: An interface that requires the caller to understand internal mechanics, pass numerous knobs, and handle low-level exceptions.

### Structural Comparison
```typescript
// ❌ Shallow Module Anti-Pattern:
// Caller must know HTTP details, headers, pagination tokens, and JSON decoding
class UserFetcher {
  async fetch(url: string, headers: Record<string, string>, pageToken?: string): Promise<RawHttpResponse> { ... }
}

// ✅ Deep Module Best Practice:
// Minimal interface. Encapsulates caching, token renewal, backoff retries, and data parsing.
interface UserService {
  getUser(userId: string): Promise<User>;
}
```

---

## 📜 Rule 2.2: Seams Golden Rules & The Deletion Test
*(Attribution: Michael Feathers, Martin Fowler & Eric Evans)*

**Core Mandate**: A seam is an expensive architectural option. Buy it only where the world is dangerous, non-deterministic, or genuinely polymorphic. Everywhere else, arrange code so the option was never needed.

### 1. Seams vs Enabling Points
* **Definition**: A **seam** is a place where you can alter program behavior without editing in that place.
* **The Enabling Point**: Every seam requires an *enabling point* outside the seam itself where the actual choice is bound. An interface with no external enabling point is an imaginary seam—pure indirection overhead.
  ```python
  # ❌ NOT a seam - Mailer is an interface, but nothing outside this class can change it
  class InvoiceMailer:
      def __init__(self):
          self.mailer: Mailer = SmtpMailer("smtp.service.internal")

  # ✅ A REAL seam - enabling point is at the constructor call site
  class InvoiceMailer:
      def __init__(self, mailer: Mailer):
          self.mailer = mailer
  ```

### 2. The Two-Adapter Law
> **"One adapter means an imaginary seam. Two adapters prove a real one."**

* Never introduce an abstract interface or port unless at least two concrete adapters are genuinely justified today (e.g., a production HTTP adapter and an in-memory test stand-in).
* The single-adapter pattern (`IUserService` with only `UserServiceImpl`) is architectural bloat driven by cargo-cult mocking.

### 3. The Seam Decision Procedure (Evaluate in Order, Stop at First Match)
1. **Touches non-determinism or external process boundaries** (clock, randomness, network, filesystem, database, third party)? $\to$ **Add Seam.**
2. **Effect is irreversible or costly** (email/SMS, card payments, deletion, public publishing, metered APIs)? $\to$ **Add Seam.**
3. **Behavior genuinely varies in production *today*** (multi-tenant, multi-cloud, feature-flagged)? $\to$ **Add Seam.**
4. **Rescuing legacy code with no existing test harness**? $\to$ **Add Temporary Seam** (mark for removal after refactoring).
5. **Can you separate the decision from the effect and test the decision as a pure function**? $\to$ **DO NOT add seam. Untangle instead.**
6. **Otherwise** $\to$ **DO NOT add seam. Use the concrete implementation directly.**

### 4. Untangle Instead of Injecting (Functional Core, Imperative Shell)
When tempted to inject a seam, check if a pure decision is welded to an I/O effect. Untangling them eliminates the need for mock-heavy interfaces:
```python
# ❌ Before: One tangled method requiring three injected seams & complex mocks
def send_overdue_notices(self):
    for invoice in self.repo.due_before(self.clock.now()):
        self.mailer.send(invoice.email, render(invoice))

# ✅ After: Pure functional decision (0 seams, test with list & date), trivial shell
def notices_to_send(invoices, today):   # Zero seams; pure calculation
    return [Notice(i.email, render(i)) for i in invoices if i.due < today]

def run(repo, mailer, clock):           # 3 lines of glue; simple integration test
    for n in notices_to_send(repo.all(), clock.now()):
        mailer.send(n.to, n.body)
```
*The architectural goal is not more seams. It is fewer seams protecting more pure code.*

### 5. The Deletion Test
> **Definition**: If you completely delete an external vendor, database engine, or cloud service today and replace it with an alternative, **does your core business logic or test suite need to change?**

* If the answer is **Yes**, your module has failed the Deletion Test.
* If the answer is **No** (only the isolated adapter file changes), your seam is architecturally sound.

### 6. Testing Strategy: Replace, Don't Layer
* When shallow modules are deepened, old unit tests asserting on internal plumbing become obsolete waste. **Delete them.**
* Write new tests strictly at the deepened module's public interface. **The interface is the test surface.**
* Tests must survive internal refactoring without changes. If a test breaks when implementation changes but behavior remains identical, it was testing past the interface.

---

## 📜 Rule 2.3: Stateless Repository Architecture
*(Attribution: The Twelve-Factor App)*

**Core Mandate**: The code repository is strictly **Stateless**. Code and ephemeral assets must never mix.

1. **No Runtime State Inside Git**:
   - Never write cache files, SQLite databases, runtime logs, or user session state into the project repository tree.
   - Hardcoding relative paths like `"logs/"`, `"state/"`, or `"cache/"` is strictly prohibited.
2. **Centralized Environment & Data Root**:
   - Resolve all mutable paths through an Environment Manager (`get_data_root()`).
   - Store user configuration, logs, and caches in a dedicated user-level or system-level directory (e.g., `~/AppNameData/` or `$XDG_DATA_HOME/app_name`).
3. **Benefits of Externalized Data**:
   - Running `git clean -fd` or switching branches will never destroy user data or active configurations.
   - Updating code via `git pull` or container rebuilding is 100% idempotent and zero-risk to state.

---

## 📜 Rule 2.4: Golden Cache & Offline-First Engineering

**Core Mandate**: Develop with offline-first resilience. Build fast local feedback loops that do not depend on remote network availability.

1. **Golden Cache for Millisecond Feedback Loops**:
   - Support a local data replay / golden cache mode.
   - Once data is fetched from an external API, allow serializing the final normalized artifact to a local snapshot.
   - Subsequent runs during UI development or business logic debugging can replay the golden cache, providing instant feedback without network latency, rate limits, or costs.
2. **Air-Gapped & File-Protocol Compliance**:
   - When building offline documentation, tools, or exported dashboards, never rely on runtime `fetch("data.json")` calls that violate browser CORS policies under `file:///` protocols.
   - Compile data into self-contained static payloads (`window.APP_DATA = {...}`) or embed assets directly.

---

## 📜 Rule 2.5: Code as the Engine, Markdown as the Brain
*(Attribution: The Unix Philosophy)*

**Core Mandate**: Keep business rules, taxonomies, and behavioral prompts out of procedural code.

1. **Procedural Logic vs Declarative Rules**:
   - Python / TypeScript / Go code should act as a reliable, high-performance execution engine (I/O, network, caching, rendering).
   - Domain policies, triage heuristics, classification taxonomies, and prompt directives should live in declarative, human-readable Markdown or YAML files.
2. **Zero-Deploy Rule Updates**:
   - Non-engineers and domain experts must be able to tune classification thresholds, add categories, or refine prompts by editing a Markdown file without recompiling or redeploying code.

---

## 🚨 Architecture Checklist

- [ ] Does the module hide complex implementation behind a clean, minimal interface?
- [ ] Are seams justified by the Two-Adapter Law (no single-implementation speculative interfaces)?
- [ ] Were pure decisions untangled from I/O effects before reaching for dependency injection?
- [ ] Does the external dependency pass the **Deletion Test**?
- [ ] Is third-party vendor code restricted entirely to adapter layers?
- [ ] Is the git repository completely stateless (zero runtime logs/cache in the tree)?
- [ ] Are file paths resolved via a centralized environment manager rather than hardcoded relative strings?
- [ ] Can the system be tested or developed offline using local golden fixtures?
- [ ] Are domain rules and prompt definitions stored in external declarative files rather than hardcoded strings?
