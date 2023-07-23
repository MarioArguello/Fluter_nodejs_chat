import 'package:chat_flutter/src/api/environment.dart';
import 'package:chat_flutter/src/pages/users/user_controller.dart';
import 'package:chat_flutter/src/utils/my_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/user.dart';

class UsersPage extends StatelessWidget {
  UserController con = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90),
        child: AppBar(
            backgroundColor: MyColors.primaryColors,
            flexibleSpace: Container(
                margin: EdgeInsets.only(top: 20),
                alignment: Alignment.topCenter,
                child: Wrap(
                    direction: Axis.vertical,
                    children: [_textFieldSearch(context), _iconsSms()]))),
      ),
      body: FutureBuilder(
          future: con.getUser(con.Nameperson.value),
          builder: (context, AsyncSnapshot<List<User>> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data?.isNotEmpty == true) {
                return ListView.builder(
                    itemExtent: 75.0,
                    itemCount: snapshot.data?.length ?? 0,
                    itemBuilder: (_, index) {
                      return _card2(snapshot.data![index]);
                    });
              } else {
                return Container();
              }
            } else {
              return Container();
            }
          }),
    );
  }

  Widget _iconsSms() {
    return GestureDetector(
      onTap: () => Get.toNamed('/mensajes_chat'),
      child: Container(
        margin: EdgeInsetsDirectional.symmetric(horizontal: 10, vertical: 25),
        width: 50,
        height: 50,
        child: Image.asset('assets/img/chat.png'),
      ),
    );
  }

  Widget _textFieldSearch(BuildContext context) {
    return SafeArea(
        child: Container(
            width: MediaQuery.of(context).size.width * 0.7,
            child: TextField(
              onChanged: con.onChangeText,
              decoration: InputDecoration(
                  hintText: 'Buscar persona',
                  suffixIcon: Icon(Icons.search, color: Colors.grey),
                  hintStyle: TextStyle(fontSize: 17, color: Colors.grey),
                  fillColor: Colors.white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.grey)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: Colors.grey)),
                  contentPadding: EdgeInsets.all(15)),
            )));
  }

  Widget cardUser(User user) {
    return Column(
      children: [
        Expanded(
          child: ListTile(
            leading: AspectRatio(
              aspectRatio: 1,
              child: ClipOval(
                child: FadeInImage.assetNetwork(
                    fit: BoxFit.cover,
                    placeholder: 'assets/img/man.png',
                    image: user.image ??
                        'https://firebasestorage.googleapis.com/v0/b/flutter-chatmaac.appspot.com/o/man.png?alt=media&token=3f63d880-6e6a-40ea-b504-2e24d42a6cdc'),
              ),
            ),
            title: Text(user.name ?? ''),
            subtitle: Text(user.lastname ?? ''),
            trailing: Icon(Icons.keyboard_arrow_right),
            tileColor: Colors.brown.shade50,
          ),
        ),
        new Divider(
          height: 2.0,
          indent: 1.0,
        ),
      ],
    );
  }

  Widget _card2(User user) {
    return Column(children: [
      SizedBox(height: 10),
      Expanded(
        child: GestureDetector(
          onTap: () => con.goToChatMessage(user),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                color: Color.fromARGB(255, 249, 211, 211),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 70,
                      height: 70,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: FadeInImage.assetNetwork(
                            fit: BoxFit.cover,
                            placeholder: 'assets/img/man.png',
                            image: user.image ?? Enviroment.image_url),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            user.name ?? '',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(user.lastname ?? '')
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, color: Colors.blue),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      user.isNull
          ? SizedBox()
          : Divider(
              indent: 80,
              height: 1,
              endIndent: 16,
            ),
    ]);
  }
}
