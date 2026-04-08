import 'dart:async';
import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _initialized = false;
  Timer? _scheduledTimer;

  Future<void> init() async {
    if (_initialized) return;
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );
    _initialized = true;
  }

  Future<bool> requestPermission() async {
    if (Platform.isAndroid) {
      final android = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      final granted = await android?.requestNotificationsPermission();
      return granted ?? false;
    } else if (Platform.isIOS) {
      final ios = _plugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      final granted = await ios?.requestPermissions(
        alert: true, badge: true, sound: true,
      );
      return granted ?? false;
    }
    return false;
  }

  Future<void> scheduleTimerEnd({
    required Duration duration,
    String title = 'AnimalTimer',
    String body = "C'est fini ! Le temps est ecoul\u00e9 \ud83c\udf89",
  }) async {
    await cancelAll();
    _scheduledTimer = Timer(duration, () {
      showNow(title: title, body: body);
    });
  }

  Future<void> showNow({
    String title = 'AnimalTimer',
    String body = "C'est fini ! Le temps est ecoul\u00e9 \ud83c\udf89",
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'timer_channel',
      'Timer Notifications',
      channelDescription: 'Notification quand le minuteur se termine',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      icon: '@mipmap/ic_launcher',
    );
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    await _plugin.show(0, title, body, details);
  }

  Future<void> cancelAll() async {
    _scheduledTimer?.cancel();
    _scheduledTimer = null;
    await _plugin.cancelAll();
  }

  void _onNotificationTap(NotificationResponse response) {}
}

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});
