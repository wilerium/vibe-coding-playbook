# 🏛️ 02. 架构模式与深模块设计 (Architecture Patterns & Deep Modules)

**[English](02_architecture_and_deep_modules.md)** | **[简体中文](02_architecture_and_deep_modules.zh.md)**

> *“模块应当是深邃的：最好的模块提供了极其强大的功能，却只暴露极其简单的接口。”* — 约翰·欧斯特豪特 (John Ousterhout)，《软件设计哲学》

---

## 🎯 核心问题：“浅层模块”陷阱 (The Shallow Module Trap)

在快节奏的 AI 辅助开发中，一个极为普遍的架构缺陷就是产生大量的**浅层封装模块 (Shallow Modules)**：
* 类或函数只是对第三方底层库的一层薄薄包装，毫无实质价值。
* 接口向调用方暴露了 20 个琐碎的配置参数、各种标志位以及底层数据结构。
* 直接耦合：业务核心逻辑直接四处 `import` 第三方厂商 SDK，一旦未来更换供应商，意味着数周的痛苦重构。
* 状态污染：把运行时缓存、临时测试产物与运行日志随手写在 Git 跟踪的代码目录中。

---

## 📜 规则 2.1：深模块哲学 (The Deep Module Principle)
*(思想溯源：John Ousterhout)*

**核心铁律**：最大化模块深度。用极简、直观的外部接口，严密封装强大的内部复杂逻辑。

### 模块深度量化公式
$$\text{模块深度 (Depth)} = \frac{\text{被封装隐藏的实现复杂度}}{\text{向外部暴露的接口复杂度}}$$

* **深模块（理想架构）**：接口小巧且直观，但在内部严密封装了重试机制、错误兜底、请求频率退避、结构校验、数据格式标准化与分层缓存。
* **浅模块（糟糕反例）**：接口庞大臃肿，要求调用方理解其内部所有细节、传递各种底层参数并自行捕获底层异常。

### 架构代码对比
```typescript
// ❌ 浅模块反例（Shallow Module）：
// 调用方必须了解 HTTP 细节、请求头组织、分页 Token 与底层 JSON 编解码
class UserFetcher {
  async fetch(url: string, headers: Record<string, string>, pageToken?: string): Promise<RawHttpResponse> { ... }
}

// ✅ 深模块最佳实践（Deep Module）：
// 接口极度精炼直观。内部严密封装了 Token 自动刷新、退避重试、内存缓存与异常抹平。
interface UserService {
  getUser(userId: string): Promise<User>;
}
```

---

## 📜 规则 2.2：接缝黄金法则与删除测试 (Seams & The Deletion Test)
*(思想溯源：Michael Feathers, Martin Fowler & Eric Evans)*

**核心铁律**：接缝是一种昂贵的架构期权。只有当外部世界充满不可控、非确定性或真实的多态分歧时才买入它。在其余所有地方，组织好代码让这种期权根本不需要。

### 1. 接缝与外部使能点 (Seams & Enabling Points)
* **定义**：**接缝 (Seam)** 是无需修改该处代码即可改变程序行为的位置。
* **使能点**：每个接缝必须存在一个处于接缝外部的使能点（Enabling Point），即实际决定选择传入哪个实现的调用位置。没有外部使能点的接口只是虚构接缝，纯属无意义的间接层。
  ```python
  # ❌ 绝非接缝 - Mailer 虽然是个接口，但类内部硬编码了具体实现，外部根本改不了它
  class InvoiceMailer:
      def __init__(self):
          self.mailer: Mailer = SmtpMailer("smtp.service.internal")

  # ✅ 真正的接缝 - 使能点位于外部构造函数的调用处
  class InvoiceMailer:
      def __init__(self, mailer: Mailer):
          self.mailer = mailer
  ```

### 2. 双适配器真实性法则 (The Two-Adapter Law)
> **“一个适配器代表虚构接缝；两个适配器才证明真实接缝。”**

* 除非在**当下**至少有两个真实适配器具备成立的理由（如一个生产级 HTTP 适配器 + 一个轻量单测桩），否则严禁凭空定义抽象接口。
* 只有一个实现的接口（如 `IUserService` 对应唯一的 `UserServiceImpl`）属于盲目跟风 Mock 的代码膨胀，必须予以剔除。

### 3. 接缝判定决策程序（顺序执行，首次匹配即止）
1. **触碰非确定性或外部进程边界**（时钟、随机数、网络 I/O、文件系统、数据库、第三方 SDK）？ $\to$ **设立接缝**。
2. **效果不可逆或代价高昂**（发送邮件/短信、银行扣款、物理删除、公开部署、计量收费 API）？ $\to$ **设立接缝**（它在防止第一次事故时就收回了成本）。
3. **行为在今天的生产环境确实存在多态分歧**（多租户、多云、特性开关切换）？ $\to$ **设立接缝**。
4. **抢救无测试保护的遗留老代码**？ $\to$ **设立临时接缝**（在补齐测试重构后按计划移除）。
5. **是否能将“决策逻辑”与“I/O 副作用”解耦，将决策作为纯函数测试**？ $\to$ **严禁设接缝，执行解耦**。
6. **其余所有情况** $\to$ **严禁设接缝，直接使用具体类与真实依赖**。

