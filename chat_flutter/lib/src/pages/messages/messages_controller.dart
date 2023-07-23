import 'dart:convert';
import 'dart:io';
import 'package:chat_flutter/src/models/Message.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:chat_flutter/src/models/response_api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import '../../models/Chat.dart';
import '../../models/user.dart';
import '../../provider/chat_provider.dart';
import '../../provider/message_provider.dart';
import '../../provider/user_provider.dart';
import '../../utils/my_colors.dart';
import '../../utils/push_notification_provider.dart';
import '../chats/chatController.dart';
import '../home/home_controller.dart';

class MessageController extends GetxController {
  User myUser = User.fromJson(GetStorage().read('user') ?? {});
  User userChat = User.fromJson(GetStorage().read('messagesend') ?? {});

  var isWriting = false.obs;
  var isOnline = false.obs;
  ChatProvider chatProvider = ChatProvider();
  MessageProvider messagesProvider = MessageProvider();
  String idChat = '';
  File? imageFile;
  ImagePicker picker = ImagePicker();
  List<Message> messages = <Message>[].obs; // Getx obs
  ScrollController scrollController = ScrollController();
  home_controller homeController = Get.find();
  PushNotificationProvider pushNotificationProvider =
      PushNotificationProvider();

  TextEditingController messageController = TextEditingController();

  UserProvider usersProvider = UserProvider();
  ChatController chatsController = Get.put(ChatController());

  String idSocket = '';

  MessageController() {
    print('Usuario chat: ${userChat.toJson()}');
    createChat();
    checkIfIsOnline();
  }

  void sendNotification(String message, String idMessage, {url = ''}) {
    Map<String, dynamic> data = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'title': '${myUser.name} ${myUser.lastname}',
      'body': message,
      'id_message': idMessage,
      'id_chat': idChat,
      'url': url
    };

