# Hermes Agent Adapter

## Install

Register `mao/SKILL.md` as the primary instruction file in the Hermes Agent skill or tool package configuration.

## Runtime

Hermes Agent should:

1. read the metadata;
2. load `SKILL.md` on trigger;
3. load resource files only when a task requires them;
4. keep user-approved memory separate from the release package.

## Notes

- Keep platform setup outside the core method files.
- Preserve conflict records instead of merging them into smooth compromise.
