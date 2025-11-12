import requests
from bs4 import BeautifulSoup

base_url = 'https://careers.liveandworkinmaine.com/search'
response = requests.get(base_url, headers={'User-Agent': 'Mozilla/5.0'})
soup = BeautifulSoup(response.text, 'html.parser')

job_divs = soup.find_all('div', class_='title')

for div in job_divs:
    a_tag = div.find('a')
    if a_tag and a_tag.get('href'):
        href = a_tag['href']
        full_url = f"https://careers.liveandworkinmaine.com{href}"
        title = a_tag.get_text(strip=True)

        job_response = requests.get(full_url, headers={'User-Agent': 'Mozilla/5.0'})
        job_soup = BeautifulSoup(job_response.text, 'html.parser')

        # Posted date
        posted_date_tag = job_soup.find('span', id='lblOutPostedDate')
        posted_date = posted_date_tag.get_text(strip=True) if posted_date_tag else "N/A"

        # Address
        address_tag = job_soup.find('span', id='lblOutAddress')
        if address_tag:
            lines = list(address_tag.stripped_strings)
            if len(lines) >= 3:
                street = " / ".join(lines[:-2])
                city_state_zip = lines[-2]
                country = lines[-1]

                if ',' in city_state_zip:
                    city, state_zip = city_state_zip.split(',', 1)
                    city = city.strip()
                    state_zip = state_zip.strip()
                    if ' ' in state_zip:
                        state, zip_code = state_zip.split(' ', 1)
                    else:
                        state, zip_code = state_zip, ""
                else:
                    city = state = zip_code = ""
            else:
                street = city = state = zip_code = country = "N/A"
        else:
            street = city = state = zip_code = country = "N/A"

        # Industry
        industry_tag = job_soup.find('span', id='lblCF91')
        industry = industry_tag.get_text(strip=True) if industry_tag else "N/A"

        print("Job Title:", title)
        print("Job URL:", full_url)
        print("Posted Date:", posted_date)
        print("Street:", street)
        print("City:", city)
        print("State:", state)
        print("Zip Code:", zip_code)
        print("Country:", country)
        print("Industry:", industry)
        print("-" * 50)
