import requests
from bs4 import BeautifulSoup
import csv
from datetime import datetime, timedelta
import re
from concurrent.futures import ThreadPoolExecutor, as_completed
import time, random

# ----------------------------
# Helper functions
# ----------------------------

def parse_posted_time(posted_str):
    posted_str = posted_str.strip().lower()
    match = re.match(r'(\d+)\s*([hdwm])', posted_str)
    if not match:
        return None
    amount = int(match.group(1))
    unit = match.group(2)
    now = datetime.now()
    if unit == 'h':
        posted_time = now - timedelta(hours=amount)
    elif unit == 'd':
        posted_time = now - timedelta(days=amount)
    elif unit == 'w':
        posted_time = now - timedelta(weeks=amount)
    elif unit == 'm':
        posted_time = now - timedelta(days=amount * 30)
    else:
        return None
    return posted_time.replace(microsecond=0)

def parse_salary(salary_str):
    if not salary_str:
        return None, None
    salary_str = salary_str.strip()
    period_match = re.search(r'/(.*?)$', salary_str)
    period = period_match.group(1).strip() if period_match else None
    amounts = re.findall(r'\$(\d+\.?\d*k?)', salary_str, re.IGNORECASE)
    if not amounts:
        return None, None
    formatted_amounts = [f"${amt}" for amt in amounts]
    if len(formatted_amounts) == 1:
        min_sal = f"{formatted_amounts[0]}/{period}" if period else formatted_amounts[0]
        max_sal = min_sal
    else:
        min_sal = f"{formatted_amounts[0]}/{period}" if period else formatted_amounts[0]
        max_sal = f"{formatted_amounts[1]}/{period}" if period else formatted_amounts[1]
    return min_sal, max_sal

# ----------------------------
# Setup
# ----------------------------

csv_file = "maine_jobs.csv"
fieldnames = [
    "Job Title",
    "Employer Website",
    "Employer Name",
    "Location",
    "Min Salary",
    "Max Salary",
    "Posted At",
    "Application URL"
]

base_url = 'https://jobsinmaine.com/jobs'
session = requests.Session()
session.headers.update({
    "User-Agent": "Mozilla/5.0 (compatible; JobScraper/1.0)"
})

employer_cache = {}

# ----------------------------
# Functions for scraping
# ----------------------------

def get_soup(url):
    """Fetch a URL and return BeautifulSoup object."""
    try:
        r = session.get(url, timeout=10)
        r.raise_for_status()
        return BeautifulSoup(r.text, 'html.parser')
    except Exception as e:
        print(f"⚠️ Error fetching {url}: {e}")
        return None

def extract_employer_website(employer_link):
    """Fetch employer page and extract external website (cached).
       If not found, return the employer_link itself."""
    if not employer_link:
        return ""
    if employer_link in employer_cache:
        return employer_cache[employer_link]

    soup3 = get_soup(employer_link)
    if not soup3:
        employer_cache[employer_link] = employer_link  # return internal page link as fallback
        return employer_link

    link_tag = soup3.select_one('a[target="_blank"][rel*="nofollow"] span')
    if link_tag:
        employer_website = link_tag.find_parent("a").get("href")
        employer_cache[employer_link] = employer_website
        return employer_website

    # Fallback: no external link found — return employer page instead
    employer_cache[employer_link] = employer_link
    return employer_link


def parse_job(job_url):
    """Scrape one job page."""
    soup2 = get_soup(job_url)
    if not soup2:
        return None

    job_title_tag = soup2.find('h1', class_='jb-color-0f172aff')
    title_text = job_title_tag.text.strip() if job_title_tag else ""

    info_div = job_title_tag.findNext('div').findNext(
        'div', class_="d-flex align-items-center flex-wrap jb-gap-lg"
    ) if job_title_tag else None

    employer_website = ""
    employer_name = ""
    location = ""
    min_sal = ""
    max_sal = ""
    posted_at = ""
    application_url = job_url

    if info_div:
        tags = info_div.find_all(['a', 'span'])
        relevant_tags = [t for i, t in enumerate(tags, start=1) if i % 2 == 1]

        if relevant_tags:
            # Employer website link
            if relevant_tags[0].name == 'a':
                employer_link = base_url[:-5] + relevant_tags[0].get('href')
                employer_website = extract_employer_website(employer_link)

            values = [t.get_text(strip=True) for t in relevant_tags]
            if len(values) == 4:
                employer_name = values[0]
                location = values[1]
                min_sal, max_sal = parse_salary(values[2])
                posted_at = parse_posted_time(values[3])
            elif len(values) == 3:
                employer_name = values[0]
                location = values[1]
                posted_at = parse_posted_time(values[2])

    # Application URL
    apply_link_tag = soup2.find('a', id="job-apply-btn")
    if apply_link_tag and apply_link_tag.get('href'):
        application_url = base_url[:-5] + apply_link_tag['href']

    return {
        "Job Title": title_text,
        "Employer Website": employer_website,
        "Employer Name": employer_name,
        "Location": location,
        "Min Salary": min_sal,
        "Max Salary": max_sal,
        "Posted At": posted_at,
        "Application URL": application_url
    }

# ----------------------------
# Main scraping loop
# ----------------------------

with open(csv_file, "w", newline="", encoding="utf-8") as f:
    writer = csv.DictWriter(f, fieldnames=fieldnames)
    writer.writeheader()

    for page_num in range(1, 35):
        url = base_url if page_num == 1 else f"{base_url}?page={page_num}"
        soup = get_soup(url)
        if not soup:
            continue

        job_links = [base_url + a["href"][5:] for a in soup.find_all('a', class_='job-details-link')]
        if not job_links:
            print(f"No jobs found on page {page_num}. Stopping.")
            break

        # Fetch job pages in parallel
        with ThreadPoolExecutor(max_workers=10) as executor:
            futures = {executor.submit(parse_job, link): link for link in job_links}
            for future in as_completed(futures):
                result = future.result()
                if result:
                    writer.writerow(result)

        print(f"✅ Page {page_num} scraped ({len(job_links)} jobs)")
        # polite delay to avoid hitting rate limits
        time.sleep(random.uniform(1, 2))

print("🎉 All pages scraped successfully!")
