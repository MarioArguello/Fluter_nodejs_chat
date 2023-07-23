import 'package:chat_flutter/src/models/response_api.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../api/environment.dart';
import '../models/Chat.dart';
import '../models/user.dart';

class ChatProvider extends GetConnect {
  User userStorage = User.fromJson(GetStorage().read('user') ?? {});
  String url = Enviroment.API_CHAT + 'api/chat/';

  Future<ResponseApi> createChat(Chat chat) async {
    Response response = await post(url + 'create', chat.toJson(), headers: {
      'Content-Type': 'application/json',
      'Authorization': userStorage.sessionToken!
    });
    if (response.body == null) {
      Get.snackbar('Error', 'No se pudo enviar sms');
      return ResponseApi();
    }
    ResponseApi responseApi = ResponseApi.fromJson(response.body);
    return responseApi;
  }

  Future<List<Chat>> getChat() async {
    Response response = await get(url + 'findBYidUser/${userStorage.id}',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': userStorage.sessionToken!
        });
    if (response.statusCode == 401) {
      Get.snackbar('Peticion denegada',
          'Tu usuario no tiene permitido obtener esta informacion');
      return [];
    }
    if (response.body == null) {
      return [];
    }
    List<Chat> chat = Chat.fromJsonList(response.body);
    return chat;
  }
}
