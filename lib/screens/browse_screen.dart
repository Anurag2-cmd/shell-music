import 'package:flutter/material.dart';
import '../models/source.dart';
import '../services/extension_manager.dart';
import '../services/python_bridge.dart';
import '../widgets/audio_card.dart';
import 'audio_detail_screen.dart';

class BrowseScreen extends StatefulWidget {
  const BrowseScreen({super.key});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen>
    with SingleTickerProviderStateMixin {
  final _extMgr = ExtensionManager();
  TabController? _tabController;
  List<Source> _sources = [];
  Map<String, List> _results = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await _extMgr.initialize();
    setState(() {
      _sources = _extMgr.sources;
      _tabController = TabController(
        length: _sources.length,
        vsync: this,
      );
      _loading = false;
    });
    if (_sources.isNotEmpty) {
      await _loadSource(0);
      _tabController?.addListener(() {
        if (!_tabController!.indexIsChanging) {
          _loadSource(_tabController!.index);
        }
      });
    }
  }

  Future<void> _loadSource(int index) async {
    if (index >= _sources.length) return;
    final src = _sources[index];
    if (_results.containsKey(src.id)) return;
    setState(() {});
    try {
      final items = await _extMgr.getPopular(sourceId: src.id);
      setState(() => _results[src.id] = items);
    } catch (e) {
      setState(() => _results[src.id] = []);
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (_sources.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Browse')),
        body: const Center(
          child: Text('No sources installed. Add extensions in Sources tab.'),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Browse'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: _sources.map((s) => Tab(text: s.name)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _sources.map((src) {
          final items = _results[src.id];
          if (items == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return RefreshIndicator(
            onRefresh: () async {
              _results.remove(src.id);
              await _loadSource(_sources.indexOf(src));
            },
            child: GridView.builder(
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
            ),
          );
        }).toList(),
      ),
    );
  }
}
