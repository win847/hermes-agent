#!/usr/bin/env python3
"""Start Hermes gateway with QQBot configuration."""

import sys
import os
from pathlib import Path

# Add Hermes code directory to path
hermes_code_dir = Path("/workspace/hermes/code")
sys.path.insert(0, str(hermes_code_dir))

# Load environment variables from .env
env_path = Path("/workspace/hermes/config/.env")
if env_path.exists():
    print(f"Loading environment from {env_path}")
    with open(env_path, 'r', encoding='utf-8') as f:
        for line in f:
            line = line.strip()
            if line and not line.startswith('#') and '=' in line:
                key, value = line.split('=', 1)
                os.environ[key.strip()] = value.strip()
                print(f"  - {key.strip()} loaded")

# Verify environment variables are set
print("\nEnvironment check:")
print(f"  QQ_APP_ID: {'set' if os.getenv('QQ_APP_ID') else 'not set'}")
print(f"  QQ_CLIENT_SECRET: {'set' if os.getenv('QQ_CLIENT_SECRET') else 'not set'}")

# Import and start gateway
print("\n" + "="*60)
print("Starting Hermes Gateway...")
print("="*60)

from hermes_cli.gateway import run_gateway

try:
    # This will run the gateway in the foreground
    run_gateway()
except KeyboardInterrupt:
    print("\nGateway stopped by user")
except Exception as e:
    print(f"\nError running gateway: {e}")
    import traceback
    traceback.print_exc()
