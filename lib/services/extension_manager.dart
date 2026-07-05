import 'dart:io';
import 'package:path/path.dart' as p;
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
  String? _userExtDir;

  ExtensionManager._(this._bridge);

  Future<void> initialize() async {
    if (_initialized) return;
    final userDir = await _bridge.initialize();
    if (userDir is String) {
      _userExtDir = userDir;
    }
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

  Future<void> installExtension(File file) async {
    if (_userExtDir == null) throw Exception('Extension directory not initialized');
    
    final destination = p.join(_userExtDir!, p.basename(file.path));
    await file.copy(destination);
    
    // Force reload sources
    await _loadSources();
  }

  Future<List<MediaEntry>> search({
    required String sourceId,
    required String query,
    int page = 1,
  }) async {
    final results = await _bridge.search(
      sourceId: sourceId,
      query: query,
      page: page,
    );
    return results.map((r) => MediaEntry.fromJson(r)).toList();
  }

  Future<List<MediaEntry>> getPopular({
    required String sourceId,
    int page = 1,
  }) async {
    final results =
        await _bridge.getPopular(sourceId: sourceId, page: page);
    return results.map((r) => MediaEntry.fromJson(r)).toList();
  }

  Future<List<MediaEntry>> getLatest({
    required String sourceId,
    int page = 1,
  }) async {
    final results =
        await _bridge.getLatest(sourceId: sourceId, page: page);
    return results.map((r) => MediaEntry.fromJson(r)).toList();
  }

  Future<MediaEntry> getAudioDetails({
    required String sourceId,
    required String url,
  }) async {
    final result = await _bridge.getAudioDetails(
      sourceId: sourceId,
      url: url,
    );
    return MediaEntry.fromJson(result);
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
