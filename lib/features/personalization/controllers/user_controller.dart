import 'package:get/get.dart';

import '../../../data/repositories/mongodb/user/user_repositories.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();

  final mongoUserRepository = Get.put(MongoUserRepository());

}