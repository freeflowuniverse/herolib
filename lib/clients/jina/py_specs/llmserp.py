import json
import requests

url = "https://llm-serp.jina.ai"
headers = {
    "Content-Type": "application/json",
    "Authorization": "Bearer jina_275aefb6495643408d4c499fce548080w5rYjijHfHVBi_vtAqNY6LBk-woz"
}
data = {
    "q": "jina ai",
    "gl": "US",
    "hl": "en",
    "num": 10,
    "page": 1
}

response = requests.post(url, headers=headers, data=json.dumps(data))
print(response.json())
