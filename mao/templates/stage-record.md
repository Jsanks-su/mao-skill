# Stage Record Template

```json
{
  "entry_id": "stage-YYYYMMDD-slug",
  "entry_type": "stage",
  "source_agent": "agent-name",
  "source_platform": "platform-name",
  "operator_agent": "agent-name",
  "created_at": "YYYY-MM-DD",
  "updated_at": "YYYY-MM-DD",
  "confidence": 0.7,
  "scope": "session",
  "evidence": [],
  "content": {
    "stage": "defense|stalemate|counteroffensive|unclear",
    "basis": [],
    "core_task": "",
    "taboo_action": "",
    "condition_to_change_stage": ""
  },
  "conflicts": [],
  "status": "active"
}
```
