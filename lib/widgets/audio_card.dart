import 'package:flutter/material.dart';
import '../models/audio_entry.dart';
import '../services/extension_manager.dart';
import '../services/playback_service.dart';

class AudioCard extends StatefulWidget {
  final MediaEntry entry;
  final VoidCallback? onTap;

  const AudioCard({
    super.key,
    required this.entry,
    this.onTap,
  });

  @override
  State<AudioCard> createState() => _AudioCardState();
}

class _AudioCardState extends State<AudioCard> {
  bool _isLoading = false;

  Future<void> _playDirectly(BuildContext context) async {
    setState(() => _isLoading = true);
    try {
      final extMgr = ExtensionManager();
      final details = await extMgr.getAudioDetails(
        sourceId: widget.entry.sourceId,
        url: widget.entry.url,
      );
      await PlaybackService().play(details);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to play: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: widget.onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    widget.entry.coverUrl ?? '',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: theme.colorScheme.surfaceContainerHighest,
                      child: const Icon(Icons.music_note, size: 48),
                    ),
                  ),
                  if (widget.entry.duration != null)
                    Positioned(
                      bottom: 4,
                      left: 4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          widget.entry.duration!,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 11),
                        ),
                      ),
                    ),
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: Material(
                      color: theme.colorScheme.primaryContainer.withOpacity(0.9),
                      shape: const CircleBorder(),
                      child: IconButton(
                        iconSize: 20,
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.all(8),
                        icon: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Icon(
                                Icons.play_arrow,
                                color: theme.colorScheme.onPrimaryContainer,
                              ),
                        onPressed: () => _playDirectly(context),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.entry.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  if (widget.entry.artist != null)
                    Text(
                      widget.entry.artist!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall
                          ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
