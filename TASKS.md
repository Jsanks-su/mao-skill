# MAO Tasks

## Final Consistency Audit

开发前只查三件事：

- [x] `PRD.md`、`DEVELOPMENT.md`、`TASKS.md` 之间没有范围、结构、验收标准冲突。
- [x] v1 必选能力和 `references/extensions/` 扩展能力没有混淆。
- [x] 没有旧口径残留：不把 MAO 写成 Codex-only，不把路线生成器写成 v1 默认行为，不写自动脚本、外部数据库、联网或用户私有记忆预置。

## v1 Scope Freeze

v1 只做 Skill 文档包、`references`、`templates`、`adapters`、`evals`，不做自动脚本、不做外部数据库、不做联网、不做用户私有记忆预置。

`agents/openai.yaml` 仅作为 Codex / OpenAI 系元数据随包提供，不是核心依赖，也不改变跨 Agent 定位。

## Development Order

- [x] `SKILL.md`
- [x] `references/core`
- [x] `references/application`
- [x] `references/history`
- [x] `references/texture`
- [x] `references/memory`
- [x] `templates`
- [x] `adapters`
- [x] `evals`
- [x] 静态校验
- [x] 行为验收

## README Decision

- [x] 根目录 `README.md` 只作为给人看的项目入口说明，不进入未来 `mao/` Skill 运行包；开发仍以 `PRD.md`、`DEVELOPMENT.md` 和 `TASKS.md` 为准。

## Release Gate

发布前必须完成以下检查：

- [x] 核心结构完整：`SKILL.md`、`references/`、`templates/`、`adapters/`、`agents/openai.yaml`、`evals/`。
- [x] 核心方法完整：实事求是、调查研究、实践论、矛盾论、群众路线、集中优势兵力、持久战、以小胜大、统一战线、批评与自我批评、实践检验。
- [x] 血肉资料完整：生平阶段、重要战役、组织建设、弱者破局、历史争议和现代迁移案例。
- [x] 思想库分层完整：原著方法库、生平阶段库、战役/组织案例库、历史争议辩证库、现代迁移库、用户个人实践库。
- [x] 稳定性格协议完整：不讨好、不附和、不哄，重大判断保留反方意见、证据缺口和验证方式。
- [x] 质量闸门完整：入口诊断、关键追问、证据等级、反方推演、杀手指标、止损线、力量地图、干部识别、执行监督、案例相似度、阶段性战略复盘。
- [x] 用户性格校准完整：只从多次决策和复盘中提炼，不因一次对话给用户贴标签。
- [x] 全局记忆协议完整：读写触发、优先级、冲突处理、隐私边界、过期废弃和 token 控制明确。
- [x] 长期命运主线完整：只能从多次决策和复盘中提炼，必须带来源、反例、置信度和适用边界。
- [x] 战略语言解释协议完整：快刀斩乱麻、统一思想、打穿、斗争、清理、歼灭战、集中火力等能按语境转译为现实动作。
- [x] 场景路由完整：工作、创业、弱者竞争、团队、人际、合作、学习、健康、财务、职业、人生长期目标、情绪强烈、旧决策、历史类比。
- [x] 输出模式路由完整：轻量、标准、深度、究极战役、强制刹车、独立参谋、复盘。
- [x] 案例卡质量合格：包含资料来源、来源等级、争议程度、可验证性、背景、主要矛盾、阶段、力量结构、路线、结果、正反解释、迁移方法和边界。
- [x] 风格规则正确：默认不模仿口吻；用户主动要求训话复盘、历史参照或口吻彩蛋时可启用风格；轻量模式可压缩结构，但不能丢掉方法内核。
- [x] `SKILL.md` 平台无关，安装路径只出现在 adapter 中。
- [x] adapter 覆盖 Codex、Claude、OpenClaw、Hermes Agent、generic-agent 和多 Agent 协同。
- [x] 共享记忆字段在 `references/memory/data-model.md` 和模板中一致。
- [x] `templates/` 覆盖 `global-memory`、`long-term-thread`、`fact`、`decision`、`review`、`strategic-review`、`principle`、`counterexample`、`contradiction`、`stage` 和 `case`。
- [x] 所有 JSON 示例可解析。
- [x] 无未完成标记、本机绝对路径和乱码。
- [x] 行为场景验收通过。
- [ ] 用户确认目标平台后再安装。

## Static Checks

PowerShell（人工复制执行示例，代码块故意使用 `text`，避免工具链自动按 PowerShell 编译）：

```text
Get-ChildItem -Recurse -File mao
$patterns = @("TODO", "[TODO", "TBD", "占位", "C:\Users\", "/Users/", "/home/", "回改", "补齐", "初版", "Codex Skill")
$patterns | ForEach-Object { rg -n ([regex]::Escape($_)) mao }
```

JSON 检查：

```text
$failures = @()
Get-ChildItem -Recurse -Filter *.md | ForEach-Object {
  $text = Get-Content -Raw -Encoding UTF8 -LiteralPath $_.FullName
  $fence = [string]([char]96) + [string]([char]96) + [string]([char]96)
  $matches = [regex]::Matches($text, $fence + 'json\s*(.*?)\s*' + $fence, [System.Text.RegularExpressions.RegexOptions]::Singleline)
  for ($i = 0; $i -lt $matches.Count; $i++) {
    try { $null = $matches[$i].Groups[1].Value.Trim() | ConvertFrom-Json -ErrorAction Stop }
    catch { $failures += "$($_.FullName):json-block-$($i + 1)" }
  }
}
if ($failures.Count) { $failures; exit 1 } else { "JSON blocks OK" }
```

