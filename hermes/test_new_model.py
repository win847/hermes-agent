#!/usr/bin/env python3
"""Test custom/glm-5-1 model"""

from openai import OpenAI

client = OpenAI(
    base_url="https://win847.top/llmapi/v1",
    api_key="sk-aiproxy"
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
    import traceback
    traceback.print_exc()

print("\n" + "=" * 60)
print("2. 测试 glm-5-1 非流式对话")
print("=" * 60)
try:
    response = client.chat.completions.create(
        model="glm-5-1",
        messages=[{"role": "user", "content": "你好，请介绍一下你自己"}]
    )
    print(f"✅ 成功获取响应！")
    print(f"响应内容: {response.choices[0].message.content}")
except Exception as e:
    print(f"❌ 对话请求失败: {e}")
    import traceback
    traceback.print_exc()
