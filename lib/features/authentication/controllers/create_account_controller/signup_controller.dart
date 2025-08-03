import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../common/dialog_box_massages/full_screen_loader.dart';
import '../../../../common/dialog_box_massages/snack_bar_massages.dart';
import '../../../../common/widgets/network_manager/network_manager.dart';
import '../../../../data/repositories/mongodb/authentication/authentication_repositories.dart';
import '../../../../utils/constants/enums.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/local_storage_constants.dart';
import '../../../../utils/helpers/encryption_hepler.dart';
import '../authentication_controller/authentication_controller.dart';
import '../../../personalization/models/user_model.dart';
import '../login_controller/login_controller.dart';

class SignupController extends GetxController{
  static SignupController get instance => Get.find();

  // Variables
  final localStorage = GetStorage();
  final hidePassword = true.obs; //Observable for hiding/showing password
  final name = TextEditingController();
  final email     = TextEditingController();
  final password  = TextEditingController();
  final phone     = TextEditingController();
  GlobalKey<FormState> signupFormKey = GlobalKey<FormState>(); //Form key for form validation

  final userController = Get.put(AuthenticationController());
  final mongoAuthenticationRepository = Get.put(MongoAuthenticationRepository());

  void signupWithEmailPassword() async {
    try {
      // Start Loading
      FullScreenLoader.openLoadingDialog('We are creating account..', Images.docerAnimation);
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        FullScreenLoader.stopLoading();
        return;
      }
      if(!signupFormKey.currentState!.validate()) {
        FullScreenLoader.stopLoading();
        return;
      }

      UserModel user = UserModel(
        name: name.text.trim(),
        email: email.text.trim(),
        password: password.text.trim(),
        phone: phone.text.trim(),
        dateCreated: DateTime.now(),
      );

      final String id = await mongoAuthenticationRepository.singUpWithEmailAndPass(user: user);
      user.id = id;

      // save to local storage
      localStorage.write(LocalStorageName.rememberMeEmail, email.text.trim());
      localStorage.write(LocalStorageName.rememberMePassword, password.text);

      FullScreenLoader.stopLoading();
      await userController.login(user: user);
    } catch (error) {
      FullScreenLoader.stopLoading();
      AppMassages.errorSnackBar(title: 'Oh Snap!', message: error.toString());
    }
  }

}




