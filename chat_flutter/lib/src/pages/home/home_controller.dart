import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../../api/environment.dart';
import '../../models/user.dart';
import '../../utils/push_notification_provider.dart';

class home_controller extends GetxController {
  GetStorage storage = GetStorage();
  User user = User.fromJson(GetStorage().read('user') ?? {});
  PushNotificationProvider pushNotificationProvider =
      PushNotificationProvider();
  var tabIndex = 0.obs;

  Socket socket = io('${Enviroment.API_CHAT}chat', <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': false
  });

  void saveToken() {
    if (user.id != null) {
      pushNotificationProvider.saveToken(user.id!);
    }
  }

  void connectAndListen() {
    if (user.id != null) {
      socket.connect();
      socket.onConnect((data) {
        emitOnLine();
        print('Usuario conectado al socket');
      });
    }
  }

  void emitOnLine() {
    socket.emit('online', {'id_user': user.id});
  }

  home_controller() {
    connectAndListen();
    saveToken();
    print('Usuario de sesion ${user.toJson()}');
  }

  void chageTabindex(int index) {
    tabIndex.value = index;
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    socket.disconnect();
  }
}
