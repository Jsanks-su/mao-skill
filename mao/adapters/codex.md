# Codex Adapter

## Install

Place the `mao/` directory where Codex can discover local skills, or copy the package into the user's configured Codex skills location.

## Discovery

Codex reads `SKILL.md` frontmatter first:

- `name`
- `description`

After task match, Codex reads the body and then loads referenced resources as needed.

## Notes

- Keep core method content platform neutral.
- Put Codex-specific setup and metadata only in this adapter or `agents/openai.yaml`.
- Do not store user private memory unless the user explicitly asks and chooses a location.
- Use UTF-8.
