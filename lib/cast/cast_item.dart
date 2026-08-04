enum CastItemKind { photo, video, networkMedia }

class CastItem {
  const CastItem({
    required this.kind,
    required this.source,
    required this.title,
  });

  final CastItemKind kind;
  final String source;
  final String title;

  bool get isPhoto => kind == CastItemKind.photo;
  bool get isPlayable =>
      kind == CastItemKind.video || kind == CastItemKind.networkMedia;

  Map<String, String> toJson() => {
        'kind': kind.name,
        'source': source,
        'title': title,
      };

  factory CastItem.fromJson(Map<String, dynamic> json) {
    return CastItem(
      kind: CastItemKind.values.firstWhere(
        (e) => e.name == json['kind'],
        orElse: () => CastItemKind.photo,
      ),
      source: json['source'] as String? ?? '',
      title: json['title'] as String? ?? 'Media',
    );
  }
}
