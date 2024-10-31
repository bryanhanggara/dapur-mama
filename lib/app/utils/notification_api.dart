import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationApi {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static Future init({bool initScheduled = false}) async {
    print("Inisialisasi dimulai...");
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: androidSettings);

    bool? initialized = await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (payload) async {
        print('Notification payload: $payload');
      },
    );

    print("Notifikasi terinisialisasi: $initialized");
  }

  static Future showNotifications({
    required int id,
    required String title,
    required String body,
    required String payload,
  }) async {
    await _notifications.show(
      id,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'channel id', // Ganti dengan ID channel yang unik
          'channel name', // Ganti dengan nama channel
          channelDescription: 'channel description', // Deskripsi channel
          importance: Importance.max,
          priority: Priority.high,
          showWhen: false,
        ),
      ),
      payload: payload,
    );
  }

  static tz.TZDateTime _scheduledDaily(TimeOfDay time) {
    final jakarta = tz.getLocation('Asia/Jakarta');
    final now = tz.TZDateTime.now(jakarta);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
        jakarta, now.year, now.month, now.day, time.hour, time.minute);

    return scheduledDate.isBefore(now)
        ? scheduledDate.add(const Duration(days: 1))
        : scheduledDate;
  }

  static Future scheduledNotification({
    required int id,
    required String title,
    required String body,
    required String payload,
    required TimeOfDay scheduledDate,
  }) async {
    await _notifications.zonedSchedule(
      id,
      title,
      body,
      _scheduledDaily(scheduledDate),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'channel id', // Ganti dengan ID channel yang unik
          'channel name', // Ganti dengan nama channel
          channelDescription: 'channel description', // Deskripsi channel
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

  static Future cancelNotification(int id) => _notifications.cancel(id);
  static Future cancelAllNotification() => _notifications.cancelAll();
}
