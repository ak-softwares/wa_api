import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../common/dialog_box_massages/dialog_massage.dart';
import '../../../../common/dialog_box_massages/snack_bar_massages.dart';
import '../../../../data/repositories/mongodb/authentication/authentication_repositories.dart';
import '../../../../utils/constants/local_storage_constants.dart';
import '../../../../utils/exceptions/firebase_auth_exceptions.dart';
import '../../../../utils/exceptions/format_exceptions.dart';
import '../../../../utils/helpers/navigation_helper.dart';
import '../../../personalization/models/user_model.dart';

class AuthenticationController extends GetxController {
  static AuthenticationController get instance => Get.find();

  RxBool isLoading = false.obs;
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();
  RxBool isAdminLogin = false.obs;
  final int loginExpiryInDays = 90;

  final localStorage = GetStorage();
  Rx<UserModel> user = UserModel().obs;
  final _auth = FirebaseAuth.instance;


  final hidePassword = true.obs; //Observable for hiding/showing password
  final imageUploading = false.obs;
  final verifyEmail = TextEditingController();
  final verifyPassword = TextEditingController();
  GlobalKey<FormState> reAuthFormKey = GlobalKey<FormState>();

  final mongoAuthenticationRepository = Get.put(MongoAuthenticationRepository());

  @override
  void onInit() {
    super.onInit();
    checkIsAdminLogin();
  }

  // Check if the user is logged in
  Future<void> checkIsAdminLogin() async {
    final String localAuthUserToken = await fetchLocalAuthToken();
    if (localAuthUserToken.isNotEmpty) {
      isAdminLogin.value = true;
      user.value = await loadUserFromLocal() ?? UserModel();
    }
  }

  Future<String> getUserId() async {
    final String localAuthUserToken = await fetchLocalAuthToken();
    if (localAuthUserToken.isNotEmpty) {
      return localAuthUserToken;
    } else{
      throw 'User not found';
    }
  }

  String get userId {
    if (!isAdminLogin.value || user.value.id == null || user.value.id!.isEmpty) {
      throw Exception("User not authenticated.");
    }
    return user.value.id!;
  }

  Future<String> fetchLocalAuthToken() async {
    final String? authToken = await secureStorage.read(key: LocalStorageName.authUserID);
    final String? expiryString = await secureStorage.read(key: LocalStorageName.loginExpiry);

    // Check if both values exist
    if (authToken == null || authToken.isEmpty || expiryString == null || expiryString.isEmpty) {
      return '';
    }

    // Parse expiry date
    final DateTime expiry = DateTime.tryParse(expiryString) ?? DateTime.fromMillisecondsSinceEpoch(0);

    // Check if current time is before expiry
    if (DateTime.now().isBefore(expiry)) {
      return authToken;
    } else {
      // Expired – clean up stored data
      await deleteLocalAuthToken();
      return '';
    }
  }

  Future<void> saveLocalAuthToken(String token) async {
    // Store user ID and login expiry
    final String expiry = DateTime.now().add(Duration(days: loginExpiryInDays)).toIso8601String();
    await secureStorage.write(key: LocalStorageName.authUserID, value: token);
    await secureStorage.write(key: LocalStorageName.loginExpiry, value: expiry);
  }

  Future<void> deleteLocalAuthToken() async {
    await secureStorage.delete(key: LocalStorageName.authUserID);
    await secureStorage.delete(key: LocalStorageName.loginExpiry);
    await removeUserFromLocal();
  }

  // Fetch user record
  Future<void> fetchUser() async {
    try {
      final String localAuthUserToken = await fetchLocalAuthToken();
      if (localAuthUserToken.isNotEmpty) { // Check if token is valid
        final userData = await mongoAuthenticationRepository.fetchUserById(userId: localAuthUserToken);
        user(userData);
      } else{
        throw 'User not found';
      }
    } catch (error) {
      rethrow;
    }
  }

  // Refresh Customer data
  Future<void> refreshUser() async {
    try {
      isLoading(true);
      user(UserModel());
      await fetchUser();
    } catch (error) {
      AppMassages.warningSnackBar(title: 'Error', message: error.toString());
    } finally {
      isLoading(false);
    }
  }

  Future<void> showDialogDeleteAccount({required BuildContext context}) async {
    try {
      DialogHelper.showDialog(
        context: context,
        title: 'Delete Account',
        message: 'Are you sure you want to delete your account permanently? This Action is not reversible and all of your data will be removed permanently',
        toastMessage: 'Your Account Deleted successfully!',
        onSubmit: () async => await mongoDeleteAccount(),
        actionButtonText: 'Delete Account'
      );
    } catch (error) {
      AppMassages.errorSnackBar(title: 'Error', message: error.toString());
    }
  }

  Future<void> mongoDeleteAccount() async {
    try {
      await mongoAuthenticationRepository.deleteUser(id: user.value.id.toString());
      await logout();
    } catch (error) {
      AppMassages.errorSnackBar(title: 'Error', message: error.toString());
    }
  }

  // this function run after successfully login
  Future<void> login({required UserModel user}) async {
    this.user.value = user; //update user value
    isAdminLogin.value = true; //make user login
    saveLocalAuthToken(user.id!);
    await saveUserFromLocal(user);
    await Future.delayed(Duration(milliseconds: 300)); // Add delay
    NavigationHelper.navigateToBottomNavigation(); //navigate to other screen
  }

  //this function for logout
  Future<void> logout() async {
    try {
      await GoogleSignIn().signOut();
      await _auth.signOut();
      await deleteLocalAuthToken();
      isAdminLogin.value = false;
      user.value = UserModel();
      NavigationHelper.navigateToLoginScreen();
    }
    on FirebaseAuthException catch (error) {
      throw TFirebaseAuthException(error.code).message;
    } on FirebaseException catch (error) {
      throw TFirebaseAuthException(error.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (error) {
      throw TFirebaseAuthException(error.code).message;
    }
    catch (error) {
      throw 'Something went wrong. Please try again $error';
    }
  }


  Future<void> saveUserFromLocal(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = jsonEncode(user.toMap(isLocal: true));
    await prefs.setString(LocalStorageName.userData, userJson);
  }

  Future<UserModel?> loadUserFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(LocalStorageName.userData);
    if (userJson != null) {
      final Map<String, dynamic> jsonMap = jsonDecode(userJson);
      return UserModel.fromJson(jsonMap, isLocal: true);
    }
    return null;
  }

  Future<void> removeUserFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(LocalStorageName.userData);
  }


}