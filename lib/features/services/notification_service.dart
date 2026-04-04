import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _localNotif =
      FlutterLocalNotificationsPlugin();

  Future<void> initialise() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    await _localNotif.initialize(
      const InitializationSettings(android: androidSettings, iOS: iosSettings),
    );
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> scheduleExpiryNotification({
    required int id,
    required String name,
    required DateTime expiryDate,
  }) async {
    final notifyAt = DateTime(
      expiryDate.year,
      expiryDate.month,
      expiryDate.day,
    ).subtract(const Duration(days: 3));

    if (notifyAt.isBefore(DateTime.now())) return;

    const androidDetails = AndroidNotificationDetails(
      'expiry_channel',
      'Expiry Alerts',
      channelDescription: 'Alerts for ingredients expiring soon',
      importance: Importance.high,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotif.show(
      id,
      'Use $name soon!',
      '$name expires in 3 days. Tap to see what you can cook.',
      details,
    );
  }

  Future<void> cancelNotification(int id) async {
    await _localNotif.cancel(id);
  }
}

final notificationServiceProvider = Provider<NotificationService>(
  (ref) => NotificationService(),
);
