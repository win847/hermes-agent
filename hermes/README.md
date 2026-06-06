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

### 3. 配置 API Key
编辑配置文件：
```bash
nano /workspace/hermes/config/.env
```

## 持久化路径说明
| 项目 | 路径 |
|------|------|
| 持久化根目录 | `/workspace/hermes/` |
| 配置文件 | `/workspace/hermes/config/` |
| 程序代码 | `/workspace/hermes/code/` |
| 技能文件 | `/workspace/hermes/config/skills/` |
| 日志文件 | `/workspace/hermes/config/logs/` |
| 记忆数据 | `/workspace/hermes/config/memories/` |

## 注意事项
- 每次重启后，先运行 `bash /workspace/hermes/start.sh` 重建符号链接
- 所有数据都保存在 `/workspace/hermes/` 下，重启不会丢失
