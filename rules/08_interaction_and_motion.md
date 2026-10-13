# 🎞️ 08. Interaction State & Motion Engineering

**[English](08_interaction_and_motion.md)** | **[简体中文](08_interaction_and_motion.zh.md)**

> *"Animation is not the art of drawings that move, but the art of movements that are drawn."* — Norman McLaren

---

## 🎯 The Core Problem: The "Jump-Cut Interface" Trap

Rule 04 controls information density and visual material. Rule 08 controls the time dimension. An interface can look correct in a static screenshot and still feel broken in use.

1. **Hard Cut State Changes**: A click makes content disappear and reappear. The user loses spatial orientation.
2. **Arbitrary Motion Parameters**: AI generates either no motion or a 500 ms bounce. Each interaction feels unrelated to the next.
3. **Multi-Open Collisions**: Several navigation groups expand at the same time. Attention scatters. The layout jumps.
4. **State Hidden Behind Detail Pages**: Unread items, failures, and pending work stay invisible until the user opens each row.
5. **Navigation Ate the Canvas**: A permanent sidebar consumes 20 percent of usable width for 6 links.
6. **Motion Without Restraint**: Infinite animations run forever. Hot paths animate layout properties. Nobody honors `prefers-reduced-motion`.

---

## 📜 Rule 8.1: Continuity Over Cut
*(Attribution: Apple Human Interface Guidelines (Motion) & Material Design motion specification)*

**Core Mandate**: Express a state change as geometric movement, not as a disappearance plus an appearance.

### Three Proven Techniques

1. **Shared Indicator (Floating Highlight)**:
   - One rounded highlight element serves the whole group.
   - On selection change, the highlight travels from the old position to the new position.
   - The highlight width follows the target label width.
2. **Staggered Reveal (Cascade)**:
   - Child items enter one by one from the parent edge.
   - Each child delays 20 ms to 30 ms after the previous child.
   - The whole cascade finishes inside 400 ms.
3. **Rolling Counter**:
   - A changed number leaves upward and enters from below.
   - The digit column moves. The container does not resize.

```css
.nav { position: relative; }

/* One absolutely positioned indicator for the whole group. */
.nav__indicator {
  position: absolute;
  top: var(--y, 0);
  left: 0;
  height: var(--h, 36px);
  width: var(--w, 0);
  border-radius: 10px;
  background: var(--accent-soft);
  transition: transform 200ms cubic-bezier(0.2, 0, 0, 1),
              width 200ms cubic-bezier(0.2, 0, 0, 1);
}

/* Cascade: set --i on each child. */
.subitem {
  opacity: 0;
  transform: translateY(-4px);
  transition: opacity 180ms ease-out,
              transform 180ms ease-out;
  transition-delay: calc(var(--i, 0) * 24ms);
}
[data-open="true"] .subitem { opacity: 1; transform: none; }
```

**Boundary Cases (When NOT to Apply)**:
- The travel distance exceeds one viewport. Use an instant swap plus a scroll anchor.
- The list is virtualized. Disable the transition on programmatic scroll. Move the indicator without animation.
- The user is dragging or scrubbing. Never animate a value the user directly controls.

---

## 📜 Rule 8.2: The Single-Expansion Invariant
*(Attribution: WAI-ARIA Authoring Practices (Accordion) & Nielsen Norman Group disclosure conventions)*

**Core Mandate**: Within one hierarchy level, allow exactly one expanded or active group at a time.

### State Machine

```text
idle -> collapsing(previous) -> expanding(target) -> idle
```

1. Collapse the previous group first. Then expand the target group.
2. To overlap both phases, offset the second phase by 60 ms. Never start both phases on the same frame.
3. Report state with `aria-expanded`. Keep the toggle reachable by keyboard.
4. Animate the height with `grid-template-rows` or a measured height. Avoid a guessed `max-height`.

```css
.panel {
  display: grid;
  grid-template-rows: 0fr;
  transition: grid-template-rows 220ms cubic-bezier(0.2, 0, 0, 1);
}
.panel[data-open="true"] { grid-template-rows: 1fr; }
.panel > .panel__inner { overflow: hidden; }
```

**Boundary Cases (When NOT to Apply)**:
- The user must compare two groups side by side. Use a multi-column layout instead.
- The surface is a file tree. Multi-open is semantically required there.
- A selection must persist across parent groups. Model that state explicitly instead of hiding it in the accordion.

---

## 📜 Rule 8.3: State Externalization
*(Attribution: Apple Human Interface Guidelines (Badges) & W3C WCAG 2.2)*

**Core Mandate**: Put new, unread, and failing state on the navigation row itself. Do not force a drill-down.

### Three Tiers

| Tier | Marker | Use When |
| :--- | :--- | :--- |
| Presence | 6 px dot | Something exists. The size is unknown. |
| Magnitude | Number badge | The count matters to the decision. |
| Severity | Colored dot or ring | The item needs urgent attention. |

