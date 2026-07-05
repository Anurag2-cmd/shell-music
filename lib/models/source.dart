class Source {
  final String id;
  final String name;
  final String version;
  final String? description;
  final String? lang;
  final String? baseUrl;
  final bool isEnabled;

  const Source({
    required this.id,
    required this.name,
    required this.version,
    this.description,
    this.lang,
    this.baseUrl,
    this.isEnabled = true,
  });

  Source copyWith({bool? isEnabled}) {
    return Source(
      id: id,
      name: name,
      version: version,
      description: description,
      lang: lang,
      baseUrl: baseUrl,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'version': version,
        'description': description,
        'lang': lang,
        'base_url': baseUrl,
        'is_enabled': isEnabled,
      };

  factory Source.fromJson(Map<String, dynamic> json) => Source(
        id: json['id'] as String,
        name: json['name'] as String,
        version: json['version'] as String,
        description: json['description'] as String?,
        lang: json['lang'] as String?,
        baseUrl: json['base_url'] as String?,
        isEnabled: json['is_enabled'] as bool? ?? true,
      );
}