    pushNotificationProvider.sendMessage(
        userChat.notification_token ?? '', data);
  }

  void listenMessage() {
    homeController.socket.on('message/$idChat', (data) {
      print('DATA EMITIDA $data');
      getMessages();
    });
  }

  void listenOnline() {
    homeController.socket.off('online/${userChat.id}');
    homeController.socket.on('online/${userChat.id}', (data) {
      print('DATA EMITIDA $data');
      isOnline.value = true;
      idSocket = data['id_socket'];
      listenOffline();
    });
  }

  void listenOffline() async {
    if (idSocket.isNotEmpty) {
      homeController.socket.off('offline/$idSocket');
      homeController.socket.on('offline/$idSocket', (data) {
        print('INGRESO A DESCONECTADO ${data}');
        if (idSocket == data['id_socket']) {
          isOnline.value = false;
          homeController.socket.off('offline/$idSocket');
        }
      });
    }
  }

  void listenMessageSeen() {
    homeController.socket.on('seen/$idChat', (data) {
      print('DATA EMITIDA $data');
      getMessages();
    });
  }

  void listenMessageReceived() {
    homeController.socket.on('received/$idChat', (data) {
      print('DATA EMITIDA $data');
      getMessages();
    });
  }

  void listenWriting() {
    homeController.socket.on('writing/$idChat/${userChat.id}', (data) {
      print('DATA EMITIDA $data');
      isWriting.value = true;
      Future.delayed(Duration(milliseconds: 2000), () {
        isWriting.value = false;
      });
    });
  }

  void emitMessage() {
    homeController.socket
        .emit('message', {'id_chat': idChat, 'id_user': userChat.id});
    getMessages();
  }

  void emitMessageSeen() {
    homeController.socket.emit('seen', {'id_chat': idChat});
  }

  void emitWriting() {
    homeController.socket.emit('writing', {
      'id_chat': idChat,
      'id_user': myUser.id,
    });
  }

  void getChats() async {
    var result = await chatProvider.getChat();
    chatsController.chat.clear();
    chatsController.chat.addAll(result);
  }

  void getMessages() async {
    var result = await messagesProvider.getMessage(idChat);
    messages.clear();
    messages.addAll(result);

    messages.forEach((m) async {
      if (m.status != 'VISTO' && m.idReceiver == myUser.id) {
        await messagesProvider.updateMessageSeen(m.id!);
        emitMessageSeen();
      }
    });

    getChats();

    Future.delayed(Duration(milliseconds: 100), () {
      scrollController.jumpTo(scrollController.position.minScrollExtent);
    });
  }

  void checkIfIsOnline() async {
    Response response =
        await usersProvider.checkIfIsOnline(userChat.id ?? "null");
    print('online:......');
    print('online:....${response.body['online']}');
    if (response.body['online'] == true) {
      isOnline.value = true;
      idSocket = response.body['id_socket'];
      listenOnline();
    } else {
      isOnline.value = false;
    }
  }

  void createChat() async {
    Chat chat = Chat(id_user1: myUser.id, id_user2: userChat.id);

    ResponseApi responseApi = await chatProvider.createChat(chat);

    if (responseApi.success == true) {
      idChat = responseApi.data as String;
      getMessages();
      listenMessage();
      listenWriting();
      listenMessageSeen();
      listenOffline();
      listenMessageReceived();
    }
    Get.snackbar('Chat creado', responseApi.message ?? 'Error en la respuesta');
  }

  void sendMessage() async {
    String messageText = messageController.text;

    if (messageText.isEmpty) {
      Get.snackbar('Texto vacio', 'Ingresa el mensaje que quieres enviar');
      return;
    }

    if (idChat == '') {
      Get.snackbar('Error', 'No se pudo enviar el mensaje');
      return;
    }

    Message message = Message(
        message: messageText,
        idSender: myUser.id,
        idReceiver: userChat.id,
        idChat: idChat,
        isImage: false,
        isVideo: false);

    ResponseApi responseApi = await messagesProvider.createMessage(message);

    if (responseApi.success == true) {
      messageController.text = '';
      emitMessage();
      sendNotification(messageText, responseApi.data as String);
    }
  }

  Future<File?> compresAndGetFile(File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path, targetPath,
        quality: 80);
    return result;
  }

  Future SelectImage(ImageSource imageSource, BuildContext context) async {
    final XFile? image = await picker.pickImage(source: imageSource);
    if (image != null) {
      ProgressDialog pd = ProgressDialog(context: context);

      imageFile = File(image.path);
      final dir = await path_provider.getTemporaryDirectory();
      final targetPath = dir.absolute.path + '/temp.jpg';
      pd.show(
        max: 100,
        msg: 'Subiendo imagen...',
        progressValueColor: MyColors.primaryColors,
      );

      File? compresFile = await compresAndGetFile(imageFile!, targetPath);

      Message messageImage = Message(
          message: 'IMAGEN',
          idSender: myUser.id,
          idReceiver: userChat.id,
          idChat: idChat,
          isImage: true,
          isVideo: false);
      Stream stream = await messagesProvider.createWithImageMessage(
          messageImage, compresFile!);
      stream.listen((res) {
        pd.close();
        ResponseApi responseApi = ResponseApi.fromJson(json.decode(res));
        if (responseApi.success == true) {
          sendNotification(
            '📷Imagen',
            responseApi.data['id'] as String,
            url: responseApi.data['url'] as String,
          );
          emitMessage();
          Get.snackbar('Mensaje', 'Se a creado un message con imagen');
        }
      });
    }
  }

  void showAlertDialog(BuildContext context) {
    Widget galleryButton = ElevatedButton(
        onPressed: () {
          Get.back();
          SelectImage(ImageSource.gallery, context);
        },
        child: Text('Galeria'));
    Widget camaraButton = ElevatedButton(
        onPressed: () {
          Get.back();
          SelectImage(ImageSource.camera, context);
        },
        child: Text('Camara'));
    AlertDialog alertDialog = AlertDialog(
        insetPadding: EdgeInsets.all(8),
        elevation: 10,
        titlePadding: const EdgeInsets.all(0.0),
        title: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _getCloseButton(context),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: Column(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        child: CircleAvatar(
                          backgroundImage: imageFile != null
                              ? FileImage(imageFile!)
                              : const AssetImage('assets/img/upload.png')
                                  as ImageProvider,
                          radius: 60,
                          backgroundColor: Colors.grey[300],
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        imageFile != null
                            ? "Cambiar imagen"
                            : "Selecciona tu imagen",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.normal),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        actions: [galleryButton, camaraButton],
        actionsAlignment: MainAxisAlignment.center);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  Future SelectVideo(ImageSource imageSource, BuildContext context) async {
    final XFile? video = await picker.pickVideo(source: imageSource);
    if (video != null) {
      File videoFile = File(video.path);

      ProgressDialog pd = ProgressDialog(context: context);

      pd.show(
        max: 100,
        msg: 'Subiendo video...',
        progressValueColor: MyColors.primaryColors,
      );

      Message messageImage = Message(
          message: 'VIDEO',
          idSender: myUser.id,
          idReceiver: userChat.id,
          idChat: idChat,
          isImage: false,
          isVideo: true);
      Stream stream = await messagesProvider.createWithVideoMessage(
          messageImage, videoFile);
      stream.listen((res) {
        ResponseApi responseApi = ResponseApi.fromJson(json.decode(res));
        if (responseApi.success == true) {
          sendNotification(
            '🎥Video',
            responseApi.data as String,
          );
          emitMessage();
          Get.snackbar('Mensaje', 'Se a creado un message con video');
          pd.close();
        } else {
          Get.snackbar('Mensaje error', 'No se a enviado el message con video');
          pd.close();
        }
      });
    }
  }

  void showAlertDialogVideo(BuildContext context) {
    Widget galleryButton = ElevatedButton(
        onPressed: () {
          Get.back();
          SelectVideo(ImageSource.gallery, context);
        },
        child: Text('Galeria'));
    Widget camaraButton = ElevatedButton(
        onPressed: () {
          Get.back();
          SelectVideo(ImageSource.camera, context);
        },
        child: Text('Camara'));
    AlertDialog alertDialog = AlertDialog(
        insetPadding: EdgeInsets.all(8),
        elevation: 10,
        titlePadding: const EdgeInsets.all(0.0),
        title: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _getCloseButton(context),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: Column(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        child: CircleAvatar(
                          backgroundImage:
                              AssetImage('assets/img/videochannel.gif')
                                  as ImageProvider,
                          radius: 60,
                          backgroundColor: Colors.grey[300],
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        "Subir video",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.normal),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        actions: [galleryButton, camaraButton],
        actionsAlignment: MainAxisAlignment.center);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }

  _getCloseButton(context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 10, 0),
      child: GestureDetector(
        onTap: () {},
        child: Container(
          alignment: FractionalOffset.topRight,
          child: GestureDetector(
            child: Icon(
              Icons.clear,
              color: Colors.red,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    scrollController.dispose();
    homeController.socket.off('message/$idChat');
    homeController.socket.off('seen/$idChat');
    homeController.socket.off('writing/$idChat/${userChat.id}');
  }
}
