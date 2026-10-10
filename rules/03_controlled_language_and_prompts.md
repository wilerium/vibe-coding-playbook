# ✍️ 03. Controlled Technical Language & Prompts

**[English](03_controlled_language_and_prompts.md)** | **[简体中文](03_controlled_language_and_prompts.zh.md)**

> *"Words are, in my not-so-humble opinion, our most inexhaustible source of magic. Capable of both inflicting injury, and remedying it."* — Albus Dumbledore

---

## 🎯 The Core Problem: The "Prompt Drift" Trap

When prompting foundation models or writing agent system instructions, teams frequently commit critical mistakes:
1. **Conversational Fluff & Politeness**: Padding instructions with *"Could you please make sure to..."* and *"In this role, you will be a helpful assistant that..."*, which burns context tokens and degrades model attention.
2. **Run-on Sentences & Semicolons**: 50-word compound sentences with multiple subordinate clauses that confuse LLM attention mechanisms and increase hallucination rates.
3. **Cache Misses Through Synonym Rotation**: Inconsistently varying words across prompts (e.g., swapping `issue`, `defect`, `bug`, `problem`), which completely destroys LLM KV-cache reuse (Prefix Caching).
4. **Blind Faith in Schema Outputs**: Trusting that an LLM will return valid JSON matching an enum without runtime defensive unwrapping.

---

## 📜 Rule 3.1: ASD-STE100 Rules for Technical English
*(Attribution: ASD-STE100 Issue 9 European Aerospace Standard)*

**Core Mandate**: All system prompts, agent instructions, executive summaries, and architectural documentation must adhere to **Simplified Technical English**.

### The Core Constraints
1. **The 25-Word Sentence Cap**:
   - Every sentence must contain **25 words or fewer**.
   - If a sentence exceeds 25 words, break it into two atomic sentences.
2. **Active Voice and Imperative Verbs**:
   - **Mandatory**: Active voice with the subject performing the action.
   - Front imperative action verbs in instructions: `Verify`, `Extract`, `Parse`, `Isolate`, `Format`.
   - **Banned**: Passive voice (`The data was fetched by the service...`).
3. **The Semicolon Ban**:
   - Semicolons (`;`) are strictly forbidden in instructions and summaries. Use a period and start a fresh sentence.
4. **Single Instruction Per Sentence**:
   - Do NOT chain multiple operations with `and`, `while`, or `then`. State one clear directive per statement.
5. **No Marketing Fluff or Hype**:
   - **Forbidden words**: `blazing-fast`, `cutting-edge`, `revolutionary`, `seamless`, `effortless`, `insanely`, `smart`.
   - State the factual metric: e.g., `Latency is under 15ms`, `Memory footprint is 4MB`.

---

## 📜 Rule 3.2: Controlled Technical Chinese
*(Attribution: Localization & Technical Communication Standards)*

**Core Mandate**: When producing Chinese technical summaries, documentation, or prompts, adhere to rigorous controlled Chinese rules.

1. **The 30-Character Sentence Cap**:
   - Single sentences must not exceed 30 Chinese characters.
2. **Direct Action Verbs (Eliminate Nominalization)**:
   - **Banned (Nominalization)**: `对系统进行了配置操作`, `实现针对数据的拉取工作`.
   - **Mandatory (Direct Verb)**: `配置系统`, `拉取数据`.
3. **Standardized Status Prefixes**:
   - Use explicit brackets for operational lifecycles: `[处理中]`, `[待集成]`, `[待验证]`, `[已解决]`, `[无法复现]`.
   - Do not invent ambiguous descriptive phrases like `好像已经修复了` or `正在搞`.

---

## 📜 Rule 3.3: Deterministic Prompt Cache Optimization
*(Attribution: Anthropic & OpenAI Prefix Caching Best Practices)*

**Core Mandate**: Structure all prompts to achieve maximum KV-cache hit rates.

1. **Freeze the Prompt Prefix**:
   - Place long, static context (system rules, tool schemas, taxonomy dictionaries) at the absolute beginning of the prompt.
   - Keep this prefix bit-for-bit identical across requests. Never inject dynamic timestamps, request IDs, or variable usernames into the static prefix!
2. **Append Dynamic Data at the Tail**:
   - Dynamic user queries, target URLs, and specific payload data must only be appended at the very end of the prompt message sequence.
3. **Zero Synonym Rotation**:
   - Define a fixed Glossary / Taxonomy of terms for your domain.
   - Always use the exact canonical token. If the system calls it an `Entity`, never refer to it as an `Item`, `Record`, or `Object` elsewhere in the prompt.
4. **Economic & Latency Impact**:
   - Maximizing prefix cache hits reduces input token costs by up to **90%** and slashes Time-to-First-Token (TTFT) by **80%**.

---

## 📜 Rule 3.4: Deterministic AI Defensiveness

**Core Mandate**: Treat all LLM outputs as untrusted user input.

1. **Defensive Schema Unwrapping**:
   - Foundation models often wrap JSON inside markdown codeblocks (````json ... ````) or nested envelopes like `{"properties": {...}}` or `{"response": {...}}`.
   - Always unwrap defensive layers in your adapter code before validating with schemas (Pydantic / Zod).
2. **Deterministic Fallbacks for Classifications**:
   - Never rely solely on an LLM to classify critical safety-related domains or risk tiers.
   - Always run a hardcoded regex / keyword dictionary pass first.
   - If the deterministic rule triggers, override the model's semantic interpretation.
3. **Graceful Degradation on Malformed Output**:
   - If an LLM call fails or times out, the application must degrade gracefully to an offline heuristic fallback instead of throwing an unhandled exception.

---

## 🚨 Controlled Language & Prompt Checklist

- [ ] Are all instruction sentences capped at ≤ 25 words (English) or ≤ 30 characters (Chinese)?
- [ ] Is active voice strictly enforced with imperative action verbs fronted?
- [ ] Are semicolons and conversational fluff completely eliminated?
- [ ] Is the prompt prefix frozen and deterministic to maximize cache hits?
- [ ] Are dynamic variables isolated to the tail of the prompt?
- [ ] Are critical classifications protected by deterministic regex/dictionary overrides?
- [ ] Is the parser defensively unwrapping nested JSON envelopes and markdown backticks?
