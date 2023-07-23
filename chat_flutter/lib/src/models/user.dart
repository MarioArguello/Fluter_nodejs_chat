// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User(
      {this.id,
      this.email,
      this.name,
      this.lastname,
      this.phone,
      this.image,
      this.img_portada,
      this.password,
      this.isAvailable = '',
      this.sessionToken,
      this.notification_token});

  String? id;
  String? email;
  String? name;
  String? lastname;
  String? phone;
  String? image;
  String? img_portada;
  String? password;
  String? isAvailable;
  String? sessionToken;
  String? notification_token;

/*
  Transformar un objeto json a modelo user
*/
  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        email: json["email"],
        name: json["name"],
        lastname: json["lastname"],
        phone: json["phone"],
        image: json["image"],
        img_portada: json["img_portada"],
        password: json["password"],
        isAvailable: json["is_available"],
        sessionToken: json["session_token"],
        notification_token: json["notification_token"],
      );
  static List<User> fromJsonList(List<dynamic> jsonList) {
    List<User> toList = [];
    jsonList.forEach((item) {
      User user = User.fromJson(item);
      toList.add(user);
    });
    return toList;
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "name": name,
        "lastname": lastname,
        "phone": phone,
        "image": image,
        "img_portada": img_portada,
        "password": password,
        "is_available": isAvailable,
        "session_token": sessionToken,
        "notification_token": notification_token,
      };
}
