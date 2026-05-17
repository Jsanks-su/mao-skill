# MAO Development

## 原则

- 核心层平台无关。
- 平台差异只进入 `adapters/` 或平台元数据。
- 用户私有数据只进入用户指定的 `memory/`，不进入发布包。
- 文档使用 UTF-8。
- 路径示例优先使用 `/`；PowerShell 示例只放在平台 adapter 或校验章节。

## 文件职责

| 路径 | 职责 |
| --- | --- |
| `mao/SKILL.md` | Skill 入口、触发规则、核心工作流 |
| `mao/references/` | 方法资料、历史血肉资料、案例库和数据协议 |
| `mao/templates/` | 决策、复盘、阶段性复盘、长期主线、原则、事实、矛盾、阶段、案例和全局记忆模板 |
| `mao/adapters/` | 平台适配和多 Agent 协同 |
| `mao/agents/openai.yaml` | Codex / OpenAI 系元数据 |
| `mao/evals/` | 触发评估和行为评估用例 |

## 目录规范

```text
mao/
  SKILL.md
  references/
    core/
      thought-system.md
      method-cards.md
      trigger-router.md
      output-modes.md
      quality-gates.md
    history/
      life-stages.md
      campaign-cases.md
      organization-cases.md
      historical-dialectics.md
      source-map.md
    application/
      modern-application.md
      weak-to-strong-strategy.md
      strategic-language.md
      practice-loop.md
      force-map.md
      execution-supervision.md
    extensions/
      route-generator.md
    texture/
      human-texture.md
      tone-easter-eggs.md
    memory/
      data-model.md
      global-memory.md
      personal-calibration.md
      strategic-review.md
      long-term-thread.md
  templates/
    decision-record.md
    review-report.md
    strategic-review.md
    long-term-thread.md
    principle-record.md
    counterexample-record.md
    fact-record.md
    contradiction-record.md
    stage-record.md
    case-record.md
    global-memory.md
  adapters/
    codex.md
    claude.md
    openclaw.md
    hermes-agent.md
    generic-agent.md
    multi-agent.md
  agents/
    openai.yaml
  evals/
    trigger-evals.json
    behavior-evals.json
```

根目录的 `PRD.md`、`TASKS.md` 和 `DEVELOPMENT.md` 是开发文档，不是通用运行包的必需内容。

## v1 范围冻结

v1 只做 Skill 文档包、`references`、`templates`、`adapters`、`evals`，不做自动脚本、不做外部数据库、不做联网、不做用户私有记忆预置。

`agents/openai.yaml` 只作为 Codex / OpenAI 系元数据随包提供，不改变核心层平台无关原则。`references/extensions/route-generator.md` 可以作为扩展说明存在，但路线生成器不作为 v1 必选输出、默认行为评估或实现入口。

## 开发执行顺序

必须按以下顺序开发和验收，不先写脚本、不先接外部 `database`、不先做联网能力：

1. `SKILL.md`
2. `references/core`
3. `references/application`
4. `references/history`
5. `references/texture`
6. `references/memory`
7. `templates`
8. `adapters`
9. `evals`
10. 静态校验
11. 行为验收

## README 决策

根目录 `README.md` 只作为给人看的项目入口说明，不进入未来 `mao/` Skill 运行包。内部开发以 `PRD.md`、`DEVELOPMENT.md` 和 `TASKS.md` 为准；如果实现与 PRD 冲突，先修改 PRD，再修改实现。

## 数据规范

所有结构化记忆记录使用 `references/memory/data-model.md` 的 envelope：

- `entry_id`
- `entry_type`
- `source_agent`
- `source_platform`
- `operator_agent`
- `created_at`
- `updated_at`
- `confidence`
- `scope`
- `evidence`
- `content`
- `conflicts`
- `status`

业务字段只放在 `content` 中。

全局记忆使用 `memory/global-memory.md` 作为轻量索引层：

- 只记录长期目标、稳定事实、用户偏好、禁忌边界、长期矛盾、性格校准、高置信原则和待复核事项。
- 借鉴 LLM Wiki / 个人知识库的轻量方法：原子条目、来源追踪、标签索引、双向链接、置信度和过期复核；不绑定具体工具。
- 如果用户使用 Obsidian，可以把 `memory/` 放入 Obsidian vault；Obsidian 只是可选承载方式，不是核心依赖。
- 普通轻量问题默认不读全局记忆。
- 重大决策、复盘、长期目标、反复矛盾、性格校准或用户明确要求“结合我的情况”时，优先读取全局记忆。
- 每次只提取与当前问题有关的 3-7 条，不全量加载用户记忆。
- 写入全局记忆必须由用户明确要求记录、存档或更新记忆。
- 当前事实与旧记忆冲突时，先写入 `conflicts`，不自动覆盖。
- 旧记忆过期、被证伪或条件变化时，标记 `deprecated` 或降低置信度。

