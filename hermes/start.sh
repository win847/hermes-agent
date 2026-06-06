#!/bin/bash
# Hermes Agent 启动脚本

# 颜色定义
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

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

# 加载环境变量
if [ -f ".env" ]; then
    export $(grep -v '^#' .env | xargs -d '\n' 2>/dev/null || true)
    echo -e "${GREEN}✓ 环境变量已加载${NC}"
fi

echo ""
echo -e "${BLUE}选择启动方式：${NC}"
echo "1) 启动网关（前台，调试用）"
echo "2) 启动网关（后台，生产用）"
echo "3) 仅检查状态"
echo "4) 停止网关"
read -p "请输入选项 [1-4]: " choice

case $choice in
    1)
        echo ""
        echo -e "${BLUE}启动网关（前台模式）...${NC}"
        hermes gateway run
        ;;
    2)
        echo ""
        echo -e "${BLUE}启动网关（后台模式）...${NC}"
        mkdir -p config/logs
        nohup hermes gateway run > config/logs/gateway.log 2>&1 &
        GATEWAY_PID=$!
        echo $GATEWAY_PID > config/gateway.pid
        sleep 3
        if kill -0 $GATEWAY_PID 2>/dev/null; then
            echo -e "${GREEN}✓ 网关已启动 (PID: $GATEWAY_PID)${NC}"
            echo "日志: tail -f config/logs/gateway.log"
        else
            echo -e "${RED}✗ 网关启动失败，查看日志：${NC}"
            tail -50 config/logs/gateway.log
        fi
        ;;
    3)
        echo ""
        hermes gateway status
        ;;
    4)
        echo ""
        echo -e "${YELLOW}正在停止网关...${NC}"
        if [ -f "config/gateway.pid" ]; then
            PID=$(cat config/gateway.pid 2>/dev/null)
            if [ -n "$PID" ]; then
                kill $PID 2>/dev/null || true
                rm -f config/gateway.pid
                echo -e "${GREEN}✓ 网关已停止${NC}"
            fi
        else
            pkill -f "hermes gateway" 2>/dev/null || true
            echo -e "${GREEN}✓ 网关已停止${NC}"
        fi
        ;;
    *)
        echo ""
        echo -e "${RED}无效选项${NC}"
        ;;
esac
