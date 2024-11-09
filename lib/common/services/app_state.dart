import 'dart:async';

import 'package:spotify_clone/core/configs/constants/string_res.dart';

import '../../core/configs/manager/storage_manager.dart';

class AppState {
  static final AppState instance = AppState._();

  AppState._();

  final Completer<void> appInitialization = Completer<void>();

  // Private variables
  String _sessionId = '';
  String _userId = '';
  List<String> _likedSongs = [];

  // Getter for sessionId
  String get sessionId => _sessionId;

  // Setter for sessionId (arrow function)
  set setSessionId(String value) => _sessionId = value;

  // Getter for userId
  String get userId => _userId;

  // Setter for userId (arrow function)
  set setUserId(String value) => _userId = value;

  // Getter for likedSongs
  List<String> get likedSongs => _likedSongs;

  // Setter for likedSongs (arrow function)
  set setLikedSongs(List<String> value) => _likedSongs = value;

  // Initialize values
  Future<void> setInitialValues() async {
    _sessionId =
        await StorageManager.instance.getData(StringRes.sessionId) ?? '';
    _userId = await StorageManager.instance.getData(StringRes.userId) ?? '';
    _likedSongs =
        await StorageManager.instance.getList(StringRes.likedSongs) ?? [];
  }

  // Clear all values
  Future<void> clearAllValues() async {
    _userId = '';
    _sessionId = '';
    await StorageManager.instance.clearData();
  }
}
