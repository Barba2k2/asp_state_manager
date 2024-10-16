import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationsHelper {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initializeNotifications() async {
    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await _notificationsPlugin.initialize(initializationSettings);
  }

  static Future<void> scheduleUrgentNotification(String itemName) async {
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'urgent_items',
      'Urgent Items',
      channelDescription: 'Notificações para itens urgentes',
      importance: Importance.max,
      priority: Priority.high,
    );

    const platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _notificationsPlugin.show(
      0,
      'Item Urgente',
      'Não se esqueça de comprar: $itemName',
      platformChannelSpecifics,
    );
  }
}
