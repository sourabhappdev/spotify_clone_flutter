import 'dart:async';

import '../../core/configs/manager/storage_manager.dart';

class AppState {
  static final AppState instance = AppState._();

  AppState._();

  final Completer<void> appInitialization = Completer<void>();

  String sessionId = '';
  String userId = '';

  Future<void> setInitialValues() async {
    sessionId = await StorageManager.instance.getData('sessionId') ?? '';
    userId = await StorageManager.instance.getData('userId') ?? '';
  }

  Future<void> clearAllValues() async {
    userId = '';
    sessionId = '';
    await StorageManager.instance.clearData();
  }
}
