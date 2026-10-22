# 🧩 10. Task Decomposition & Agent-Team Delegation

**[English](10_agent_team_decomposition.md)** | **[简体中文](10_agent_team_decomposition.zh.md)**

> *"Adding manpower to a late software project makes it later."* — Fred Brooks, *The Mythical Man-Month*

---

## 🎯 The Core Problem: The Hero Run and the Theatre Team

A capable agent can now do a great deal alone. That produces two opposite failures, plus three ways the work still goes wrong:

1. **The hero run**: one agent grinds through a request with two independent deliverables, two repositories, and two acceptance criteria. It runs out of context halfway and reports success on the half it still remembers.
2. **The theatre team**: a single-file edit is split across five teammates. Each rebuilds the same context, the Lead spends more time arbitrating than writing, and total wall clock is longer than doing it once.
3. **Collisions**: two "parallel" tasks write the same index file. The second write silently overwrites the first, and nobody notices until review.
4. **The unwitnessed completion**: the writer of the change also declares it done. No second agent ran the acceptance command, so a broken deliverable ships as finished.
5. **The abandoned fan-out**: work is dispatched, the final answer goes out, and one background job is still running. Its output never reaches the answer.

**Core mandate**: delegation is an engineering decision with a measurable cost. Decompose only when the parallel gain exceeds the coordination overhead, and close every dispatched unit before answering.

---

## 📜 Rule 10.1: Decomposition Verdict Before Action

Before the first write of any request, emit exactly one verdict line. Not a plan essay.

```text
Decomposition verdict: single agent | team (N tasks) — <reason>
```

**Size threshold** (the verdict applies to **every** request; any one of these holds, it must be judged seriously, and "this counts as trivial" is not an available exemption):
- The expected change spans two or more files, or two or more directories.
- Two or more distinct acceptance commands are needed, or the same command run twice independently.
- The work spans two or more repositories.
- The deliverables include both writes and read-only research.

**Mandate**:
- Emit the line before touching any file, for any request that spans more than one file, one deliverable, or one acceptance criterion.
- When no criterion holds, write `single agent`. Do **not** write `team (1 task)` to hedge. The verdict is routing, not an alibi.
- Name the deciding evidence in the reason: the satisfied criteria of Rule 10.2, or the cost of Rule 10.3 that rules a team out.
- Keep it to one line. The verdict is a routing decision, not a design document. Design belongs in the task ticket.
- Re-emit the line only when scope changes materially, and state what changed.

**Anti-pattern**:
- A long plan substituted for the verdict. A plan never states who does the work.
- Declaring `team (4 tasks)` and then doing all four alone. The verdict then only adds noise.
- Emitting no verdict on a multi-deliverable request, then meeting the split problem at the third file.

---

## 📜 Rule 10.2: The Parallelizability Test

**Core mandate**: team up only when the work is genuinely parallel. Count the criteria; do not feel them.

| # | Criterion | Signal that it holds |
| :--- | :--- | :--- |
| a | Two or more independent intents or deliverables | Two different "done" sentences are needed |
| b | Physically disjoint write scopes | Different repositories, directories, or file sets |
| c | Different acceptance criteria | Each unit needs its own command and its own exit code |
| d | Read-only research that runs beside the writes | A survey, audit, or source read that blocks no write |
| e | Long serial work that can overlap | Two long serial chains that share no resource |

**Threshold**: at least two criteria hold **and** the coordination cost gate of Rule 10.3 passes, then delegate.

**Counter-criteria** — any one of these forces a single agent. **The scope is the unit, not the request**:

| # | Counter-criterion | Why it forces a single agent |
| :--- | :--- | :--- |
| i | One file, one intent | Parallel gain is zero; merge cost is not |
| ii | The change fits inside one agent turn | Context rebuild exceeds the work itself |
| iii | Step N+1 strictly depends on step N | The units are a sequence, not a team |
| iv | The unit needs to delegate its own teammates | Nested delegation multiplies coordination cost |

