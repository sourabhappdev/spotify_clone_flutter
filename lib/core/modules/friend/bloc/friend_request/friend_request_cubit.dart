import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:appwrite/appwrite.dart';
import 'package:spotify_clone/common/services/app_state.dart';
import 'package:spotify_clone/common/services/appwrite_service.dart';

import '../../model/friend_request_model.dart';

part 'friend_request_state.dart';

enum RequestStatus { confirmed, rejected }

class FriendRequestsCubit extends Cubit<FriendRequestsState> {
  FriendRequestsCubit() : super(FriendRequestsInitial());

  Future<void> fetchRequests() async {
    emit(FriendRequestsLoading());
    try {
      final response = await AppWriteService.databases.listDocuments(
        databaseId: dotenv.env['DB'] ?? '',
        collectionId: dotenv.env['FRIEND_REQUEST'] ?? '',
        queries: [
          Query.equal('receiver_id', AppState.instance.userId),
          Query.equal('status', 'pending'),
        ],
      );

      final requests = <FriendRequest>[];

      for (var doc in response.documents) {
        requests.add(FriendRequest.fromMap(doc.data, doc.$id));
      }

      emit(FriendRequestsLoaded(requests));
    } catch (e) {
      emit(const FriendRequestsError('Failed to fetch requests'));
    }
  }

  Future<void> respondToRequest(
      String docId, RequestStatus status, String receiverId) async {
    try {
      await AppWriteService.databases.updateDocument(
        databaseId: dotenv.env['DB'] ?? '',
        collectionId: dotenv.env['FRIEND_REQUEST'] ?? '',
        documentId: docId,
        data: {'status': status.name},
      );
      fetchRequests();
      if (status == RequestStatus.confirmed) {
        addFriendToUser(AppState.instance.userId, receiverId);
      }
    } catch (e) {
      emit(const FriendRequestsError('Failed to update request'));
    }
  }

  Future<void> addFriend(String forUser, String friend) async {
    final database = AppWriteService.databases;
    final dbId = dotenv.env['DB']!;
    final userFriendsCollection = dotenv.env['FRIENDS']!;
    final response = await database.listDocuments(
      databaseId: dbId,
      collectionId: userFriendsCollection,
      queries: [Query.equal('user_id', forUser)],
    );

    if (response.documents.isEmpty) {
      await database.createDocument(
        databaseId: dbId,
        collectionId: userFriendsCollection,
        documentId: forUser,
        data: {
          'user_id': forUser,
          'user': forUser,
          'friends': [friend],
        },
      );
    } else {
      final doc = response.documents.first;
      final currentFriends = List<String>.from(doc.data['friends'] ?? []);
      if (currentFriends.contains(friend)) return;
      currentFriends.add(friend);
      await database.updateDocument(
        databaseId: dbId,
        collectionId: userFriendsCollection,
        documentId: doc.$id,
        data: {
          'friends': currentFriends,
        },
      );
    }
  }

  Future<void> addFriendToUser(String userId, String friendId) async {
    try {
      await addFriend(userId, friendId); // user adds friend
      await addFriend(friendId, userId); // friend adds user
    } catch (e) {
      debugPrint('Error adding friends mutually: $e');
    }
  }
}
