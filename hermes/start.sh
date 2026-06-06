#!/bin/bash
# Hermes Agent 持久化启动脚本

# 持久化路径
PERSISTENT_DIR="/workspace/hermes"
CONFIG_DIR="$PERSISTENT_DIR/config"
CODE_DIR="$PERSISTENT_DIR/code"
VENV_DIR="$CODE_DIR/venv"

# 检查并创建符号链接
if [ ! -L "/root/.hermes" ] && [ ! -d "/root/.hermes" ]; then
    ln -sf "$CONFIG_DIR" "/root/.hermes"
    echo "✓ Created symlink: /root/.hermes -> $CONFIG_DIR"
fi

# 检查并链接代码目录
if [ ! -L "/usr/local/lib/hermes-agent" ] && [ ! -d "/usr/local/lib/hermes-agent" ]; then
    ln -sf "$CODE_DIR" "/usr/local/lib/hermes-agent"
    echo "✓ Created symlink: /usr/local/lib/hermes-agent -> $CODE_DIR"
fi

# 检查虚拟环境，如果没有就复制原来的
if [ ! -d "$VENV_DIR" ] && [ -d "/usr/local/lib/hermes-agent/venv" ]; then
    echo "✓ Copying virtual environment from original location..."
    cp -a /usr/local/lib/hermes-agent/venv "$VENV_DIR"
fi

# 创建 hermes 命令启动脚本（使用正确的包装脚本）
cp "$CODE_DIR/hermes" /usr/local/bin/hermes
chmod +x /usr/local/bin/hermes

# 确保使用正确的 Python 虚拟环境
sed -i '1c\#!/workspace/hermes/code/venv/bin/python3' /usr/local/bin/hermes

echo ""
echo "=========================================="
echo "  Hermes Agent 持久化配置已就绪"
echo "=========================================="
echo "  配置目录: $CONFIG_DIR"
echo "  代码目录: $CODE_DIR"
echo ""
echo "  运行 'hermes' 启动 Agent"
echo "=========================================="
