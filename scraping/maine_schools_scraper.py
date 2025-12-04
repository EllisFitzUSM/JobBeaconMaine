"""
Information on the source seen here:
https://collegescorecard.ed.gov/data/api/
"""

from dotenv import load_dotenv
import requests
import json
import csv
import os

url = "https://api.data.gov/ed/collegescorecard/v1/schools"
load_dotenv()
key = os.getenv("US_DOE_CS_KEY")

params = {'api_key': key, 'school.state': 'ME', 'fields':['school.name']}
response = requests.get(url, params)
print(response.status_code)

json_dict = json.loads(response.text)
with open('maine_schools.csv', 'w') as file:
	writer = csv.DictWriter(file, ['school.name'], lineterminator='\n')
	writer.writerows(json_dict['results'])