import 'package:flutter/cupertino.dart';

class NotificationsModel {
  String? title;
  String? notification;
  String? notificationType;
  String? prefixIcon;
  Color? prefixIconColor;
  Color? suffixIconColor;


  /// Notification Model Constructor
  NotificationsModel(
      {this.title,
      this.notification,
      this.notificationType,
      this.prefixIcon,
      this.prefixIconColor,
      this.suffixIconColor});
}
