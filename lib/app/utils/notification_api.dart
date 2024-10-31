import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationApi {
  static final _notificationss = FlutterLocalNotificationsPlugin();
  static Future init({bool initScheduled = false}) async {
    print("Inisialisasi dimulai...");
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: androidSettings);

    bool? initialized = await _notificationss.initialize(
      settings,
      onDidReceiveNotificationResponse: (payload) async {
        print('notification payload : $payload');
      },
    );

    print("Notifikasi terinisialisasi: $initialized");
  }

  static Future showNotifiactions({
    required int id,
    required String title,
    required String body,
    required String payload,
  }) =>
      _notificationss.show(
        id,
        title,
        body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'channel id',
            'channel name',
            channelDescription: 'channel description',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: false,
          ),
        ),
        payload: payload,
      );

  static tz.TZDateTime _scheduledDaily(TimeOfDay time) {
    final jakarta = tz.getLocation('Asia/Jakarta');
    final now = tz.TZDateTime.now(jakarta);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
        jakarta, now.year, now.month, now.day, time.hour, time.minute);

    return scheduledDate.isBefore(now)
        ? scheduledDate = scheduledDate.add(const Duration(days: 1))
        : scheduledDate;
  }

  static Future scheduledNotification({
    required int id,
    required String title,
    required String body,
    required String payload,
    required TimeOfDay scheduledDate,
  }) async {
    _notificationss.zonedSchedule(
      id,
      title,
      body,
      _scheduledDaily(scheduledDate),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'channel id',
          'channel name',
          channelDescription: 'channel description',
          importance: Importance.max,
          priority: Priority.high,
          showWhen: true,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static Future cancelNotification(int id) => _notificationss.cancel(id);
  static Future cancelAllNotification() => _notificationss.cancelAll();
}
