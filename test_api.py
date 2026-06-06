#!/usr/bin/env python3
"""Test custom LLM API"""

from openai import OpenAI

client = OpenAI(
    base_url="https://win847.top/gemini/v1",
    api_key="sk-aliyun-gemini3-5flash-arch-use"
)

print("=" * 60)
print("1. 查询可用的模型列表")
print("=" * 60)
try:
    models = client.models.list()
    print(f"✅ 成功获取模型列表！")
    for model in models.data:
        print(f"  - {model.id}")
except Exception as e:
    print(f"❌ 获取模型列表失败: {e}")

print("\n" + "=" * 60)
print("2. 测试非流式对话")
print("=" * 60)
try:
    response = client.chat.completions.create(
        model="gemini-2.5-flash-lite",
        messages=[{"role": "user", "content": "你好，请介绍一下你自己"}]
    )
    print(f"✅ 成功获取响应！")
    print(f"响应内容: {response.choices[0].message.content}")
except Exception as e:
    print(f"❌ 对话请求失败: {e}")
    import traceback
    traceback.print_exc()

print("\n" + "=" * 60)
print("3. 测试流式对话")
print("=" * 60)
try:
    stream = client.chat.completions.create(
        model="gemini-2.5-flash-lite",
        messages=[{"role": "user", "content": "你好，请介绍一下你自己"}],
        stream=True
    )
    print("流式响应: ", end="", flush=True)
    full_text = ""
    for chunk in stream:
        if chunk.choices and chunk.choices[0].delta.content:
            content = chunk.choices[0].delta.content
            full_text += content
            print(content, end="", flush=True)
    print(f"\n✅ 流式请求成功！完整响应: {full_text}")
except Exception as e:
    print(f"\n❌ 流式对话请求失败: {e}")
    import traceback
    traceback.print_exc()
