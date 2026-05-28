import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import '../../../features/medicines/domain/entities/medicine_entity.dart';

/// Central service for all local push notification scheduling.
/// Handles both dosage reminders (e.g. "Time to take Paracetamol")
/// and expiry warnings (30d / 7d / 1d before expiry).
class NotificationService {
  static final NotificationService _instance = NotificationService._();
  factory NotificationService() => _instance;
  NotificationService._();

  final _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  // ── Init ──────────────────────────────────────────────────────────────────
  Future<void> init() async {
    if (_initialized) return;
    tz.initializeTimeZones();

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    await _plugin.initialize(
      const InitializationSettings(android: android, iOS: ios),
    );
    _initialized = true;
  }

  // ── Request permissions ──────────────────────────────────────────────────
  Future<bool> requestPermissions() async {
    final android = _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      return await android.requestNotificationsPermission() ?? false;
    }
    return true;
  }

  // ── Schedule all reminders for a medicine ─────────────────────────────────
  Future<void> scheduleMedicineReminders(MedicineEntity medicine) async {
    await cancelMedicineReminders(medicine.id);

    if (medicine.reminderEnabled && medicine.scheduledTimes.isNotEmpty) {
      for (int i = 0; i < medicine.scheduledTimes.length; i++) {
        await _scheduleDoseReminder(medicine, i);
      }
    }

    if (medicine.notificationEnabled) {
      await _scheduleExpiryWarnings(medicine);
    }
  }

  // ── Cancel all reminders for a medicine ──────────────────────────────────
  Future<void> cancelMedicineReminders(String medicineId) async {
    final baseId = medicineId.hashCode.abs();
    // Cancel up to 4 dose reminders and 3 expiry warnings
    for (int i = 0; i < 4; i++) {
      await _plugin.cancel(baseId + i);
    }
    for (int i = 0; i < 3; i++) {
      await _plugin.cancel(baseId + 100 + i);
    }
  }

  // ── Cancel ALL notifications ──────────────────────────────────────────────
  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  // ── Private: daily dose reminder ─────────────────────────────────────────
  Future<void> _scheduleDoseReminder(MedicineEntity medicine, int slot) async {
    final timeStr = medicine.scheduledTimes[slot]; // "HH:mm"
    final parts = timeStr.split(':');
    if (parts.length != 2) return;
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return;

    final id = medicine.id.hashCode.abs() + slot;
    final dosage = medicine.dosageAmount ?? '1 dose';
    final scheduledTime = _nextInstanceOf(hour, minute);

    await _plugin.zonedSchedule(
      id,
      '💊 Time to take ${medicine.name}',
      '$dosage — Stay on schedule!',
      scheduledTime,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'dose_reminders',
          'Dose Reminders',
          channelDescription: 'Daily medication dose reminders',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time, // repeat daily
    );
  }

  // ── Private: expiry warning reminders ────────────────────────────────────
  Future<void> _scheduleExpiryWarnings(MedicineEntity medicine) async {
    final baseId = medicine.id.hashCode.abs() + 100;
    final warnings = [
      (days: 30, label: '30 days', id: baseId),
      (days: 7, label: '7 days', id: baseId + 1),
      (days: 1, label: 'tomorrow', id: baseId + 2),
    ];

    for (final w in warnings) {
      final notifyAt = medicine.expiryDate.subtract(Duration(days: w.days));
      if (notifyAt.isBefore(DateTime.now())) continue;

      final tzNotifyAt = tz.TZDateTime.from(
        DateTime(notifyAt.year, notifyAt.month, notifyAt.day, 9, 0),
        tz.local,
      );

      await _plugin.zonedSchedule(
        w.id,
        '⚠️ ${medicine.name} expires in ${w.label}',
        'Check your medicine cabinet and replace if needed.',
        tzNotifyAt,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'expiry_warnings',
            'Expiry Warnings',
            channelDescription: 'Medicine expiry date warnings',
            importance: Importance.defaultImportance,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: const DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }

  // ── Helper ───────────────────────────────────────────────────────────────
  tz.TZDateTime _nextInstanceOf(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }
}
