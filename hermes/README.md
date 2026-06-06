# Hermes Agent Configuration

这个目录包含 Hermes Agent 的配置和启动脚本。

## 快速开始

### 1. 首次设置

```bash
cd hermes
./setup.sh
```

### 2. 配置密钥

编辑 `hermes/.env` 文件，填入你的 API 密钥和 QQBot 凭证：

```bash
# Custom LLM Provider
CUSTOM_LLM_API_KEY=your_actual_api_key
CUSTOM_LLM_BASE_URL=https://win847.top/llmapi/v1

# QQBot Configuration
QQ_APP_ID=your_actual_app_id
QQ_CLIENT_SECRET=your_actual_secret

# Default Model
DEFAULT_MODEL=custom/glm-5-1
```

### 3. 启动网关

```bash
./start.sh
```

选择 `2` 以在后台启动网关，或选择 `1` 以前台启动进行调试。

## 文件说明

| 文件 | 说明 |
|------|------|
| `setup.sh` | 一键安装和配置脚本 |
| `start.sh` | 网关启动和管理脚本 |
| `.env.example` | 环境变量模板（不含密钥） |
| `config/config.yaml.example` | 配置文件模板（不含密钥） |
| `config/config.yaml` | 实际配置文件（.gitignore中） |
| `config/.env` | 实际环境变量（.gitignore中） |
| `config/logs/` | 网关日志目录（.gitignore中） |

## 重要说明

- `.env` 和 `config.yaml` 包含敏感信息，**不会**被提交到 git
- 每次虚拟机重置后，只需重新运行 `setup.sh` 然后编辑 `.env` 即可
- `hermes-agent` 包是通过 pip 安装的，虚拟机重置后需要重新安装（setup.sh会处理）

## 手动操作

如果不使用脚本，可以手动操作：

```bash
# 安装 hermes-agent
pip install hermes-agent

# 配置符号链接
ln -sf /workspace/hermes/config /root/.hermes

# 编辑配置文件
cd /workspace/hermes
cp .env.example .env
# 编辑 .env 填入真实密钥

# 启动网关
hermes gateway run
```
