import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const InitializationSettings initializationSettings = InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings()); // Use DarwinNotificationDetails
    await _notificationsPlugin.initialize(initializationSettings);
  }

  static Future<void> showNotification(
      int id, String title, String body, String payload) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('channel_id', 'Channel Name',
            channelDescription: 'My notification channel description',
            importance: Importance.max,
            priority: Priority.high);

    const DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails(); // Use DarwinNotificationDetails

    const NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: iosNotificationDetails);

    await _notificationsPlugin.show(id, title, body, notificationDetails,
        payload: payload);
  }

  static Future<void> scheduleNotifications(
      List<DateTime> times, String title, String body, String payload) async {
    for (DateTime time in times) {
      await _notificationsPlugin.zonedSchedule(
        0,
        title,
        body,
        tz.TZDateTime.from(time, tz.local),
        const NotificationDetails(
            android: AndroidNotificationDetails('channel_id', 'Channel Name',
                channelDescription: 'My notification channel description',
                importance: Importance.max,
                priority: Priority.high),
            iOS: DarwinNotificationDetails()),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: payload,
      );
    }
  }
}
