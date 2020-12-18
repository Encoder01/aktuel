
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';

class PushNotificationsManager {
  PushNotificationsManager._();

  factory PushNotificationsManager() => _instance;

  static final PushNotificationsManager _instance =
  PushNotificationsManager._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool _initialized = false;
  BehaviorSubject<Map<String, dynamic>> notificationSubject =
  BehaviorSubject<Map<String, dynamic>>();
  Future<void> init() async {
    if (!_initialized) {
      _firebaseMessaging.requestNotificationPermissions();
      _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          notificationSubject.add({'type': 'Yeni Broşürler Eklendi', 'value': message});
        },
        onLaunch: (Map<String, dynamic> message) async {
          notificationSubject.add({'type': 'Yeni Broşürler Eklendi', 'value': message});
        },
      );
      _initialized = true;
    }
  }

  Future<void> createChannel() async {
    var notificationPlugin = FlutterLocalNotificationsPlugin();
    var notificationChannel = AndroidNotificationChannel(
        'test_push_notification', // TODO: bildirim adı girilecek.
        "Test Push Notification",
        "Channel to test push notification",);
    await notificationPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(notificationChannel);
  }
}