import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> handleNotification(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

class FirebaseMsg {
  final msgService = FirebaseMessaging.instance;

  Future<void> initFCM() async {
    await msgService.requestPermission();

    var token = await msgService.getToken();
    print("Token: $token");

    FirebaseMessaging.onBackgroundMessage(handleNotification); // ✅ Correct handler
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Foreground message: ${message.notification?.title}");
    });
  }
}
