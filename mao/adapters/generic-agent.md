# 通用 Agent 适配

## 安装

任何支持本地指令包的 Agent，都以 `mao/SKILL.md` 作为入口文件。

## 最低兼容要求

Agent 需要支持：

- 读取 Markdown。
- 读取 frontmatter 或等价元数据。
- 按相对路径加载文件。
- 保持 UTF-8。
- 把私人用户记忆放在发布包之外。

## 降级方案

如果 Agent 不能按需加载资源，只加载 `SKILL.md` 和当前任务真正需要的少数参考文件。
