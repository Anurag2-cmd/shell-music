# Future Improvement Suggestions

To take this app to the next level, I suggest implementing the following features:

## 1. Playback Improvements
- **Notification Controls**: Use `audio_service` (Flutter package) to allow users to control playback from the Android notification shade and lock screen.
- **Sleep Timer**: A common feature for ASMR apps. Let users set a timer to stop playback after 15, 30, or 60 minutes.
- **Equalizer / Speed Control**: ASMR listeners often prefer specific speeds (0.75x or 1.25x).

## 2. Content & Extensions
- **Extension Store**: Instead of manually placing `.py` files, create a "Browse Extensions" tab that downloads them from a GitHub repository (similar to Tachiyomi).
- **Webview Scraping**: Some sites have complex anti-bot protection. Using a hidden Webview to bypass Cloudflare would make extensions more robust.

## 3. UI/UX
- **Custom Themes**: Deep purple is great, but users love OLED Black or light mode options.
- **Drag & Drop Queue**: Allow users to queue multiple tracks to play in a row.

## 4. Suggested Additional Handover Files
- **`api_schema.json`**: A JSON schema file defining exactly what the Python-to-Flutter bridge expects. This helps an AI or new dev write extensions without reading the Dart code.
- **`environment_setup.bat`**: A script to automatically run `flutter pub get` and `build_runner` for new developers.
