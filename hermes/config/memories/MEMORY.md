**Airoha CA73 PON 网关 — 核心技术栈**
芯片平台：
- CPU: ARM Cortex-A73 4核 @ 1.8GHz (ARM64)
- Wi-Fi 7/8 驱动集成
- UPS: Unified Packet Switch 硬件转发加速（物理层至MAC层线速转发）
- NPU: Network Processing Unit 弹性流量整流/智能DPI/AI边缘推理加速

三大开源平台适配：
- OpenWrt：驱动主线upstream、DTS板级提交、包管理适配
- prplOS：运营商级模块化OS，关注LCM/USP(TR-369)/容器化AI边缘部署
- RDK-B：广电及全球运营商宽带网关参考设计，C++/Yocto架构，HAL/Bridges/WebPA集成

双重职责：
- AI智能化：CA73+NPU上跑轻量AI推理（ZeroClaw C推理引擎，Intent识别/NER）
- ARM64内核开发：维护 drivers/net/ethernet/airoha/ 下驱动（airoha_eth.c, airoha_npu.c, airoha_ppe.c, airoha_regs.h），upstream到Linux主线+OpenWrt社区

本地内核项目路径：/home/win847/Projects/KernelUpstream
§
**助理能力范围（用户期望）**
1. 内核驱动调试与Upstream：airoha_eth.c/airoha_ppe.c代码编写审查，checkpatch.pl校验，git format-patch + git send-email (Netdev规范)
2. 轻量C/C++嵌入式推理：Q8量化、端侧NPU加速、ZeroClaw微调与推理验证
3. OpenWrt/prplOS/RDK-B构建编译：Buildroot/Yocto/CMake交叉编译(ARM64 musl/glibc)，不修改第三方框架源码，DTS/Makefile/Kconfig裁剪
§
**/workspace 虚拟机重置机制（重要）**
- /workspace 是一个 git 仓库
- 虚拟机重置 = 整个 /workspace 目录恢复到上一次 git commit 的状态
- 未 commit 的修改在重置后会全部丢失
- 正确做法：修改文件后尽快 git add + git commit，commit 过的内容重置后仍保留
- 重置后先 git log 确认最新 commit 是否是自己的，如果不是说明有远程更新，需 git pull 拉回