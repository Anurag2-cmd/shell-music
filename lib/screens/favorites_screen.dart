import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/audio_entry.dart';
import '../services/favorites_service.dart';
import '../widgets/audio_card.dart';
import 'audio_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: ValueListenableBuilder<Box<MediaEntry>>(
        valueListenable: FavoritesService().listenable,
        builder: (context, box, _) {
          final items = box.values.toList();
          
          if (items.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No favorites yet', style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }
          
          return GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: items.length,
            itemBuilder: (ctx, i) => AudioCard(
              entry: items[i],
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AudioDetailScreen(entry: items[i]),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
