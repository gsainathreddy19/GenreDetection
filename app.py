from flask import Flask
from flask import jsonify
app = Flask(__name__)
from bs4 import BeautifulSoup
import requests
import urllib
from pandas.io.html import read_html
import re
import html5lib
import lxml
#source = requests.get('https://www.google.com/search?q=frankenstein+genre').text

#soup = BeautifulSoup(source,'lxml')
#print(soup.find('span',class_="BNeawe"))
#data = ['fiction','Action','Adventure','Art','Alternate history','Autobiography','Anthology','Biography','Chick lit','Book review','Children\'s','Cookbook','Comic book','Diary','Coming-of-age','Dictionary','Crime','Encyclopedia','Drama','Guide']
#dataset = set(data)
@app.route('/<name>')
def index(name):
    source = requests.get('https://www.google.com/search?q={}+genre'.format(name)).text
    items = list(source.split())
    s = 'not found'
    query = name+"'book wiki'"
    query = urllib.parse.quote_plus(query)  # Format into URL encoding
    number_result = 20
    google_url = "https://www.google.com/search?q=" + query + "&num=" + str(number_result)
    response = requests.get(google_url, {"User-Agent": 'sainath'})
    soup = BeautifulSoup(response.text, "html.parser")
    result_div = soup.find_all('div', attrs={'class': 'ZINbbc'})
    links = []
    titles = []
    descriptions = []
    for r in result_div:
        # Checks if each element is present, else, raise exception
        try:
            link = r.find('a', href=True)
            title = r.find('div', attrs={'class': 'vvjwJb'}).get_text()
            description = r.find('div', attrs={'class': 's3v9rd'}).get_text()

            # Check to make sure everything is present before appending
            if link != '' and title != '' and description != '':
                links.append(link['href'])
                titles.append(title)
                descriptions.append(description)
        # Next loop if one element is not present
        except:
            continue

    to_remove = []
    clean_links = []
    for i, l in enumerate(links):
        clean = re.search('\/url\?q\=(.*)\&sa', l)

        # Anything that doesn't fit the above pattern will be removed
        if clean is None:
            to_remove.append(i)
            continue
        clean_links.append(clean.group(1))
    page = clean_links[0]
    infoboxes = read_html(page, index_col=0, attrs={"class": "infobox"})
    # wikitables = read_html(page, index_col=0, attrs={"class":"wikitable"})

    print("Extracted {num} infoboxes".format(num=len(infoboxes)))
    # print("Extracted {num} wikitables".format(num=len(wikitables)))

    s = infoboxes[0].xs(u'Genre').values[0]
    return jsonify(genre=s)