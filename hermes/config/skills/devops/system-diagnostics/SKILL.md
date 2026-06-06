---
name: system-diagnostics
description: Gather system info, test network connectivity, and measure performance accurately. Covers hardware/OS discovery, connectivity checks, and speed benchmarking.
tags: [diagnostics, network, speed-test, sysinfo, benchmarking]
---

# System Diagnostics

Gather system information, test network connectivity, and measure performance.

## System Info Gathering

Standard commands for a full system profile:

```bash
# OS & Kernel
uname -a
cat /etc/os-release

# CPU
lscpu

# Memory
free -h

# Disk
df -h /

# GPU
nvidia-smi 2>/dev/null || echo "无 NVIDIA GPU"

# User/Permissions
whoami && id
```

## Network Connectivity Check

Test reachability with `curl -sI`:

```bash
curl -sI --connect-timeout 5 https://example.com | head -5
```

- HTTP 200 = reachable
- Timeout/exit 28 = unreachable or firewall blocked
- Exit 35 = SSL handshake failure (reachable but TLS blocked)

## Speed Testing — CRITICAL PITFALLS

### ❌ Never trust speed stats from tiny responses

`curl -w %{speed_download}` on tiny responses (a few bytes) produces meaningless numbers. A 9-byte 404 page will report absurdly low speeds like "2.5 KB/s" — this is a measurement artifact, not real throughput.

**Minimum file size for reliable speed measurement: ~1 MB.**

### ✅ Correct approach

1. **Use a known-large file** (>1 MB, ideally >10 MB) from the target host:
   ```bash
   curl -sL --connect-timeout 10 --max-time 60 \
     -w "速度: %{speed_download} bytes/s\n总时间: %{time_total}s\n大小: %{size_download} bytes\n" \
     -o /dev/null "https://github.com/python/cpython/archive/refs/tags/v3.12.0.tar.gz"
   ```

2. **Check HTTP status** — a 404/redirect on a wrong URL gives a tiny error page, not a speed test.

3. **Sanity-check results** — if GitHub reports 2.5 KB/s, something is wrong with the test, not the network. Ask: "Could Hermes itself have been installed from this network?"

4. **pip download is also a good real-world benchmark:**
   ```bash
   time pip download --no-deps --no-cache-dir -d /tmp/speedtest <package>
   ```

5. **For multi-site comparison**, test at least 3 sites including a domestic (baidu.com) and international (github.com) target.

### Why tiny files lie

- TCP slow-start means the first few KB are always below peak throughput
- TLS handshake, HTTP headers, and redirect overhead dominate tiny transfers
- curl's speed = total_bytes / total_time, and overhead time inflates the denominator while tiny payload deflates the numerator

## Response Format

When reporting diagnostics, present results in a clear table with status indicators (🟢/🟡/🔴). Always sanity-check before reporting — if a number looks wrong, re-test with better methodology rather than publishing a misleading result.
