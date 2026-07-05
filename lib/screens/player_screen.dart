import 'package:flutter/material.dart';
import '../services/playback_service.dart';

class PlayerScreen extends StatelessWidget {
  final String url;
  final String title;
  
  const PlayerScreen({
    super.key,
    required this.url,
    required this.title,
  });

  String _fmt(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final service = PlaybackService();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
      body: StreamBuilder(
        stream: service.currentEntryStream,
        builder: (context, entrySnapshot) {
          final entry = entrySnapshot.data;
          
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (entry?.coverUrl != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      entry!.coverUrl!,
                      width: 240,
                      height: 240,
                      fit: BoxFit.cover,
                    ),
                  )
                else
                  Icon(Icons.music_note, size: 120, color: theme.colorScheme.primary),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    title,
                    style: theme.textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 32),
                StreamBuilder<Duration>(
                  stream: service.player.positionStream,
                  builder: (context, posSnap) {
                    final pos = posSnap.data ?? Duration.zero;
                    return StreamBuilder<Duration?>(
                      stream: service.player.durationStream,
                      builder: (context, durSnap) {
                        final dur = durSnap.data ?? Duration.zero;
                        return Column(
                          children: [
                            Text('${_fmt(pos)} / ${_fmt(dur)}'),
                            const SizedBox(height: 8),
                            Slider(
                              value: dur.inMilliseconds > 0
                                  ? (pos.inMilliseconds / dur.inMilliseconds)
                                      .clamp(0.0, 1.0)
                                  : 0,
                              onChanged: (v) {
                                final seekPos = Duration(
                                    milliseconds:
                                        (v * dur.inMilliseconds).round());
                                service.player.seek(seekPos);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.skip_previous, size: 40),
                      onPressed: () => service.player.seek(Duration.zero),
                    ),
                    const SizedBox(width: 16),
                    StreamBuilder<bool>(
                      stream: service.player.playingStream,
                      builder: (context, playSnap) {
                        final playing = playSnap.data ?? false;
                        return IconButton(
                          icon: Icon(
                            playing ? Icons.pause_circle : Icons.play_circle,
                            size: 64,
                          ),
                          onPressed: service.togglePlay,
                        );
                      },
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      icon: const Icon(Icons.skip_next, size: 40),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
