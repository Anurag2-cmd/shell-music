# ASMR App Features

An extensible ASMR audio scraper and player inspired by Tachiyomi.

## 🚀 Core Features

### 🧩 Python Extension Support
- **Dynamic Sources**: Add new websites to scrape by simply dropping a `.py` file into the `python_extensions` folder.
- **Cross-Language**: Uses Chaquopy to run Python logic seamlessly inside a Flutter Android app.

### 🎧 Professional Audio Playback
- **Global Audio**: Music keeps playing when you go back to browse more content.
- **Mini-Player**: A persistent control bar at the bottom of the app allows you to play/pause or return to the full player.
- **Full Player Screen**: Includes seeking, skip controls, and cover art display.
- **Quick Play**: Start listening directly from the browse/search grid with a single tap.

### 🔍 Discovery
- **Browse**: Explore popular and latest content from installed sources.
- **Search**: Search specific titles or artists across different extensions.
- **Multi-Source Tabs**: Each installed extension automatically gets its own tab in the Browse screen.

### 📁 Library & Favorites
- **Favorites**: Save tracks to your local library with the Heart icon.
- **Persistence**: Your favorites are saved in a local database and stay there even if the app is closed.

### 📥 Downloads (Foundational)
- **UI Ready**: Detail screens already include sections for multiple download qualities (MP3, FLAC).
- **Service Ready**: Python extensions can provide multiple download URLs with size information.
