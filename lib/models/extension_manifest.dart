class ExtensionManifest {
  final String id;
  final String name;
  final String version;
  final String? description;
  final String? lang;
  final String? baseUrl;
  final String className;

  const ExtensionManifest({
    required this.id,
    required this.name,
    required this.version,
    this.description,
    this.lang,
    this.baseUrl,
    required this.className,
  });

  factory ExtensionManifest.fromJson(Map<String, dynamic> json) =>
      ExtensionManifest(
        id: (json['id'] ?? '').toString(),
        name: (json['name'] ?? 'Unknown').toString(),
        version: (json['version'] ?? '1.0.0').toString(),
        description: json['description']?.toString(),
        lang: json['lang']?.toString(),
        baseUrl: json['base_url']?.toString(),
        className: (json['class'] ?? '').toString(),
      );
}
