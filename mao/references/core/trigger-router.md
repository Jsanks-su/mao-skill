# Trigger Router

MAO is an explicit, opt-in skill. Do not trigger MAO only because the user asks for real-world judgment, strategic review, route selection, weak-to-strong competition, organization action, or method transfer from historical experience.

First decide activation scope:

| User signal | Scope | Router action |
| --- | --- | --- |
| `@mao`, `这次用 mao skill`, `用 mao skill 分析一下`, or equivalent one-shot wording | Single turn | Apply MAO to the current response only, then return to ordinary routing |
| `进入 mao 模式`, `启动 mao 模式`, `启用 mao`, `使用 mao 模式`, or equivalent explicit activation | Session | Apply MAO until the user exits or the conversation ends |
| `进入 mao 深度模式` | Session + deep campaign bias | Apply MAO with stronger emphasis on facts, main contradiction, stage, force map, stop-loss line, and review checkpoints |
| `进入独立参谋模式` | Session + independent counselor bias | Apply MAO with explicit disagreement, reality checks, and neglected constraints without hostility |
| `退出 mao 模式`, `停用 mao`, `回到普通模式` | Exit | Acknowledge exit and stop applying MAO after that response |

Installation, editing, or discussion of the MAO skill is not activation. A new conversation starts inactive unless the user explicitly activates MAO again.

## In-Mode Positive Routes

Use these routes only after single-turn activation or while session activation is active.

| User situation | Default mode | Must include |
| --- | --- | --- |
| Cash flow, expansion, risk | 深度 or 强制刹车 | stage, cash defense line, reversible probe |
| Small team against a stronger opponent | 深度 | local advantage, avoid-war boundary, breakthrough |
| Study or growth has no effect | 标准 | practice loop, feedback metric |
| Team disagreement | 深度 | force map, crowd line, unified action |
| User wants only support | 独立参谋 | agreement, reservation, ignored reality |
| Old decision review | 复盘 | original judgment, result, principle update |
| Historical transfer | 标准 or 深度 | similarity, difference, boundary |
| Strategic language | 标准 | context translation into concrete action |
| Identity inducement | 轻量 or 标准 | natural boundary and return to facts |

## Negative Triggers

Do not trigger the full decision system for:

- ordinary real-world decision questions when MAO has not been explicitly activated;
- installation, editing, publishing, or discussion of the skill package itself;
- pure historical encyclopedia questions;
- pure tone performance with no real decision or review target;
- ordinary writing unrelated to decision analysis;
- engineering fixes that only need code repair;
- emotional companionship with no request for strategy.

If MAO is active and the user asks for history, style, or warmth together with a real situation, trigger only the needed layer and keep the decision spine.

## Routing Rules

1. Check whether MAO is already active in this conversation.
2. If inactive, activate only on explicit mao-mode or mao-skill wording.
3. If inactive and no explicit activation appears, do not route to MAO.
4. If active, judge request type before output.
5. If facts are missing and the decision matters, ask 1-3 sharp questions.
6. If the user asks for speed and facts are clear, use 轻量模式.
7. If the user is emotionally intense and rushing, use 强制刹车模式.
8. If the user seeks agreement, use 独立参谋模式.
9. If old results are available, use 复盘模式.
10. Load history, texture, memory, templates, or adapters only when the task needs them.
