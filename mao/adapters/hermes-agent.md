# Hermes Agent 适配

## 安装

在 Hermes Agent 的 skill 或工具包配置中，把 `mao/SKILL.md` 注册为主指令文件。

## 运行时

Hermes Agent 应当：

1. 读取元数据。
2. 触发后加载 `SKILL.md`。
3. 只在任务需要时加载资源文件。
4. 把用户批准的记忆放在发布包之外。

## 注意

- 平台设置不要混入核心方法文件。
- 多 Agent 分歧要保留，不要合成圆滑折中。
