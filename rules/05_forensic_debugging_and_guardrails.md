# 🔍 05. Forensic Debugging & Safety Guardrails

**[English](05_forensic_debugging_and_guardrails.md)** | **[简体中文](05_forensic_debugging_and_guardrails.zh.md)**

> *"Debugging is twice as hard as writing the code in the first place. Therefore, if you write the code as cleverly as possible, you are, by definition, not smart enough to debug it."* — Brian Kernighan

---

## 🎯 The Core Problem: The "Speculative Patch" Trap

When developers or agents debug under time pressure, they often fall into destructive patterns:
1. **Speculative Fixes (Shooting in the Dark)**: Altering business logic based on a hunch without proving root cause, causing silent regressions elsewhere.
2. **Accidental Credential Exposure**: Logging raw HTTP requests or dumping session memory into terminal transcripts or AI chat logs, exposing authorization tokens and private keys.
3. **Catastrophic State Destruction**: Running `git reset --hard` or `git checkout .` to "start over", which permanently wipes uncommitted human work or stashed context.
4. **Fragile CLI Setups**: Configuration scripts that prompt for secrets in plaintext or overwrite configs non-idempotently.

---

## 📜 Rule 5.1: Feedback Loop First (Red-Light Verification)
*(Attribution: Kent Beck & Matt Pocock `diagnosing-bugs`)*

**Core Mandate**: You are strictly forbidden from modifying production business code without first establishing a reproducible red-light feedback loop.

### The 4-Phase Diagnostic Cycle
1. **Phase 1: Isolate & Reproduce (Red Light)**:
   - Write a minimal failing unit test, curl command, or CLI script that reliably triggers the reported error.
   - Run it. Observe the failure. If it doesn't fail, you have not reproduced the problem.
2. **Phase 2: Forensic Root-Cause Analysis**:
   - Inspect stack traces and data flows. Distinguish between the **symptom** (where the exception exploded) and the **root cause** (where invalid state originated).
3. **Phase 3: Surgical Fix (Green Light)**:
   - Make the smallest possible change to production code to make the failing test pass.
   - Run the test loop. Verify that it now turns green.
4. **Phase 4: Regression Sweep**:
   - Run the complete project test suite to verify that zero collateral damage occurred.

---

## 📜 Rule 5.2: Deterministic Credential Redaction

**Core Mandate**: Never print or log plaintext credentials. All tokens, passwords, session cookies, and private keys must be sanitized to `<REDACTED>` before output.

### Redaction Patterns
Before emitting logs, printing terminal transcripts, or sending context to an LLM, run a deterministic sanitizer matching:
1. **Bearer Tokens**: `Bearer\s+[A-Za-z0-9_\-\.~+/]+=*` -> `Bearer <REDACTED>`
2. **API & Private Keys**: `(ghp_|gho_|sk-|AIza|token=)[A-Za-z0-9_\-]+` -> `$1<REDACTED>`
3. **Basic Auth Passwords**: `https?://([^:]+):([^@]+)@` -> `https://$1:<REDACTED>@`
4. **Sensitive Headers & Cookies**: `(Authorization|Set-Cookie|Cookie|token|password):\s*([^\r\n]+)` -> `$1: <REDACTED>`

```python
# Universal Deterministic Redaction Utility Example
import re

SENSITIVE_PATTERNS = [
    (re.compile(r"(Bearer\s+)[A-Za-z0-9_\-\.~+/]+=*", re.IGNORECASE), r"\1<REDACTED>"),
    (re.compile(r"((?:token|secret|password|apikey|api_key)\s*[:=]\s*['\"])[^'\"]+(['\"])", re.IGNORECASE), r"\1<REDACTED>\2"),
    (re.compile(r"gh[pousr]_[A-Za-z0-9_]{36,255}"), "<REDACTED_GH_TOKEN>"),
]

def redact_sensitive_text(text: str) -> str:
    if not text:
        return text
    for pattern, replacement in SENSITIVE_PATTERNS:
        text = pattern.sub(replacement, text)
    return text
```

---

## 📜 Rule 5.3: Multi-Stage CLI Wizard Architecture
*(Attribution: Matt Pocock `wizard`)*

**Core Mandate**: When building terminal setup tools or interactive CLI initialization scripts, follow a delightful, safe multi-stage pattern.

1. **Stage Indicators (`[Stage i/N]`)**:
   - Always display progress so the user knows where they are in the onboarding flow (e.g., `[Stage 1/4] Environment Detection`, `[Stage 2/4] Credentials`).
2. **Silent Secret Prompts**:
   - Never echo API keys or passwords to the terminal screen while typing. Use silent input modes (`read -s` in bash, or masked input in Node/Python).
3. **Confirmation Gates Before Disk Writes**:
   - Present a clear summary of all configuration settings before writing to disk.
   - Require explicit user confirmation (`Proceed with configuration? [y/N]`).
4. **Idempotent Upserts**:
   - Never wipe existing configuration files. Parse existing keys, preserve unrelated settings, and upsert only modified variables.

---

## 📜 Rule 5.4: Destructive Git Operations Interception Guardrail

**Core Mandate**: Autonomous agents and automation scripts must be physically intercepted from running destructive Git commands.

### Blacklisted Destructive Operations
The following commands are strictly prohibited in automated or AI-assisted sessions:
* `git push --force` or `git push -f`: Rewriting remote shared history.
* `git reset --hard`: Permanently discarding unstaged or committed local work.
* `git clean -fd`: Deleting untracked files and new directories without trash recovery.
* `git checkout .` or `git restore .`: Wiping working tree modifications.
* `git branch -D`: Force-deleting branches that may contain unmerged commits.
* `git stash clear`: Wiping all stashed working states.

### Pure Shell Guardrail Interceptor Pattern
Install a lightweight pre-tool or pre-execution interceptor in your toolchain:
```bash
#!/usr/bin/env bash
# Intercepts dangerous git invocations before execution
cmd="$*"

if [[ "$cmd" =~ git[[:space:]]+push[[:space:]]+.*(-f|--force) ]]; then
  echo "🚨 BLOCKED by Safety Guardrail: Force-push is strictly prohibited." >&2
  exit 1
fi

if [[ "$cmd" =~ git[[:space:]]+reset[[:space:]]+--hard ]]; then
  echo "🚨 BLOCKED by Safety Guardrail: git reset --hard destroys uncommitted work." >&2
  exit 1
fi

if [[ "$cmd" =~ git[[:space:]]+clean[[:space:]]+.*-f ]]; then
  echo "🚨 BLOCKED by Safety Guardrail: git clean -f permanently deletes untracked files." >&2
  exit 1
fi
```

---

## 🚨 Forensic Debugging & Safety Checklist

- [ ] Was a reproducible failing test/probe created BEFORE modifying production code?
- [ ] Did you observe the test fail (Red) and then verify it passes (Green) after the fix?
- [ ] Were all credentials, tokens, and cookies verified to be redacted (`<REDACTED>`) in logs?
- [ ] Did you avoid all destructive Git commands (`push --force`, `reset --hard`, `clean -fd`)?
- [ ] Do CLI setup wizards use silent input for secrets and idempotent writes?
- [ ] Did you execute a full regression test pass before concluding the triage?
