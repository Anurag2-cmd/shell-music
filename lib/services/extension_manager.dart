import 'dart:convert';
import '../models/source.dart';
import '../models/audio_entry.dart';
import '../models/extension_manifest.dart';
import 'python_bridge.dart';

class ExtensionManager {
  static final ExtensionManager _instance = ExtensionManager._(PythonBridge());
  factory ExtensionManager() => _instance;
  
  final PythonBridge _bridge;

  List<Source> _sources = [];
  bool _initialized = false;

  ExtensionManager._(this._bridge);

  Future<void> initialize() async {
    if (_initialized) return;
    await _bridge.initialize();
    await _loadSources();
    _initialized = true;
  }

  List<Source> get sources => List.unmodifiable(_sources);

  Source? getSource(String id) {
    try {
      return _sources.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> _loadSources() async {
    final manifests = await _bridge.getInstalledExtensions();
    _sources = manifests.map((m) {
      final manifest = ExtensionManifest.fromJson(m);
      return Source(
        id: manifest.id,
        name: manifest.name,
        version: manifest.version,
        description: manifest.description,
        lang: manifest.lang,
        baseUrl: manifest.baseUrl,
      );
    }).toList();
  }

  Future<List<AudioEntry>> search({
    required String sourceId,
    required String query,
    int page = 1,
  }) async {
    final results = await _bridge.search(
      sourceId: sourceId,
      query: query,
      page: page,
    );
    return results.map((r) => AudioEntry.fromJson(r)).toList();
  }

  Future<List<AudioEntry>> getPopular({
    required String sourceId,
    int page = 1,
  }) async {
    final results =
        await _bridge.getPopular(sourceId: sourceId, page: page);
    return results.map((r) => AudioEntry.fromJson(r)).toList();
  }

  Future<List<AudioEntry>> getLatest({
    required String sourceId,
    int page = 1,
  }) async {
    final results =
        await _bridge.getLatest(sourceId: sourceId, page: page);
    return results.map((r) => AudioEntry.fromJson(r)).toList();
  }

  Future<AudioEntry> getAudioDetails({
    required String sourceId,
    required String url,
  }) async {
    final result = await _bridge.getAudioDetails(
      sourceId: sourceId,
      url: url,
    );
    return AudioEntry.fromJson(result);
  }

  Future<List<Map<String, dynamic>>> getDownloadUrls({
    required String sourceId,
    required String url,
  }) async {
    return await _bridge.getDownloadUrls(
      sourceId: sourceId,
      url: url,
    );
  }
}
