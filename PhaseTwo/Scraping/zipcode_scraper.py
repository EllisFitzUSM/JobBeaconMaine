import requests
from bs4 import BeautifulSoup
import csv

"""This program was made for me by Sonnet 4.5 with the prompt
being me getting the all of the rows that contained the information,
prettifying it and pasting the prettified info and telling it to make
me a code to extract ZipCode, City and County"""

base_url = 'https://www.zip-codes.com/state/me.asp'
page = requests.get(base_url)
soup = BeautifulSoup(page.text, 'html.parser')

info_row = soup.find_all('tr')

# Open CSV file for writing
with open('maine_zipcodes.csv', 'w', newline='', encoding='utf-8') as csvfile:
    writer = csv.writer(csvfile)

    # Write header row
    writer.writerow(['ZIP Code', 'City', 'County'])

    # Skip header rows and iterate through data rows
    for row in info_row:
        cells = row.find_all('td')

        # Make sure we have enough cells
        if len(cells) >= 4:
            # Get zip code from first cell
            zip_link = cells[0].find('a')
            if zip_link:
                zip_code = zip_link.get_text(strip=True)

                # Get city from third cell
                city_link = cells[2].find('a')
                city = city_link.get_text(strip=True) if city_link else cells[2].get_text(strip=True)

                # Get county from fourth cell
                county = cells[3].get_text(strip=True)

                # Write to CSV
                writer.writerow([zip_code, city, county])

print("CSV file created successfully!")