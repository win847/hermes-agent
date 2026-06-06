# Building NatTypeTester on Linux

NatTypeTester (https://github.com/HMBSbige/NatTypeTester) requires .NET 10 SDK, which is not in standard Ubuntu repos.

## Install .NET 10 SDK

```bash
curl -sSL https://dot.net/v1/dotnet-install.sh -o /tmp/dotnet-install.sh
chmod +x /tmp/dotnet-install.sh
/tmp/dotnet-install.sh --channel 10.0 --install-dir /usr/share/dotnet
export PATH="/usr/share/dotnet:$PATH"
```

If `dotnet-sdk-8.0` is already installed via apt, the .NET 10 SDK installs alongside it in `/usr/share/dotnet`.

## Build the Console version

```bash
git clone https://github.com/HMBSbige/NatTypeTester.git /tmp/NatTypeTester
cd /tmp/NatTypeTester
dotnet publish src/NatTypeTester.Console/NatTypeTester.Console.csproj \
  -c Release -o /tmp/nattypetester-bin
```

The binary is at `/tmp/nattypetester-bin/NatTypeTester.Console`.

## Pitfalls

- **Do NOT downgrade TargetFramework to net8.0** — NuGet packages like `DTLS 0.4.1` and `Dns.Net 0.3.0` only target `net10.0`. Changing `Directory.Build.props` to net8.0 causes NU1202 restore errors.
- **The `dotnet tool install` path doesn't work** — NatTypeTester is not published as a .NET global tool on NuGet. Clone and build from source.
- **`stun-client` apt package** is a simpler alternative for RFC 3489 only, but it lacks RFC 5780 support and may fail on servers where UDP is blocked (returns misleading "Blocked" with no further detail).

## STUN server reference

Common public STUN servers:
- `stun.qq.com:3478` — Tencent/QQ (popular in China)
- `stun.l.google.com:19302` — Google
- `stun.syncthing.net:22000` — Syncthing
- `stun.voip.eutelia.it:3478` — VoIP provider

If all servers return `UdpBlocked`, the host's UDP egress is firewalled at the network level (cloud security group), not a STUN server issue.
