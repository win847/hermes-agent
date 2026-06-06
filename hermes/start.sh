#!/bin/bash
# Hermes Agent 启动脚本 - 支持一键启动

# 颜色定义
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# 脚本目录
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Hermes Agent 启动${NC}"
echo -e "${BLUE}========================================${NC}"

# 检查并配置符号链接
if [ ! -L "/root/.hermes" ] || [ ! -d "/root/.hermes" ]; then
    if [ -d "/root/.hermes" ]; then
        rm -rf "/root/.hermes"
    fi
    ln -sf "$(pwd)/config" "/root/.hermes"
    echo -e "${GREEN}✓ 符号链接已配置${NC}"
fi

# 加载环境变量（从 config/.env）
ENV_FILE="config/.env"
if [ -f "$ENV_FILE" ]; then
    # 使用 set -a 导出所有变量，然后 source
    set -a
    source "$ENV_FILE"
    set +a
    echo -e "${GREEN}✓ 环境变量已加载 ($ENV_FILE)${NC}"
else
    echo -e "${RED}✗ 环境变量文件不存在: $ENV_FILE${NC}"
    exit 1
fi

# 启动模式
MODE="${1:-background}"  # 默认为后台模式

start_gateway() {
    local mode=$1

    # 先停止已有的网关
    if [ -f "config/gateway.pid" ]; then
        OLD_PID=$(cat config/gateway.pid 2>/dev/null)
        if [ -n "$OLD_PID" ] && kill -0 $OLD_PID 2>/dev/null; then
            echo -e "${YELLOW}停止旧网关 (PID: $OLD_PID)...${NC}"
            kill $OLD_PID 2>/dev/null || true
            sleep 2
        fi
    fi
    pkill -f "hermes gateway" 2>/dev/null || true

    mkdir -p config/logs

    if [ "$mode" = "foreground" ]; then
        echo ""
        echo -e "${BLUE}启动网关（前台模式）...${NC}"
        hermes gateway run
    else
        echo ""
        echo -e "${BLUE}启动网关（后台模式）...${NC}"
        nohup hermes gateway run > config/logs/gateway.log 2>&1 &
        GATEWAY_PID=$!
        echo $GATEWAY_PID > config/gateway.pid
        sleep 3

        if kill -0 $GATEWAY_PID 2>/dev/null; then
            echo -e "${GREEN}✓ 网关已启动 (PID: $GATEWAY_PID)${NC}"
            echo "日志: tail -f config/logs/gateway.log"
            # 等待并检查 QQ Bot 是否连接成功
            sleep 3
            if grep -q "qqbot connected" config/logs/gateway.log 2>/dev/null; then
                echo -e "${GREEN}✓ QQ Bot 连接成功${NC}"
            else
                echo -e "${YELLOW}⚠ QQ Bot 状态请查看日志确认${NC}"
            fi
        else
            echo -e "${RED}✗ 网关启动失败，查看日志：${NC}"
            tail -30 config/logs/gateway.log
        fi
    fi
}

stop_gateway() {
    echo -e "${YELLOW}正在停止网关...${NC}"
    if [ -f "config/gateway.pid" ]; then
        PID=$(cat config/gateway.pid 2>/dev/null)
        if [ -n "$PID" ]; then
            kill $PID 2>/dev/null || true
            rm -f config/gateway.pid
        fi
    fi
    pkill -f "hermes gateway" 2>/dev/null || true
    echo -e "${GREEN}✓ 网关已停止${NC}"
}

check_status() {
    if pgrep -f "hermes gateway" > /dev/null; then
        PID=$(pgrep -f "hermes gateway")
        echo -e "${GREEN}✓ 网关运行中 (PID: $PID)${NC}"
    else
        echo -e "${RED}✗ 网关未运行${NC}"
        [ -f "config/gateway.pid" ] && rm -f config/gateway.pid
    fi
}

case "$MODE" in
    start|background)
        start_gateway background
        ;;
    foreground|debug)
        start_gateway foreground
        ;;
    stop)
        stop_gateway
        ;;
    status)
        check_status
        ;;
    restart)
        stop_gateway
        sleep 2
        start_gateway background
        ;;
    *)
        echo ""
        echo -e "${BLUE}用法: $0 [命令]${NC}"
        echo ""
        echo "命令:"
        echo "  start      启动网关（后台，默认）"
        echo "  foreground 启动网关（前台，调试用）"
        echo "  stop       停止网关"
        echo "  restart    重启网关"
        echo "  status     检查状态"
        echo ""
        echo "示例:"
        echo "  $0          # 一键后台启动"
        echo "  $0 start    # 后台启动"
        echo "  $0 foreground  # 前台启动"
        ;;
esac
