import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../models/user.dart';

class ProfileController extends GetxController {
  var user = User.fromJson(GetStorage().read('user') ?? {}).obs;
  User userimg = User.fromJson(GetStorage().read('user') ?? {});
  GetStorage storage = GetStorage();
  void GoToProfileEdit() {
    Get.toNamed('/profile/edit');
  }

  void singOut() {
    Get.snackbar(
      'Logout',
      'Se ha cerrado sesión correctamente',
      icon: Icon(Icons.person, color: Colors.white),
      snackPosition: SnackPosition.TOP,
      backgroundColor: Color.fromARGB(255, 125, 108, 87),
      borderRadius: 20,
      margin: EdgeInsets.all(15),
      colorText: Colors.white,
      duration: Duration(seconds: 4),
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutBack,
    );
    storage.remove('user');
    storage.remove('shopping_bag');
    Get.offNamedUntil('/', (route) => false);
  }
}
