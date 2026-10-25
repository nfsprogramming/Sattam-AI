import requests
import time

print("Sending request to FastAPI...")
start = time.time()
try:
    response = requests.post(
        "http://127.0.0.1:8000/chat",
        json={"query": "theft"},
        timeout=20
    )
    print(f"Status: {response.status_code}")
    print(f"Response: {response.json()}")
except Exception as e:
    print(f"Failed: {e}")
print(f"Took {time.time() - start:.2f} seconds")
