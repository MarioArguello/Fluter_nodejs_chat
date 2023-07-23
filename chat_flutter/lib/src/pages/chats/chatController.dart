import 'package:chat_flutter/src/models/Chat.dart';
import 'package:chat_flutter/src/models/Message.dart';
import 'package:chat_flutter/src/utils/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../home/home_controller.dart';
import '../../models/user.dart';
import '../../provider/chat_provider.dart';

class ChatController extends GetxController {
  User myUser = User.fromJson(GetStorage().read('user') ?? {});
  home_controller homeController = Get.find();
  List<Chat> chat = <Chat>[].obs;
  ChatProvider chatProvider = ChatProvider();

  ChatController() {
    getChat();
    ListenMessageChat();
  }
  void getChat() async {
    var result = await chatProvider.getChat();
    chat.clear();
    chat.addAll(result);
  }

  // Future<List<Chat>> getChat() async {
  //  return await chatProvider.getChat();
  //}
  void goToChat(Chat chat) {
    User user = User();
    if (chat.id_user1 == myUser.id) {
      user.id = chat.id_user2;
      user.name = chat.nameUser2;
      user.lastname = chat.lastnameUser2;
      user.email = chat.emailUser2;
      user.phone = chat.phoneUser2;
      user.image = chat.imageUser2;
      user.notification_token = chat.notification_tokenUser2;
    } else {
      user.id = chat.id_user1;
      user.name = chat.nameUser1;
      user.lastname = chat.lastnameUser1;
      user.email = chat.emailUser1;
      user.phone = chat.phoneUser1;
      user.image = chat.imageUser1;
      user.notification_token = chat.notification_tokenUser1;
    }
    Get.toNamed('/message', arguments: {'user': user.toJson()});
  }

  void ListenMessageChat() {
    homeController.socket.on('message/${myUser.id}', (data) {
      print('Data emitida $data');
      getChat();
    });
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    homeController.socket.off('message/${myUser.id}');
  }
}