## Behavior Checks

- [x] 现金流紧张是否扩张：输出主要矛盾、阶段判断和 72 小时行动。
- [x] 入口诊断：先判断请求类型和输出档位，不默认大而全。
- [x] 弱者竞争：输出局部优势、避战边界和集中突破点。
- [x] 事实不足：先调查而不是直接给结论；默认只问 1-3 个关键问题，不输出长问卷。
- [x] 证据等级：重大判断必须标注证据等级、置信度、证据缺口和下一步验证。
- [x] 反方推演：重大决策必须输出最强反对理由、失败路径和更小可逆试探。
- [x] 止损线：重要方案必须输出继续、暂停、止损和转向条件。
- [x] 关键追问：事实不足时只问 1-3 个会改变判断的问题，不使用僵硬问卷。
- [x] 力量地图：团队、合作、组织或人际问题必须识别真支持者、假支持者、观望者、反对者、关键少数、消耗源、可争取力量和边界对象。
- [x] 干部识别：必须区分谁能执行、谁只表态、谁能担责、谁需要授权、谁需要监督、谁不适合关键位置。
- [x] 人物/关系/干部记忆边界：默认只用于当前决策分析，不自动写入长期记忆；写入时必须拆成事实、观察、推测并标注来源、时间、置信度和复核条件。
- [x] 执行监督：重大行动必须输出 72 小时检查点、每周检查点、偏航信号、拖延识别、借口识别、责任人和下一步最小动作。
- [x] 定盘判断：事实清楚且用户要求快速判断时，用一句话压缩主要矛盾、当前行动和最忌讳。
- [x] 学习无效：输出实践闭环和反馈指标。
- [x] 团队分歧：输出力量结构、群众路线和统一行动方案。
- [x] 人际冲突：区分对抗性和非对抗性矛盾，给出边界和协调方案。
- [x] 合作关系：输出利益结构、责任边界、可争取力量和退出条件。
- [x] 健康精力：判断防御/相持/反攻阶段，先保基础盘。
- [x] 财务风险：输出现金流、防御线、不可逆风险和最小试探。
- [x] 职业选择：输出主要矛盾、阶段判断、能力主攻方向和机会窗口。
- [x] 人生长期目标：输出持久战阶段路线和 30 天最小闭环。
- [x] 寻求附和：触发独立参谋协议。
- [x] 人格独立：用户要求“你只要支持我”时，输出同意部分、保留部分、忽略现实、坚持判断和验证方式。
- [x] 战略语言：用户说“我要快刀斩乱麻/统一思想/打穿这个问题”时，先判断语境，再转译成目标、边界、纪律、取舍和突破口。
- [x] 训话复盘：风格可以直接，但必须保留事实、矛盾、阶段、行动和验证。
- [x] 历史争议：区分可迁移方法和不可迁移边界。
- [x] 历史案例引用：必须说明相似点、差异点、迁移边界，不适合类比时明确拒绝类比。
- [x] 历史/口吻轻量触发：纯历史百科不触发现实决策系统；只要求口吻表演不触发深度决策，但可轻量使用口吻彩蛋。
- [x] 身份诱导防护：不生硬长拒绝，使用同志式承接机制转回事实、矛盾、阶段和行动。
- [x] 旧决策复盘：对照原判断，更新原则和反例。
- [x] 性格校准：多次复盘后才能更新用户长期偏差，不因一次对话贴标签。
- [x] 全局记忆：重大决策、复盘、长期目标、反复矛盾或用户要求“结合我的情况”时读取；普通轻量问题不全量读取。
- [x] 全局记忆写入：只有用户明确要求记录、存档或更新记忆时才写入；冲突写入 `conflicts`，不自动覆盖。
- [x] 案例相似度：引用历史、生平或用户案例时必须说明相似点、差异点、可迁移方法、不可迁移边界和误用风险。
- [x] 资料来源可信度：历史、人物血肉和案例引用必须区分原文、年谱档案、回忆录、二手研究、争议材料和未证实传闻；案例卡必须包含资料来源、来源等级、争议程度和可验证性。
- [x] 阶段性复盘：能汇总月度或阶段主要矛盾、原则置信度变化、性格校准变化和下一阶段主攻方向。
- [x] 执行监督复盘：复盘时能回放检查点，识别偏航、拖延、借口和责任缺口。
- [x] 长期命运主线：多次决策和复盘后，能提炼长期矛盾、稳定优势、常见误判、反复代价、阶段底盘和主攻方向。
- [x] 多 Agent 冲突：保留分歧，并给出下一步验证方法。

## Extension Behavior Checks

- [x] 路线生成器：作为 `references/extensions/` 下的可选扩展，只在用户明确要求路线或战役方案时输出主路线、备路线、退路线、试探路线和暂不进入的战场；不作为 v1 默认行为评估要求。

## Install

安装只在用户明确目标平台后执行。

发布包包含：

```text
mao/
  SKILL.md
  references/
  templates/
  adapters/
  agents/
  evals/
```

发布包不包含用户私有 `memory/`。
