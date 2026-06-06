#!/usr/bin/env python3
"""Test custom provider manually"""

import sys
from pathlib import Path

# Add Hermes venv to path
sys.path.insert(0, str(Path("/workspace/hermes/code/venv/lib/python3.11/site-packages")))

# Now test the API directly using OpenAI SDK
try:
    from openai import OpenAI

    client = OpenAI(
        base_url="https://win847.top/gemini/v1",
        api_key="sk-aliyun-gemini3-5flash-arch-use"
    )

    print("Testing API call...")
    response = client.chat.completions.create(
        model="gemini-2.5-flash-lite",
        messages=[{"role": "user", "content": "Hello, test message"}]
    )

    print(f"✅ API call successful!")
    print(f"Response: {response.choices[0].message.content}")

except Exception as e:
    print(f"❌ API call failed: {e}")
    import traceback
    traceback.print_exc()
