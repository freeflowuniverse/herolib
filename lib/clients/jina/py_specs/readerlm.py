import requests

url = "https://r.jina.ai/https://www.threefold.io/what/"
headers = {
    "Accept": "text/event-stream",
    "Authorization": "Bearer jina_275aefb6495643408d4c499fce548080w5rYjijHfHVBi_vtAqNY6LBk-woz",
    "X-Base": "final",
    "X-Respond-With": "readerlm-v2",
    "X-Return-Format": "markdown",
    "X-With-Iframe": "true",
    "X-With-Shadow-Dom": "true"
}

response = requests.get(url, headers=headers)
print(response.text)

