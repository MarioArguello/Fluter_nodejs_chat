import 'dart:io';
import 'dart:convert';
import 'package:chat_flutter/src/api/environment.dart';
import 'package:chat_flutter/src/models/response_api.dart';
import 'package:chat_flutter/src/models/user.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;

class UserProvider extends GetConnect {
  User userStorage = User.fromJson(GetStorage().read('user') ?? {});
  String url = Enviroment.API_CHAT + 'api/users/';

  Future<Response> create(User user) async {
    Response response = await post(url + 'create', user.toJson(),
        headers: {'Content-Type': 'application/json'});
    return response;
  }

  Future<Response> checkIfIsOnline(String idUser) async {
    Response response = await get(url + 'checkIfIsOnline/' + idUser, headers: {
      'Content-Type': 'application/json',
      'Authorization': userStorage.sessionToken!
    });

    return response;
  }

  Future<List<User>> getUser() async {
    Response response = await get(url + 'getAll/${userStorage.id}', headers: {
      'Content-Type': 'application/json',
      'Authorization': userStorage.sessionToken!
    });
    if (response.statusCode == 401) {
      Get.snackbar('Peticion denegada',
          'Tu usuario no tiene permitido obtener esta informacion');
      return [];
    }
    if (response.body == null) {
      Get.snackbar('Error', 'Lista vacia');
      return [];
    }
    List<User> users = User.fromJsonList(response.body);
    return users;
  }

  Future<ResponseApi> getCorreoPerson(String email) async {
    Response response = await post('${url}correoperson', {'email': email},
        headers: {'Content-Type': 'application/json'});
    if (response.body == null) {
      Get.snackbar('Error', 'No se pudo ejecutar la peticion de login');
      return ResponseApi();
    }
    ResponseApi responseApi = ResponseApi.fromJson(response.body);
    return responseApi;
  }

  Future<ResponseApi> enviarcodeCorreo(String email, String code) async {
    Response response = await post(
        '${url}gmailSend', {'emailperson': email, 'code': code},
        headers: {'Content-Type': 'application/json'});
    if (response.body == null) {
      Get.snackbar('Error', 'No se pudo ejecutar la peticion de login');
      return ResponseApi();
    }
    ResponseApi responseApi = ResponseApi.fromJson(response.body);
    return responseApi;
  }

  Future<List<User>> getUserPerson(String name) async {
    Response response = await get(url + 'getPerson/${userStorage.id}/$name',
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
      Get.snackbar('Error', 'Lista vacia');
      return [];
    }
    List<User> users = User.fromJsonList(response.body);
    return users;
  }

// update sin imagen
  Future<ResponseApi> updateUser(User user) async {
    Response response = await put(url + 'updateUser', user.toJson(), headers: {
      'Content-Type': 'application/json',
      'Authorization': userStorage.sessionToken!
    });
    if (response.body == null) {
      Get.snackbar('Error', 'No se pudo actualizar el usuario');
      return ResponseApi();
    }
    ResponseApi responseApi = ResponseApi.fromJson(response.body);
    return responseApi;
  }

  Future<Stream> Update_user_double_image(User user, List<File> images) async {
    Uri uri =
        Uri.http(Enviroment.API_CHAT_old, 'api/users/updateWithDoubleImage');
    final request = http.MultipartRequest('PUT', uri);
    request.headers['Authorization'] = userStorage.sessionToken ?? '';

    for (int i = 0; i < images.length; i++) {
      request.files.add(http.MultipartFile(
          'image',
          http.ByteStream(images[i].openRead().cast()),
          await images[i].length(),
          filename: basename(images[i].path)));
    }

    request.fields['user'] = json.encode(user);
    final response = await request.send();
    return response.stream.transform(utf8.decoder);
  }

// update sin imagen
  Future<ResponseApi> updateNotificationTOken(
      String id_user, String token) async {
    Response response = await put(url + 'updateNotificationToken', {
      'id': id_user,
      'notification_token': token
    }, headers: {
      'Content-Type': 'application/json',
      'Authorization': userStorage.sessionToken!
    });
    if (response.body == null) {
      Get.snackbar('Error', 'No se pudo actualizar el token');
      return ResponseApi();
    }
    ResponseApi responseApi = ResponseApi.fromJson(response.body);
    return responseApi;
  }

// subir imagenes pesadas
  Future<Stream> createWithImage(User user, File image) async {
    Uri url = Uri.http(Enviroment.API_CHAT_old, '/api/users/create');
    final request = http.MultipartRequest('POST', url);
    request.files.add(http.MultipartFile(
        'image', http.ByteStream(image.openRead().cast()), await image.length(),
        filename: basename(image.path)));
    request.fields['user'] = json.encode(user);
    final response = await request.send();
    return response.stream.transform(utf8.decoder);
  }

// update with image
  Future<Stream> updateWithImage(User user, File image, String tipo) async {
    Uri url = Uri.http(Enviroment.API_CHAT_old, '/api/users/updateWithImage');
    final request = http.MultipartRequest('PUT', url);
    request.headers['Authorization'] = userStorage.sessionToken!;
    request.files.add(http.MultipartFile(
        'image', http.ByteStream(image.openRead().cast()), await image.length(),
        filename: basename(image.path)));
    request.fields['user'] = json.encode(user);
    request.fields['tipo'] = tipo;
    final response = await request.send();
    return response.stream.transform(utf8.decoder);
  }

//usando getX no se puede subir imagenes pesadas, no las valida
  Future<ResponseApi> createUserWithImage(User user, File image) async {
    FormData form = FormData({
      'image': MultipartFile(image, filename: basename(image.path)),
      'user': json.encode(user)
    });
    Response response = await post(url + 'create', form);
    if (response.body == null) {
      Get.snackbar('Error', 'No se pudo crear el usuario');
      return ResponseApi();
    }
    ResponseApi responseApi = ResponseApi.fromJson(response.body);
    return responseApi;
  }

  Future<ResponseApi> Login(String email, String password) async {
    Response response = await post(
        '${url}login', {'email': email, 'password': password},
        headers: {'Content-Type': 'application/json'});
    if (response.body == null) {
      Get.snackbar('Error', 'No se pudo ejecutar la peticion de login');
      return ResponseApi();
    }
    ResponseApi responseApi = ResponseApi.fromJson(response.body);
    return responseApi;
  }
}
