import 'package:flutter/material.dart';
import '../models/source.dart';
import '../services/extension_manager.dart';
import '../services/python_bridge.dart';

class ExtensionsScreen extends StatefulWidget {
  const ExtensionsScreen({super.key});

  @override
  State<ExtensionsScreen> createState() => _ExtensionsScreenState();
}

class _ExtensionsScreenState extends State<ExtensionsScreen> {
  final _extMgr = ExtensionManager();
  List<Source> _sources = [];
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
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sources'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              setState(() => _loading = true);
              await _init();
            },
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _sources.isEmpty
              ? const Center(
                  child: Text('No extensions installed.\nPlace .py files in python_extensions/'),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _sources.length,
                  itemBuilder: (ctx, i) {
                    final s = _sources[i];
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(s.name[0].toUpperCase()),
                        ),
                        title: Text(s.name),
                        subtitle: Text(
                          'v${s.version}${s.lang != null ? ' · ${s.lang}' : ''}${s.description != null ? '\n${s.description}' : ''}',
                        ),
                        trailing: Switch(
                          value: s.isEnabled,
                          onChanged: (v) {
                            setState(() {
                              _sources[i] = s.copyWith(isEnabled: v);
                            });
                          },
                        ),
                        isThreeLine: s.description != null,
                      ),
                    );
                  },
                ),
    );
  }
}
