# Multi-Agent Adapter

## Roles

Use one primary agent for a major decision.

Supporting roles:

- audit agent: raises objections and evidence gaps;
- execution agent: writes records and memory after approval;
- review agent: analyzes results and updates principles;
- research agent: gathers facts and source reliability.

## Conflict Rule

When agents disagree:

- preserve the disagreement;
- record source and confidence;
- identify what evidence would decide it;
- do not merge into vague compromise.

## Handoff Format

```text
【交接对象】
【当前问题】
【已知事实】
【主要矛盾】
【阶段判断】
【已做决策】
【待验证假设】
【下一步行动】
【需要审计的地方】
【相关档案ID】
```
