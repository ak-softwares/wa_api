import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/dialog_box_massages/full_screen_loader.dart';
import '../../../../common/dialog_box_massages/snack_bar_massages.dart';
import '../../../../common/widgets/network_manager/network_manager.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../screens/email_login/reset_password_screen.dart';

class ForgetPasswordController extends GetxController{
  static ForgetPasswordController get instance => Get.find();

  // variables
  RxString countryISO = ''.obs;
  RxBool isLoading = false.obs;
  RxBool showOTPField = false.obs;
  final phoneNumber = TextEditingController();
  final countryCode = TextEditingController();
  final otp = TextEditingController();
  GlobalKey<FormState> forgetPasswordFormKey = GlobalKey<FormState>(); //Form key for form validation

  @override
  void onInit() {
    super.onInit();
    showOTPField(false);
  }

  @override
  dispose() {
    super.dispose();
    showOTPField(false);
  }

}


