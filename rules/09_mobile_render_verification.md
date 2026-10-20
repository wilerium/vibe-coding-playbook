# 📱 09. Mobile & Rendered-UI Verification

**[English](09_mobile_render_verification.md)** | **[简体中文](09_mobile_render_verification.zh.md)**

> *"Program testing can be used to show the presence of bugs, but never to show their absence!"* — Edsger W. Dijkstra

---

## 🎯 The Core Problem: "It Looks Fine on My Screen"

Rendered interfaces fail differently from logic. The code exits `0`, the static linter passes, the HTML is well formed — and the layout is still wrong on the target device. Four failure modes dominate:

1. **Exit-Code Optimism**: A build script or static audit passes, so the agent reports success. Static analysis reads text. It cannot see geometry.
2. **Eyeball Certification**: A human or a vision model looks at a screenshot and says "looks good". This verdict is not reproducible, not diffable, and not enforceable in review.
3. **Assumed Tooling**: The verification script targets an emulator binary, device name, or URL scheme that no longer exists, or that was never compatible. The script "runs" and verifies nothing.
4. **Unstated Viewport**: "Fits on one screen" is meaningless until the viewport is declared — browser chrome, safe area, and scale factor all change the verdict.

**Core mandate**: a claim about layout is valid only if it comes from an actual render, measured against a declared viewport, and expressed as a number that a machine can re-check.

---

## 📜 Rule 9.1: Render Is Truth

Static checks and unit tests are necessary, never sufficient, for rendered surfaces.

| Check type | Proves | Cannot prove |
| :--- | :--- | :--- |
| Exit code / unit tests | Logic and data flow | Anything about pixels |
| Static markup audit | Structure, anchors, no external refs | Overflow, wrapping, truncation, tap-target size |
| Screenshot, human-read | Subjective impression | Reproducibility, regression |
| **Render + measurement** | Declared geometry constraints | Visual taste |

**Mandate**:
- State explicitly which layer you verified. "Static audit passed" is a valid sentence. "Layout is correct" is not, unless a render measured it.
- When a requirement is geometric (`fits one screen`, `no horizontal scroll`, `label does not truncate`), it must be asserted numerically, not described.

---

## 📜 Rule 9.2: Declare the Viewport Contract

Write the contract down before measuring anything.

```text
REFERENCE VIEWPORT
  device model      : <e.g. iPhone 18 Pro Max>
  logical size      : <width> x <height> points
  native pixels     : <width> x <height> @ <scale>x
  chrome            : none | browser toolbar | app navigation
  safe area         : top <n> / bottom <m> points
```

Three consequences:

1. **Assert the renderer actually reports that viewport.** If the measured `innerWidth` differs from the contract, every downstream verdict is false. Fail loudly.
2. **Name the surface for every verdict.** "Fits" under browser chrome and "fits" full-screen are different claims. Never mix them in one report.
3. **Fix the reference device per requirement.** The widest device in the matrix never reveals the narrow-screen regressions. One primary judge per requirement, plus at least one narrower regression target.

**Anti-pattern**: measuring on whichever device happens to be booted, then treating the result as universal.

---

## 📜 Rule 9.3: Emit Measurements, Not Adjectives

Every render check writes a machine-readable record per page and per device. Humans read screenshots; agents must read numbers.

```json
{
  "page": "<route id>",
  "device": "<device model>",
  "innerWidth": 440, "innerHeight": 956,
  "safeTop": 62, "safeBottom": 34,
  "usableHeight": 860,
  "scrollWidth": 440, "scrollHeight": 984,
  "fitsFull": false, "fitsUsable": false,
  "hOverflow": false, "overflowEls": [],
  "viewportFitCover": true
}
```

Rules for this record:
- **One row per page per device.** No aggregation that hides which page failed.
- **Booleans are derived, not judged.** `fitsFull` is `scrollHeight <= innerHeight`, computed by the checker, not asserted by the agent.
- **Include the element list on overflow.** `overflowEls` turns "something is too wide" into a fixable locator.
- **Store the record outside the code repository** (data root or build directory), and keep it diffable across runs.

---

## 📜 Rule 9.4: Separate the Two Rendering Surfaces

Mobile web UI has two surfaces that look identical and measure differently:

| Surface | Viewport | Use it for |
| :--- | :--- | :--- |
| In-browser | Reduced by toolbar and chrome | Realistic first-open experience |
| Full-screen host (standalone / home-screen app) | Whole screen, safe area passed to CSS | Geometry verdicts, "one screen" claims |

**Mandate**:
- Geometry requirements are judged on the **full-screen** surface only.
- Visual first-impression checks may use the browser surface, labelled as such.
- If the page does not opt into safe-area layout (`viewport-fit=cover` plus `env(safe-area-inset-*)` padding), full-screen rendering places content under the status bar. Detect it (`viewportFitCover: false`) and report it; do not silently ship a layout that collides with system UI.

**Implementation note**: a minimal WebView host application is enough. It is a few dozen lines, compiles with the platform toolchain, and gives deterministic full-screen rendering plus script access to the rendered document. Prefer it over emulating a viewport by resizing a desktop browser.

