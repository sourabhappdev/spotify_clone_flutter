import 'package:appwrite/appwrite.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:spotify_clone/core/modules/auth/Models/song_model.dart';

import '../../../../common/services/appwrite_service.dart';
import 'new_songs_state.dart';

class NewSongsCubit extends HydratedCubit<NewSongsState> {
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
      print(songs);

      emit(NewSongsSuccess(songs));
    } on AppwriteException catch (e) {
      emit(NewSongsFailure(e.message ?? 'An unknown error occurred'));
    } catch (e) {
      emit(const NewSongsFailure('Something went wrong'));
    }
  }

  @override
  NewSongsState? fromJson(Map<String, dynamic> json) {
    final state = json['state'] as String?;

    switch (state) {
      case 'NewSongsInitial':
        return NewSongsInitial();
      case 'NewSongsLoading':
        return NewSongsLoading();
      case 'NewSongsSuccess':
        return NewSongsSuccess(json['songs']);
      case 'NewSongsFailure':
        final error = json['error'] as String?;
        return NewSongsFailure(error ?? 'Unknown error');
      default:
        return NewSongsInitial();
    }
  }

  @override
  Map<String, dynamic>? toJson(NewSongsState state) {
    if (state is NewSongsInitial) {
      return {'state': 'NewSongsInitial'};
    } else if (state is NewSongsLoading) {
      return {'state': 'NewSongsLoading'};
    } else if (state is NewSongsSuccess) {
      return {'state': 'NewSongsSuccess', 'songs': state.songs};
    } else if (state is NewSongsFailure) {
      return {
        'state': 'NewSongsFailure',
        'error': state.error,
      };
    }
    return null;
  }
}
