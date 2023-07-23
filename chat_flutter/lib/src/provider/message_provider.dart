import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:chat_flutter/src/models/response_api.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../api/environment.dart';
import '../models/Message.dart';
import '../models/user.dart';
import 'dart:convert';
import 'package:path/path.dart';

class MessageProvider extends GetConnect {
  User userStorage = User.fromJson(GetStorage().read('user') ?? {});
  String url = Enviroment.API_CHAT + 'api/message/';

// subir imagenes pesadas
  Future<Stream> createWithImageMessage(Message message, File image) async {
    Uri url = Uri.http(Enviroment.API_CHAT_old, '/api/message/createWithImage');
    final request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = userStorage.sessionToken!;
    request.files.add(http.MultipartFile(
        'image', http.ByteStream(image.openRead().cast()), await image.length(),
        filename: basename(image.path)));
    request.fields['message'] = json.encode(message);
    final response = await request.send();
    return response.stream.transform(utf8.decoder);
  }

// subir video
  Future<Stream> createWithVideoMessage(Message message, File video) async {
    Uri url = Uri.http(Enviroment.API_CHAT_old, '/api/message/createWithVideo');
    final request = http.MultipartRequest('POST', url);
    request.headers['Authorization'] = userStorage.sessionToken!;
    request.files.add(http.MultipartFile(
        'video', http.ByteStream(video.openRead().cast()), await video.length(),
        filename: basename(video.path)));
    request.fields['message'] = json.encode(message);
    final response = await request.send();
    return response.stream.transform(utf8.decoder);
  }

  Future<ResponseApi> createMessage(Message mesage) async {
    Response response = await post(url + 'create', mesage.toJson(), headers: {
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

  Future<List<Message>> getMessage(String id_chat) async {
    Response response = await get(url + 'findByChat/${id_chat}', headers: {
      'Content-Type': 'application/json',
      'Authorization': userStorage.sessionToken!
    });
    if (response.statusCode == 401) {
      Get.snackbar('Peticion denegada',
          'Tu usuario no tiene permitido obtener esta informacion');
      return [];
    }
    List<Message> message = Message.fromJsonList(response.body);
    return message;
  }

  Future<ResponseApi> updateMessageSeen(String id) async {
    Response response = await put(url + 'updatetoSeen', {
      'id': id
    }, headers: {
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

  Future<ResponseApi> updateMessageRecived(String id) async {
    Response response = await put(url + 'updatetoRecived', {
      'id': id
    }, headers: {
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
}
