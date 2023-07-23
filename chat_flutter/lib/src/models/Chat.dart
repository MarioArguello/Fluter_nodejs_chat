// To parse this JSON data, do
//
//     final chat = chatFromJson(jsonString);

import 'dart:convert';

Chat chatFromJson(String str) => Chat.fromJson(json.decode(str));

String chatToJson(Chat data) => json.encode(data.toJson());

class Chat {
  String? id;
  String? id_user1;
  String? id_user2;
  int? timestamp;
  // usuario 1
  String? nameUser1;
  String? lastnameUser1;
  String? emailUser1;
  String? phoneUser1;
  String? imageUser1;
  String? notification_tokenUser1;
  // usuario 2
  String? nameUser2;
  String? lastnameUser2;
  String? emailUser2;
  String? phoneUser2;
  String? imageUser2;
  String? notification_tokenUser2;
  String? last_message;
  int? unread_messages;
  int? last_message_timestamp;

  Chat(
      {this.id,
      this.id_user1,
      this.id_user2,
      this.timestamp,
      this.nameUser1,
      this.lastnameUser1,
      this.emailUser1,
      this.phoneUser1,
      this.imageUser1,
      this.notification_tokenUser1,
      this.nameUser2,
      this.lastnameUser2,
      this.emailUser2,
      this.phoneUser2,
      this.imageUser2,
      this.notification_tokenUser2,
      this.last_message,
      this.unread_messages,
      this.last_message_timestamp});

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
        id: json["id"],
        id_user1: json["id_user1"],
        id_user2: json["id_user2"],
        timestamp: int.parse(json["timestamp"]),
        nameUser1: json['name_user1'],
        lastnameUser1: json['lastname_user1'],
        emailUser1: json['email_user1'],
        phoneUser1: json['phone_user1'],
        imageUser1: json['image_user1'],
        notification_tokenUser1: json['notification_token_user1'],
        nameUser2: json['name_user2'],
        lastnameUser2: json['lastname_user2'],
        emailUser2: json['email_user2'],
        phoneUser2: json['phone_user2'],
        imageUser2: json['image_user2'],
        notification_tokenUser2: json['notification_token_user2'],
        last_message: json['last_message'],
        unread_messages: json['unread_messages'] != null
            ? int.parse(json['unread_messages'])
            : 0,
        last_message_timestamp: json['last_message_timestamp'] != null
            ? int.parse(json['last_message_timestamp'])
            : 0,
      );
  static List<Chat> fromJsonList(List<dynamic> jsonList) {
    List<Chat> toList = [];
    jsonList.forEach((item) {
      Chat chat = Chat.fromJson(item);
      toList.add(chat);
    });
    return toList;
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "id_user1": id_user1,
        "id_user2": id_user2,
        "timestamp": timestamp,
        //Usuario 1
        'name_user1': nameUser1,
        'lastname_user1': lastnameUser1,
        'email_user1': emailUser1,
        'phone_user1': phoneUser1,
        'image_user1': imageUser1,
        'notification_token_user1': notification_tokenUser1,
        // Usuario 2
        'name_user2': nameUser2,
        'lastname_user2': lastnameUser2,
        'email_user2': emailUser2,
        'phone_user2': phoneUser2,
        'image_user2': imageUser2,
        'notification_token_user2': notification_tokenUser2,
        'last_message': last_message,
        'unread_messages': unread_messages,
        'last_message_timestamp': last_message_timestamp,
      };
}
