import 'package:chat_flutter/src/api/environment.dart';
import 'package:chat_flutter/src/models/user.dart';
import 'package:chat_flutter/src/pages/chats/chat_page.dart';
import 'package:chat_flutter/src/pages/home/home_page.dart';
import 'package:chat_flutter/src/pages/login/login_page.dart';
import 'package:chat_flutter/src/pages/messages/messages_pages.dart';

import 'package:chat_flutter/src/pages/profile/image_page.dart';
import 'package:chat_flutter/src/pages/profile/otherProfile/otherProfile.dart';
import 'package:chat_flutter/src/utils/default_firebase_config.dart';
import 'package:chat_flutter/src/utils/my_colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:chat_flutter/src/utils/push_notification_provider.dart';
import 'package:socket_io_client/socket_io_client.dart';

//ctrl+shift+l select all
// atajo https://code.visualstudio.com/docs/getstarted/tips-and-tricks
User myUser = User.fromJson(GetStorage().read('user') ?? {});
PushNotificationProvider pushNotificationProvider = PushNotificationProvider();
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseConfig.platformOptions);

  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  print('Handling a background message ${message.messageId}');
  print('Nueva Notificacion background ${message.data}');
  pushNotificationProvider.showNotification(message);
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

void main() async {
  await GetStorage.init();
  await Firebase.initializeApp(options: DefaultFirebaseConfig.platformOptions);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  print('notificacion 2');
  pushNotificationProvider.initPushNotifications();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppasState();
}

class _MyAppasState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('notificacion 3');
    pushNotificationProvider.onMessageListener();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Chat App Flutter",
      initialRoute: myUser.id != null ? '/home_page' : '/',
      debugShowCheckedModeBanner: false,
      getPages: [
        GetPage(name: '/', page: () => LoginPage()),
        GetPage(name: '/home_page', page: () => HomePage()),
        GetPage(name: '/mensajes_chat', page: () => ChatPage()),
        GetPage(name: '/message', page: () => MessagesPage()),
        GetPage(name: '/otherprofile', page: () => OtheProfileScreen())
      ],
      theme: ThemeData(primaryColor: MyColors.primaryColors),
      navigatorKey: Get.key,
    );
  }
}
