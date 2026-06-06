#!/bin/bash
# Hermes Agent 停止脚本

echo "=========================================="
echo "  Hermes Agent 停止服务"
echo "=========================================="

# 持久化路径
PERSISTENT_DIR="/workspace/hermes"
CONFIG_DIR="$PERSISTENT_DIR/config"

# 停止网关
echo ""
echo "正在停止QQ网关..."

# 获取PID
GATEWAY_PID=""
if [ -f "$CONFIG_DIR/gateway.pid" ]; then
    GATEWAY_PID=$(cat "$CONFIG_DIR/gateway.pid" 2>/dev/null)
elif [ -f "$CONFIG_DIR/gateway_manual.pid" ]; then
    GATEWAY_PID=$(cat "$CONFIG_DIR/gateway_manual.pid" 2>/dev/null)
fi

# 停止进程
if [ -n "$GATEWAY_PID" ]; then
    if kill -0 $GATEWAY_PID 2>/dev/null; then
        kill $GATEWAY_PID
        echo "✓ 已发送停止信号 (PID: $GATEWAY_PID)"
        # 等待进程退出
        for i in {1..10}; do
            if ! kill -0 $GATEWAY_PID 2>/dev/null; then
                break
            fi
            sleep 0.5
        done
    else
        echo "进程 $GATEWAY_PID 不存在"
    fi
else
    # 尝试通过名称查找
    GATEWAY_PIDS=$(pgrep -f "hermes gateway run" 2>/dev/null)
    if [ -n "$GATEWAY_PIDS" ]; then
        for PID in $GATEWAY_PIDS; do
            kill $PID 2>/dev/null
            echo "✓ 已停止进程: $PID"
        done
    else
        echo "未找到运行中的QQ网关进程"
    fi
fi

# 清理PID文件
rm -f "$CONFIG_DIR/gateway.pid" "$CONFIG_DIR/gateway_manual.pid" 2>/dev/null

echo ""
echo "=========================================="
echo "  已停止！"
echo "=========================================="
