# Claude skills

## 安装 Claude code

```bash
npm install -g @anthropic-ai/claude-code

npm install -g agent-browser
agent-browser install
```

## 配置 DeepSeek 环境变量

Linux / Mac 用户执行以下命令配置 DeepSeek Anthropic API 环境变量，其中 API Key 在 DeepSeek Platform 获取：

```bash
export ANTHROPIC_BASE_URL=https://api.deepseek.com/anthropic
export ANTHROPIC_AUTH_TOKEN=<你的 DeepSeek API Key>
export ANTHROPIC_MODEL=deepseek-v4-pro[1m]
export ANTHROPIC_DEFAULT_OPUS_MODEL=deepseek-v4-pro[1m]
export ANTHROPIC_DEFAULT_SONNET_MODEL=deepseek-v4-pro[1m]
export ANTHROPIC_DEFAULT_HAIKU_MODEL=deepseek-v4-flash
export CLAUDE_CODE_SUBAGENT_MODEL=deepseek-v4-flash
export CLAUDE_CODE_EFFORT_LEVEL=max
```

Windows 用户执行：

```powershell
$env:ANTHROPIC_BASE_URL="https://api.deepseek.com/anthropic"
$env:ANTHROPIC_AUTH_TOKEN="<你的 DeepSeek API Key>"
$env:ANTHROPIC_MODEL="deepseek-v4-pro[1m]"
$env:ANTHROPIC_DEFAULT_OPUS_MODEL="deepseek-v4-pro[1m]"
$env:ANTHROPIC_DEFAULT_SONNET_MODEL="deepseek-v4-pro[1m]"
$env:ANTHROPIC_DEFAULT_HAIKU_MODEL="deepseek-v4-flash"
$env:CLAUDE_CODE_SUBAGENT_MODEL="deepseek-v4-flash"
$env:CLAUDE_CODE_EFFORT_LEVEL="max"
```

## Rust skills

Inside Claude code, run the following commands:

```
# 步骤 1: 添加 marketplace
/plugin marketplace add actionbook/rust-skills

# 步骤 2: 安装插件
/plugin install rust-skills@rust-skills
```

## 常用命令

```
# 查看所有可用的插件
/plugin list

# 刷新插件
/reload-plugins

# 简化代码，其实是一个 review 功能
# 注意这个会消耗极大量的token，同时因为CC的行为会把历史的背景全部上传，
# 而DeepSeek新版有1M的上下文容量，就会造成资源的极大量消耗。
# 在做完这一步之后应该要执行下面的clear命令，清理历史的背景。
/simplify

# 清理历史的背景
/clear

对现在的代码库进行 code review

清理所有的编译警告

修复所有发现的问题

继续你没完成的任务
```
