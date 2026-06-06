# Hermes Agent 持久化配置说明

## 目录结构
```
/workspace/hermes/
├── config/          # 配置目录（持久化）
├── code/            # 代码目录（持久化）
├── start.sh         # 启动脚本
└── README.md        # 本说明文件
```

## 使用方法
### 1. 首次启动（或重启后）
```bash
cd /workspace/hermes
bash start.sh
```

### 2. 正常使用 Hermes
```bash
hermes
```

### 3. 配置模型配置
编辑配置文件：
```bash
nano /workspace/hermes/config/config.yaml
```

## 当前模型配置
| 配置项 | 值 |
|--------|-----|
| **默认模型** | `glm-5-1` |
| **Provider** | `custom` |
| **API Base URL** | `https://win847.top/llmapi/v1` |
| **API Key** | `sk-aiproxy` |

## 可用模型列表
- Google/Gemini 系列
  - `google/gemini-3.5-flash`
  - `google/gemini-3.1-pro-preview`
  - `google/gemini-3.1-flash-lite-preview`
  - `google/gemini-3.1-flash-image-preview`
  - `google/gemini-3-flash-preview`
  - `google/gemini-2.5-pro`
  - `google/gemini-2.5-flash`
  - `google/gemini-2.0-flash-001`
  - `google/gemini-2.0-flash-lite-001`
  - `google/gemini-2.0-flash-lite`

- GLM 系列
  - `glm-5`
  - `glm-5-1` (当前默认)

- 其他开源模型
  - `llama4-scout-17b-16e-instruct`
  - `deepseek-coder-v2-lite-instruct`
  - `gpt-oss-120b`
  - `qwen2-5-coder-32b-instruct`
  - `gemma4-31b-it`
  - `qwen3-5-122b-a10b`
  - `qwen3-6-35b-a3b`

- AWS/Claude 系列
  - `aws/anthropic.claude-haiku-4-5-20251001-v1:0`
  - `aws/anthropic.claude-sonnet-4-5-20250929-v1:0`
  - `aws/anthropic.claude-sonnet-4-6`
  - `aws/anthropic.claude-opus-4-6-v1`
  - `aws/anthropic.claude-opus-4-7`

- Azure/GPT 系列
  - `azure/aide-gpt-4-turbo`
  - `azure/aide-gpt-4o`
  - `azure/aide-gpt-4o-mini`
  - `azure/aide-gpt-4.1`
  - `azure/aide-gpt-4.1-mini`
  - `azure/aide-gpt-4.1-nano`
  - `azure/aide-gpt-5`
  - `azure/aide-gpt-5-mini`
  - `azure/aide-gpt-5-nano`
  - `azure/gpt-5.5`
  - `azure/aide-o3`
  - `azure/aide-o3-mini`
  - `azure/aide-o4-mini`

## 持久化路径说明
| 项目 | 路径 |
|------|------|
| 持久化根目录 | `/workspace/hermes/` |
| 配置文件 | `/workspace/hermes/config/` |
| 程序代码 | `/workspace/hermes/code/` |
| 技能文件 | `/workspace/hermes/config/skills/` |
| 日志文件 | `/workspace/hermes/config/logs/` |
| 记忆数据 | `/workspace/hermes/config/memories/` |

## 快速启动
更换虚拟机后，只需执行：
```bash
cd /workspace/hermes
bash start.sh
```

选择 `1) 启动QQ网关（后台运行）` 即可一键启动所有服务！

## 命令说明
- `bash start.sh` - 配置环境并启动服务
- `bash stop.sh` - 停止QQ网关
- `hermes` - 使用Hermes CLI工具
- `hermes gateway run` - 手动启动QQ网关（前台）
- `tail -f /workspace/hermes/config/logs/gateway.log` - 查看网关日志

## 持久化结构
```
/workspace/hermes/
├── start.sh          # 一键启动脚本
├── stop.sh           # 停止脚本
├── code/             # Hermes代码（包含venv虚拟环境）
├── config/           # 所有配置和数据
│   ├── .env          # API密钥等环境变量
│   ├── config.yaml   # 主配置文件
│   ├── logs/         # 日志文件
│   ├── sessions/     # 会话数据
│   └── skills/       # 技能文件
└── README.md         # 本说明文件
```

## 注意事项
- ✅ 所有数据、配置、代码都在 `/workspace/hermes/` 下
- ✅ 更换虚拟机后只需运行 `bash start.sh` 即可恢复所有服务
- ✅ QQBot和自定义模型配置都已持久化保存

