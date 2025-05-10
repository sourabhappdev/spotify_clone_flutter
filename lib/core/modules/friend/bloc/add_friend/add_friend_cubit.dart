import 'dart:convert';

import 'package:appwrite/appwrite.dart';
import 'package:bloc/bloc.dart';
import 'package:crypto/crypto.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:spotify_clone/common/services/app_state.dart';

import '../../../../../common/services/appwrite_service.dart';

part 'add_friend_state.dart';

class AddFriendCubit extends Cubit<AddFriendState> {
  AddFriendCubit() : super(AddFriendInitial());

  Future<void> addFriend({required String receiverId}) async {
    emit(AddFriendLoading());

    try {
      final senderId = AppState.instance.userId;

      // Deterministic ID for uniqueness
      final docId = _getFriendRequestDocId(senderId, receiverId);

      // Check if a request already exists
      final existingRequest = await _checkExistingFriendRequest(docId);

      if (existingRequest) {
        return emit(const AddFriendFailure('Friend request already exists'));

      }

      // Create the friend request
      final response = await AppWriteService.databases.createDocument(
        databaseId: dotenv.env['DB'] ?? '',
        collectionId: dotenv.env['FRIEND_REQUEST'] ?? '',
        documentId: docId,
        permissions: [
          Permission.write(Role.any()),
          Permission.read(Role.any()),
        ],
        data: {
          'receiver_id': receiverId,
          'sender_id': senderId,
          'receiver': receiverId,
          'sender': senderId,
          'time_stamp': DateTime.now().toUtc().toIso8601String(),
          'status': 'pending',
        },
      );

      if (response.$id.isEmpty) {
        emit(const AddFriendFailure('Something went wrong'));
      } else {
        emit(const AddFriendSuccess('Friend request sent'));
      }
    } on AppwriteException catch (e) {
      emit(AddFriendFailure(e.message ?? 'Something went wrong'));
    } catch (e) {
      emit(const AddFriendFailure('Something went wrong'));
    }
  }

  // Generate unique doc ID regardless of sender/receiver direction
  String _getFriendRequestDocId(String id1, String id2) {
    final sorted = [id1, id2]..sort(); // ensure same order every time
    final raw = '${sorted[0]}_${sorted[1]}';
    final hash = sha1.convert(utf8.encode(raw)); // 40-char hex
    return hash.toString().substring(0, 36); // trim to 36 chars max
  }

  Future<bool> _checkExistingFriendRequest(String docId) async {
    try {
      await AppWriteService.databases.getDocument(
        databaseId: dotenv.env['DB'] ?? '',
        collectionId: dotenv.env['FRIEND_REQUEST'] ?? '',
        documentId: docId,
      );
      return true;
    } on AppwriteException catch (e) {
      debugPrint(e.message);
      if (e.code == 404) return false;
      rethrow;
    }
  }
}
