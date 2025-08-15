import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../common/dialog_box_massages/snack_bar_massages.dart';
import '../../../../common/widgets/network_manager/network_manager.dart';
import '../../../../data/repositories/firebase/authentication/firebase_auth_repository.dart';
import '../../../../data/repositories/mongodb/authentication/authentication_repositories.dart';
import '../../../../data/repositories/whatsapp/authentication/whatsapp_auth_repo.dart';
import '../../../../utils/constants/local_storage_constants.dart';
import '../../../../utils/data/state_iso_code_map.dart';
import '../../../../utils/formatters/formatters.dart';
import '../../../personalization/models/user_model.dart';
import '../../../settings/app_settings.dart';

class OTPController extends GetxController {
  static OTPController get instance => Get.find();

  Rx<bool> isLoading = false.obs;
  Rx<bool> isSocialLogin = false.obs;
  RxBool showOTPField = false.obs;
  final countryCode = TextEditingController();
  RxString countryISO = ''.obs;
  final rememberMe = true.obs; //Observable for Remember me checked or not
  final phoneNumber = TextEditingController();
  final otp = TextEditingController();
  RxInt countdownTimer = 60.obs;
  final localStorage = GetStorage();
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  // Otp variables
  int otpLength = AppSettings.otpLength;
  String _generatedOtp = '';
  DateTime? _otpExpiry;
  int expiryTime = 10; // minutes

  // A map to store phone number and their request timestamps
  final Map<String, List<DateTime>> _otpRequestTimestamps = {};
  // Limit settings
  static const int maxRequests = 3;
  static const Duration limitDuration = Duration(minutes: 5);

  // Otp attempt protection
  final Map<String, List<DateTime>> _otpVerificationAttempts = {};
  static const int maxVerificationAttempts = 5;
  static const Duration attemptWindow = Duration(minutes: 10);

  String saveGenerateOTP = '';

  final mongoAuthenticationRepository = Get.put(MongoAuthenticationRepository());
  final firebaseAuthRepository = Get.put(FirebaseAuthRepository());

  @override
  onInit() {
    super.onInit();
    _initialized();
    showOTPField(false);
  }

  @override
  dispose() {
    super.dispose();
    showOTPField(false);
  }

  Future<void> _initialized() async {
    String? rememberedPhone = localStorage.read(LocalStorageName.rememberMePhone);
    if(rememberedPhone == null) return;
    await CountryData.loadFromAssets(); // MUST await
    var c = CountryData.fromFullNumber(rememberedPhone);
    phoneNumber.text = c?.phoneNumber ?? '';
    countryCode.text = c?.dialCode ?? '';
    countryISO.value = c?.iso ?? 'IN';
  }


  // Send OTP through WhatsApp API
  Future<void> whatsappSendOtp({required String countryCode, required String phoneNumber}) async {
    try {
      isLoading(true);

      // Check internet connectivity
      final isConnected = await Get.put(NetworkManager()).isConnected();
      if (!isConnected) {
        AppMassages.errorSnackBar(title: 'No Internet', message: 'Please check your internet connection.');
        return;
      }

      // Format and validate phone
      String fullPhoneNumber = AppFormatter.formatPhoneNumberForWhatsAppOTP(countryCode: countryCode, phoneNumber: phoneNumber);

      // Rate limiting logic
      final now = DateTime.now();
      final timestamps = _otpRequestTimestamps[fullPhoneNumber] ?? [];

      // Remove timestamps older than limit duration
      final recentTimestamps = timestamps.where((t) => now.difference(t) < limitDuration).toList();

      if (recentTimestamps.length >= maxRequests) {
        AppMassages.errorSnackBar(
          title: 'Too Many Requests',
          message: 'You can only request OTP $maxRequests times every ${limitDuration.inMinutes} minutes.',
        );
        return;
      }

      // Store the new timestamp
      recentTimestamps.add(now);
      _otpRequestTimestamps[fullPhoneNumber] = recentTimestamps;

      // Generate and send OTP
      _generateAndStoreOtp();
      await WhatsappAuthRepo.sendOtp(phoneNumber: fullPhoneNumber, otp: _generatedOtp);

    } catch (error) {
      rethrow;
    } finally {
      isLoading(false);
    }
  }

  Future<UserModel> verifyOtp({required String otp, required String countryCode, required String phoneNumber}) async {
    try {
      // Start Loading
      isLoading(true);

      String fullPhoneNumber = AppFormatter.formatPhoneNumberForWhatsAppOTP(countryCode: countryCode, phoneNumber: phoneNumber);

      // Check brute-force protection
      final now = DateTime.now();
      final attempts = _otpVerificationAttempts[fullPhoneNumber] ?? [];

      // Keep only recent attempts within the time window
      final recentAttempts = attempts.where((t) => now.difference(t) < attemptWindow).toList();

      if (recentAttempts.length >= maxVerificationAttempts) {
        throw Exception('Too many incorrect attempts. Try again later.');
      }

      // Verify OTP
      if (!_isOtpValid(otp)) {
        recentAttempts.add(now); // Log failed attempt
        _otpVerificationAttempts[fullPhoneNumber] = recentAttempts;
        throw Exception('Invalid OTP');
      }

      // OTP is valid — clear attempts
      _otpVerificationAttempts.remove(fullPhoneNumber);

      final UserModel user = await mongoAuthenticationRepository.fetchUserByPhone(phone: fullPhoneNumber);

      if(rememberMe.value){
        localStorage.write(LocalStorageName.rememberMePhone, fullPhoneNumber);
      }
      return user;
    } catch (error) {
      rethrow;
    } finally {
      isLoading(false);
    }
  }


  void _generateAndStoreOtp() {
    _generatedOtp = _generateOtp(length: otpLength);
    _otpExpiry = DateTime.now().add(Duration(minutes: expiryTime));
  }

  bool _isOtpValid(String inputOtp) {
    if (_generatedOtp.isEmpty || _otpExpiry == null) return false;
    if (DateTime.now().isAfter(_otpExpiry!)) return false;

    return inputOtp == _generatedOtp;
  }

  String _generateOtp({int length = 4}) {
    final random = Random();
    String otp = '';
    for (int i = 0; i < length; i++) {
      otp += random.nextInt(10).toString(); // Adds a digit from 0 to 9
    }
    return otp;
  }

  Future<UserModel> signInWithGoogle() async {
    String googleEmail = ''; // Initialize with an empty string
    try {
      // Start Loading
      isSocialLogin(true);
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
          throw Exception('No Internet');
      }
      // Google Authentication
      final userCredentials = await firebaseAuthRepository.signInWithGoogle();
      googleEmail = userCredentials.user?.email ?? ''; // Assign the value here
      final UserModel user = await mongoAuthenticationRepository.fetchUserByEmail(email: googleEmail);
      return user;
    } catch (error) {
      await GoogleSignIn().signOut();
      rethrow;
    }finally{
      isSocialLogin(false);
    }
  }

}