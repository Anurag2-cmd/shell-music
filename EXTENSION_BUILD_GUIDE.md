# Shell Music Player - Extension Development Guide

This guide explains how to build and integrate Python-based scrapers (Extensions) into the Shell Music Player.

## 🏗️ Architecture Overview

The app uses **Chaquopy** to run Python logic inside the Android environment.
1. **Flutter**: Handles the UI and background audio player.
2. **MethodChannel**: Bridges data between Dart (Flutter) and Python.
3. **Bridge (`bridge.py`)**: A Python registry that scans for `.py` files and calls their functions.
4. **Extensions**: Independent Python scripts that scrape specific websites and return structured data.

---

## 🛠️ Getting Started

Every extension is a standalone Python file. For development, place them in `python_extensions/`. For end-users, they can be installed via the "Sources" tab in the app.

### 1. Metadata
Every extension **must** implement a `metadata()` function. This tells the app the name and capabilities of your source.

```python
def metadata():
    return {
        "id": "unique_source_id",
        "name": "My Source Name",
        "version": "1.0.0",
        "description": "Scraper for mysite.com",
        "lang": "en",
        "base_url": "https://mysite.com",
    }
```

### 2. Main Listing Functions
These functions populate the "Browse" grid and "Search" results.

- **`get_popular(page: int)`**: Returns popular content.
- **`get_latest(page: int)`**: Returns latest content.
- **`search(query: str, page: int)`**: Returns search results.

**Expected Return**: A list of dictionaries with these keys:
- `id`: Unique string (e.g., md5 of the URL).
- `title`: Display title.
- `url`: The link to the web page of this item.
- `cover_url`: Link to the thumbnail image.
- `artist`: (Optional) Creator name.
- `duration`: (Optional) Duration string (e.g., "12:30").

### 3. Detailed Data
When a user clicks an item, the app calls:

**`get_audio_details(url: str)`**:
Must return a dictionary containing the direct media links:
- `audio_url`: Direct link to an `.mp3`, `.m4a`, or `.wav` file. (Required for background play).
- `video_url`: (Optional) Direct link to an `.mp4` or `.mkv` file. (Enables the "Watch Video" button).
- `description`: Text summary of the item.
- `tags`: List of strings (categories).

### 4. Downloads (Future Proofing)
**`get_download_urls(url: str)`**:
Returns a list of available files for offline saving:
```python
[{"url": "...", "quality": "320kbps", "format": "mp3", "size": 52428800}]
```

---

## 🧪 Best Practices & Tips

### Scrape the "Source" directly
Many sites hide their links in JavaScript. Instead of using `BeautifulSoup` for everything, use `re.search()` on the raw `response.text` to find URLs ending in `.mp4` or `.mp3`.

### Use Resilient Selectors
Websites change often. Try to target ID attributes or unique parent containers rather than generic CSS classes like `col-md-3`.

### Handle Anti-Bot
The app includes `requests` and `beautifulsoup4`. Always use a mobile User-Agent to avoid being blocked:
```python
HEADERS = {"User-Agent": "Mozilla/5.0 (Linux; Android 10; K) Mobile Safari/537.36"}
```

---

## 📂 Deployment
1. Move your `.py` script to the `python_extensions/` folder.
2. Build the app with `flutter run`.
3. Your new source will automatically appear as a new tab in the **Browse** screen.
