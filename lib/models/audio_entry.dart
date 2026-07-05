import 'package:hive/hive.dart';

part 'audio_entry.g.dart';

@HiveType(typeId: 0)
class AudioEntry extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String sourceId;
  @HiveField(3)
  final String url;
  @HiveField(4)
  final String? coverUrl;
  @HiveField(5)
  final String? artist;
  @HiveField(6)
  final List<String> tags;
  @HiveField(7)
  final String? duration;
  @HiveField(8)
  final String? description;
  @HiveField(9)
  final int? fileSize;
  @HiveField(10)
  final String? audioUrl;
  @HiveField(11)
  final String? language;
  @HiveField(12)
  final bool isDownloaded;
  @HiveField(13)
  final DateTime? dateAdded;

  AudioEntry({
    required this.id,
    required this.title,
    required this.sourceId,
    required this.url,
    this.coverUrl,
    this.artist,
    this.tags = const [],
    this.duration,
    this.description,
    this.fileSize,
    this.audioUrl,
    this.language,
    this.isDownloaded = false,
    this.dateAdded,
  });

  AudioEntry copyWith({
    String? id,
    String? title,
    String? sourceId,
    String? url,
    String? coverUrl,
    String? artist,
    List<String>? tags,
    String? duration,
    String? description,
    int? fileSize,
    String? audioUrl,
    String? language,
    bool? isDownloaded,
    DateTime? dateAdded,
  }) {
    return AudioEntry(
      id: id ?? this.id,
      title: title ?? this.title,
      sourceId: sourceId ?? this.sourceId,
      url: url ?? this.url,
      coverUrl: coverUrl ?? this.coverUrl,
      artist: artist ?? this.artist,
      tags: tags ?? this.tags,
      duration: duration ?? this.duration,
      description: description ?? this.description,
      fileSize: fileSize ?? this.fileSize,
      audioUrl: audioUrl ?? this.audioUrl,
      language: language ?? this.language,
      isDownloaded: isDownloaded ?? this.isDownloaded,
      dateAdded: dateAdded ?? this.dateAdded,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'source_id': sourceId,
        'url': url,
        'cover_url': coverUrl,
        'artist': artist,
        'tags': tags,
        'duration': duration,
        'description': description,
        'file_size': fileSize,
        'audio_url': audioUrl,
        'language': language,
        'is_downloaded': isDownloaded,
        'date_added': dateAdded?.toIso8601String(),
      };

  factory AudioEntry.fromJson(Map<String, dynamic> json) => AudioEntry(
        id: json['id'] as String,
        title: json['title'] as String,
        sourceId: json['source_id'] as String,
        url: json['url'] as String,
        coverUrl: json['cover_url'] as String?,
        artist: json['artist'] as String?,
        tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
        duration: json['duration'] as String?,
        description: json['description'] as String?,
        fileSize: json['file_size'] as int?,
        audioUrl: json['audio_url'] as String?,
        language: json['language'] as String?,
        isDownloaded: json['is_downloaded'] as bool? ?? false,
        dateAdded: json['date_added'] != null
            ? DateTime.parse(json['date_added'] as String)
            : null,
      );
}
