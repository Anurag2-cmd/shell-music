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
      title: 'ASMR App',
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
      body: Column(
        children: [
          Expanded(child: _screens[_currentIndex]),
          const MiniPlayer(),
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
