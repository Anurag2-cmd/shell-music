import requests
from bs4 import BeautifulSoup
import hashlib
import re
import json
from typing import Any, Dict, List

BASE_URL = "https://www.pornhub.com"
HEADERS = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
    "Cookie": "age_verified=1"
}

def metadata() -> Dict[str, str]:
    return {
        "id": "pornhub",
        "name": "Pornhub",
        "version": "1.0.0",
        "description": "Video scraper for Pornhub",
        "lang": "en",
        "base_url": BASE_URL,
    }

def _make_id(url: str) -> str:
    return hashlib.md5(url.encode()).hexdigest()[:12]

def get_popular(page: int = 1) -> List[Dict[str, Any]]:
    # Pornhub video list
    url = f"{BASE_URL}/video?page={page}"
    response = requests.get(url, headers=HEADERS)
    soup = BeautifulSoup(response.text, "html.parser")

    entries = []
    # Video items usually in li.videoBox or similar
    items = soup.select("ul#videoCategory li.videoBox")
    for item in items:
        link = item.select_one("span.title a")
        img = item.select_one("img")

        if link and img:
            video_url = BASE_URL + link["href"]
            entries.append({
                "id": _make_id(video_url),
                "title": link.text.strip(),
                "source_id": "pornhub",
                "url": video_url,
                "cover_url": img.get("data-src") or img.get("src"),
                "artist": "PH User",
                "tags": [],
                "duration": item.select_one("var.duration").text.strip() if item.select_one("var.duration") else None,
            })
    return entries

def search(query: str, page: int = 1) -> List[Dict[str, Any]]:
    url = f"{BASE_URL}/video/search?search={query}&page={page}"
    response = requests.get(url, headers=HEADERS)
    soup = BeautifulSoup(response.text, "html.parser")

    entries = []
    items = soup.select("ul#videoSearchResult li.videoBox")
    for item in items:
        link = item.select_one("span.title a")
        img = item.select_one("img")

        if link and img:
            video_url = BASE_URL + link["href"]
            entries.append({
                "id": _make_id(video_url),
                "title": link.text.strip(),
                "source_id": "pornhub",
                "url": video_url,
                "cover_url": img.get("data-src") or img.get("src"),
                "artist": "PH User",
                "tags": [],
                "duration": item.select_one("var.duration").text.strip() if item.select_one("var.duration") else None,
            })
    return entries

def get_audio_details(url: str) -> Dict[str, Any]:
    response = requests.get(url, headers=HEADERS)
    html = response.text
    soup = BeautifulSoup(html, "html.parser")

    title = soup.select_one("h1.title").text.strip() if soup.select_one("h1.title") else "Unknown"

    # Extraction of video URL from PH script tags is complex (requires flashvars or media definitions)
    # This is a simplified placeholder as real PH extraction often requires regex on JS
    video_url = ""
    # Look for the flashvars object in script tags
    match = re.search(r'"mediaDefinitions":\s*(\[.*?\])', html)
    if match:
        try:
            media = json.loads(match.group(1))
            # Sort by quality if available, pick first valid
            valid_sources = [m for m in media if m.get("videoUrl")]
            if valid_sources:
                video_url = valid_sources[0]["videoUrl"]
        except:
            pass

    return {
        "id": _make_id(url),
        "title": title,
        "source_id": "pornhub",
        "url": url,
        "cover_url": "", # Extracted from meta tags usually
        "artist": "PH Creator",
        "tags": [t.text.strip() for t in soup.select("div.categoriesWrapper a")],
        "description": "Video from Pornhub",
        "audio_url": None, # Mostly video
        "video_url": video_url,
    }

def get_download_urls(url: str) -> List[Dict[str, Any]]:
    # Requires more complex logic for multiple qualities
    return []
