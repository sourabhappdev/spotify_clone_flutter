import 'package:appwrite/appwrite.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:spotify_clone/common/services/app_state.dart';
import 'package:spotify_clone/common/services/appwrite_service.dart';
import 'package:spotify_clone/core/modules/profile/models/profile_info_model.dart';

part 'search_friend_state.dart';

class SearchFriendCubit extends Cubit<SearchFriendState> {
  SearchFriendCubit() : super(SearchFriendInitial());

  Future<void> searchFriends(String query) async {
    try {
      emit(SearchFriendLoading());
      final response = await AppWriteService.databases.listDocuments(
        databaseId: dotenv.env['DB'] ?? '',
        collectionId: dotenv.env['USERS'] ?? '',
        queries: [
          Query.search('name', query),
        ],
      );
      final profiles = response.documents
          .map((doc) => ProfileInfoModel.fromMap(doc.data))
          .toList();

      profiles.removeWhere((element) => element.id == AppState.instance.userId);

      emit(SearchFriendLoaded(profiles));
    } catch (e) {
      emit(SearchFriendInitial());
    }
  }
}
