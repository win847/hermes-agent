#!/bin/bash
# Hermes Agent 完整启动脚本 - 持久化版本
# 更换虚拟机后运行此脚本即可启动全部服务

# 持久化路径
PERSISTENT_DIR="/workspace/hermes"
CONFIG_DIR="$PERSISTENT_DIR/config"
CODE_DIR="$PERSISTENT_DIR/code"
VENV_DIR="$CODE_DIR/venv"

echo "=========================================="
echo "  Hermes Agent 持久化启动"
echo "=========================================="

# 1. 检查并创建符号链接
if [ ! -L "/root/.hermes" ] && [ ! -d "/root/.hermes" ]; then
    ln -sf "$CONFIG_DIR" "/root/.hermes"
    echo "✓ Created symlink: /root/.hermes -> $CONFIG_DIR"
else
    echo "✓ Symlink /root/.hermes already exists"
fi

# 2. 检查并链接代码目录
if [ ! -L "/usr/local/lib/hermes-agent" ] && [ ! -d "/usr/local/lib/hermes-agent" ]; then
    ln -sf "$CODE_DIR" "/usr/local/lib/hermes-agent"
    echo "✓ Created symlink: /usr/local/lib/hermes-agent -> $CODE_DIR"
else
    echo "✓ Symlink /usr/local/lib/hermes-agent already exists"
fi

# 3. 检查虚拟环境，如果没有就复制原来的
if [ ! -d "$VENV_DIR" ] && [ -d "/usr/local/lib/hermes-agent/venv" ]; then
    echo "✓ Copying virtual environment from original location..."
    cp -a /usr/local/lib/hermes-agent/venv "$VENV_DIR"
elif [ -d "$VENV_DIR" ]; then
    echo "✓ Virtual environment exists"
fi

# 4. 创建 hermes 命令
cp "$CODE_DIR/hermes" /usr/local/bin/hermes
chmod +x /usr/local/bin/hermes
sed -i '1c\#!/workspace/hermes/code/venv/bin/python3' /usr/local/bin/hermes
echo "✓ Hermes CLI installed"

# 5. 加载环境变量
echo ""
echo "加载环境变量..."
if [ -f "$CONFIG_DIR/.env" ]; then
    export $(grep -v '^#' "$CONFIG_DIR/.env" | xargs -d '\n')
    echo "✓ Environment variables loaded"
fi

# 6. 检查是否需要安装QQBot依赖
source "$VENV_DIR/bin/activate"
python3 -c "import aiohttp, httpx" 2>/dev/null
if [ $? -ne 0 ]; then
    echo ""
    echo "安装QQBot依赖..."
    pip install aiohttp httpx
fi

# 7. 显示配置信息
echo ""
echo "=========================================="
echo "  当前配置"
echo "=========================================="
echo "  持久化目录: $PERSISTENT_DIR"
echo "  配置目录: $CONFIG_DIR"
echo "  代码目录: $CODE_DIR"
echo "  模型: $(grep 'default:' "$CONFIG_DIR/config.yaml" | head -1 | awk '{print $2}')"
echo "  QQBot: 已配置 (APP_ID: ${QQ_APP_ID:--})"
echo ""
echo "=========================================="

# 8. 选择启动方式
echo ""
echo "请选择启动方式："
echo "1) 启动QQ网关（后台运行）"
echo "2) 启动QQ网关（前台运行）"
echo "3) 仅配置环境（不启动服务）"
read -p "请输入选项 (1-3): " choice

case $choice in
    1)
        echo ""
        echo "启动QQ网关（后台运行）..."
        nohup bash -c "source \"$VENV_DIR/bin/activate\" && hermes gateway run" > "$CONFIG_DIR/logs/gateway_start.log" 2>&1 &
        GATEWAY_PID=$!
        echo $GATEWAY_PID > "$CONFIG_DIR/gateway_manual.pid"
        echo "✓ QQ网关已启动，PID: $GATEWAY_PID"
        echo "日志文件: $CONFIG_DIR/logs/gateway.log"
        echo "查看日志: tail -f $CONFIG_DIR/logs/gateway.log"
        ;;
    2)
        echo ""
        echo "启动QQ网关（前台运行，按Ctrl+C停止）..."
        hermes gateway run
        ;;
    3)
        echo ""
        echo "✓ 环境配置完成，服务未启动"
        echo "可以使用 'hermes gateway run' 手动启动"
        ;;
    *)
        echo ""
        echo "无效选项，仅配置环境"
        ;;
esac

echo ""
echo "=========================================="
echo "  完成！"
echo "=========================================="
