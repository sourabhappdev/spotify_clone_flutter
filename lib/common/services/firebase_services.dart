import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';

class FirebaseServices {
  FirebaseServices._internal();
  static final FirebaseServices _instance = FirebaseServices._internal();
  factory FirebaseServices() => _instance;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String _fcmToken = "", _apnsToken = "";
  late StreamSubscription<RemoteMessage> _remoteMessageStreamSubscription;

  //Getters
  String get fcmToken => _fcmToken;
  String get apnsToken => _apnsToken;
  StreamSubscription<RemoteMessage> get remoteMessageStreamSubscription =>
      _remoteMessageStreamSubscription;

  /// Get the current FCM token
  Future<void> getFCMToken() async {
    try {
      _fcmToken = await _firebaseMessaging.getToken() ?? '';
      debugPrint('FCM Token: $_fcmToken');
    } catch (e) {
      debugPrint('Error getting FCM token: $e');
    }
  }

  /// Get the APNs (Apple Push Notification Service) token for iOS devices
  Future<void> getAPNSToken() async {
    try {
      _apnsToken = await _firebaseMessaging.getAPNSToken() ?? '';
      debugPrint('APNs Token: $_apnsToken');
    } catch (e) {
      debugPrint('Error getting APNs token: $e');
    }
  }

  /// Delete the current FCM token
  Future<void> deleteFCMToken() async {
    try {
      await _firebaseMessaging.deleteToken();
      _fcmToken = '';
      debugPrint('FCM Token deleted successfully');
    } catch (e) {
      debugPrint('Error deleting FCM token: $e');
    }
  }

  /// Update the FCM token
  /// This might be part of your app's logic to refresh the token if required
  Future<void> updateToken() async {
    try {
      await deleteFCMToken();
      _fcmToken = await _firebaseMessaging.getToken() ?? '';
      debugPrint('Updated FCM Token: $_fcmToken');
    } catch (e) {
      debugPrint('Error updating FCM token: $e');
    }
  }

  /// Subscribe to a topic
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
      debugPrint('Subscribed to topic: $topic');
    } catch (e) {
      debugPrint('Error subscribing to topic $topic: $e');
    }
  }

  /// Unsubscribe from a topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      debugPrint('Unsubscribed from topic: $topic');
    } catch (e) {
      debugPrint('Error unsubscribing from topic $topic: $e');
    }
  }

  /// Handle initial remoteMessage when the app is opened from a terminated state
  Future<RemoteMessage?> getInitialMessage(
      final void Function(RemoteMessage remoteMessage) callback) async {
    try {
      final RemoteMessage? initialMessage =
      await _firebaseMessaging.getInitialMessage();
      if (initialMessage != null) {
        callback(initialMessage);
        debugPrint('Initial remoteMessage: ${initialMessage.messageId}');
      }
      return initialMessage;
    } catch (e) {
      debugPrint('Error getting initial remoteMessage: $e');
      return null;
    }
  }

  /// Set up foreground remoteMessage handling
  void onMessageListener(void Function(RemoteMessage remoteMessage) onMessage) {
    try {
      _remoteMessageStreamSubscription =
          FirebaseMessaging.onMessage.listen(onMessage);
      debugPrint('Foreground remoteMessage listener set up');
    } catch (e) {
      debugPrint('Error setting up remoteMessage listener: $e');
    }
  }

  /// Set up background remoteMessage handling
  void onBackgroundMessageListener(
      Future<void> Function(RemoteMessage remoteMessage) onBackgroundMessage) {
    try {
      FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
      debugPrint('Background remoteMessage listener set up');
    } catch (e) {
      debugPrint('Error setting up background remoteMessage listener: $e');
    }
  }

  /// Set up onMessageOpenedApp handling
  void onMessageOpenedAppHandler(
      void Function(RemoteMessage remoteMessage) onMessage) {
    try {
      FirebaseMessaging.onMessageOpenedApp.listen(onMessage);
      debugPrint('onMessageOpenedAppHandler set up');
    } catch (e) {
      debugPrint('Error setting up remoteMessage listener: $e');
    }
  }

  /// By default this function returns false it means simply show notification [return false in this case]
  /// If this function is not assigned to default value it means instead of showing notification directly check some condition then behave accordingly [return true in this case]
  Future<bool> Function(RemoteMessage remoteMessage) _listenerFunction =
      (remoteMessage) async {
    return false;
  };

  // Getter
  Future<bool> Function(RemoteMessage remoteMessage) get listenerFunction =>
      _listenerFunction;

  // Setter
  set setListenerFunction(
      Future<bool> Function(RemoteMessage remoteMessage) value) {
    _listenerFunction = value;
  }

  /// This method resets listener function to default value
  void resetListenerFunction() {
    _listenerFunction = (remoteMessage) async {
      return false;
    };
  }

// /// By default listener function stays null it means simply show notification [return false in this case]
// /// If this function is not null call the listener function [return true in this case]
// Future<bool> checkListenerFunctionIsNotNull(
//     RemoteMessage remoteMessage) async {
//   if (_listenerFunction == null) return false;
//   return await _listenerFunction!(remoteMessage);
// }
}