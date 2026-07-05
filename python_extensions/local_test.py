def metadata():
    return {
        "id": "local_test",
        "name": "Local Test (No Network)",
        "version": "1.0.0",
        "description": "Static data for testing the bridge",
        "lang": "en",
        "base_url": "",
    }

def get_popular(page=1):
    return [
        {
            "id": "test_1",
            "title": "Local Test Audio 1",
            "source_id": "local_test",
            "url": "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3",
            "cover_url": "https://picsum.photos/seed/test1/300/300",
            "artist": "Test Artist",
            "duration": "05:00",
        },
        {
            "id": "test_2",
            "title": "Local Test Video 1",
            "source_id": "local_test",
            "url": "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3",
            "video_url": "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
            "cover_url": "https://picsum.photos/seed/test2/300/300",
            "artist": "Test Artist",
            "duration": "10:00",
        }
    ]

def search(query, page=1):
    return get_popular(page)

def get_audio_details(url):
    pop = get_popular(1)
    for item in pop:
        if item["url"] == url:
            item["description"] = "This is a local test item that does not require internet for scraping."
            item["tags"] = ["test", "local", "working"]
            item["audio_url"] = item["url"]
            return item
    return pop[0]

def get_download_urls(url):
    return []