> **Fields like `delegate_depth` are self-reported, not observed.** A script cannot see the real delegation behaviour: whether a teammate quietly delegated again is only discoverable by the verifier under Rule 10.5. Counter-criterion iv rests on the **verifier**, not on the gate.

**Priority arbitration (removes ambiguity; hard rule)**:
1. **Counter-criteria outrank criteria.** When both hold on the same unit, the counter-criterion decides.
2. **A counter-criterion rules out only the unit it hits, never the whole request.** When two units of a request are strictly ordered (iii), merge those two into one unit; leave the rest parallel. Do **not** cite iii to demote a multi-deliverable request to a single agent.
3. Write `single agent` only when merging reduces the unit count to one; otherwise write `team (remaining unit count)`.
4. **Merging may not cross independent intents.** Two units may merge only when the output of the earlier is the input of the later. Being merely "related" or "on the way" is not a dependency. **The count of independent intents is a lower bound on the merged unit count**: however many deliverables are produced independently, that many units remain at least.

**Mandate**:
- Evaluate the criteria against the actual work, not the wording of the request. One paragraph can still hold three independent deliverables.
- State the satisfied count in the verdict reason, for example `team (3 tasks) — criteria a, b, c`.
- Treat research beside writes as a first-class criterion. A read-only survey that unblocks later decisions is parallel work.

**Anti-pattern**:
- Counting "the user asked for a team" as a criterion. Intent is not a criterion.
- Calling sequential steps parallel because they touch different files. Dependency order defeats disjointness.
- Splitting along the paragraphs of the request instead of along the deliverables.

---

## 📜 Rule 10.3: The Coordination Cost Gate

**Core mandate**: delegation has a fixed cost. When the saved time is smaller than that cost, do the work yourself.

| Fixed cost | Paid by | Typical shape |
| :--- | :--- | :--- |
| Context rebuild | Each teammate | Re-reading the sources the Lead already read |
| Write-scope arbitration | Lead | Deciding who owns which file, then policing it |
| Harvest and review | Lead | Collecting reports, running acceptance commands, reconciling |
| Integration | Lead | Merging units that drifted apart while running |

**Mandate**:
- Estimate saved wall clock and overhead before dispatching. State both in one sentence when the margin is thin.
- Name the overhead you expect. If you cannot name it, you cannot bound it.
- Choose the single agent when the two numbers are close. Ties go to the cheaper option.
- Never delegate to appear professional. A solo run that ships beats a team that coordinates.

**Anti-pattern**:
- Delegating a one-file edit.
- Fanning out a task that fits in one agent turn.
- Splitting work, then re-reading every unit yourself to reconcile it. That is the overhead paid twice.

---

## 📜 Rule 10.4: Disjoint Write Scopes

**Core mandate**: every task ticket declares its write scopes. Overlap is a warning, not a lock, so the Lead must split the work physically.

**Mandate**:
- Declare write scopes as path prefixes on the ticket, before any teammate starts.
- One writer per file at a time. Two writers on one file means one of them loses.
- Treat shared index files, changelogs, and dependency manifests as a single-owner zone. Assign them to one writer, or serialize the tasks that touch them.
- When two units must touch the same file, order them with an explicit dependency and merge the second after the first completes.
- Re-read a file before writing it when a peer may have written it since your last read.

**Mechanical check (do not rely on self-discipline)**: hand the ticket set to a gate script and turn "may the work be split this way" into an exit code.
Interface contract: the script reads a ticket array (each ticket carrying `write_scopes`, `acceptance`, `owner`, `verifier`) and may also accept the verdict line; exit `0` = legal and dispatchable / `2` = violation / `3` = incomplete fields or script failure (**fail-closed**).
It mirrors the commit-gate script of Rule 6.5. **A gate without a script is only an honour system.**

