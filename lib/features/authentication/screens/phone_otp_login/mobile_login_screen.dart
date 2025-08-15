import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../../../../common/dialog_box_massages/snack_bar_massages.dart';
import '../../../../common/styles/spacing_style.dart';
import '../../../../common/widgets/common/input_phone_field.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/icons.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../personalization/models/user_model.dart';
import '../../controllers/authentication_controller/authentication_controller.dart';
import '../../controllers/phone_otp_controller/phone_otp_controller.dart';
import '../email_login/email_login.dart';
import '../create_account/signup.dart';
import '../widgets/countdown_timer.dart';

class MobileLoginScreen extends StatelessWidget {
  const MobileLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OTPController());
    final userController = Get.put(AuthenticationController());
    controller.showOTPField(false);

    final bool isWhatsappOtpLogin = true;
    return Scaffold(
      // appBar: const TAppBar2(titleText: "Login", showBackArrow: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: AppSpacingStyle.paddingWidthAppbarHeight,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // login, Title, Subtitle
                Column(
                  children: [
                    Text('Your Phone!', style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: AppSizes.sm),
                    Text(AppTexts.loginSubTitle, style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center)
                  ],
                ),
                const SizedBox(height: AppSizes.spaceBtwSection),

                // Phone field
                Obx(() {
                  if (controller.countryISO.value.isEmpty) {
                    return CircularProgressIndicator(); // or SizedBox.shrink()
                  }
                  return PhoneNumberField(
                    phoneController: controller.phoneNumber,
                    countryCodeController: controller.countryCode,
                    initialCountryCode: controller.countryISO.value,
                    // validator: (value) => Validator.validatePhoneNumber(value?.number),
                  );
                }),
                SizedBox(height: AppSizes.inputFieldSpace),

                // Otp Input field
                Obx(() {
                  if (!controller.showOTPField.value) return SizedBox.shrink();
                  return Column(
                    children: [
                      SizedBox(
                        width: 250,
                        child: PinFieldAutoFill(
                          codeLength: controller.otpLength,
                          // code length, default 6
                          cursor: Cursor(
                            color: Colors.blue,
                            enabled: true,
                            width: 2, // Specify the width of the cursor
                            height: 24, // Specify the height of the cursor
                          ),
                          textInputAction: TextInputAction.done,
                          decoration: UnderlineDecoration(
                              textStyle: TextStyle(fontSize: 18, color: Theme.of(context).colorScheme.onSurface),
                              colorBuilder: FixedColorBuilder(Theme.of(context).colorScheme.onSurfaceVariant),
                              bgColorBuilder: FixedColorBuilder(Colors.grey.withOpacity(0.2))
                          ),
                          controller: controller.otp,
                          // currentCode: otpController.messageOtpCode.value,
                          // onCodeChanged: (code) {
                          //   otpController.messageOtpCode.value = code!;
                          // },
                          onCodeSubmitted: (otp) async {
                            try{
                              final UserModel user = await controller.verifyOtp(otp: otp, countryCode: controller.countryCode.text, phoneNumber: controller.phoneNumber.text);
                              await userController.login(user: user);
                            }catch(e) {
                              AppMassages.errorSnackBar(title: 'Oh Snap!', message: e.toString());
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: AppSizes.spaceBtwItems * 2),
                    ],
                  );
                }),
                // Row(
                //   children: [
                //     Obx(() => Checkbox(
                //       value: controller.rememberMe.value,
                //       onChanged: (value) => controller.rememberMe.value = !controller.rememberMe.value,
                //     ),
                //     ),
                //     const Text(AppTexts.rememberMe),
                //   ],
                // ),
                if(isWhatsappOtpLogin)
                  Obx(() {
                    if (controller.showOTPField.value) {
                      return Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                                onPressed: () async {
                                  try{
                                    final UserModel user = await controller.verifyOtp(otp: controller.otp.text, countryCode: controller.countryCode.text, phoneNumber: controller.phoneNumber.text);
                                    await userController.login(user: user);
                                  }catch(e) {
                                    AppMassages.errorSnackBar(title: 'Oh Snap!', message: e.toString());
                                  }
                                },
                                child: controller.isLoading.value
                                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: AppColors.whatsAppColor, strokeWidth: 2,))
                                    : Text('Verify OTP')
                            ),
                          ),
                          const SizedBox(height: AppSizes.inputFieldSpace),
                          // CountDown Timer
                          OtpCountdownWidget(
                            initialSeconds: 60,
                            onResend: () async {
                              await controller.whatsappSendOtp(
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
                                await controller.whatsappSendOtp(
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

                            child: controller.isLoading.value
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
                  }),

                // Not a Member?  Divider
                const SizedBox(height: AppSizes.spaceBtwItems * 2),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[700],
                      )),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(AppTexts.orContinueWith.capitalize!, style: Theme.of(context).textTheme.labelMedium),
                      ),
                      Expanded(child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[700],
                      )),
                    ],
                  ),
                ),

                // Social login
                const SizedBox(height: AppSizes.inputFieldSpace),
                OutlinedButton(
                    onPressed: () async {
                      try{
                        final UserModel user = await controller.signInWithGoogle();
                        userController.login(user: user);
                      }catch(e) {
                        AppMassages.errorSnackBar(title: 'Oh Snap!', message: e.toString());
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      alignment: Alignment.center,
                      side: const BorderSide(color: Colors.grey),
                    ),
                    child: controller.isSocialLogin.value
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
                        Text('Login with Google')
                      ],
                    )
                ),

                // Continue with email and password
                const SizedBox(height: AppSizes.inputFieldSpace),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                      onPressed: () => Get.to(() => const EmailLoginScreen()),
                      child: const Text('Login with Email and Password')
                  ),
                ),

                // Not a Member? register
                const SizedBox(height: AppSizes.spaceBtwItems),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Not a member?', style: Theme.of(context).textTheme.labelLarge),
                      TextButton(
                          onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen()));},
                          child: Text(AppTexts.createAccount, style: Theme.of(context).textTheme.labelLarge!.copyWith(color: AppColors.linkColorDark )))
                    ]
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
