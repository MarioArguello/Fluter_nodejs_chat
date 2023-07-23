import 'dart:typed_data';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart';

import '../api/environment.dart';
import '../provider/message_provider.dart';
import '../provider/user_provider.dart';

class PushNotificationProvider extends GetConnect {
  AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    importance: Importance.high,
  );
  MessageProvider messageProvider = MessageProvider();
  FlutterLocalNotificationsPlugin plugin = FlutterLocalNotificationsPlugin();

  void initPushNotifications() async {
    await plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
            alert: true, badge: true, sound: true);
  }

  void onMessageListener() async {
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {}
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('NUEVA NOTIFICACION ${message.data}');
      // NOTIFICACIONES EN PRIMER PLANO
      showNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
    });
  }

  Future<Uint8List> _getByteArrayFromUrl(String url) async {
    final http.Response response = await http.get(Uri.parse(url));
    return response.bodyBytes;
  }

  void showNotification(RemoteMessage message) async {
    AndroidNotificationDetails? androidPlatformChannelSpecifics;

    if (message.data['url'] == '') {
      // MENSAJE DE TEXTO

      androidPlatformChannelSpecifics = AndroidNotificationDetails(
          channel.id, channel.name,
          icon: 'launch_background');
    } else {
      // MENSAJE CON IMAGEN
      ByteArrayAndroidBitmap bigPicture = ByteArrayAndroidBitmap(
          await _getByteArrayFromUrl(message.data['url']));
      BigPictureStyleInformation information = BigPictureStyleInformation(
          bigPicture,
          contentTitle: message.data['title'],
          htmlFormatContentTitle: true,
          summaryText: message.data['body'],
          htmlFormatSummaryText: true);
      androidPlatformChannelSpecifics = AndroidNotificationDetails(
          channel.id, channel.name,
          icon: 'launch_background', styleInformation: information);
    }

    plugin.show(
        int.parse(message.data['id_chat']),
        message.data['title'],
        message.data['body'],
        NotificationDetails(android: androidPlatformChannelSpecifics));
    await messageProvider.updateMessageRecived(message.data['id_message']);
    Socket socket = io('${Enviroment.API_CHAT}chat', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false
    });
    socket.connect();
    socket.emit('received', {
      'id_chat': message.data['id_chat'],
      'id_message': message.data['id_message'],
    });
  }

  Future<Response> sendMessage(String token, Map<String, dynamic> data) async {
    Response response = await post(
        '', {'priority': 'high', 'ttl': '4500s', 'data': data, 'to': token},
        headers: {'Content-type': 'application/json', 'Authorization': ''});

    return response;
  }

  void saveToken(String idUser) async {
    String? token = await FirebaseMessaging.instance.getToken();
    UserProvider usersProvider = UserProvider();
    if (token != null) {
      await usersProvider.updateNotificationTOken(idUser, token);
    }
  }
}
