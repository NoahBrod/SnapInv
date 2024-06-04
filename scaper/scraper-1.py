import requests
import json
from bs4 import BeautifulSoup
from googlesearch import search
import asyncio
# import websockets
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

markers = "/-_"

def findKeyWord(i):
    print()
    highIndex = 0
        
    for j in markers:
        curIndex = i.find(j)
        if curIndex > 0:
            if curIndex < highIndex and highIndex != 0:
                highIndex = curIndex
                print("Marker index at: " + str(highIndex))
                break
            else:
                highIndex = curIndex
    
    if highIndex == 0:
        return "NONE"
    
    return i[:highIndex]

def searchKeyWord(i, urls, keyWord):
    matches = 1
    for j in urls:
            if i != j:
                if keyWord.lower() in j.lower():
                    print("Found keyword: " + keyWord)
                    matches += 1
                
                # if matches > 2:
                #     keyWords.append(keyWord)
                #     break
    # print()
    return matches

@app.route('/receive_code', methods=['POST'])
def receive_code():
    data = request.json
    print("Received data:", data)
    
    urls = []
    fixedUrls = []
    keyWords = []
    
    finalString = ""

    query = "9780670922857"
    print("Searching: " + query)
    for i in search(query, num=7, stop=7, pause=2):
        urls.append(i)
    
    print()
    print("Found:")
    for i in urls:
        print("    " + i)
    
    print()
    print("Changing urls:")
    for i in range(len(urls)):
        urlFix = urls[i][urls[i].index("//")+2:]
        urlFix = urlFix[urlFix.index("/")+1:]
        fixedUrls.append(urlFix)
        print("    " + urlFix)
    
    print()
    print("Getting key words:")
    
    i = 0
    count = 0
    while True:
        print()
        keyWord = findKeyWord(fixedUrls[i])
        if keyWord != query:
            matches = searchKeyWord(fixedUrls[i], fixedUrls, keyWord)
            if matches > 2 and not keyWord in keyWords:
                keyWords.append(keyWord)
            
        if findKeyWord(fixedUrls[i]):
            if keyWord != "NONE":
                fixedUrls[i] = fixedUrls[i][len(keyWord)+1:]
                print("Key word " + keyWord + " removed: " + fixedUrls[i])
            else:
                i += 1
            
            count += 1
            
        if i == len(fixedUrls):
            break
    
    print(keyWords)
    lowerKeyWords = map(lambda x:x.lower(), keyWords)
    presentKeyWords = []
    for i in keyWords:
        check = False
        if i.lower() in lowerKeyWords and i.lower() not in presentKeyWords:
            if len(i) == 1:
                for j in keyWords:
                    if len(j) > 1 and i in j:
                        presentKeyWords.append(i.lower())
                        check = True
                        break
            if not check:
                presentKeyWords.append(i.lower())
                finalString += i + " "
    finalString = finalString[:len(finalString)-1]
    
    return finalString

if __name__ == '__main__':
    app.run(debug=True)
