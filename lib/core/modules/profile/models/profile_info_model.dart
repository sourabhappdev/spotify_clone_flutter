import '../../auth/Models/song_model.dart';

class ProfileInfoModel {
  final String id, name, image, email;
  final List<SongModel> likedSong;

  ProfileInfoModel(
      {required this.id,
      required this.name,
      required this.email,
      required this.image,
      required this.likedSong});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'likedSong': likedSong,
      'email': email
    };
  }

  factory ProfileInfoModel.fromMap(Map<String, dynamic> map) {
    final List<SongModel> likedSongs = (map['liked_songs'] as List<dynamic>)
        .map((song) => SongModel.fromJson(song as Map<String, dynamic>))
        .toList();

    return ProfileInfoModel(
      id: map['id'] as String,
      email: map['email'] as String,
      name: map['name'] as String,
      image: map['image'] as String,
      likedSong: likedSongs,
    );
  }
}
