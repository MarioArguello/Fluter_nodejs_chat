import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/my_colors.dart';
import '../chats/chat_page.dart';
import '../profile/profile_page.dart';
import '../users/users_page.dart';
import 'home_controller.dart';

class HomePage extends StatelessWidget {
  home_controller con = Get.put(home_controller());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: bottomNavigationBar(context),
        body: Obx(() => IndexedStack(
              index: con.tabIndex.value,
              children: [ChatPage(), UsersPage(), ProfilePage()],
            )));
  }

  Widget bottomNavigationBar(BuildContext context) {
    return Obx(() => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Container(
          height: 54, // ALTURA DEL BNB
          child: BottomNavigationBar(
            showUnselectedLabels: true,
            showSelectedLabels: true,
            onTap: con.chageTabindex,
            currentIndex: con.tabIndex.value,
            backgroundColor: MyColors.primaryColors,
            unselectedItemColor: Colors.white.withOpacity(0.5),
            selectedItemColor: Colors.white,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.chat,
                    size: 20,
                  ),
                  label: 'Chats',
                  backgroundColor: MyColors.primaryColors),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.person,
                    size: 20,
                  ),
                  label: 'Usuarios',
                  backgroundColor: MyColors.primaryColors),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.person_pin_rounded,
                    size: 20,
                  ),
                  label: 'Perfil',
                  backgroundColor: MyColors.primaryColors)
            ],
          ),
        )));
  }
}
