import 'package:appwrite/appwrite.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../../../common/services/app_state.dart';
import '../../../../../common/services/appwrite_service.dart';
import '../../../profile/models/profile_info_model.dart';

part 'my_friends_state.dart';

class MyFriendsCubit extends Cubit<MyFriendsState> {
  MyFriendsCubit() : super(MyFriendsInitial());

  Future<void> fetchConfirmedFriends() async {
    emit(MyFriendsLoading());

    final db = AppWriteService.databases;
    final dbId = dotenv.env['DB']!;
    final collectionId = dotenv.env['FRIENDS']!;
    final userId = AppState.instance.userId;

    try {
      final response = await db.listDocuments(
        databaseId: dbId,
        collectionId: collectionId,
        queries: [Query.equal('user_id', userId)],
      );

      if (response.documents.isEmpty) {
        emit(const MyFriendsLoaded([]));
        return;
      }

      final doc = response.documents.first;
      final friendsData = doc.data['friends'] as List<dynamic>? ?? [];

      final friends =
          friendsData.map((data) => ProfileInfoModel.fromMap(data)).toList();

      emit(MyFriendsLoaded(friends));
    } on AppwriteException catch (e) {
      emit(MyFriendsError(e.message ?? 'Appwrite error'));
    } catch (_) {
      emit(const MyFriendsError('Failed to fetch friends'));
    }
  }
}
