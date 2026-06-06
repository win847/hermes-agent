#!/usr/bin/env python3
"""Test custom provider with streaming"""

import sys
from pathlib import Path

# Add Hermes venv to path
sys.path.insert(0, str(Path("/workspace/hermes/code/venv/lib/python3.11/site-packages")))

try:
    from openai import OpenAI

    client = OpenAI(
        base_url="https://win847.top/gemini/v1",
        api_key="sk-aliyun-gemini3-5flash-arch-use"
    )

    print("Testing streaming API call...")
    stream = client.chat.completions.create(
        model="gemini-2.5-flash-lite",
        messages=[{"role": "user", "content": "Hello, test message"}],
        stream=True
    )

    print("Response chunks:")
    full_text = ""
    for chunk in stream:
        if chunk.choices[0].delta.content:
            full_text += chunk.choices[0].delta.content
            print(chunk.choices[0].delta.content, end="")
    print(f"\n✅ Streaming successful! Full response: {full_text}")

except Exception as e:
    print(f"\n❌ Streaming API call failed: {e}")
    import traceback
    traceback.print_exc()
