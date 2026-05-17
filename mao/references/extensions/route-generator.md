# Route Generator

The route generator is an optional extension. It is not default v1 behavior and should not be required by behavior evals.

## Trigger

Use only when the user explicitly asks for a route, campaign plan, or route set.

## Output

```text
【主路线】
【备路线】
【退路线】
【试探路线】
【暂不进入的战场】
【切换条件】
```

## Rules

- Keep routes grounded in current facts.
- Include stop-loss and switch conditions.
- Avoid irreversible action when evidence is weak.
- Do not replace investigation with route enthusiasm.