The gate should try to cover **both ends**, but the two ends are **not equally strong**, and that must be stated plainly:
- **Downstream "is the split legal" (strong)**: pairwise write-scope overlap (compared after `realpath` and case folding), `owner != verifier`, `acceptance` that is not a platitude, nested delegation.
- **Upstream "should this be split at all" (weak: only three mechanical signals)**:
  1. Any ticket spanning two or more top-level areas triggers a warning (the mechanical signal of a solo run; threshold aligned with criteria a and b);
  2. A task count declared in the verdict that disagrees with the number of tickets triggers a warning;
  3. When the gate is granted read access to the actual version-control changes (a `git diff`-style source), the measured changes are subjected to a **coverage test** against the self-reported `write_scopes`, and uncovered changes are reported as an audit note; **this does not block by default** (a working tree often holds another session's leftovers, and constant blocking trains people to bypass the gate), and blocks only under an explicit strict mode. When that source is unavailable the gate must be **fail-closed** and must not silently skip.
- **What upstream still misses, stated honestly**: an executor who writes "this is a single agent" from the outset, creates one ticket, and declares a single-area write scope leaves the gate **nothing to contradict**, because every input it holds was supplied by that same executor. **Only the independent verifier of Rule 10.5 can cover this layer; it must not be claimed as mechanically blocked.**

**A gate cannot replace judgement**: it reads signals only from tickets you already wrote down, and cannot read thoughts you never recorded. The verdict itself is still emitted by the executor; the gate only checks that the verdict and the tickets agree. **Judge first, ticket second, gate third.**

**Anti-pattern**:
- Assuming the tool prevents collisions. It reports them; it does not prevent them.
- Declaring two tasks independent when both edit the same README.
- Discovering the overlap after both units have written. The second write is now a silent revert.

---

## 📜 Rule 10.5: Independent Verdict

**Core mandate**: the writer never declares completion. A verdict comes from another agent and carries the raw output of an executable command.

**Mandate**:
- Attach the acceptance command to the ticket. A criterion a reviewer cannot run is not a criterion.
- The verdict states one of `PASS`, `FAIL`, `BLOCKED`, `NOT DELIVERED`, plus the command's raw output and exit code.
- The verifier runs the command itself. A verifier that only reads the writer's summary has verified nothing.
- Keep the verifier context separate from the writer context. Independence is a property of the run, not of the job title.
- When no second agent is available, attach the raw output anyway and close the verdict as `BLOCKED — unverified`. Never label it `PASS`.

**Anti-pattern**:
- "Done" with no exit code.
- A verifier that re-reads the diff and agrees with it.
- The writer and the verifier being the same context with a different label.

---

## 📜 Rule 10.6: Harvest and Close

**Core mandate**: nothing is finished until every dispatched unit has reported and every background job is collected or cancelled.

**Mandate**:
- Before the final answer, list every teammate and every background job started for this request.
- Collect the output of each still-relevant job. Cancel the jobs that stopped mattering, and state that you cancelled them.
- Give every task ticket an explicit conclusion: `PASS`, `FAIL`, `BLOCKED`, or `NOT DELIVERED`. An open ticket is not a conclusion.
- Include failed and blocked units in the answer. A silently dropped unit reads as success.
- Re-list the units after a wait or a timeout. A timeout is not a result.

**Anti-pattern**:
- Shipping the final answer while a job is still running.
- Leaving a ticket in progress because the work "mostly" landed.
- Reporting the three units that passed and omitting the one that failed.

---

## 📜 Rule 10.7: Anti-Patterns

**Core mandate**: name the failure shape, then name the alternative. A delegation rule that only forbids is not usable.

| Anti-pattern | Symptom | Correct action |
| :--- | :--- | :--- |
| Committee for one file | Three agents, one file, one intent | Single agent (Rule 10.2 counter-criterion i) |
| Fan-out without harvest | Units dispatched, answer shipped, jobs orphaned | Harvest per Rule 10.6 first |
| "Parallel" tasks on one file | Second write silently reverts the first | Disjoint scopes per Rule 10.4 |
| Delegating to avoid reading | Teammate asked to summarize a source the Lead never opened | Read it first, then decide (Rule 10.3: who pays context rebuild) |
| Double work | Lead dispatches, then redoes the unit | Pick one owner and let the verdict close it (Rule 10.5) |
| Delegation as status | Team size reported as progress | Apply the Rule 10.3 cost gate |
| Unbounded depth | Teammates delegating their own teammates | One delegation level per request (Rule 10.2 counter-criterion iv) |
| Ticket without acceptance | "Make it better" dispatched as work | Executable command per Rule 10.5 |

**Mandate**:
- **Every row in this table is a binding constraint, not merely an example.** A row annotated with a clause number takes its force from that clause; unannotated rows are bound directly by this Rule 10.7.
- When you catch one of these in your own run, state which row applies and correct it in the same turn.
- Prefer the smallest unit that can still hold an independent verdict.

**Anti-pattern**:
- Naming the anti-pattern without changing the plan.
- Adding a new rule for every incident. Extend the table instead.

---

## 🤖 Prompt Templates for AI Agents

**T1 — Verdict before work**

> Before you edit anything, emit one line: `Decomposition verdict: single agent | team (N tasks) — reason`. The reason must name the Rule 10.2 criteria that hold, or the Rule 10.3 cost that rules a team out. Do not write a plan instead.

**T2 — Write the task ticket**

> Write one ticket per unit. Include the goal, write scopes as path prefixes, the acceptance command with its expected exit code, and the dependency order against the other tickets. If two tickets share a path prefix, merge them or serialize them before dispatching.

**T3 — Harvest before answering**

> List every teammate and background job started for this request. For each, report its status, its raw acceptance output, and one of PASS, FAIL, BLOCKED, or NOT DELIVERED. Cancel anything that no longer matters. Do not answer until this table is complete.

**T4 — Guard clause for every delegation**

> The writer never declares completion. The verdict carries a command and its raw output. No file has two writers at the same time. No unit is dropped without a conclusion. No delegation without a named coordination cost.

---

## 🚨 Agent-Team Delegation Checklist

- [ ] Is a one-line decomposition verdict present before the first write?
- [ ] Was the Rule 10.1 size threshold applied, rather than a verbal claim that "this is trivial"?
- [ ] Does the verdict name the satisfied criteria or the ruling-out cost?
- [ ] Do at least two parallelizability criteria hold, and does the cost gate pass?
- [ ] Did the counter-criteria rule out only the units they hit, without demoting the whole request?
- [ ] Is there no nested delegation (a teammate must not delegate its own teammates)?
- [ ] Does every ticket declare write scopes as path prefixes?
- [ ] Is every file owned by exactly one writer at a time?
- [ ] Are shared index files, changelogs, and manifests single-owner or serialized?
- [ ] Does every ticket carry an executable acceptance command?
- [ ] Did an independent agent produce the verdict, with raw output and an exit code?
- [ ] Is every teammate and background job collected or cancelled before the answer?
- [ ] Does every ticket end in PASS, FAIL, BLOCKED, or NOT DELIVERED?

---

## ⚖️ Boundary with Rules 01, 06, and 07

- **Rule 01 (Cognitive Discipline)** decides *whether* to ask the human and what to recommend. Rule 10 decides *who* executes the approved work.
- **Rule 06 (Governance)** classifies reversibility, blast radius, and review axes. Rule 10 consumes that classification: one-way doors stay with the Lead, two-way doors may be delegated.
- **Rule 07 (Master Checklist)** owns release red lines. Its current ten red lines do **not** cover delegation. Rule 10 constrains delegation independently, and recommends that a future revision of Rule 07 absorb one entry: no delegation without an independent verdict and a harvest.
