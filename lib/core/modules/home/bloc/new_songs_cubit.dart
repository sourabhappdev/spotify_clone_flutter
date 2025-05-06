import 'package:appwrite/appwrite.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:spotify_clone/core/modules/auth/Models/song_model.dart';

import '../../../../common/services/appwrite_service.dart';
import 'new_songs_state.dart';

class NewSongsCubit extends Cubit<NewSongsState> {
  NewSongsCubit() : super(NewSongsInitial());

  void getNewsSongs() async {
    try {
      emit(NewSongsLoading());
      final response = await AppWriteService.databases.listDocuments(
        databaseId: dotenv.env['DB'] ?? '',
        collectionId: dotenv.env['SONGS'] ?? '',
      );
      final List<SongModel> songs = response.documents
          .map((doc) => SongModel.fromJson(doc.data))
          .toList();

      emit(NewSongsSuccess(songs));
    } on AppwriteException catch (e) {
      emit(NewSongsFailure(e.message ?? 'An unknown error occurred'));
    } catch (e) {
      emit(const NewSongsFailure('Something went wrong'));
    }
  }
}
