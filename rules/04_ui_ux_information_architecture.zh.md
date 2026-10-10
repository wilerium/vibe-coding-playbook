# 🎨 04. 工业级 UI/UX 与信息架构 (Industrial UI/UX & Information Architecture)

**[English](04_ui_ux_information_architecture.md)** | **[简体中文](04_ui_ux_information_architecture.zh.md)**

> *“简单并不是没有杂乱，那只是简单带来的一个结果。简单在本质上描述了一个物体和产品存在的目的与位置。”* — 乔纳森·伊夫 (Jony Ive)

---

## 🎯 核心问题：“平庸无趣的 AI 仪表盘”陷阱

当由 AI 生成用户界面时，往往容易走向两个极端：
1. **低信息密度的“AI 塑料感” (AI Slop)**：巨大无比的卡片、宽得夸张的内边距、通篇都是毫无意义的插画，翻看 5 屏才能看到 3 个业务指标。
2. **生硬的原始 JSON 堆砌**：直接输出密密麻麻、无视觉层级的大表格与日志堆，无法帮助高层或工程师在数秒内看懂结论并做出决断。
3. **脆弱的脚本依赖**：在邮件报告（Apple Mail、Outlook）或受限安全沙箱中嵌入 `<script>` 交互脚本，导致邮件直接把脚本剔除，展开/收起按钮彻底失效。
4. **半吊子暗黑模式**：在 CSS 中写死 `#FFFFFF` 或 `#333333` 绝对颜色，导致用户切换到暗黑模式时文字不可读或背景惨白刺眼。

---

## 📜 规则 4.1：首屏即决断与渐进式信息披露 (Progressive Disclosure)
*(思想溯源：Jakob Nielsen 渐进式披露理论)*

**核心铁律**：极高的数据密度与克制的渐进式披露相配合。用户必须在打开卡片或界面的**前 2 秒内**完成核心决断。

### 2 秒决断标准体系 (The 2-Second Decision Standard)
1. **顶层决断区 (前 2 秒视觉落点)**：
   - 显眼的状态角标（如 `[🚨 高危预警]`, `[🔄 已更新]`）。
   - 核心对象标题与底层单据协议直达超链接。
   - 核心属性胶囊栏（Capsules）：水平排列的浅底圆角微型标签，依次呈现 `状态`、`优先级`、`风险分`、`耗时天数` 与 `责任人`。
2. **渐进式披露三层结构**：
   - **第 1 层（默认展开）**：高管级 1-Pager 决策核心（问题定性、根因分析、即时工程动作）。
   - **第 2 层（按需点击呈现）**：相似问题关联、上下游血缘追溯、受影响模块矩阵。
   - **第 3 层（深度手风琴面板）**：底层 Crash 调用栈、原始日志提取片段、历史讨论流转串。

---

## 📜 规则 4.2：纯 CSS 交互黑魔法（零脚本 Checkbox Hack）
*(思想溯源：Web 标准与邮件客户端安全沙箱规范)*

**核心铁律**：在邮件客户端或安全沙箱等严禁 `<script>` 标签的环境中生成交互式卡片时，所有点击展开/收起的动效**必须纯靠 CSS 实现**。

### 纯 CSS Checkbox Hack 黄金范式
```html
<!-- 1. 隐藏的原生 checkbox 作为状态容器 -->
<input type="checkbox" id="toggle-details-101" class="accordion-checkbox" style="display: none;" />

<!-- 2. Label 标签模拟交互按钮 -->
<label for="toggle-details-101" class="accordion-button">
  <span>🔍 技术调用栈明细</span>
  <span class="chevron">▾</span>
</label>

<!-- 3. 相邻兄弟容器，通过 CSS 相邻兄弟选择器实现平滑展开 -->
<div class="accordion-content">
  <pre><code>NullPointerException at line 42...</code></pre>
</div>
```

```css
/* 核心样式 */
.accordion-content {
  max-height: 0;
  overflow: hidden;
  transition: max-height 0.25s ease-out;
}

/* 当 Checkbox 选中时，展开内容面板 */
.accordion-checkbox:checked ~ .accordion-content {
  max-height: 2000px; /* 无需 JavaScript 即可实现丝滑折叠展开 */
}

/* 翻转箭头图标 */
.accordion-checkbox:checked + .accordion-button .chevron {
  transform: rotate(180deg);
}
```

