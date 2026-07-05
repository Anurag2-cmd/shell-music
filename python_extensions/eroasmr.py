import requests
from bs4 import BeautifulSoup
import hashlib
import json
from typing import Any, Dict, List

# Basic setup for scraping
BASE_URL = "https://eroasmr.com"
HEADERS = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
}

def metadata() -> Dict[str, str]:
    return {
        "id": "eroasmr",
        "name": "EroASMR",
        "version": "1.1.0",
        "description": "Scraper for EroASMR.com with Video support",
        "lang": "en",
        "base_url": BASE_URL,
    }

def _make_id(url: str) -> str:
    return hashlib.md5(url.encode()).hexdigest()[:12]

def _parse_entry(item) -> Dict[str, Any]:
    link_tag = item.select_one("a.thumb-link")
    title_tag = item.select_one("h2.title a")
    img_tag = item.select_one("img")

    url = link_tag["href"] if link_tag else ""
    title = title_tag.text.strip() if title_tag else "Unknown"
    cover_url = img_tag["src"] if img_tag else ""

    return {
        "id": _make_id(url),
        "title": title,
        "source_id": "eroasmr",
        "url": url,
        "cover_url": cover_url,
        "artist": "EroASMR",
        "tags": [],
        "duration": None,
        "language": "en",
    }

def get_popular(page: int = 1) -> List[Dict[str, Any]]:
    url = f"{BASE_URL}/page/{page}/" if page > 1 else BASE_URL
    response = requests.get(url, headers=HEADERS)
    soup = BeautifulSoup(response.text, "html.parser")

    entries = []
    items = soup.select("div.post-item")
    for item in items:
        entries.append(_parse_entry(item))
    return entries

def search(query: str, page: int = 1) -> List[Dict[str, Any]]:
    url = f"{BASE_URL}/page/{page}/?s={query}"
    response = requests.get(url, headers=HEADERS)
    soup = BeautifulSoup(response.text, "html.parser")

    entries = []
    items = soup.select("div.post-item")
    for item in items:
        entries.append(_parse_entry(item))
    return entries

def get_audio_details(url: str) -> Dict[str, Any]:
    response = requests.get(url, headers=HEADERS)
    soup = BeautifulSoup(response.text, "html.parser")

    title = soup.select_one("h1.entry-title").text.strip()
    img = soup.select_one("div.entry-content img")
    cover_url = img["src"] if img else ""

    # Audio source
    audio_tag = soup.select_one("audio source")
    audio_url = audio_tag["src"] if audio_tag else ""

    # Video source (look for video tags)
    video_tag = soup.select_one("video source")
    video_url = video_tag["src"] if video_tag else ""

    description = ""
    desc_tag = soup.select_one("div.entry-content")
    if desc_tag:
        description = desc_tag.text.strip()[:500] + "..."

    tags = [t.text.strip() for t in soup.select("span.tags-links a")]

    return {
        "id": _make_id(url),
        "title": title,
        "source_id": "eroasmr",
        "url": url,
        "cover_url": cover_url,
        "artist": "EroASMR",
        "tags": tags,
        "duration": None,
        "description": description,
        "audio_url": audio_url,
        "video_url": video_url,
        "language": "en",
    }

def get_download_urls(url: str) -> List[Dict[str, Any]]:
    details = get_audio_details(url)
    urls = []
    if details["audio_url"]:
        urls.append({"url": details["audio_url"], "quality": "Audio", "format": "mp3", "size": None})
    if details["video_url"]:
        urls.append({"url": details["video_url"], "quality": "Video", "format": "mp4", "size": None})
    return urls
