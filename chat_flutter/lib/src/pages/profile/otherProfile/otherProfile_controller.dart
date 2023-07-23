import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../models/user.dart';

class otherprofilecontroller extends GetxController {
  User userChat = User.fromJson(GetStorage().read('messagesend') ?? {});
  GetStorage storage = GetStorage();
  void goToChatMessage() {
    print('Usuario chat mensaje: ${userChat.toJson()}');
    Get.toNamed('/message');
  }
}
