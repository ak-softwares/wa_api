import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../../../../common/dialog_box_massages/snack_bar_massages.dart';
import '../../../../common/navigation_bar/appbar.dart';
import '../../../../common/styles/spacing_style.dart';
import '../../../../common/widgets/common/input_phone_field.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/icons.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../../personalization/models/user_model.dart';
import '../../controllers/login_controller/forget_password_controller.dart';
import '../../controllers/phone_otp_controller/phone_otp_controller.dart';
import '../widgets/countdown_timer.dart';
import 'reset_password_screen.dart';

class ForgetPasswordScreen extends StatelessWidget {
  final String? email;
  const ForgetPasswordScreen({super.key, this.email});

  @override
  Widget build(BuildContext context) {
    final dark = HelperFunctions.isDarkMode(context);

    final controller = Get.put(ForgetPasswordController());
    final oTPController = Get.put(OTPController());
    controller.showOTPField(false);

    return Scaffold(
      appBar: const AppAppBar(title: "Forget Password", showBackArrow: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: AppSpacingStyle.paddingWidthAppbarHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //login, Title, Subtitle
              Column(
                children: [
                  Text('Forget password', style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: AppSizes.sm),
                  Text('Do not worry sometime people can forget too, Enter your phone',
                      style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center)
                ],
              ),
              const SizedBox(height: AppSizes.spaceBtwSection),
              // Form Field
              Form(
                key: controller.forgetPasswordFormKey,
                  child: Column(
                    spacing: AppSizes.spaceBtwItems,
                      children: [
                        // Phone
                        PhoneNumberField(
                          phoneController: controller.phoneNumber,
                          countryCodeController: controller.countryCode,
                          initialCountryCode: 'IN',
                          // validator: (value) => Validator.validatePhoneNumber(value?.number),
                        ),
                        // Forget password button
                        const SizedBox(height: AppSizes.spaceBtwItems),

                        // Otp Input field
                        Obx(() {
                          if (!controller.showOTPField.value) return SizedBox.shrink();
                          return Column(
                            children: [
                              SizedBox(
                                width: 250,
                                child: PinFieldAutoFill(
                                  codeLength: oTPController.otpLength,
                                  //code length, default 6
                                  cursor: Cursor(
                                    color: Colors.pink,
                                    enabled: true,
                                    width: 2, // Specify the width of the cursor
                                    height: 24, // Specify the height of the cursor
                                  ),
                                  textInputAction: TextInputAction.done,
                                  decoration: UnderlineDecoration(
                                      textStyle: TextStyle(
                                          fontSize: 18, color: Theme
                                          .of(context)
                                          .colorScheme
                                          .onSurface),
                                      colorBuilder: FixedColorBuilder(Theme
                                          .of(context)
                                          .colorScheme
                                          .onSurfaceVariant),
                                      bgColorBuilder: FixedColorBuilder(
                                          Colors.grey.withOpacity(0.2))
                                  ),
                                  controller: controller.otp,
                                  // currentCode: otpController.messageOtpCode.value,
                                  // onCodeChanged: (code) {
                                  //   otpController.messageOtpCode.value = code!;
                                  // },
                                  onCodeSubmitted: (otp) async {
                                    try{
                                      final UserModel user = await oTPController.verifyOtp(otp: otp, countryCode: controller.countryCode.text, phoneNumber: controller.phoneNumber.text);
                                      Get.to(() => ResetPasswordScreen(user: user,));
                                    }catch(e) {
                                      AppMassages.errorSnackBar(title: 'Oh Snap!', message: e.toString());
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(height: AppSizes.spaceBtwItems),
                            ],
                          );
                        }),

                        Obx(() {
                          if (controller.showOTPField.value) {
                            return Column(
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: OutlinedButton(
                                      onPressed: () async {
                                        try{
                                          final UserModel user = await oTPController.verifyOtp(otp: controller.otp.text, countryCode: controller.countryCode.text, phoneNumber: controller.phoneNumber.text);
                                          Get.to(() => ResetPasswordScreen(user: user,));
                                        }catch(e) {
                                          AppMassages.errorSnackBar(title: 'Oh Snap!', message: e.toString());
                                        }
                                      },
                                    child: oTPController.isLoading.value
                                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: AppColors.whatsAppColor, strokeWidth: 2,))
                                        : Text('Verify OTP')
                                  ),
                                ),
                                const SizedBox(height: AppSizes.inputFieldSpace),
                                // CountDown Timer
                                OtpCountdownWidget(
                                  initialSeconds: 60,
                                  onResend: () async {
                                    await oTPController.whatsappSendOtp(
                                      countryCode: controller.countryCode.text,
                                      phoneNumber: controller.phoneNumber.text,
                                    );
                                  },
                                ),
                              ],
                            );
                          } else {
                            return SizedBox(
                              width: double.infinity,
                              child: Obx(() => OutlinedButton(
                                  onPressed: () async {
                                    controller.showOTPField.value = false; // reset first
                                    try {
                                      await oTPController.whatsappSendOtp(
                                        countryCode: controller.countryCode.text,
                                        phoneNumber: controller.phoneNumber.text,
                                      );
                                      // only run if no error thrown
                                      controller.showOTPField.value = true;
                                    } catch (e) {
                                      controller.showOTPField.value = false;
                                      AppMassages.errorSnackBar(title: 'Oh Snap!', message: e.toString());
                                    }
                                  },

                                  child: oTPController.isLoading.value
                                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: AppColors.whatsAppColor, strokeWidth: 2,))
                                      : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    spacing: AppSizes.sm,
                                    children: [
                                      Icon(AppIcons.whatsapp, size: 20, color: AppColors.whatsAppColor,),
                                      Text('Get Whatsapp OTP'),
                                    ],
                                  )
                              ),
                              ),
                            );
                          }
                        })
                      ]
                  )
              ),

              // Not a Member?  Divider
              const SizedBox(height: AppSizes.spaceBtwSection),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    Expanded(child: Divider(
                      thickness: 0.5,
                      color: dark ? Colors.grey[300] : Colors.grey[700],
                    )),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text('Or reset password with Google', style: Theme.of(context).textTheme.labelMedium),
                    ),
                    Expanded(child: Divider(
                      thickness: 0.5,
                      color: dark ? Colors.grey[300] : Colors.grey[700],
                    )),
                  ],
                ),
              ),

              // Social Login
              const SizedBox(height: AppSizes.spaceBtwSection),
              OutlinedButton(
                  onPressed: () async {
                    try{
                      final UserModel user = await oTPController.signInWithGoogle();
                      Get.to(() => ResetPasswordScreen(user: user,));
                    }catch(e) {
                      AppMassages.errorSnackBar(title: 'Oh Snap!', message: e.toString());
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    alignment: Alignment.center,
                    side: const BorderSide(color: Colors.grey),
                  ),
                  child: oTPController.isSocialLogin.value
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: AppColors.whatsAppColor, strokeWidth: 2,))
                      : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                          height: AppSizes.iconMd,
                          width: AppSizes.iconMd,
                          image: AssetImage(Images.google)
                      ),
                      SizedBox(width: AppSizes.inputFieldSpace),
                      Text('Reset with Google')
                    ],
                  )
              ),
            ]
          ),
        ),
      ),
    );
  }
}
