# Memory Data Model

This model defines a portable envelope for structured memory records. It does not create private user memory by itself.

## Envelope

All structured records use:

```json
{
  "entry_id": "string",
  "entry_type": "fact|decision|review|principle|counterexample|contradiction|stage|case|global-memory|long-term-thread",
  "source_agent": "string",
  "source_platform": "string",
  "operator_agent": "string",
  "created_at": "YYYY-MM-DD",
  "updated_at": "YYYY-MM-DD",
  "confidence": 0.75,
  "scope": "session|project|user-approved-long-term",
  "evidence": [
    {
      "type": "first-hand|second-hand|inference|analogy|historical-analogy",
      "source": "string",
      "note": "string"
    }
  ],
  "content": {},
  "conflicts": [],
  "status": "active|deprecated|needs-review"
}
```

Business fields belong inside `content`.

## Rules

- Separate facts, observations, and inferences.
- Mark source, time, confidence, and review condition.
- Write conflicts instead of overwriting.
- Lower confidence or mark deprecated when evidence changes.
- Do not store private memory unless the user explicitly asks.