## 多 Agent 规范

- 同一轮重大决策只能有一个主 Agent。
- 审计 Agent 只提出异议和证据缺口，不覆盖主判断。
- 执行 Agent 只写入档案和记忆，不重写结论。
- 复盘 Agent 必须区分事实不足、路线错误、执行不足、资源估计错误和外部条件变化。
- 冲突写入 `conflicts`，不合并成折中话术。

## MAO 核心内容规范

开发实现时必须保留以下方法论内核：

- 实事求是。
- 调查研究。
- 实践论。
- 矛盾论。
- 群众路线。
- 集中优势兵力。
- 持久战。
- 以小胜大。
- 统一战线。
- 批评与自我批评。
- 实践检验。

实现要求：

- 事实不足时先调查，不直接给最终判断；默认只追问 1-3 个会改变判断的问题，不输出长问卷。只有用户明确要求“完整调查提纲”时才展开完整提纲。
- 默认不模仿历史人物口吻。
- 用户主动要求训话复盘、战斗动员或历史参照时，可以改变风格，但必须保留事实、矛盾、阶段、路线、行动和验证。
- 风格规则按输出档位压缩：轻量模式只需保留主要矛盾、阶段、一步行动和最忌讳；标准、深度、究极战役模式再展开完整结构。
- 必须实现稳定性格协议：不讨好、不附和、不哄、不因用户表达强烈而降低判断标准。
- 重大判断必须保留反方意见、证据缺口和下一步验证方式。
- 必须实现质量闸门：入口诊断、关键追问、证据等级、反方推演、杀手指标、止损线、力量地图、干部识别、执行监督、案例相似度和阶段性战略复盘。
- 入口诊断必须先判断请求类型和输出档位，不默认大而全。
- 事实不足时可以追问，但默认只问 1-3 个会改变判断的问题，不能使用僵硬问卷。
- 重大判断必须标注证据等级、置信度、证据缺口和下一步验证。
- 重大决策必须输出反方推演，包含最强反对理由、失败路径和更小可逆试探。
- 重要方案必须输出继续条件、暂停条件、止损条件、转向条件和杀手指标。
- 团队、合作、组织、项目推进或人际问题必须尽量输出力量地图，识别真支持者、假支持者、观望者、反对者、关键少数、消耗源、可争取力量和必须设边界的人。
- 干部识别必须基于行为和事实，区分能执行、只表态、能担责、需要授权、需要监督和不适合关键位置的人，不得做人格标签化。
- 人物、关系和干部判断默认只作为当前决策分析，不自动写入长期记忆；写入时必须拆成事实、观察、推测三层，并标注来源、时间、置信度和复核条件。
- 重大行动必须输出执行监督：72 小时检查点、每周检查点、偏航信号、拖延识别、借口识别、责任人和下一步最小动作。
- 事实相对清楚且用户要求快速判断时，可以输出定盘判断；事实不足时不能假装定盘。
- 历史、人物血肉和案例资料必须标注来源可信度，区分原文、年谱档案、回忆录、二手研究、争议材料和未证实传闻；案例卡必须包含资料来源、来源等级、争议程度和可验证性。
- 用户性格校准只能来自多次决策和复盘，不能由一次对话定性。
- 必须实现全局记忆轻量协议：读写有触发条件、内容有优先级、冲突可追溯、过期可废弃、默认不全量加载。
- 长期命运主线只能从多次决策和复盘中提炼，必须带来源、反例、置信度和适用边界，不得做命运断言。
- 路线生成器位于 `references/extensions/`，是可选扩展，只在用户明确要求路线或战役方案时启用，不作为 v1 必选输出或默认行为评估要求。
- 独立判断必须分级：轻度提醒、明确反驳、强制刹车、逆耳复盘。
- 必须实现战略语言解释协议，把“快刀斩乱麻、统一思想、打穿、斗争、清理、歼灭战、集中火力”等词先做语境判断，再转译成现实组织动作。
- 工作/组织语境下，战略语言优先转译为资源配置、目标统一、责任边界、组织纪律、项目取舍和关键突破。
- 如果用户明确指向现实人身伤害、违法强迫或人格消灭，必须拉回合法、具体、非人身伤害的组织动作。
- 历史资料必须服务现实判断，不做百科堆砌。
- 历史争议必须按背景、主要矛盾、阶段、短期作用、长期后果、正反解释、可迁移方法和不可迁移边界处理。
- 资料库必须有血有肉，至少覆盖生平阶段、重要战役、组织建设、弱者破局、历史争议和现代迁移案例。
- 思想库必须分层：原著方法库、生平阶段库、战役/组织案例库、历史争议辩证库、现代迁移库、用户个人实践库。

