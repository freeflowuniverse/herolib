import json
import requests

url = "https://api.jina.ai/v1/classify"
headers = {
    "Content-Type": "application/json",
    "Authorization": "Bearer jina_275aefb6495643408d4c499fce548080w5rYjijHfHVBi_vtAqNY6LBk-woz"
}
data = {
    "model": "jina-clip-v2",
    "input": [
        {
            "text": "A sleek smartphone with a high-resolution display and multiple camera lenses"
        },
        {
            "text": "Fresh sushi rolls served on a wooden board with wasabi and ginger"
        },
        {
            "image": "https://picsum.photos/id/11/367/267"
        },
        {
            "image": "https://picsum.photos/id/22/367/267"
        },
        {
            "text": "Vibrant autumn leaves in a dense forest with sunlight filtering through"
        },
        {
            "image": "https://picsum.photos/id/8/367/267"
        }
    ],
    "labels": [
        "Technology and Gadgets",
        "Food and Dining",
        "Nature and Outdoors",
        "Urban and Architecture"
    ]
}

response = requests.post(url, headers=headers, data=json.dumps(data))
print(response.json())
