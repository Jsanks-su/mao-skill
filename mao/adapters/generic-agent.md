# Generic Agent Adapter

## Install

For any agent that supports local instruction packages, use `mao/SKILL.md` as the entry file.

## Minimum Compatibility

The agent must support:

- reading Markdown;
- reading frontmatter or equivalent metadata;
- loading files by relative path;
- preserving UTF-8;
- keeping private user memory outside the release package.

## Fallback

If the agent cannot load resources on demand, load `SKILL.md` plus only the specific reference files needed for the current task.
