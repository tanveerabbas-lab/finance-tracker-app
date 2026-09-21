import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// NotificationService sets up and triggers local notifications,
/// used here for budget alerts. This is the evidence file for the
/// "Notifications Implementation" task.
class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
  FlutterLocalNotificationsPlugin();

  /// Call once at app startup to configure notification channels.
  static Future<void> init() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    const settings = InitializationSettings(android: androidInit, iOS: iosInit);
    await _plugin.initialize(settings);
  }

  /// Configures a budget-alert notification channel (Android).
  static Future<void> configureBudgetAlerts() async {
    const channel = AndroidNotificationChannel(
      'budget_alerts',
      'Budget Alerts',
      description: 'Notifies you when spending crosses your budget limit.',
      importance: Importance.high,
    );
    await _plugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  /// Triggers a test notification so the user can confirm alerts work.
  static Future<void> showTestNotification() async {
    const androidDetails = AndroidNotificationDetails(
      'budget_alerts',
      'Budget Alerts',
      channelDescription: 'Notifies you when spending crosses your budget limit.',
      importance: Importance.high,
      priority: Priority.high,
    );
    const details = NotificationDetails(android: androidDetails);

    await _plugin.show(
      0,
      'Budget Alert',
      'You have spent 80% of your monthly budget.',
      details,
    );
  }
}
