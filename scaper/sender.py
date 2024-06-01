import requests

data = {"key": "value"}
response = requests.post("http://localhost:5000/receive_code", json=data)
print(response.text)