# Codex 适配

## 安装

把 `mao/` 目录放到 Codex 能发现本地 skills 的位置，或复制到用户配置的 Codex skills 目录。

## 发现

Codex 会先读取 `SKILL.md` 的 frontmatter：

- `name`
- `description`

任务匹配后，再读取正文，并按需加载引用资源。

## 注意

- 核心方法保持平台中立。
- Codex 相关设置只放在本适配文档或 `agents/openai.yaml`。
- 除非用户明确要求并指定位置，不要保存私人记忆。
