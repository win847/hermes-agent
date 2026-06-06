#!/usr/bin/env python3
"""Test QQBot configuration loading."""

import sys
import os
import yaml

# Add Hermes code to path
sys.path.insert(0, '/workspace/hermes/code')

# Test 1: Check config.yaml
print("=" * 60)
print("Test 1: Checking config.yaml")
print("=" * 60)
config_path = os.path.expanduser("~/.hermes/config.yaml")
if not os.path.exists(config_path):
    config_path = "/workspace/hermes/config/config.yaml"

print(f"Config path: {config_path}")
try:
    with open(config_path, 'r', encoding='utf-8') as f:
        config = yaml.safe_load(f)
    
    # Check for qqbot configuration
    if 'platforms' in config and 'qqbot' in config['platforms']:
        qq_config = config['platforms']['qqbot']
        print(f"✓ Found qqbot in platforms: {qq_config.keys()}")
        if 'enabled' in qq_config:
            print(f"  - enabled: {qq_config['enabled']}")
        if 'extra' in qq_config:
            extra = qq_config['extra']
            print(f"  - extra keys: {list(extra.keys())}")
            if 'app_id' in extra:
                print(f"  - app_id: {extra['app_id']} (exists)")
            if 'client_secret' in extra:
                print(f"  - client_secret: {'***' if extra['client_secret'] else '(empty)'}")
    else:
        print("✗ qqbot configuration not found in platforms")
        
except Exception as e:
    print(f"✗ Error reading config: {e}")

# Test 2: Check environment variables
print("\n" + "=" * 60)
print("Test 2: Checking environment variables")
print("=" * 60)
qq_app_id = os.getenv('QQ_APP_ID')
qq_secret = os.getenv('QQ_CLIENT_SECRET')
print(f"QQ_APP_ID: {'set' if qq_app_id else 'not set'}")
print(f"QQ_CLIENT_SECRET: {'set' if qq_secret else 'not set'}")

# Test 3: Check if .env file exists
print("\n" + "=" * 60)
print("Test 3: Checking .env file")
print("=" * 60)
env_path = os.path.expanduser("~/.hermes/.env")
if not os.path.exists(env_path):
    env_path = "/workspace/hermes/config/.env"

print(f".env path: {env_path}")
if os.path.exists(env_path):
    print("✓ .env file exists")
    try:
        with open(env_path, 'r', encoding='utf-8') as f:
            env_content = f.read()
            if 'QQ_APP_ID' in env_content:
                print("  - QQ_APP_ID found in .env")
            if 'QQ_CLIENT_SECRET' in env_content:
                print("  - QQ_CLIENT_SECRET found in .env")
    except Exception as e:
        print(f"✗ Error reading .env: {e}")
else:
    print("✗ .env file not found")

# Test 4: Try importing QQAdapter
print("\n" + "=" * 60)
print("Test 4: Checking dependencies and QQAdapter")
print("=" * 60)
try:
    import aiohttp
    print("✓ aiohttp is installed")
except ImportError as e:
    print(f"✗ aiohttp not installed: {e}")

try:
    import httpx
    print("✓ httpx is installed")
except ImportError as e:
    print(f"✗ httpx not installed: {e}")

try:
    from gateway.platforms.qqbot import QQAdapter, check_qq_requirements
    print("✓ QQAdapter imported successfully")
    req_ok = check_qq_requirements()
    print(f"✓ QQ requirements check: {req_ok}")
except Exception as e:
    print(f"✗ Error importing QQAdapter: {e}")
    import traceback
    traceback.print_exc()