### 4. 解除缠绕优于依赖注入 (Functional Core, Imperative Shell)
每当想要注入接缝时，先检查是否将纯决策与 I/O 副作用缠绕在一起。将它们解耦即可消灭对庞大 Mock 接缝的依赖：
```python
# ❌ 重构前：单一方法缠绕，需要 3 个注入接缝与繁重的 Mock 伪造
def send_overdue_notices(self):
    for invoice in self.repo.due_before(self.clock.now()):
        self.mailer.send(invoice.email, render(invoice))

# ✅ 重构后：纯函数决策（0 个接缝，传入列表与日期即可穷举测试），极薄的外壳
def notices_to_send(invoices, today):   # 零接缝；纯计算逻辑
    return [Notice(i.email, render(i)) for i in invoices if i.due < today]

def run(repo, mailer, clock):           # 3 行胶水；单次集成测试覆盖
    for n in notices_to_send(repo.all(), clock.now()):
        mailer.send(n.to, n.body)
```
*架构的目标不是制造更多的接缝，而是用更少的接缝保护更多的纯净业务代码。*

### 5. 删除测试定义 (The Deletion Test)
> **法则**：如果你今天把系统正在使用的第三方供应商、数据库引擎或网络协议直接删掉，换成另一家替代方案，**你的核心业务代码和单元测试是否需要修改哪怕一行？**

* 如果答案是**需要修改**，说明抽象接缝失败，模块未通过删除测试。
* 如果答案是**不需要修改**（仅需更换独立的适配器文件），说明架构接缝完全健康。

### 6. 测试演进策略：替换而非堆叠 (Replace, Don't Layer)
* 当多个浅层模块被重构加深为一个深模块后，原有断言内部组装细节的琐碎单测已成为垃圾债务。**果断删除它们**。
* 新测试必须严格建立在深模块的公共接口上。**接口即是测试表面**。
* 只要外部接口行为不变，内部如何重构测试绝不应当报错。如果实现改变但行为未变时测试报错，说明测试越过了接口探测了私有细节。

---

## 📜 规则 2.3：无状态代码仓库架构 (Stateless Repository)
*(思想溯源：The Twelve-Factor App)*

**核心铁律**：代码仓库保持**绝对无状态 (Stateless)**。代码与临时资产彻底两清。

1. **Git 目录严禁写入状态**：
   - 严禁向项目根目录写入本地缓存文件、SQLite 数据库、运行时日志或临时会话。
   - 业务逻辑中严禁硬编码 `"logs/"`、`"state/"` 或 `"cache/"` 等相对路径。
2. **中心化环境与数据根目录 (Data Root)**：
   - 所有运行时可变路径统一通过环境变量管理器（如 `get_data_root()`）进行解析。
   - 用户配置、运行时日志和大体积缓存必须分流存放在系统级或用户级外部独立目录（如 `~/AppNameData/` 或 `$XDG_DATA_HOME/app_name`）。
3. **外部化带来的核心价值**：
   - 执行 `git clean -fd` 或切换 feature 分支绝不会误删用户数据或运行缓存。
   - 代码升级只需 `git pull`，保证绝对幂等且零风险。

---

## 📜 规则 2.4：黄金缓存与离线优先设计 (Golden Cache & Offline-First)

**核心铁律**：贯彻离线优先思想。构建极速本地闭环，严禁日常调试与单测无谓依赖外网环境。

1. **黄金缓存赋能毫秒级调试**：
   - 支持本地黄金数据回放机制（Golden Cache）。
   - 一旦首次从外部 API 拉取到数据，将其序列化为最终产物快照保存在本地。
   - 后续在开发 UI 样式或调试下流业务规则时，可一键读取黄金缓存，跳过耗时网络拉取、Token 费用与接口限频，实现毫秒级即时响应。
2. **离线与文件协议兼容 (Zero-CORS Architecture)**：
   - 编译输出的离线文档、工具或汇报页面，绝不依赖运行期的 `fetch("data.json")` 动态加载，防止在 `file:///` 协议下被浏览器跨域安全策略拦截（CORS Error）。
   - 将数据编译为自包含的静态嵌入对象（如 `window.APP_DATA = {...}`）。

---

## 📜 规则 2.5：代码为引擎，Markdown 为大脑 (Engine vs Brain)
*(思想溯源：Unix 哲学)*

**核心铁律**：将多变繁杂的业务策略、分类规则与 Prompt 指令与过程代码彻底解耦。

1. **过程逻辑 vs 声明式规则**：
   - Python / TypeScript / Go 应当作为高性能、确定性的执行引擎（I/O、网络并发、解析、渲染）。
   - 业务分类学（Taxonomy）、排障诊断树、敏感度打分规则与 Prompt 系统提示词必须统一沉淀在人类可读、可独立更新的 Markdown 或 YAML 文件中。
2. **零代码修改迭代**：
   - 业务专家或非工程师可以直接编辑 Markdown 文档来调整系统行为或分类维度，而无需重新编译、打包和部署底层引擎代码。

---

## 🚨 架构设计核对清单 (Architecture Checklist)

- [ ] 模块是否拥有小巧接口，并将复杂逻辑封闭在内部？
- [ ] 设立的接缝是否满足“双适配器法则”（无单一实现投机性接口）？
- [ ] 在引入依赖注入前，是否已尝试将纯决策与 I/O 副作用解耦（Functional Core, Imperative Shell）？
- [ ] 外部依赖是否封装在适配器后，且能够通过**删除测试**？
- [ ] 业务核心层是否彻底杜绝了第三方专有 SDK 的直接引用？
- [ ] 代码仓库是否保持纯粹无状态（无任何运行时日志/缓存污染 Git）？
- [ ] 动态文件路径是否统一经由环境管理器分流至外部目录？
- [ ] 是否支持黄金缓存模式以保障本地极速调试与离线运行？
- [ ] 核心策略与提示词是否抽离在 Markdown/YAML 中与程序代码解耦？
