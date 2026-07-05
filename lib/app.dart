import 'package:flutter/material.dart';
import 'screens/browse_screen.dart';
import 'screens/library_screen.dart';
import 'screens/extensions_screen.dart';
import 'screens/downloads_screen.dart';
import 'screens/search_screen.dart';
import 'screens/favorites_screen.dart';
import 'widgets/mini_player.dart';

class AsmrApp extends StatelessWidget {
  const AsmrApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shell Music Player',
      theme: ThemeData(
        colorSchemeSeed: Colors.deepPurple,
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: const MainShell(),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final _screens = const [
    BrowseScreen(),
    SearchScreen(),
    FavoritesScreen(),
    LibraryScreen(),
    DownloadsScreen(),
    ExtensionsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // We use a Stack here so the MiniPlayer floats above the navigation bar
      // and doesn't get covered by the bottom navigation bar or sub-screens.
      body: Stack(
        children: [
          _screens[_currentIndex],
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: MiniPlayer(),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.explore), label: 'Browse'),
          NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
          NavigationDestination(icon: Icon(Icons.favorite), label: 'Favorites'),
          NavigationDestination(icon: Icon(Icons.library_music), label: 'Library'),
          NavigationDestination(icon: Icon(Icons.download), label: 'Downloads'),
          NavigationDestination(icon: Icon(Icons.extension), label: 'Sources'),
        ],
      ),
    );
  }
}
