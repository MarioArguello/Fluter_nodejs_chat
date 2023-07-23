import 'dart:async';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../models/user.dart';
import '../../provider/user_provider.dart';

class UserController extends GetxController {
  UserProvider userProvider = UserProvider();
  GetStorage storage = GetStorage();
  var Nameperson = ''.obs;
  Timer? searchOnStoppedTyping;
  Future<List<User>> getUser(String namePerson) async {
    if (namePerson.isEmpty) {
      return await userProvider.getUser();
    } else {
      return await userProvider.getUserPerson(namePerson);
    }
  }

  void onChangeText(String text) {
    const duration = Duration(milliseconds: 300);
    if (searchOnStoppedTyping != null) {
      searchOnStoppedTyping?.cancel();
    }
    searchOnStoppedTyping = Timer(duration, () {
      Nameperson.value = text;
      print('Texto Completo:');
    });
  }

  void onChangeBuscar(String text) {
    Nameperson.value = text;
  }

  void goToChatMessage(User user) {
    Get.toNamed('/otherprofile');
    storage.write('messagesend', user.toJson());
  }
}
