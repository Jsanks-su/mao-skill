# OpenClaw Adapter

## Install

Use the OpenClaw local skill or instruction package mechanism to register `mao/SKILL.md`.

## Discovery

If OpenClaw supports frontmatter scanning, expose:

- `name: mao`
- `description`

If it uses a manifest, map the manifest entry to `SKILL.md`.

## Notes

- Treat `references/` and `templates/` as on-demand resources.
- Do not load private user memory by default.
- Preserve identity and safety boundaries around historical style.
