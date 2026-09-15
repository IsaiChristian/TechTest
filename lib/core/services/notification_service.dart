import 'package:closer_to_god/core/error/logger_service.dart';
import 'package:closer_to_god/domain/entities/alarm_entity.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;

    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
      macOS: darwinSettings,
    );

    await _notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        LoggerService.info('Notification', 'Notification tapped: ${response.payload}');
      },
    );

    _isInitialized = true;
  }

  Future<bool> requestPermissions() async {
    final androidImplementation =
        _notificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    bool? androidGranted = false;
    if (androidImplementation != null) {
      androidGranted = await androidImplementation.requestNotificationsPermission();
    }

    final iosImplementation =
        _notificationsPlugin.resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();

    bool? iosGranted = false;
    if (iosImplementation != null) {
      iosGranted = await iosImplementation.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    return (androidGranted ?? false) || (iosGranted ?? false);
  }

  Future<void> scheduleAlarmNotification(AlarmEntity alarm) async {
    await init();

    if (!alarm.isEnabled) {
      await cancelAlarmNotification(alarm.id);
      return;
    }

    const androidDetails = AndroidNotificationDetails(
      'prayer_alarm_channel',
      'Prayer Reminders',
      channelDescription: 'High priority daily prayer alarms and reminders',
      importance: Importance.max,
      priority: Priority.high,
      fullScreenIntent: true,
      category: AndroidNotificationCategory.alarm,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentSound: true,
      ),
    );

    final now = DateTime.now();

    for (final dayOfWeek in alarm.daysOfWeek) {
      final scheduledDate = _nextInstanceOfDayAndTime(alarm.hour, alarm.minute, dayOfWeek, now);
      final notificationId = alarm.id.hashCode + dayOfWeek;

      try {
        await _notificationsPlugin.zonedSchedule(
          notificationId,
          'Time to Pray - ${alarm.title}',
          alarm.reason.isNotEmpty ? alarm.reason : 'Take a moment to connect with God.',
          tz.TZDateTime.from(scheduledDate, tz.local),
          notificationDetails,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
          payload: alarm.id,
        );
      } catch (e, st) {
        LoggerService.error("NotificationSchedule", e.toString(), st);
      }
    }
  }

  Future<void> cancelAlarmNotification(String alarmId) async {
    await init();
    for (int dayOfWeek = 1; dayOfWeek <= 7; dayOfWeek++) {
      final notificationId = alarmId.hashCode + dayOfWeek;
      await _notificationsPlugin.cancel(notificationId);
    }
  }

  DateTime _nextInstanceOfDayAndTime(int hour, int minute, int dayOfWeek, DateTime now) {
    DateTime scheduledDate = DateTime(now.year, now.month, now.day, hour, minute);
    while (scheduledDate.weekday != dayOfWeek || scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}