---

## 📜 Rule 9.5: Transport Is Part of the Test

Local artifacts are not automatically reachable by the target renderer.

- Opening a local file by `file://` may be intercepted by a file provider or a document picker instead of the browser. The screenshot then shows a file browser, not the page.
- Serve local artifacts over an **ephemeral loopback HTTP server**: bind `127.0.0.1`, port `0` (kernel-assigned), read-only handler, no access log, shut down after the run.
- **Never assume routing behaviour carries across transports.** Hash-based navigation, history, and fetch restrictions can differ between `file://` and `http://`.
- Verify transport before content: if the first render is blank or shows a picker, fix transport first. Do not debug CSS against a page that never loaded.

---

## 📜 Rule 9.6: Idempotent Fixtures and Honest Failures

Verification harnesses rot faster than product code. Assume every identifier is wrong until probed.

1. **Probe, do not hardcode.** Device names, runtime identifiers, and binary locations change across toolchain releases. Query them at run time and choose from what exists.
2. **Reuse before create.** Emulator and container creation often permits duplicate names. Look up existing fixtures first; creating blindly leaves one orphan per run and makes results ambiguous. Match on both name **and** fixture type.
3. **Compatibility is not version order.** The newest runtime is not always able to host the requested device. Check the runtime's supported-device list and pick the newest *compatible* one; report the skipped runtimes and why.
4. **Wait for stability, not for a duration.** Fixed sleeps race the renderer. Sample until two consecutive captures are identical, with a bounded retry budget.
5. **Detect blindness.** If two consecutive page captures are byte-identical, navigation probably did not happen. Mark the check as failed — never as passed.
6. **Fail closed.** A missing measurement is a failure. "No data" must never be reported as success, and the exit code must reflect it.

---

## 📜 Rule 9.7: Layer the Verification Budget

Keep the cheap loop fast; reserve the expensive matrix for delivery.

| Level | Cost | Contents | When |
| :--- | :--- | :--- | :--- |
| L0 Static | seconds | Markup audit, dead anchors, external refs | Every edit |
| L1 Single render | ~10 s | One primary device, subset of pages, measurements | Every UI edit |
| L2 Full matrix | minutes | All pages, primary plus narrow regression device | Before merge |
| L3 Both surfaces | minutes | L2 on browser and full-screen surface | Before release |

**Contract**: each level is one command with a meaningful exit code, suitable for a task ticket's acceptance line. An acceptance criterion that a reviewer cannot run is not an acceptance criterion.

---

## 🤖 Prompt Templates for AI Agents

**T1 — Self-check after a UI change**

> Run the render checker on the primary device for the pages you touched. Compare `scrollHeight` and `hOverflow` against the previous run. Report only which pages changed and by how many points. Do not describe screenshots as "looking correct".

**T2 — Pre-delivery acceptance**

> Run the full render verification with the one-screen assertion enabled. If the exit code is non-zero, paste every "content height N > viewport M (over by X pt)" line verbatim, then propose the minimal CSS change per offending page. Do not report the task as complete without the exit code.

**T3 — Investigate a reported layout problem**

> Probe the environment first (device list, runtime compatibility, page count). Then render only the reported page and report the measured viewport, content height, and overflow elements. Determine whether the cause is transport, viewport contract, or CSS. Do not guess.

**T4 — Visual regression sweep**

> Diff the measurement records of the two runs. List pages whose `scrollHeight` changed by more than 8 pt, sorted by magnitude, and mark each as expected or unexpected given the change description.

**T5 — Guard clause for every UI task**

> Do not certify layout from a screenshot alone. Do not open local artifacts with a file URL. Do not reference tool names or device identifiers that have not been probed in this environment. Completion requires a measured record or a passing exit code.

---

## 🚨 Rendered-UI Verification Checklist

- [ ] Is the reference viewport declared (device, logical size, scale, chrome, safe area)?
- [ ] Does the renderer report exactly that viewport?
- [ ] Is every geometric requirement expressed as a numeric assertion with an exit code?
- [ ] Are measurements written per page per device, outside the code repository?
- [ ] Is transport verified before content (loopback HTTP, no file-URL assumptions)?
- [ ] Are fixtures probed, reused, and cleaned instead of blindly created?
- [ ] Is the runtime checked for compatibility with the requested device?
- [ ] Are identical consecutive captures treated as failures?
- [ ] Does a missing measurement fail closed rather than pass silently?
- [ ] Is there at least one narrower regression device besides the primary judge?

---

## ⚖️ Boundary with Rules 04, 05, and 07

- **Rule 04 (UI/UX)** defines what good layout *is*. Rule 09 defines how to *prove* it rendered.
- **Rule 05 (Forensic Debugging)** owns the red-light loop for logic defects. Rule 09 supplies the rendered equivalent: measure first, then patch.
- **Rule 07 (Master Checklist)** owns release red lines. Rule 09 contributes one entry to it: no layout claim without a measurement record.
