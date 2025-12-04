import requests
from bs4 import BeautifulSoup
import pandas as pd
import time

jobs = []
max_jobs = 120  # stops after getting 120 jobs

page = 1
while True:
    if len(jobs) >= max_jobs:
        print("Reached job limit. Stopping scrape.")
        break

    url = f"https://careers.liveandworkinmaine.com/search?page={page}"
    response = requests.get(url, headers={'User-Agent': 'Mozilla/5.0'})
    soup = BeautifulSoup(response.text, 'html.parser')

    job_divs = soup.find_all('div', class_='title')
    if not job_divs:
        print(f"No jobs found on page {page}. Stopping.")
        break

    print(f"Scraping page {page} ({len(job_divs)} jobs found)")

    for div in job_divs:
        if len(jobs) >= max_jobs:
            break

        a_tag = div.find('a')
        if not a_tag or not a_tag.get('href'):
            continue

        href = a_tag['href']
        full_url = f"https://careers.liveandworkinmaine.com{href}"
        title = a_tag.get_text(strip=True)

        job_response = requests.get(full_url, headers={'User-Agent': 'Mozilla/5.0'})
        job_soup = BeautifulSoup(job_response.text, 'html.parser')

        employer_name = job_soup.find('span', id='lblOutCompany')
        employer_name = employer_name.get_text(strip=True) if employer_name else "N/A"

        employer_website = job_soup.find('a', id='hlOutCompanyURL')
        employer_website = employer_website.get('href') if employer_website else "N/A"

        location_tag = job_soup.find('span', id='lblOutAddress')
        location = " ".join(location_tag.stripped_strings) if location_tag else "N/A"

        salary_tag = job_soup.find('span', id='lblOutSalary')
        salary_text = salary_tag.get_text(strip=True) if salary_tag else ""
        min_salary = max_salary = ""
        if "$" in salary_text:
            parts = salary_text.replace("$", "").replace(",", "").split("-")
            if len(parts) == 2:
                min_salary = f"${parts[0].strip()}"
                max_salary = f"${parts[1].strip()}"
            else:
                min_salary = max_salary = salary_text.strip()

        posted_date = job_soup.find('span', id='lblOutPostedDate')
        posted_date = posted_date.get_text(strip=True) if posted_date else "N/A"

        apply_tag = job_soup.find('a', id='hlOutApply')
        apply_url = apply_tag.get('href') if apply_tag else full_url

        jobs.append({
            "Job Title": title,
            "Employer Website": employer_website,
            "Employer Name": employer_name,
            "Location": location,
            "Min Salary": min_salary,
            "Max Salary": max_salary,
            "Posted At": posted_date,
            "Application URL": apply_url
        })

        print(f"Saved job #{len(jobs)}: {title}")
        time.sleep(0.1)

    page += 1

df = pd.DataFrame(jobs)
df.to_csv("liveandworkinmaine_jobs.csv", index=False, sep='\t')
print(f"Saved {len(df)} jobs to liveandworkinmaine_jobs.csv")