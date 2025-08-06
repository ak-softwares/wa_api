import 'package:get/get.dart';

import '../../../../common/dialog_box_massages/full_screen_loader.dart';
import '../../../../common/dialog_box_massages/snack_bar_massages.dart';
import '../../../../common/widgets/network_manager/network_manager.dart';
import '../../../../data/repositories/firebase/authentication/firebase_auth_repository.dart';
import '../../../../data/repositories/mongodb/authentication/authentication_repositories.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../personalization/models/user_model.dart';
import '../authentication_controller/authentication_controller.dart';
import '../login_controller/login_controller.dart';

class SocialLoginController extends GetxController{
  static SocialLoginController get instance => Get.find();

  final mongoAuthenticationRepository = Get.put(MongoAuthenticationRepository());
  final userController = Get.put(AuthenticationController());
  final firebaseAuthRepository = Get.put(FirebaseAuthRepository());

  //Google SignIn Authentication
  Future<void> signInWithGoogle() async {
    String googleEmail = ''; // Initialize with an empty string
    try {
      // Start Loading
      FullScreenLoader.openLoadingDialog('Logging you in...', Images.docerAnimation);
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        FullScreenLoader.stopLoading();
        return;
      }
      // Google Authentication
      final userCredentials = await firebaseAuthRepository.signInWithGoogle();
      googleEmail = userCredentials.user?.email ?? ''; // Assign the value here
      final UserModel user = await mongoAuthenticationRepository.fetchUserByEmail(email: googleEmail);

      FullScreenLoader.stopLoading();
      userController.login(user: user);
    } catch (error) {
      // Remove Loader
      FullScreenLoader.stopLoading();
      userController.logout();
      AppMassages.errorSnackBar(title: 'Error', message: error.toString());
    }
  }
}
