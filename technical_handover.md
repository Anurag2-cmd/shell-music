# Technical Handover - ASMR App Development

This document provides a summary of the technical changes, bug fixes, and architectural decisions made during the initial development phase.

## 1. Key Architectural Changes

### Global Playback Service (`playback_service.dart`)
- **Reason**: Playback originally stopped when navigating back from the player screen.
- **Change**: Implemented a Singleton `PlaybackService` using `just_audio`.
- **Result**: Audio continues playing globally. Managed via a `BehaviorSubject` to allow multiple UI components (Full Player, Mini-Player) to react to the same state.

### Singleton Extension Manager (`extension_manager.dart`)
- **Reason**: Multiple screens were initializing the Python bridge independently, causing race conditions and slow "Quick Play" actions.
- **Change**: Converted to a Singleton.
- **Result**: The Python bridge is initialized once, and extension metadata is cached across the app.

### Hive Persistence (`audio_entry.dart`)
- **Reason**: Needed to save "Favorites" and potentially "Downloads" locally.
- **Change**: Annotated `AudioEntry` with `@HiveType` and registered the adapter in `main.dart`.

## 2. Critical Bug Fixes

### Python Integration (Windows & Android)
- **Problem**: `build.gradle` had a hardcoded `/usr/bin/python3` path (Linux/macOS only).
- **Fix**: Removed the hardcoded path to let Gradle use the system's `python` command.
- **Problem**: Extensions were not bundled in the APK.
- **Fix**: Added `sourceSets` to `build.gradle` to include `../../python_extensions`.
- **Problem**: `bridge.py` used relative dev-paths that don't exist on Android.
- **Fix**: Changed `extensions_dir` to `os.path.dirname(__file__)` which works in the bundled Chaquopy environment.

### "ValueStream has no value" Crash
- **Problem**: Accessing `PlaybackService().currentEntry` before any audio was played.
- **Fix**: Switched from `.value` to `.valueOrNull` in `rxdart` BehaviorSubject.

### Build Failure (Typo)
- **Problem**: Use of `MainValueAlignment` (non-existent) instead of `MainAxisAlignment`.
- **Fix**: Corrected the constant name in `favorites_screen.dart`.

## 3. Important Implementation Details
- **Mini-Player**: Integrated directly into `MainShell` in `app.dart` to ensure it stays above the Navigation Bar regardless of which tab is active.
- **Quick Play**: Located in `AudioCard`, it fetches details (the direct MP3 link) from Python *before* calling the player, allowing for one-tap playback from the home screen.
