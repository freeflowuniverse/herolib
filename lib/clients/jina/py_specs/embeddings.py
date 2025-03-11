import requests
import json

url = "https://api.jina.ai/v1/embeddings"
headers = {
    "Content-Type": "application/json",
    "Authorization": "Bearer jina_275aefb6495643408d4c499fce548080w5rYjijHfHVBi_vtAqNY6LBk-woz"
}
data = {
    "model": "jina-embeddings-v3",
    "task": "text-matching",
    "late_chunking": False,
    "dimensions": "1024",
    "embedding_type": "ubinary",
    "input": [
        "Organic skincare for sensitive skin with aloe vera and chamomile: Imagine the soothing embrace of nature with our organic skincare range, crafted specifically for sensitive skin. Infused with the calming properties of aloe vera and chamomile, each product provides gentle nourishment and protection. Say goodbye to irritation and hello to a glowing, healthy complexion.",
        "Bio-Hautpflege für empfindliche Haut mit Aloe Vera und Kamille: Erleben Sie die wohltuende Wirkung unserer Bio-Hautpflege, speziell für empfindliche Haut entwickelt. Mit den beruhigenden Eigenschaften von Aloe Vera und Kamille pflegen und schützen unsere Produkte Ihre Haut auf natürliche Weise. Verabschieden Sie sich von Hautirritationen und genießen Sie einen strahlenden Teint.",
    ]
}

response = requests.post(url, headers=headers, data=json.dumps(data))

print(response.json())

