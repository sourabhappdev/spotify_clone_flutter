import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final class LocalNotificationManager {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  bool isInitialized = false;

  Future<void> initialize(BuildContext context) async {
    const InitializationSettings initializationSettings =
    InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
      iOS: DarwinInitializationSettings(),
    );
    await _notificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (notification) async {
          Map<String, dynamic> messageData =
          jsonDecode(notification.payload.toString());
          navigate(context, messageData);
        });
    isInitialized = true;
  }

  Future<void> displayMessage(RemoteMessage message) async {
    debugPrint(message.data.toString());
    try {
      final int id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      const NotificationDetails notificationDetails = NotificationDetails(
        //TODO: change channel accordingly
          android: AndroidNotificationDetails(
            'custom_channel', // id
            'High Importance Notifications', // title
            importance: Importance.max,
            priority: Priority.high,
            enableVibration: true,
            playSound: true,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentSound: true,
            presentBadge: true,
          ));
      await _notificationsPlugin.show(
        id,
        message.notification?.title ?? '',
        message.notification?.body ?? '',
        notificationDetails,
        payload: jsonEncode(message.data),
      );
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

  void navigate(BuildContext context, Map<String, dynamic> messageData) {
    debugPrint('Navigate started');
    debugPrint('----${messageData['type']}');
    debugPrint('----${messageData.toString()}');
    //TODO: Add navigation code accordingly
  }
}