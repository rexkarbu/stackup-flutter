import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationHelper {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tz.initializeTimeZones();

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);

    await _plugin.initialize(initSettings);
  }

  static Future<bool> requestPermission() async {
    final androidImpl = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    return await androidImpl?.requestNotificationsPermission() ?? false;
  }

  /// Kirim notifikasi instan (untuk preview/test)
  static Future<void> showInstantNudge({
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'stackup_nudge_channel',
      'Pengingat Game StackUp',
      channelDescription: 'Pengingat untuk memainkan backlog game Anda',
      importance: Importance.high,
      priority: Priority.high,
    );

    await _plugin.show(
      0,
      title,
      body,
      const NotificationDetails(android: androidDetails),
    );
  }

  /// Jadwalkan pengingat mingguan (Sabtu jam 19:00 malam)
  static Future<void> scheduleWeeklyNudge({
    required String gameTitle,
  }) async {
    await _plugin.cancel(101); // Bersihkan jadwal sebelumnya

    const androidDetails = AndroidNotificationDetails(
      'stackup_weekly_channel',
      'Pengingat Weekend StackUp',
      channelDescription: 'Pengingat akhir pekan untuk bermain game',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );

    // Hitung Sabtu berikutnya jam 19:00
    final tz.TZDateTime scheduledDate = _nextInstanceOfSaturday7PM();

    await _plugin.zonedSchedule(
      101,
      '🎮 Waktunya Main Game!',
      'Weekend tiba! Jangan lupa lanjutin petualanganmu di "$gameTitle".',
      scheduledDate,
      const NotificationDetails(android: androidDetails),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }

  static Future<void> cancelNudge() async {
    await _plugin.cancel(101);
  }

  static tz.TZDateTime _nextInstanceOfSaturday7PM() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, 19);
    while (scheduledDate.weekday != DateTime.saturday ||
        scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}
