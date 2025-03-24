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


#OTHER EXAMPLE WITH MORE ARGUMENTS

url = "https://s.jina.ai/"
params = {
    "q": "Jina AI",
    "gl": "US",
    "hl": "en",
    "num": 10,
    "page": 1,
    "location": "gent"
}
headers = {
    "Accept": "application/json",
    "Authorization": "Bearer jina_275aefb6495643408d4c499fce548080w5rYjijHfHVBi_vtAqNY6LBk-woz",
    "X-Return-Format": "markdown",
    "X-Timeout": "10"
}

response = requests.get(url, params=params, headers=headers)

print(response.json())
