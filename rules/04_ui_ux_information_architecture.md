# 🎨 04. Industrial UI/UX & Information Architecture

**[English](04_ui_ux_information_architecture.md)** | **[简体中文](04_ui_ux_information_architecture.zh.md)**

> *"Simplicity is not the lack of clutter, that's a consequence of simplicity. Simplicity somehow essentially describes the purpose and place of an object and product."* — Jony Ive

---

## 🎯 The Core Problem: The "Generic AI Dashboard" Trap

When AI tools generate user interfaces, they typically fall into one of two extremes:
1. **Low-Density AI Slop**: Enormous cards with massive padding, giant stock illustrations, and very little actionable information. Users must scroll 5 screens to see 3 metrics.
2. **Raw JSON Dumps**: Dumping unformatted tables and dense technical logs with no visual hierarchy, making executive decision-making impossible.
3. **Fragile JavaScript in Email/Sandboxes**: Adding `<script>` tags for interactivity to reports sent via email or viewed in restricted web sandboxes, resulting in broken buttons and blank pages.
4. **Half-Baked Dark Mode**: Hardcoding hex color values like `#FFFFFF` or `#333333`, resulting in blinding white backgrounds or unreadable text when the user switches to dark mode.

---

## 📜 Rule 4.1: Instant Decision Hierarchy & Progressive Disclosure
*(Attribution: Jakob Nielsen & Nielsen Norman Group)*

**Core Mandate**: High data density paired with progressive disclosure. The user must be able to make a decision within the first 2 seconds of viewing any screen or card.

### The 2-Second Decision Standard
1. **Header Area (First 2 Seconds)**:
   - Visual Badge indicating status and state changes (e.g., `[🚨 NEW HIGH RISK]`, `[🔄 UPDATED]`).
   - Clear Title with direct link to the underlying ticket or resource.
   - Core Attribute Capsule Row: Color-coded pills for `Status`, `Severity`, `Owner`, and `Aging`.
2. **Progressive Disclosure Layers**:
   - **Layer 1 (Always Visible)**: Executive 1-Pager summary (Problem statement, Root cause, Immediate next action).
   - **Layer 2 (On-Demand Click to Reveal)**: Secondary details, similar items, related tickets, test suites.
   - **Layer 3 (Deep Accordion)**: Full stack traces, raw diagnostic logs, historical comment threads.

---

## 📜 Rule 4.2: Zero-Script Interaction (Pure CSS Checkbox Hack)
*(Attribution: Web Standards & Email Security Constraints)*

**Core Mandate**: When building interactive reports for email clients (Apple Mail, Outlook) or air-gapped sandboxes where `<script>` execution is forbidden, implement all expandable interactivity via **pure CSS**.

### The Pure CSS Checkbox Hack Pattern
```html
<!-- 1. Hidden native checkbox acts as the state container -->
<input type="checkbox" id="toggle-details-101" class="accordion-checkbox" style="display: none;" />

<!-- 2. Label styled as an interactive button -->
<label for="toggle-details-101" class="accordion-button">
  <span>🔍 Technical Stack Trace</span>
  <span class="chevron">▾</span>
</label>

<!-- 3. Sibling container expanded dynamically via CSS adjacent sibling selector -->
<div class="accordion-content">
  <pre><code>NullPointerException at ...</code></pre>
</div>
```

```css
/* CSS Rules */
.accordion-content {
  max-height: 0;
  overflow: hidden;
  transition: max-height 0.25s ease-out;
}

.accordion-checkbox:checked ~ .accordion-content {
  max-height: 2000px; /* Expands smoothly without JavaScript */
}

.accordion-checkbox:checked + .accordion-button .chevron {
  transform: rotate(180deg);
}
```

---

## 📜 Rule 4.3: Industrial Aesthetics & Apple HIG Craftsmanship
*(Attribution: Dieter Rams & Apple Human Interface Guidelines)*

**Core Mandate**: Create distinctive, production-grade interfaces with high craftsmanship that avoid generic AI aesthetics.

1. **Frosted Glass Textures**:
   - Translucent top bars and modal dialogs using backdrop blur:
     `background: var(--bg-glass); backdrop-filter: saturate(180%) blur(20px); -webkit-backdrop-filter: blur(20px);`
2. **Typography Sizing & Tight Kerning**:
   - Headers: High optical contrast, tight letter spacing (`letter-spacing: -0.025em`).
   - Code & Monospace: High legibility fonts (`SF Mono`, `JetBrains Mono`, `Fira Code`) at `12px` or `13px` with subtle line heights (`1.5`).
3. **Executive Spec HUD (Heads-Up Display)**:
   - For overview dashboards, use a Bento Box layout with prominent key metrics: large bold numbers (`32px` to `48px`) paired with a crisp, small-caps label (`11px`, `text-transform: uppercase`, `opacity: 0.6`).
4. **Semantic Callout Quotes**:
   - Style callouts with left accent borders and subtle tinted backgrounds:
     - ℹ️ **Note**: Blue accent border (`#0071e3`).
     - 💡 **Tip**: Green accent border (`#34c759`).
     - ⚠️ **Warning**: Orange accent border (`#ff9500`).
     - 🚨 **Critical**: Red accent border (`#ff3b30`).

---

## 📜 Rule 4.4: True Dark Mode Parity via CSS Variables

**Core Mandate**: Zero hardcoded hex colors. Full dark mode parity is mandatory across all views.

1. **CSS Variable Design Tokens**:
   - Define semantic color tokens at `:root` and override them inside `@media (prefers-color-scheme: dark)` or `[data-theme="dark"]`.
2. **OLED Pure Black for Dark Mode**:
   - Canvas / Body: Pure black `#000000` for OLED contrast.
   - Elevated Cards / Surfaces: `#1c1c1e` or `#2c2c2e`.
   - Borders: Subtle translucent white `rgba(255, 255, 255, 0.1)`.
   - Text Primary: `#ffffff` or `rgba(255, 255, 255, 0.92)`.
   - Text Secondary: `rgba(255, 255, 255, 0.56)`.

---

## 📜 Rule 4.5: Zero-Crash Template Assertions

**Core Mandate**: Never trust template generation logs blindly. Always verify rendered markup.

1. **The Silent Failure Trap**:
   - Template engines (Jinja, Mustache, EJS, React SSR) often catch rendering errors internally or render empty `<div>` tags while returning exit code 0.
2. **Automated Post-Render Assertion**:
   - After compiling or rendering any template, automated checks or test scripts must parse the resulting HTML file.
   - Assert that no error strings (such as `Error rendering`, `UndefinedError`, `null pointer`, or raw `{{ ... }}`) exist in the final output file.

---

## 🚨 UI/UX Checklist

- [ ] Does the interface achieve the 2-second decision standard (status, severity, and action visible immediately)?
- [ ] Are secondary details and raw logs hidden behind progressive disclosure controls?
- [ ] Is interactive toggling built with pure CSS (Checkbox Hack) if deployed to email or sandboxed views?
- [ ] Are all colors mapped to semantic CSS variables with 100% dark mode parity?
- [ ] Are typography tracking and layout spacing polished (tight headers, legible code, Bento grid)?
- [ ] Was the rendered output verified for zero silent template errors or unrendered tokens?
