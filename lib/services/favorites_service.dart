import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/audio_entry.dart';

class FavoritesService {
  static const String boxName = 'favorites';
  late Box<MediaEntry> _box;

  static final FavoritesService _instance = FavoritesService._();
  factory FavoritesService() => _instance;
  FavoritesService._();

  Future<void> initialize() async {
    _box = await Hive.openBox<MediaEntry>(boxName);
  }

  ValueListenable<Box<MediaEntry>> get listenable => _box.listenable();

  List<MediaEntry> get favorites => _box.values.toList();

  bool isFavorite(String id) => _box.containsKey(id);

  Future<void> toggleFavorite(MediaEntry entry) async {
    if (isFavorite(entry.id)) {
      await _box.delete(entry.id);
    } else {
      await _box.put(entry.id, entry);
    }
  }

  Future<void> removeFavorite(String id) async {
    await _box.delete(id);
  }
}
