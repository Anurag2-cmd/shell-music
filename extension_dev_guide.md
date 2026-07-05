# Extension Development Guide

This app uses Python scripts to scrape data. Each script must be placed in `python_extensions/` and follow this structure.

## 1. Required Metadata
Every extension must have a `metadata()` function.

```python
def metadata():
    return {
        "id": "my_unique_id",
        "name": "Site Name",
        "version": "1.0.0",
        "description": "Scrapes site.com",
        "lang": "en",
        "base_url": "https://site.com",
    }
```

## 2. Mandatory Functions

### `get_popular(page)` & `get_latest(page)`
Returns a list of dictionaries for the grid view.
- **Keys**: `id`, `title`, `url` (source link), `cover_url`, `artist`, `duration`.

### `search(query, page)`
Returns a list of dictionaries matching the query.

### `get_audio_details(url)`
Called when a user taps an item. Must return full details including:
- `audio_url`: The direct link to the `.mp3` or `.m4a` file.
- `description`: Full text description.
- `tags`: A list of strings.

### `get_download_urls(url)`
Returns a list of available files for downloading.
- **Keys**: `url`, `quality`, `format`, `size` (in bytes).

## 3. Best Practices
- **Use `requests`**: The app is pre-configured with the `requests` library.
- **IDs**: Use `hashlib.md5(url.encode()).hexdigest()` to create unique IDs for tracks if the website doesn't provide them.
- **Testing**: Test your Python logic on your computer first before moving it to the `python_extensions` folder.
