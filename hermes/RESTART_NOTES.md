# Hermes 重启测试笔记

## 状态检查
- [ ] 确认 `/workspace/hermes/` 目录存在
- [ ] 确认符号链接: `/root/.hermes` -> `/workspace/hermes/config`
- [ ] 确认符号链接: `/usr/local/lib/hermes-agent` -> `/workspace/hermes/code`

## 启动步骤
1. 进入目录: `cd /workspace/hermes`
2. 运行启动脚本: `bash start.sh`
3. 选择 `1) 启动QQ网关（后台运行）`
4. 验证: `hermes gateway status`
5. 查看日志: `tail -f /workspace/hermes/config/logs/gateway.log`

## 快速命令
```bash
cd /workspace/hermes && bash start.sh
```

## 预期结果
- ✅ QQBot 连接成功 (WebSocket connected)
- ✅ 网关在线 (Gateway running with 1 platform(s))
- ✅ 可以通过QQ机器人对话

## 如需停止
```bash
cd /workspace/hermes && bash stop.sh
```

## 配置信息
- 模型: glm-5-1
- QQ APP_ID: 1904071403
- API: https://win847.top/llmapi/v1
