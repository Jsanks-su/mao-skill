# Claude 适配

## 安装

把 `mao/` 放到 Claude 或 Claude Code 环境支持的本地 skill 目录。

## 发现

环境应读取 `SKILL.md` 的 frontmatter，并通过 `description` 匹配任务。

## 注意

- 核心包保持可移植。
- 不依赖 Codex 专属路径或命令。
- 渐进读取参考资料。
- 用户可见输出默认中文，除非用户要求其他语言。
