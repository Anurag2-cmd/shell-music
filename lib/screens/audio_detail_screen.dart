import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/audio_entry.dart';
import '../services/extension_manager.dart';
import '../services/python_bridge.dart';
import '../services/favorites_service.dart';
import '../services/playback_service.dart';
import 'player_screen.dart';

class AudioDetailScreen extends StatefulWidget {
  final AudioEntry entry;
  const AudioDetailScreen({super.key, required this.entry});

  @override
  State<AudioDetailScreen> createState() => _AudioDetailScreenState();
}

class _AudioDetailScreenState extends State<AudioDetailScreen> {
  final _extMgr = ExtensionManager();
  final _favService = FavoritesService();
  AudioEntry? _details;
  bool _loading = true;
  List<Map<String, dynamic>> _downloadUrls = [];

  @override
  void initState() {
    super.initState();
    _loadDetails();
  }

  Future<void> _loadDetails() async {
    try {
      final details = await _extMgr.getAudioDetails(
        sourceId: widget.entry.sourceId,
        url: widget.entry.url,
      );
      final urls = await _extMgr.getDownloadUrls(
        sourceId: widget.entry.sourceId,
        url: widget.entry.url,
      );
      setState(() {
        _details = details;
        _downloadUrls = urls;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final e = _details ?? widget.entry;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(e.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: [
          ValueListenableBuilder<Box<AudioEntry>>(
            valueListenable: _favService.listenable,
            builder: (context, box, _) {
              final isFav = _favService.isFavorite(e.id);
              return IconButton(
                icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
                color: isFav ? Colors.red : null,
                onPressed: () => _favService.toggleFavorite(e),
              );
            },
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      e.coverUrl ?? '',
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 200,
                        height: 200,
                        color: theme.colorScheme.surfaceContainerHighest,
                        child: const Icon(Icons.music_note, size: 64),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(e.title, style: theme.textTheme.headlineSmall),
                if (e.artist != null) ...[
                  const SizedBox(height: 4),
                  Text(e.artist!, style: theme.textTheme.titleMedium),
                ],
                if (e.duration != null) ...[
                  const SizedBox(height: 4),
                  Text('Duration: ${e.duration}', style: theme.textTheme.bodyMedium),
                ],
                if (e.description != null) ...[
                  const SizedBox(height: 12),
                  Text(e.description!, style: theme.textTheme.bodyLarge),
                ],
                if (e.tags.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: e.tags
                        .map((t) => Chip(
                              label: Text(t, style: const TextStyle(fontSize: 12)),
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ))
                        .toList(),
                  ),
                ],
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: () {
                    PlaybackService().play(e);
                  },
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Play'),
                ),
                const SizedBox(height: 12),
                if (_downloadUrls.isNotEmpty) ...[
                  Text('Downloads', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  ..._downloadUrls.map(
                    (d) => Card(
                      child: ListTile(
                        title: Text('${d['quality']} · ${d['format']}'),
                        subtitle: d['size'] != null
                            ? Text(_formatSize(d['size'] as int))
                            : null,
                        trailing: const Icon(Icons.download),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Downloading ${d['quality']}...'),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ],
            ),
    );
  }

  String _formatSize(int bytes) {
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
