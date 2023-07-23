import 'package:chat_flutter/src/models/response_api.dart';
import 'package:chat_flutter/src/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../models/user.dart';

class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    UserProvider userprovider = UserProvider();
    GetStorage storage = GetStorage();

    if (!email.isEmpty && !password.isEmpty) {
      print('${email + ' ' + password}');
      ResponseApi responseApi = await userprovider.Login(email, password);
      print('Response api: ${responseApi.toJson()}');

      if (responseApi.success == true) {
        User user = User.fromJson(responseApi.data);
        storage.write('user', user.toJson());
        goToHomePage();
        Get.snackbar(
          'Login correcto',
          'Se ha iniciado sesion',
          icon: Icon(Icons.person, color: Colors.white),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Color.fromARGB(255, 87, 125, 88),
          borderRadius: 20,
          margin: EdgeInsets.all(15),
          colorText: Colors.white,
          duration: Duration(seconds: 4),
          isDismissible: true,
          forwardAnimationCurve: Curves.easeOutBack,
        );
      } else {
        Get.snackbar('Error de sesion', 'No se a podido iniciar sesion');
      }
    } else {
      Get.snackbar('Completa los datos', 'Engresa el email y el password');
    }
  }

  void goToHomePage() {
    Get.offNamedUntil('/home_page', (route) => false);
  }
}
