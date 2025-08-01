import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../common/dialog_box_massages/full_screen_loader.dart';
import '../../../common/dialog_box_massages/snack_bar_massages.dart';
import '../../../common/widgets/network_manager/network_manager.dart';
import '../../../data/repositories/mongodb/authentication/authentication_repositories.dart';
import '../../../utils/constants/image_strings.dart';
import '../../authentication/controllers/authentication_controller/authentication_controller.dart';
import '../../personalization/models/user_model.dart';
import '../models/fb_api_credentials.dart';
import '../models/mongo_db_credentials.dart';

class FBApiSetupController extends GetxController {
  static FBApiSetupController get instance => Get.find();

  final accessToken = TextEditingController();
  final phoneNumberID = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final mongoAuthenticationRepository = Get.put(MongoAuthenticationRepository());
  final auth = Get.put(AuthenticationController());

  @override
  void onInit() {
    super.onInit();
    initialize();
  }

  void initialize() {
    accessToken.text = auth.user.value.fBApiCredentials?.accessToken ?? '';
    phoneNumberID.text = auth.user.value.fBApiCredentials?.phoneNumberID ?? '';
  }

  Future<void> saveFBApiData() async {
    try {
      //Start Loading
      FullScreenLoader.openLoadingDialog('We are uploading your information..', Images.docerAnimation);
      //check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        FullScreenLoader.stopLoading();
        return;
      }
      // Form Validation
      if (!formKey.currentState!.validate()) {
        FullScreenLoader.stopLoading();
        return;
      }

      final fBApiCredentials = FBApiCredentials(
        accessToken: accessToken.text.trim(),
        phoneNumberID: phoneNumberID.text.trim(),
      );

      final userData = UserModel(
        fBApiCredentials: fBApiCredentials,
      );

      await mongoAuthenticationRepository.updateUserById(id: auth.userId, user: userData);

      await auth.refreshUser();
      // remove Loader
      FullScreenLoader.stopLoading();

      // UserController.instance.fetchUserRecord();
      AppMassages.showToastMessage(message: 'Details updated successfully!');
      // move to next screen
      Get.close(1);
    } catch (error) {
      //remove Loader
      FullScreenLoader.stopLoading();
      AppMassages.errorSnackBar(title: 'Error', message: error.toString());
    }
  }

}