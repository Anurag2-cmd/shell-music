import 'package:flutter/material.dart';
import '../models/source.dart';
import '../services/extension_manager.dart';
import '../services/python_bridge.dart';
import '../widgets/audio_card.dart';
import 'audio_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _extMgr = ExtensionManager();
  final _searchCtl = TextEditingController();
  List<Source> _sources = [];
  List _results = [];
  bool _loading = false;
  bool _initialized = false;
  Source? _selectedSource;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await _extMgr.initialize();
    setState(() {
      _sources = _extMgr.sources;
      if (_sources.isNotEmpty) _selectedSource = _sources.first;
      _initialized = true;
    });
  }

  Future<void> _search() async {
    final q = _searchCtl.text.trim();
    if (q.isEmpty || _selectedSource == null) return;
    setState(() => _loading = true);
    try {
      final r = await _extMgr.search(
        sourceId: _selectedSource!.id,
        query: q,
      );
      setState(() {
        _results = r;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _results = [];
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _searchCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchCtl,
                    decoration: const InputDecoration(
                      hintText: 'Search ASMR...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _search(),
                  ),
                ),
                const SizedBox(width: 8),
                DropdownButton<Source>(
                  value: _selectedSource,
                  items: _sources
                      .map(
                        (s) => DropdownMenuItem(
                          value: s,
                          child: Text(s.name),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => setState(() => _selectedSource = v),
                ),
              ],
            ),
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _results.isEmpty
                    ? const Center(child: Text('Enter a query to search'))
                    : GridView.builder(
                        padding: const EdgeInsets.all(8),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.7,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemCount: _results.length,
                        itemBuilder: (ctx, i) => AudioCard(
                          entry: _results[i],
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  AudioDetailScreen(entry: _results[i]),
                            ),
                          ),
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
