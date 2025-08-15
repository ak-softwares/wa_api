import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/dialog_box_massages/snack_bar_massages.dart';
import '../../../../data/repositories/mongodb/authentication/authentication_repositories.dart';
import '../../../personalization/models/user_model.dart';
import '../authentication_controller/authentication_controller.dart';

class ResetPasswordController extends GetxController {

  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isObscure = true.obs;
  final isConfirmObscure = true.obs;

  void togglePasswordVisibility() => isObscure.value = !isObscure.value;
  void toggleConfirmPasswordVisibility() => isConfirmObscure.value = !isConfirmObscure.value;

  final mongoAuthenticationRepository = Get.put(MongoAuthenticationRepository());
  final userController = Get.put(AuthenticationController());

  Future<void> submit({required UserModel user}) async {
    try{
      if (passwordController.text.isEmpty || confirmPasswordController.text.isEmpty) {
        throw Exception("Please fill in all fields");
      }

      if (passwordController.text != confirmPasswordController.text) {
        throw Exception("Passwords do not match");
      }

      // update single field user
      final updatedUser = UserModel(
          password: passwordController.text.trim()
      );
      await mongoAuthenticationRepository.updateUserById(id: user.id!, user: updatedUser);

      AppMassages.successSnackBar(title: 'Success', message: "Password reset successfully");
      await userController.login(user: user);
    }catch(e){
      AppMassages.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }

  }

  @override
  void onClose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
