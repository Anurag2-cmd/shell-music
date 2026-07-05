import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import '../models/audio_entry.dart';

class PlaybackService {
  static final PlaybackService _instance = PlaybackService._();
  factory PlaybackService() => _instance;
  PlaybackService._();

  final AudioPlayer _player = AudioPlayer();
  final _currentEntrySubject = BehaviorSubject<MediaEntry?>();

  AudioPlayer get player => _player;
  Stream<MediaEntry?> get currentEntryStream => _currentEntrySubject.stream;
  MediaEntry? get currentEntry => _currentEntrySubject.valueOrNull;

  Future<void> play(MediaEntry entry) async {
    // If it's already playing this exact entry, just return
    if (entry.id == currentEntry?.id && _player.playing) return;

    final url = entry.audioUrl ?? entry.url;
    if (url.isEmpty) return;

    try {
      // Clear current state and stop before loading new source
      _currentEntrySubject.add(entry);
      
      // Using try-catch around setAudioSource specifically to catch load errors
      try {
        await _player.stop();
        await _player.setAudioSource(
          AudioSource.uri(Uri.parse(url)),
          preload: true,
        );
        await _player.play();
      } catch (loadError) {
        print('Error loading audio source: $loadError');
        _currentEntrySubject.add(null);
        rethrow;
      }
    } catch (e) {
      print('Error in PlaybackService.play: $e');
    }
  }

  Future<void> pause() async {
    await _player.pause();
  }

  Future<void> togglePlay() async {
    if (_player.playing) {
      await _player.pause();
    } else {
      await _player.play();
    }
  }

  Future<void> stop() async {
    await _player.stop();
    _currentEntrySubject.add(null);
  }
  
  void dispose() {
    _player.dispose();
    _currentEntrySubject.close();
  }
}
