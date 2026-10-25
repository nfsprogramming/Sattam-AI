"""
Direct NVIDIA NIM streaming test with new API key.
Run: .\venv\Scripts\python.exe test_nvidia.py
"""
import os
import time
import sys
from openai import OpenAI

# Force UTF-8 output on Windows terminal
sys.stdout.reconfigure(encoding='utf-8')

API_KEY = os.getenv("NVIDIA_API_KEY", "")
MODEL  = "meta/llama-3.1-70b-instruct"

if not API_KEY:
    print("Error: NVIDIA_API_KEY environment variable is not set.")
    sys.exit(1)

print(f"API Key: {API_KEY[:10]}...")
print(f"Model:   {MODEL}")
print("Calling NVIDIA NIM (streaming)...\n")

client = OpenAI(
    base_url="https://integrate.api.nvidia.com/v1",
    api_key=API_KEY,
    timeout=120.0
)

start = time.time()
first_token_time = None

try:
    stream = client.chat.completions.create(
        model=MODEL,
        temperature=0.2,
        top_p=0.7,
        max_tokens=256,
        stream=True,
        messages=[
            {"role": "system", "content": "You are an Indian law expert."},
            {"role": "user", "content": "What is the punishment for theft under IPC? Answer in 3 sentences."}
        ]
    )

    print("--- RESPONSE ---")
    for chunk in stream:
        if chunk.choices and chunk.choices[0].delta.content:
            token = chunk.choices[0].delta.content
            if first_token_time is None:
                first_token_time = time.time()
                print(f"[First token in {first_token_time - start:.1f}s]\n")
            print(token, end="", flush=True)

    elapsed = time.time() - start
    print(f"\n\n--- SUCCESS in {elapsed:.1f}s total ---")

except Exception as e:
    elapsed = time.time() - start
    print(f"\n--- FAILED after {elapsed:.1f}s ---")
    print(f"Error type: {type(e).__name__}")
    print(f"Error: {e}")
