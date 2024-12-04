import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:freud_ai/app.dart';
import 'package:freud_ai/configs/database/database_helper.dart';
import 'package:freud_ai/configs/database/shared_pref.dart';
import 'package:freud_ai/managers/preference_manager.dart';
import 'package:freud_ai/screens/routine/notification_remainder/local_remainder_notification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferenceManager().init();
  await dotenv.load(fileName: '.env');
  await LocalRemainderNotification.init();
  await databaseHelper.createTheInstanceOfDatabase();

  /// first commit
  sharedPreferencesManager.createInstance();

  //  handle in terminated state
  var initialNotification =
  await FlutterLocalNotificationsPlugin().getNotificationAppLaunchDetails();
  if (initialNotification?.didNotificationLaunchApp == true) {
    // LocalNotifications.onClickNotification.stream.listen((event) {
    Future.delayed(const Duration(seconds: 1), () {
      // print(event);
      // navigatorKey.currentState!.pushNamed('/another',
      //     arguments: initialNotification?.notificationResponse?.payload);
    });
  }

  runApp(const MyApp());
}
