import requests
import json
from bs4 import BeautifulSoup
from googlesearch import search
import asyncio
import websockets
from flask import Flask, request, jsonify

# set up the request parameters
# params = {
# 'api_key': '5EF3BB181B3E447F94EA4BEC27D06179',
#   'q': 'pizza'
# }

# # make the http GET request to Scale SERP
# api_result = requests.get('https://api.scaleserp.com/search', params)

# # print the JSON response from Scale SERP
# print(json.dumps(api_result.json()))
# urls = []

# query = "9781803233307"
# print()
# i = 0
# for j in search(query, num=3, stop=3, pause=2):
#     print(j)
#     urls.append(j)
#     i += 1

# print(urls)
app = Flask(__name__)

@app.route('/receive_code', methods=['POST'])
def receive_code():
    data = request.json
    print("Received data:", data)
    
    urls = []

    query = "9781803233307"
    print()
    i = 0
    for j in search(query, num=3, stop=3, pause=2):
        print(j)
        urls.append(j)
        i += 1
    
    return urls

if __name__ == '__main__':
    app.run(debug=True)