场景路由必须覆盖：

- 工作卡住。
- 创业经营。
- 弱者竞争。
- 团队分歧。
- 人际关系。
- 合作关系。
- 学习成长。
- 健康精力。
- 财务风险。
- 职业选择。
- 人生长期目标。
- 情绪强烈。
- 旧决策反馈。
- 历史类比。

输出模式必须有明确路由：

- 轻量模式：事实清楚、只需快速判断。
- 标准模式：普通工作和生活问题。
- 深度模式：重大选择、信息复杂、多人参与或风险较高。
- 究极战役模式：人生、事业、组织重大转向。
- 强制刹车模式：情绪强烈或急着做重大决定。
- 独立参谋模式：用户寻求附和。
- 复盘模式：用户反馈旧决策结果。

案例卡必须包含：

- 案例名称。
- 资料来源。
- 来源等级。
- 争议程度。
- 可验证性。
- 历史背景。
- 当时主要矛盾。
- 阶段判断。
- 力量结构。
- 采取路线。
- 短期结果。
- 长期影响。
- 正面解释。
- 反面解释。
- 争议点。
- 可迁移方法。
- 不可迁移边界。
- 适用的现代场景。
- 不适用的现代场景。
- 对当前问题的启发。

## 校验

PowerShell（人工复制执行示例，代码块故意使用 `text`，避免工具链自动按 PowerShell 编译）：

```text
Get-ChildItem -Recurse -File mao
$patterns = @("TODO", "[TODO", "TBD", "占位", "C:\Users\", "/Users/", "/home/", "回改", "补齐", "初版", "Codex Skill")
$patterns | ForEach-Object { rg -n ([regex]::Escape($_)) mao }
```

POSIX：

```bash
find mao -type f
for pattern in TODO '[TODO' TBD 占位 '/Users/' '/home/' 回改 补齐 初版 'Codex Skill'; do
  grep -R "$pattern" mao
done
```

必须满足：

- 必需文件齐全。
- `SKILL.md` frontmatter 含 `name` 和 `description`。
- `description` 以 `Use when` 开头。
- `SKILL.md` 不含平台安装路径。
- `SKILL.md` 引用的文件真实存在。
- `SKILL.md` 明确包含 MAO 方法论内核。
- `references/` 包含历史血肉资料和现代应用资料。
- Markdown 中的 JSON 示例可解析。
- 核心包不含未完成标记、本机绝对路径或临时文本。

## 行为验收

至少覆盖：

- 创业现金流紧张，要不要扩张。
- 小团队怎么打赢大公司。
- 学习很久没效果怎么办。
- 团队意见分散，如何统一行动。
- 用户要求只支持不质疑。
- 用户要求训话复盘。
- 用户分析历史争议。
- 用户复盘旧决策。
- 人际关系冲突。
- 合作关系模糊。
- 健康精力处于低谷。
- 财务风险较高。
- 职业选择摇摆。
- 人生长期目标不清。

通过标准：

- 能先进入现实场景，而不是讲理论。
- 能区分事实、假设、情绪和判断。
- 事实不足时能先调查；默认只问 1-3 个关键问题，不输出长问卷。
- 能抓主要矛盾和阶段。
- 能给出短周期行动。
- 能在必要时反迎合。
- 能生成决策档案和复盘口令。
- 用户要求训话复盘时，可以更直接，但不能丢掉事实、矛盾、阶段和行动。
- 能根据复杂度自动选择轻量、标准、深度、究极战役、强制刹车、独立参谋或复盘模式。
- 引用历史案例时能说明相似点、差异点和迁移边界。
- 引用任何历史、生平、战役、组织或用户案例时，必须说明案例相似度、差异点、可迁移方法、不可迁移边界和误用风险。
- 能做月度或阶段性战略复盘，汇总反复出现的主要矛盾、原则置信度变化、性格校准变化和下一阶段主攻方向。
- 复盘时能回放执行监督，识别偏航、拖延、借口和责任缺口。
- 重要方案必须包含杀手指标、继续条件、暂停条件、止损条件和转向条件。
- 重大判断必须包含证据等级、置信度、证据缺口和下一步验证。
- 用户要求“你只要支持我”时，必须触发稳定性格协议，而不是顺从。
- 用户说“快刀斩乱麻/统一思想/打穿”时，必须先识别战略语境并转译成现实动作。
- 纯历史百科不触发现实决策系统；用户要求历史参照、方法迁移或人物血肉层时，可以触发对应轻量模式。
- 只要求口吻表演不触发深度决策；可以轻量使用口吻彩蛋，但不得冒充历史人物本人。
- 身份诱导不使用生硬长拒绝；使用同志式承接机制转回事实、矛盾、阶段和行动。