---

## 📜 规则 4.3：工业级审美与 Apple HIG 质感
*(思想溯源：Dieter Rams & Apple 人机界面指南 HIG)*

**核心铁律**：摒弃通用 AI 审美的塑料感，打造具备工业级质感与高信任度的界面。

1. **磨砂玻璃质感 (Frosted Glass)**：
   - 置顶导航栏与浮动卡片采用半透明磨砂玻璃滤镜：
     `background: var(--bg-glass); backdrop-filter: saturate(180%) blur(20px); -webkit-backdrop-filter: blur(20px);`
2. **严谨的排版字距 (Tight Kerning)**：
   - 大字标题：强制应用负字距微调（`letter-spacing: -0.025em`），呈现紧凑现代质感。
   - 代码与等宽文本：选用高可读性字体（`SF Mono`、`JetBrains Mono`），字号控制在 `12px` - `13px`，行高锁定 `1.5`。
3. **高管级 HUD 指标看板 (Spec HUD)**：
   - 概览看板采用非对称 Bento Grid 模块化排版。
   - 大数字统计卡：巨大加粗的数字（`32px` - `48px`），配以微小的全大写说明标签（`11px`, `text-transform: uppercase`, `opacity: 0.6`）。
4. **语义化引用卡片 (Callout Quotes)**：
   - 使用左侧高亮色条与淡色背景搭配：
     - ℹ️ **说明 (Note)**：蓝色色条 (`#0071e3`)。
     - 💡 **提示 (Tip)**：绿色色条 (`#34c759`)。
     - ⚠️ **警告 (Warning)**：橙色色条 (`#ff9500`)。
     - 🚨 **严重 (Critical)**：红色色条 (`#ff3b30`)。

---

## 📜 规则 4.4：基于 CSS 变量的真正暗黑模式平替

**核心铁律**：绝对严禁在样式中写死十六进制绝对色值。全面基于语义化 CSS 变量实现 100% 完美的暗黑自适应。

1. **设计 Token 变量化**：
   - 在 `:root` 中声明基础语义 Token，在 `@media (prefers-color-scheme: dark)` 或 `[data-theme="dark"]` 中覆盖。
2. **OLED 纯黑基底**：
   - 页面背景 (Canvas)：采用纯黑 `#000000`，兼顾 OLED 省电与极致对比度。
   - 悬浮卡片 (Elevated Surfaces)：采用 `#1c1c1e` 或 `#2c2c2e`。
   - 细微边框：半透明白色 `rgba(255, 255, 255, 0.1)`。
   - 主文本：`#ffffff`，次级文本：`rgba(255, 255, 255, 0.56)`。

---

## 📜 规则 4.5：模板防静默崩溃断言 (Zero-Crash Assertions)

**核心铁律**：绝对不要盲目信任模板生成脚本的返回值。必须对最终渲染产物执行自动化断言。

1. **静默失败陷阱**：
   - 常见的模板引擎（如 Jinja、EJS、React SSR）经常在遇到空指针或未定义变量时静默吞掉异常，或者仅仅在页面中输出一个隐蔽的 `<div>Error rendering...</div>`，但进程退出码仍然是 0。
2. **构建后自动化扫描断言**：
   - 自动化流程必须在页面生成完毕后，自动解析最终的 `.html` 字符串。
   - 强行断言内容中不存在任何 `Error rendering`、`UndefinedError`、`None` 或原始未解析的 `{{ ... }}`。

---

## 🚨 UI/UX 核对清单 (UI/UX Checklist)

- [ ] 是否达成 2 秒决断标准（状态、严重度与核心动作首屏可见）？
- [ ] 深度调用栈与原始日志是否置于渐进式折叠面板之后？
- [ ] 邮件报告等受限环境是否采用纯 CSS Checkbox Hack（无脚本）实现交互？
- [ ] 所有颜色是否严格基于 CSS 变量，并具备 100% 暗黑模式平替？
- [ ] 标题与排版是否具备工业级质感（紧凑字距、Bento Grid、HUD 指标卡）？
- [ ] 是否在渲染后自动校验了 HTML 产物，确认无任何静默模板崩溃？
