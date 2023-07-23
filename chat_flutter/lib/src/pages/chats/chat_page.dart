import 'package:chat_flutter/src/utils/relative_time_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../api/environment.dart';
import '../../models/Chat.dart';
import '../../models/user.dart';
import '../../utils/my_colors.dart';
import 'chatController.dart';

class ChatPage extends StatelessWidget {
  ChatController con = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Mensajes')),
        automaticallyImplyLeading: false,
        backgroundColor: MyColors.primaryColors,
      ),
      body: Obx(() => SafeArea(
              child: ListView(
            children: getChat(),
          ))),
    );
  }

  List<Widget> getChat() {
    return con.chat.map((mensaje) {
      return Container(
        margin: EdgeInsets.only(top: 10, right: 15, left: 15),
        child: cardChat(mensaje),
      );
    }).toList();
  }

  Widget cardChat(Chat chat) {
    return GestureDetector(
      onTap: () => con.goToChat(chat),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15), //<-- SEE HERE
        ),
        leading: AspectRatio(
          aspectRatio: 1,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: FadeInImage.assetNetwork(
                fit: BoxFit.cover,
                placeholder: 'assets/img/man.png',
                image: chat.id_user1 == con.myUser.id
                    ? chat.imageUser2 ?? Enviroment.image_url
                    : chat.imageUser1 ?? Enviroment.image_url,
              )),
        ),
        title: Text(
          chat.id_user1 == con.myUser.id
              ? chat.nameUser2 ?? ''
              : chat.nameUser1 ?? '',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(chat.last_message ?? 'null message ._.'),
        trailing: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 7, right: 7),
              child: Text(
                RelativeTimeUtil.getRelativeTime(
                    chat.last_message_timestamp ?? 0),
                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              ),
            ),
            chat.unread_messages! > 0
                ? circleMessageUnread(chat.unread_messages ?? 0)
                : SizedBox(
                    height: 0,
                  ),
          ],
        ),
        tileColor: Color.fromARGB(255, 249, 211, 211),
      ),
    );
  }

  Widget circleMessageUnread(int number) {
    return Container(
      margin: EdgeInsets.only(top: 5, left: 10, right: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: Container(
          height: 25,
          width: 25,
          color: MyColors.primaryColors,
          alignment: Alignment.center,
          child: Text(
            number.toString(),
            style: TextStyle(color: Colors.white, fontSize: 10),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
