#!/bin/bash
# Hermes Agent 持久化启动脚本
# 虚拟机重启后运行此脚本恢复所有服务

echo "=========================================="
echo "  Hermes Agent 持久化启动"
echo "=========================================="

# 持久化路径
PERSISTENT_DIR="/workspace/hermes"
CONFIG_DIR="$PERSISTENT_DIR/config"

# 1. 检查并创建符号链接
if [ ! -L "/root/.hermes" ] && [ ! -d "/root/.hermes" ]; then
    ln -sf "$CONFIG_DIR" "/root/.hermes"
    echo "✓ Created symlink: /root/.hermes -> $CONFIG_DIR"
else
    echo "✓ Symlink /root/.hermes already exists"
fi

# 2. 加载环境变量
echo ""
echo "加载环境变量..."
if [ -f "$CONFIG_DIR/.env" ]; then
    export $(grep -v '^#' "$CONFIG_DIR/.env" | xargs -d '\n')
    echo "✓ Environment variables loaded"
    echo "  - 模型: $DEFAULT_MODEL"
    echo "  - QQ APP_ID: $QQ_APP_ID"
fi

# 3. 显示配置信息
echo ""
echo "=========================================="
echo "  当前配置"
echo "=========================================="
echo "  持久化目录: $PERSISTENT_DIR"
echo "  配置目录: $CONFIG_DIR"
echo "  模型: $DEFAULT_MODEL"
echo "  QQBot: 已配置 (APP_ID: $QQ_APP_ID)"
echo "=========================================="

# 4. 选择启动方式
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
        nohup hermes gateway run > "$CONFIG_DIR/logs/gateway.log" 2>&1 &
        GATEWAY_PID=$!
        echo $GATEWAY_PID > "$CONFIG_DIR/gateway.pid"
        sleep 2
        echo "✓ QQ网关已启动，PID: $GATEWAY_PID"
        echo "日志文件: $CONFIG_DIR/logs/gateway.log"
        echo ""
        echo "查看日志:"
        tail -20 "$CONFIG_DIR/logs/gateway.log"
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