1. Clamp large counts at `999+`. Expose the exact value in the accessible name and in a tooltip.
2. Animate a changed count as a vertical roll. Do not animate the badge size.
3. Clear the badge when the user visits the target. Animate the badge to scale 0 over 150 ms.
4. Never rely on color alone. Pair the color with a shape, an icon, or text.
5. Announce count changes with a polite live region. Do not interrupt the user.

```css
.badge--breathing {
  animation: breathe 1800ms ease-in-out infinite;
}
@keyframes breathe {
  0%, 100% { opacity: 0.65; transform: scale(0.96); }
  50%      { opacity: 1;    transform: scale(1.04); }
}
```

**Boundary Cases (When NOT to Apply)**:
- The count itself is a primary business metric. Put it on the dashboard. A badge hides magnitude.
- Every item carries a badge. Constant alerts become noise. Fix the underlying process instead.

---

## 📜 Rule 8.4: The Navigation Pixel Budget
*(Attribution: Nielsen Norman Group information architecture & the menu-pattern survey cited in Rule 00)*

**Core Mandate**: Treat navigation footprint as an explicit budget. The chosen form determines both the usable canvas and the reachable hierarchy depth.

| Form | Footprint | Best For | Fails When |
| :--- | :--- | :--- | :--- |
| Persistent sidebar | 200 px to 280 px of width | 8 to 20 items, 2 to 3 levels, pointer input | Content needs full width or the screen is narrow |
| Top bar plus mega panel | Full width, ~48 px of height | 5 to 9 primary items, wide detail panels | Hierarchy exceeds 3 levels, or input is touch only |
| Floating bottom dock | Content corners, ~64 px of height | Up to 7 icon-only destinations | Labels are required for comprehension |
| Command palette only | Zero permanent footprint | Expert tools, keyboard-first users | Novice users who browse by recognition |
| Hybrid (sidebar plus palette) | Sidebar plus a hotkey | Large products with mixed audiences | The two surfaces drift out of sync |

1. Below 200 px, a persistent sidebar costs more than it returns. Collapse it to icons.
2. Never build a hover-opened navigation panel for a touch-primary product. Touch has no hover state.
3. Keep the primary navigation visible on first paint. A hidden menu needs a visible search fallback.

**Boundary Cases (When NOT to Apply)**:
- A kiosk or a single-task view. Remove navigation entirely and provide one exit.
- A marketing page. Navigation footprint follows the narrative, not the tool budget.

---

## 📜 Rule 8.5: Retrieval Over Hierarchy
*(Attribution: command palette lineage (Sublime Text, VS Code, Linear) & Nielsen recognition-over-recall)*

**Core Mandate**: When the navigable set grows past roughly 20 targets, offer direct retrieval. Do not deepen the tree.

### Performance Budget

| Stage | Budget |
| :--- | :--- |
| Open the palette after the hotkey | 150 ms or less |
| Filter after each keystroke | 100 ms or less, synchronous and local |
| Highlight the matched substring | Same frame as the filter result |

1. Support `Up`, `Down`, `Enter`, and `Escape`. The mouse is optional. Never required.
2. Dim and blur the background. Keep the palette's own contrast above WCAG AA.
3. Rank exact prefix matches above fuzzy matches. Show the ranking rule in the result row.
4. Keep the command list deterministic. The same query must always produce the same order.

**Boundary Cases (When NOT to Apply)**:
- The user does not know the name of the target. Browsing beats searching there. Keep visual navigation first class.
- The item set is small and stable. A palette adds a mode for no gain.
- The product is touch primary. A palette is an expert shortcut, not the only path.

---

## 📜 Rule 8.6: Motion Accessibility and Performance Red Lines
*(Attribution: W3C WCAG 2.2 (2.2.2, 2.3.3), Apple Reduce Motion, web.dev rendering performance)*

**Core Mandate**: Motion must be optional, interruptible, and cheap. Accessibility and frame budget are release blockers.

1. **Honor the reduced-motion preference**. Replace movement with an opacity or color change. Keep the state feedback.
2. **Animate only `transform` and `opacity`** on hot paths. Never animate `top`, `left`, `width`, or `height` in a list or a scroll container.
3. **Keep feedback fast**. Direct manipulation feedback must start within 150 ms. Total motion must stay under 400 ms.
4. **No unmotivated infinite animation**. A subtle breathing badge is acceptable. A permanently spinning decoration is not.
5. **Never animate focus visibility away**. The focus ring appears instantly and stays visible.
6. **Respect user interrupt**. A new input cancels the running transition. Never queue animations.
7. **Contain long lists**. Apply `contain: layout paint` so a single animated row does not invalidate the page.

```css
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
    scroll-behavior: auto !important;
  }
  /* Keep feedback. Swap movement for opacity. */
  .subitem { transform: none !important; }
}
```

