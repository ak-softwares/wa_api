import 'package:get/get.dart';

import '../common/widgets/network_manager/network_manager.dart';
import '../features/authentication/controllers/authentication_controller/authentication_controller.dart';

class GeneralBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NetworkManager());
    Get.lazyPut(() => AuthenticationController());
  }
}