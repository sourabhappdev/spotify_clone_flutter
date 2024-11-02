class SongModel {
  final String name;
  final String url;
  final String coverImage;
  final List<String> artists;

  SongModel({
    required this.name,
    required this.url,
    required this.coverImage,
    this.artists = const [],
  });

  factory SongModel.fromJson(Map<String, dynamic> json) {
    return SongModel(
      name: json['name'],
      url: json['url'],
      coverImage: json['cover_image'],
      artists: List<String>.from(json['artists'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'url': url,
      'cover_image': coverImage,
      'artists': artists,
    };
  }
}
