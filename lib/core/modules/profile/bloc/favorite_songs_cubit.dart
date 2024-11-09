import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:spotify_clone/common/services/app_state.dart';
import 'package:spotify_clone/core/configs/constants/string_res.dart';
import 'package:spotify_clone/core/configs/manager/storage_manager.dart';

import '../../../../common/services/appwrite_service.dart';
import '../../auth/Models/song_model.dart';

part 'favorite_songs_state.dart';

class FavoriteSongsCubit extends Cubit<FavoriteSongsState> {
  FavoriteSongsCubit() : super(FavoriteSongsInitial());

  Future<void> addSongToFavorites(
      {required String userId, required String songId}) async {
    try {
      emit(AddToFavoriteSongsLoading());
      if (!AppState.instance.likedSongs.contains(songId)) {
        AppState.instance.likedSongs.add(songId);
        await StorageManager.instance.addToList(StringRes.likedSongs, songId);

        await AppWriteService.databases.updateDocument(
          databaseId: dotenv.env['DB'] ?? '',
          collectionId: dotenv.env['USERS'] ?? '',
          documentId: userId,
          data: {'liked_songs': AppState.instance.likedSongs},
        );

        emit(const AddToFavoriteSongsSuccess(message: ""));
      }
    } on AppwriteException catch (e) {
      emit(AddToFavoriteSongsFailure(
          error: e.message ?? 'An unknown error occurred'));
    } catch (e) {
      emit(const AddToFavoriteSongsFailure(error: 'Something went wrong'));
    }
  }

  Future<void> removeSongFromFavorites(
      {required String userId, required String songId}) async {
    try {
      emit(RemoveFavoriteSongsLoading());
      AppState.instance.likedSongs.removeWhere(
        (element) => element == songId,
      );
      await StorageManager.instance
          .removeFromList(StringRes.likedSongs, songId);

      print(AppState.instance.likedSongs);

      await AppWriteService.databases.updateDocument(
        databaseId: dotenv.env['DB'] ?? '',
        collectionId: dotenv.env['USERS'] ?? '',
        documentId: AppState.instance.userId,
        data: {'liked_songs': AppState.instance.likedSongs},
      );

      emit(const RemoveFavoriteSongsSuccess(message: "Removed from favorite"));
    } catch (e) {
      emit(RemoveFavoriteSongsFailure(
          error: "Failed to remove song from favorites: $e"));
    }
  }

  Future<void> setLikedSongs() async {
    try {
      emit(SetLikedSongsLoading());
      final Document userDoc = await AppWriteService.databases.getDocument(
          databaseId: dotenv.env['DB'] ?? '',
          collectionId: dotenv.env['USERS'] ?? '',
          documentId: AppState.instance.userId);

      final List<String> likedSongs = (userDoc.data['liked_songs']
              as List<dynamic>)
          .map((song) => SongModel.fromJson(song as Map<String, dynamic>).id)
          .toList();
      AppState.instance.setLikedSongs = likedSongs;
      await StorageManager.instance.saveList(StringRes.likedSongs, likedSongs);
      emit(SetLikedSongsSuccess());
    } catch (e) {
      emit(SetLikedSongsFailure(error: e.toString()));
    }
  }
}
