from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import pandas as pd
import time

# List of skills to search on YouTube
skills = [
    "Excel",
    "Data analysis",
    "Microsoft Office",
    "CPR",
    "python",
    "crm",
    "budgeting"
]

results = []

# Initialize Chrome WebDriver
driver = webdriver.Chrome()

for skill in skills:
    search_query = skill.replace(" ", "+") + "+tutorial"
    driver.get(f"https://www.youtube.com/results?search_query={search_query}")

    try:
        # Wait until at least one video appears
        videos = WebDriverWait(driver, 10).until( # 10 seconds
            EC.presence_of_all_elements_located((By.XPATH, '//a[@id="video-title"]'))
        )
    except:
        # Fallback if nothing loads
        videos = []

    # Alternate selector in case YouTube uses different layout
    if not videos:
        videos = driver.find_elements(By.XPATH, '//ytd-video-renderer//a[@href and @title]')

    if videos:
        video = videos[0]  # we pick the first video
        results.append({
            "Skill": skill,
            "Video URL": video.get_attribute('href'),
            "Video Title": video.get_attribute('title'),
            "Source": "YouTube"
        })
        print(f"✓ Found for {skill}: {video.get_attribute('href')}")
    else:
        print(f"⚠ No video found for {skill}")

    # Short pause
    time.sleep(2)

driver.quit()

# Saves the results to CSV
df = pd.DataFrame(results)
df.to_csv("skills_resources.csv", index=False)
print(f"\n✓ Saved {len(df)} skill resources to skills_resources.csv")
print("\nResults:")
print(df)