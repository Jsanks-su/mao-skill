# MAO Skill

MAO Skill 是一个跨 Agent、跨系统的现实决策 Skill 项目。

它不是语录生成器、口吻模仿器、历史百科或情绪陪伴品，而是一个以实事求是为底层、以矛盾分析为核心、以调查研究、群众路线、集中优势兵力、持久战、以小胜大、独立参谋和实践复盘为方法的长期现实决策系统。

## 当前状态

项目当前处于文档冻结和开发准备阶段。

现有根目录文档：

- `PRD.md`：产品定义、方法内核、行为边界、资料结构和验收标准。
- `DEVELOPMENT.md`：开发规范、目录职责、跨平台和多 Agent 实现要求。
- `TASKS.md`：开发任务、发布检查、行为验收和扩展项。
- `README.md`：项目入口说明，仅用于根目录展示，不作为 Skill 运行包内容。

## v1 范围冻结

v1 只做 Skill 文档包、`references`、`templates`、`adapters`、`evals`，不做自动脚本、不做外部数据库、不做联网、不做用户私有记忆预置。

`agents/openai.yaml` 只作为 Codex / OpenAI 系元数据随包提供，不改变核心跨 Agent 定位。

## 核心价值

MAO Skill 的目标不是让 Agent “像毛泽东一样说话”，而是把毛泽东思想中可迁移的方法论转化为现实问题的分析和行动系统：

- 先调查现实，不先套结论。
- 抓主要矛盾，不平均用力。
- 判断阶段，不幻想速胜。
- 识别力量结构，不只看表态。
- 集中优势兵力，打穿关键突破口。
- 在弱势条件下寻找局部优势、根据地、杠杆和时机。
- 保留独立参谋人格，不讨好、不附和、不哄。
- 通过决策档案、复盘和原则更新，让系统越用越有历史感。

## 计划发布包结构

```text
mao/
  SKILL.md
  references/
  templates/
  adapters/
  agents/
  evals/
```

发布包不包含用户私有 `memory/`，也不包含根目录开发文档。

## 开发顺序

按以下顺序执行：

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

## 平台目标

核心内容保持平台无关，适配层覆盖：

- Codex
- Claude / Claude Code
- OpenClaw
- Hermes Agent
- 其他兼容 Agent

Windows 和 macOS 都必须支持安装、读取和校验。

## 重要边界

- 不把平台适配写进核心方法。
- 不把历史资料当成现实决策的直接答案。
- 不把口吻彩蛋变成口吻壳子。
- 不把一次经验升级成普遍原则。
- 不默认读取或写入用户私有记忆。
- 不把路线生成器混入 v1 默认行为；它只作为 `references/extensions/` 下的可选扩展。

## 开发依据

开发以 `PRD.md`、`DEVELOPMENT.md` 和 `TASKS.md` 为准。若实现与 PRD 冲突，先修改 PRD，再修改实现。

## Activation Model

MAO Skill is opt-in, not global.

- Single turn: `@mao ...`, `这次用 mao skill ...`
- Session: `进入 mao 模式`, `启动 mao 模式`, `使用 mao 模式`
- Deep campaign session: `进入 mao 深度模式`
- Independent counselor session: `进入独立参谋模式`
- Exit: `退出 mao 模式`, `停用 mao`, `回到普通模式`

Installation, editing, publishing, or discussing the skill does not activate it. Ordinary decision questions do not trigger MAO unless the user explicitly starts or uses MAO mode.
