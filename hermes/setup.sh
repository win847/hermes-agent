#!/bin/bash
# Hermes Agent 一键设置脚本

# 颜色定义
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Hermes Agent 设置${NC}"
echo -e "${BLUE}========================================${NC}"

# 检查是否在正确的目录
if [ ! -f "setup.sh" ]; then
    echo -e "${RED}✗ 请在 hermes/ 目录中运行此脚本${NC}"
    exit 1
fi

# 步骤1: 安装依赖
echo ""
echo -e "${YELLOW}步骤1: 安装 hermes-agent${NC}"
pip install hermes-agent
if [ $? -ne 0 ]; then
    echo -e "${RED}✗ hermes-agent 安装失败${NC}"
    exit 1
fi
echo -e "${GREEN}✓ hermes-agent 安装成功${NC}"

# 步骤2: 创建符号链接
echo ""
echo -e "${YELLOW}步骤2: 配置符号链接${NC}"
if [ -L "/root/.hermes" ] || [ -d "/root/.hermes" ]; then
    echo -e "${YELLOW}✓ 已存在的 .hermes 配置目录，正在更新链接...${NC}"
    rm -rf "/root/.hermes"
fi
ln -sf "$(pwd)/config" "/root/.hermes"
echo -e "${GREEN}✓ 符号链接创建成功${NC}"

# 步骤3: 检查配置文件
echo ""
echo -e "${YELLOW}步骤3: 检查配置文件${NC}"
if [ ! -f ".env" ]; then
    echo -e "${YELLOW}⚠️  未找到 .env 文件，正在从 .env.example 创建...${NC}"
    cp .env.example .env
    echo -e "${YELLOW}✓ 请编辑 .env 文件填入真实的 API 密钥和 QQBot 凭证${NC}"
fi
echo -e "${GREEN}✓ 配置文件检查完成${NC}"

echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}  设置完成！${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo "接下来的步骤："
echo "1. 编辑 hermes/.env 填入真实的密钥"
echo "2. 运行 ./start.sh 启动网关"
echo "3. 或使用 hermes 命令直接操作"
echo ""
