# OpenClaw 适配

## 安装

使用 OpenClaw 的本地 skill 或指令包机制注册 `mao/SKILL.md`。

## 发现

如果 OpenClaw 支持 frontmatter 扫描，暴露：

- `name`
- `description`

如果使用清单文件，把清单入口映射到 `SKILL.md`。

## 注意

- `references/` 和 `templates/` 都按需读取。
- 默认不加载私人用户记忆。
- 历史风格相关内容必须保留身份和安全边界。
