import 'package:chat_flutter/src/pages/login/login_controller.dart';
import 'package:chat_flutter/src/utils/my_colors.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  LoginController con = LoginController();
  var _passwordVisible = true.obs;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: Container(
          width: double.infinity,
          child: Stack(
            children: [
              Positioned(top: -80, left: -100, child: _circleLogin()),
              Positioned(
                child: _textLogin(),
                top: 60,
                left: 25,
              ),
              SingleChildScrollView(
                child: Column(
                  children: [
                    // _imagenesmailman(context),
                    _imageMailman(context),
                    _TextFielcorreo(),
                    _TextFielpassword(),
                    _botton_login(),
                    _Registro_newUser()
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _textLogin() {
    return Text(
      "Login",
      style: TextStyle(
          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
    );
  }

  Widget _Registro_newUser() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'No tienes cuenta',
            style: TextStyle(color: MyColors.primaryColors),
          ),
          SizedBox(width: 7),
          GestureDetector(
            onTap: () {
              Get.snackbar('Pagina', 'No existe');
            },
            child: Text('Registrate',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: MyColors.primaryColors)),
          )
        ],
      ),
    );
  }

  Widget _imageMailman(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: 80, bottom: MediaQuery.of(context).size.height * 0.10),
      child: Image.asset(
        'assets/img/mailman.png',
        width: 200,
        height: 200,
      ),
    );
  }

  Widget _circleLogin() {
    return Container(
      width: 240,
      height: 230,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: MyColors.primaryColors),
    );
  }

  Widget _TextFielcorreo() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 5),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(30)),
      child: TextField(
        keyboardType: TextInputType.emailAddress,
        controller: con.emailController,
        decoration: InputDecoration(
            hintText: "Correo electronico",
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15),
            hintStyle: TextStyle(color: MyColors.primaryColorDark),
            prefixIcon: Icon(
              Icons.email,
              color: MyColors.primaryColors,
            )),
      ),
    );
  }

  Widget _TextFielpassword() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 5),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(30)),
      child: TextField(
        controller: con.passwordController,
        obscureText: _passwordVisible.value,
        decoration: InputDecoration(
            hintText: "Contraseña",
            suffixIcon: IconButton(
                icon: Icon(
                  // Based on passwordVisible state choose the icon
                  _passwordVisible.value
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: MyColors.primaryColors,
                ),
                onPressed: () {
                  _passwordVisible.value = !_passwordVisible.value;
                }),
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15),
            hintStyle: TextStyle(color: MyColors.primaryColorDark),
            prefixIcon: Icon(
              Icons.lock,
              color: MyColors.primaryColors,
            )),
      ),
    );
  }

  Widget _botton_login() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
      child: ElevatedButton(
        onPressed: () => con.login(),
        child: Text('Ingresar'),
        style: ElevatedButton.styleFrom(
            primary: MyColors.primaryColors,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            padding: EdgeInsets.symmetric(vertical: 15)),
      ),
    );
  }
}
