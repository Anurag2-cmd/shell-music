import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../models/source.dart';
import '../services/extension_manager.dart';

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
    if (mounted) {
      setState(() {
        _sources = _extMgr.sources;
        _loading = false;
      });
    }
  }

  Future<void> _installNewExtension() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['py'],
      );

      if (result != null && result.files.single.path != null) {
        setState(() => _loading = true);
        final file = File(result.files.single.path!);
        await _extMgr.installExtension(file);
        await _init();
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Extension installed successfully!')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to install: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
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
                  child: Text(
                    'No extensions installed.\nTap "+" to add a .py file.',
                    textAlign: TextAlign.center,
                  ),
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
                        trailing: IconButton(
                          icon: const Icon(Icons.info_outline),
                          onPressed: () {
                            // Show details or settings
                          },
                        ),
                        isThreeLine: s.description != null,
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _installNewExtension,
        child: const Icon(Icons.add),
      ),
    );
  }
}
