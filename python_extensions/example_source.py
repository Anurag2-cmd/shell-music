"""
Example ASMR audio source extension.
Implement these functions to scrape a real website.
"""

import hashlib
import json
from typing import Any, Dict, List
from urllib.parse import urljoin

import requests


def metadata() -> Dict[str, str]:
    return {
        "id": "example_source",
        "name": "Example ASMR",
        "version": "1.0.0",
        "description": "Example source for demonstration purposes",
        "lang": "en",
        "base_url": "https://example-asmr.com",
        "class": "ExampleSource",
    }


def _make_id(url: str) -> str:
    return hashlib.md5(url.encode()).hexdigest()[:12]


def search(query: str, page: int = 1) -> List[Dict[str, Any]]:
    results = []
    for i in range(20):
        results.append(
            {
                "id": _make_id(f"search_{query}_{page}_{i}"),
                "title": f"Search Result {i + 1} for '{query}'",
                "source_id": "example_source",
                "url": f"https://example-asmr.com/audio/{page}_{i}",
                "cover_url": f"https://picsum.photos/seed/{page}_{i}/300/300",
                "artist": f"Artist {i % 5 + 1}",
                "tags": ["asmr", "whisper", "roleplay"],
                "duration": f"{10 + i}:00",
                "language": "en",
            }
        )
    return results


def get_popular(page: int = 1) -> List[Dict[str, Any]]:
    results = []
    for i in range(20):
        results.append(
            {
                "id": _make_id(f"popular_{page}_{i}"),
                "title": f"Popular ASMR #{page * 20 + i}",
                "source_id": "example_source",
                "url": f"https://example-asmr.com/audio/popular_{page}_{i}",
                "cover_url": f"https://picsum.photos/seed/pop_{page}_{i}/300/300",
                "artist": f"Voice Actor {i % 3 + 1}",
                "tags": ["asmr", "popular"],
                "duration": f"{15 + (i % 30)}:00",
                "language": "en",
            }
        )
    return results


def get_latest(page: int = 1) -> List[Dict[str, Any]]:
    results = []
    for i in range(20):
        results.append(
            {
                "id": _make_id(f"latest_{page}_{i}"),
                "title": f"New Release #{page * 20 + i}",
                "source_id": "example_source",
                "url": f"https://example-asmr.com/audio/new_{page}_{i}",
                "cover_url": f"https://picsum.photos/seed/new_{page}_{i}/300/300",
                "artist": f"Creator {i % 4 + 1}",
                "tags": ["asmr", "new", "release"],
                "duration": f"{20 + (i % 15)}:00",
                "language": "jp",
            }
        )
    return results


def get_audio_details(url: str) -> Dict[str, Any]:
    return {
        "id": _make_id(url),
        "title": "Mock ASMR Audio Title",
        "source_id": "example_source",
        "url": url,
        "cover_url": "https://picsum.photos/seed/detail/400/400",
        "artist": "Mock Artist",
        "tags": ["mock", "asmr", "whisper", "relaxation"],
        "duration": "45:00",
        "description": (
            "A relaxing ASMR experience generated for testing purposes."
        ),
        "file_size": 1024 * 1024 * 2,
        "audio_url": "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3",
        "language": "en",
    }


def get_download_urls(url: str) -> List[Dict[str, Any]]:
    return [
        {
            "url": "https://example-asmr.com/download/audio_320kbps.mp3",
            "quality": "320kbps",
            "format": "mp3",
            "size": 52428800,
        },
        {
            "url": "https://example-asmr.com/download/audio_128kbps.mp3",
            "quality": "128kbps",
            "format": "mp3",
            "size": 20971520,
        },
        {
            "url": "https://example-asmr.com/download/audio_flac.flac",
            "quality": "FLAC",
            "format": "flac",
            "size": 157286400,
        },
    ]
