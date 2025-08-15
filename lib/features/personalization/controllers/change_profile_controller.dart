import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../common/dialog_box_massages/full_screen_loader.dart';
import '../../../common/dialog_box_massages/snack_bar_massages.dart';
import '../../../common/widgets/network_manager/network_manager.dart';
import '../../../data/repositories/mongodb/authentication/authentication_repositories.dart';
import '../../../utils/constants/enums.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/constants/local_storage_constants.dart';
import '../../../utils/data/state_iso_code_map.dart';
import '../../../utils/formatters/formatters.dart';
import '../../../utils/validators/validation.dart';
import '../models/user_model.dart';
import '../../authentication/controllers/authentication_controller/authentication_controller.dart';
import '../screens/user_profile_info/user_profile_info.dart';

class ChangeProfileController extends GetxController {
  static ChangeProfileController get instance => Get.find();

  // variables
  final name = TextEditingController();
  final email = TextEditingController();
  final phoneNumber = TextEditingController();
  final countryCode = TextEditingController();
  RxString countryISO = ''.obs;

  GlobalKey<FormState> changeProfileFormKey = GlobalKey<FormState>();

  final localStorage = GetStorage();
  final auth = Get.put(AuthenticationController());
  final mongoAuthenticationRepository = Get.put(MongoAuthenticationRepository());

  @override
  onInit() {
    super.onInit();
    _initialized();
  }

  Future<void> _initialized() async {
    name.text = auth.user.value.name ?? '';
    email.text = auth.user.value.email ?? '';
    await CountryData.loadFromAssets(); // MUST await

    var c = CountryData.fromFullNumber(auth.user.value.phone ?? '');
    phoneNumber.text = c?.phoneNumber ?? '';
    countryCode.text = c?.dialCode ?? '';
    countryISO.value = c?.iso ?? 'IN';
  }

  // Mongo update profile details
  Future<void> mongoChangeProfileDetails() async {
    try {
      //Start Loading
      FullScreenLoader.openLoadingDialog('We are updating your information..', Images.docerAnimation);
      //check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        FullScreenLoader.stopLoading();
        return;
      }
      // Form Validation
      if (!changeProfileFormKey.currentState!.validate()) {
        FullScreenLoader.stopLoading();
        return;
      }

      String fullPhoneNumber = AppFormatter.formatPhoneNumberForWhatsAppOTP(countryCode: countryCode.text.trim(), phoneNumber: phoneNumber.text.trim());

      // update single field user
      final updatedUser = UserModel(
          name: name.text.trim(),
          email: email.text.trim(),
          phone: fullPhoneNumber,
      );
      await mongoAuthenticationRepository.updateUserProfile(id: auth.userId, newUser: updatedUser, oldUser: auth.user.value);

      // update the Rx user value
      auth.user(updatedUser);

      // update email to local storage too
      localStorage.write(LocalStorageName.rememberMeEmail, email.text.trim());

      //remove Loader
      FullScreenLoader.stopLoading();

      // UserController.instance.fetchUserRecord();
      AppMassages.showToastMessage(message: 'Details updated successfully!');
      // move to next screen
      Get.close(1);
      Get.off(() => const UserProfileInfo());
    } catch (error) {
      //remove Loader
      FullScreenLoader.stopLoading();
      AppMassages.errorSnackBar(title: 'Error', message: error.toString());
    }
  }


}

