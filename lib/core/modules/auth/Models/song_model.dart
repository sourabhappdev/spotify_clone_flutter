class SongModel {
  final String name, id, url, coverImage, duration;
  final List<String> artists;

  SongModel({
    required this.name,
    required this.id,
    required this.duration,
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
      duration: json['duration'],
      id: json['\$id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'url': url,
      'cover_image': coverImage,
      'artists': artists,
      'duration': duration,
      '\$id': duration,
    };
  }
}
