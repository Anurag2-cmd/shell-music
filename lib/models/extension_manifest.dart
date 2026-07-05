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
        id: json['id'] as String,
        name: json['name'] as String,
        version: json['version'] as String,
        description: json['description'] as String?,
        lang: json['lang'] as String?,
        baseUrl: json['base_url'] as String?,
        className: json['class'] as String,
      );
}
