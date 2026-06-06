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

## Public IP & Geo-Location

Discover the machine's external IP and hosting metadata:

```bash
curl -s https://ipinfo.io
```

Returns: IP, city, region, country, coordinates, ASN/org, timezone, postal code. This identifies the cloud provider (e.g. "Beijing Volcano Engine Technology Co., Ltd." → ByteDance/Volcano Engine).

**Alternative services** (if ipinfo.io is down):
- `curl -s https://ifconfig.me` (plain IP only)
- `curl -s https://api.ipify.org` (plain IP only)

## NAT Type Testing

Determine the NAT behavior of the host — critical for P2P, WebRTC, and real-time comms.

### NatTypeTester (recommended, RFC 3489 & 5780)

NatTypeTester is a .NET tool that tests NAT type via STUN with both RFC 3489 and RFC 5780 methods. It supports UDP, TCP, TLS-over-TCP, and DTLS-over-UDP transports.

**Build from source** (requires .NET 10 SDK — see `references/nattypetester-build.md` for full build instructions and pitfalls):

```bash
git clone https://github.com/HMBSbige/NatTypeTester.git /tmp/NatTypeTester
cd /tmp/NatTypeTester
dotnet publish src/NatTypeTester.Console/NatTypeTester.Console.csproj \
  -c Release -o /tmp/nattypetester-bin
```

**Run the test:**

```bash
# RFC 3489 (classic STUN NAT detection)
/tmp/nattypetester-bin/NatTypeTester.Console rfc3489 -s stun.qq.com:3478

# RFC 5780 (mapping + filtering behavior)
/tmp/nattypetester-bin/NatTypeTester.Console rfc5780 -s stun.qq.com:3478
```

**Common NAT types and their meaning:**

| NAT Type | P2P Capable | Notes |
|----------|-------------|-------|
| Full Cone / Open | ✅ Yes | Any external host can reach mapped port |
| Restricted Cone | ✅ Possible | Only hosts that received packets can reply |
| Port Restricted Cone | ⚠️ Maybe | Like restricted but port-specific |
| Symmetric | ❌ No | Different mapping per destination — needs relay |
| UdpBlocked | ❌ No | UDP outbound blocked entirely (common on cloud VMs) |

**Pitfall — cloud VMs often block UDP outbound:**
If NatTypeTester returns `UdpBlocked` on all STUN servers, the issue is likely a cloud platform security group (not local firewall). On Volcano Engine (火山引擎) and similar Chinese cloud providers, UDP egress may be blocked by default. This requires a security group change in the cloud console — local iptables/nftables changes won't fix it.

**Quick fallback — Python raw STUN probe** (no .NET needed):

```python
import socket, struct
msg = b'\x00\x01\x00\x00\x21\x12\xa4\x42' + b'\0'*12
sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
sock.settimeout(5)
try:
    sock.sendto(msg, ('stun.qq.com', 3478))
    data, addr = sock.recvfrom(1024)
    # Parse XOR-MAPPED-ADDRESS attribute (type 0x0020)
    print(f'UDP reachable — response from {addr}')
except socket.timeout:
    print('UDP blocked — no STUN response')
finally:
    sock.close()
```

## Response Format

When reporting diagnostics, present results in a clear table with status indicators (🟢/🟡/🔴). Always sanity-check before reporting — if a number looks wrong, re-test with better methodology rather than publishing a misleading result.