---

## 📊 Motion Parameter Quick Reference

| Interaction | Duration | Easing | Notes |
| :--- | :--- | :--- | :--- |
| Hover, press, focus feedback | 120 - 160 ms | `cubic-bezier(0.2, 0, 0, 1)` | Must start under 150 ms |
| Shared indicator travel | 180 - 240 ms | `cubic-bezier(0.2, 0, 0, 1)` | Add mild overshoot only for selection |
| Indicator width change | 180 - 240 ms | `cubic-bezier(0.2, 0, 0, 1)` | Keep it in phase with travel |
| Expand and collapse height | 200 - 260 ms | `cubic-bezier(0.2, 0, 0, 1)` | Collapse faster than expand by 20 percent |
| Cascade entry per child | 160 - 200 ms | `ease-out` | Delay 20 - 30 ms per index, total under 400 ms |
| Counter roll | 180 - 240 ms | `ease-out` | Clip the container. Never resize it |
| Badge appear | 150 ms | `ease-out` | Scale from 0.8 to 1 |
| Badge dismiss | 120 ms | `ease-in` | Scale to 0, then remove from the tree |
| Breathing reminder | 1600 - 2000 ms loop | `ease-in-out` | Amplitude at or below 8 percent |
| Command palette open | 120 - 150 ms | `cubic-bezier(0.2, 0, 0, 1)` | Animate the scrim in the same phase |
| Page level transition | 240 - 320 ms | `cubic-bezier(0.2, 0, 0, 1)` | Only on hierarchy change, never on same-level switch |

**Three anchors**: Feedback is fast (150 ms or less). Spatial change is moderate (300 ms or less). Nothing exceeds 400 ms.

---

## 🤖 Prompt Templates for AI Agents

Use these templates in place of an ad hoc description. Replace the bracketed fields. Keep the constraint clauses. They prevent the model from inventing motion parameters.

```text
[1] Sliding highlight navigation
Component: [name]. Items: [count]. Input: [pointer | touch | keyboard].
Add one rounded highlight element that serves the whole group.
On selection change, move the highlight from the old position to the new position.
Width follows the target label width. Duration 200ms, ease cubic-bezier(0.2,0,0,1).
Animate only transform and opacity. Honor prefers-reduced-motion.

[2] Inline expansion with single-open behavior
Component: [name]. Levels: [depth]. Items per level: [count].
Expand child items in place under the parent row.
Rotate the chevron 90 degrees. Cascade children with 24ms per-index delay.
Draw a 1px vertical connector on the leading edge.
Allow exactly one open group per level. Collapse the previous group first.
Expose state via aria-expanded. Animate height with grid-template-rows.

[3] Externalized state on navigation rows
Component: [name]. Tiers: [dot | count | severity color].
Render the state marker on the right edge of each navigation row.
Use a 6px dot for presence, a number badge for magnitude, a colored ring for severity.
Clamp counts at 999+ and expose the exact value to assistive technology.
Roll a changed number vertically for 200ms. Clear the marker over 150ms after a visit.
Never encode meaning with color alone.

[4] Navigation form change
Component: [name]. Current form: [sidebar]. Target form: [top bar + mega panel].
Move primary navigation to [target form]. Return the reclaimed width to the content region.
On hover, drop one full-width panel. Lay out child pages in columns with an icon and one line of text.
Keep the panel open while the pointer moves between items. Swap content only.
Never require hover on a touch-primary device.

[5] Command palette
Component: [name]. Command count: [count].
Add a command palette opened by [hotkey].
Center it on screen. Dim and blur the background.
Filter locally and synchronously on each keystroke. Highlight the matched substring.
Support Up, Down, Enter, and Escape. Complete the open within 150ms.
Keep the command order deterministic for a given query.
```

---

## 🚨 Interaction and Motion Checklist

- [ ] Does every state change read as movement, instead of a jump cut?
- [ ] Does each hierarchy level keep exactly one expanded group?
- [ ] Are new, unread, and failing states visible on the navigation row?
- [ ] Is the navigation footprint an explicit decision, not a default?
- [ ] Does the product offer direct retrieval once the target set passes ~20 items?
- [ ] Does every animation honor `prefers-reduced-motion: reduce`?
- [ ] Do hot paths animate only `transform` and `opacity`?
- [ ] Does direct manipulation feedback start within 150 ms and end within 400 ms?
- [ ] Is every state readable without color, and reachable without a mouse?
- [ ] Are focus indicators instant, visible, and never animated away?

---

## 🔗 Relationship to Rule 04

| Concern | Rule |
| :--- | :--- |
| Density, hierarchy, visual material, dark mode, render assertions | 04 |
| State transitions, timing, navigation form, accessibility of motion | 08 |

Rule 04 answers "what does the user see at rest". Rule 08 answers "what does the user understand while the state changes".
