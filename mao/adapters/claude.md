# Claude Adapter

## Install

Place `mao/` in the local skill directory supported by the Claude or Claude Code environment.

## Discovery

The environment should read `SKILL.md` frontmatter and match tasks through the `description`.

## Notes

- Keep the core package portable.
- Do not depend on Codex-specific paths or commands.
- Load references progressively.
- Keep user-visible output in Chinese by default unless the user asks otherwise.
