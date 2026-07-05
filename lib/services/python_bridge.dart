import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/audio_entry.dart';

class PythonBridge {
  static const _channel = MethodChannel('com.shell.musicplayer/python');

  static final PythonBridge _instance = PythonBridge._();
  factory PythonBridge() => _instance;
  PythonBridge._();

  bool _initialized = false;
  bool _pythonAvailable = false;

  Future<void> initialize() async {
    if (_initialized) return;
    try {
      await _channel.invokeMethod('initialize');
      _pythonAvailable = true;
    } catch (_) {
      _pythonAvailable = false;
    }
    _initialized = true;
  }

  bool get isAvailable => _pythonAvailable;

  Future<List<Map<String, dynamic>>> _call(
      String method, Map<String, dynamic> args) async {
    if (!_pythonAvailable) throw UnsupportedError('Python not available');
    final result = await _channel.invokeMethod(method, args);
    return (result as List<dynamic>).cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> _callMap(
      String method, Map<String, dynamic> args) async {
    if (!_pythonAvailable) throw UnsupportedError('Python not available');
    final result = await _channel.invokeMethod(method, args);
    return result as Map<String, dynamic>;
  }

  Future<List<Map<String, dynamic>>> getInstalledExtensions() async {
    if (!_pythonAvailable) {
      return [
        {
          'id': 'mock_source',
          'name': 'Mock ASMR',
          'version': '1.0.0',
          'description': 'Built-in mock source for testing',
          'lang': 'en',
          'base_url': '',
          'class': 'MockSource',
        }
      ];
    }
    final result = await _channel.invokeMethod('get_installed_extensions');
    return (result as List<dynamic>).cast<Map<String, dynamic>>();
  }

  Future<List<Map<String, dynamic>>> search({
    required String sourceId,
    required String query,
    int page = 1,
  }) async {
    if (!_pythonAvailable) {
      return _mockResults('Search: $query', page);
    }
    return await _call('search', {
      'source_id': sourceId,
      'query': query,
      'page': page,
    });
  }

  Future<List<Map<String, dynamic>>> getPopular({
    required String sourceId,
    int page = 1,
  }) async {
    if (!_pythonAvailable) {
      return _mockResults('Popular', page);
    }
    return await _call('get_popular', {
      'source_id': sourceId,
      'page': page,
    });
  }

  Future<List<Map<String, dynamic>>> getLatest({
    required String sourceId,
    int page = 1,
  }) async {
    if (!_pythonAvailable) {
      return _mockResults('Latest', page);
    }
    return await _call('get_latest', {
      'source_id': sourceId,
      'page': page,
    });
  }

  Future<Map<String, dynamic>> getAudioDetails({
    required String sourceId,
    required String url,
  }) async {
    if (!_pythonAvailable) {
      return _mockDetail(url);
    }
    return await _callMap('get_audio_details', {
      'source_id': sourceId,
      'url': url,
    });
  }

  Future<List<Map<String, dynamic>>> getDownloadUrls({
    required String sourceId,
    required String url,
  }) async {
    if (!_pythonAvailable) {
      return _mockDownloadUrls();
    }
    return await _call('get_download_urls', {
      'source_id': sourceId,
      'url': url,
    });
  }

  List<Map<String, dynamic>> _mockResults(String prefix, int page) {
    return List.generate(20, (i) {
      final n = page * 20 + i;
      return {
        'id': 'mock_${n}_${DateTime.now().millisecondsSinceEpoch}',
        'title': '$prefix #$n',
        'source_id': 'mock_source',
        'url': 'https://mock-asmr.com/audio/$n',
        'cover_url': 'https://picsum.photos/seed/mock$n/300/300',
        'artist': 'Mock Artist ${i % 5 + 1}',
        'tags': ['mock', 'asmr'],
        'duration': '${15 + (i % 30)}:00',
        'language': 'en',
      };
    });
  }

  Map<String, dynamic> _mockDetail(String url) {
    return {
      'id': 'mock_detail',
      'title': 'Mock ASMR Audio Title',
      'source_id': 'mock_source',
      'url': url,
      'cover_url': 'https://picsum.photos/seed/mockdetail/400/400',
      'artist': 'Mock Artist',
      'tags': ['mock', 'asmr', 'whisper', 'relaxation'],
      'duration': '45:00',
      'description':
          'A relaxing ASMR experience generated for testing purposes.',
      'file_size': 52428800,
      'audio_url':
          'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
      'language': 'en',
    };
  }

  List<Map<String, dynamic>> _mockDownloadUrls() {
    return [
      {
        'url': 'https://example.com/download/320kbps.mp3',
        'quality': '320kbps',
        'format': 'mp3',
        'size': 52428800,
      },
      {
        'url': 'https://example.com/download/128kbps.mp3',
        'quality': '128kbps',
        'format': 'mp3',
        'size': 20971520,
      },
    ];
  }
}
