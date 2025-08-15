import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../common/dialog_box_massages/snack_bar_massages.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../personalization/models/user_model.dart';
import '../../controllers/authentication_controller/authentication_controller.dart';
import '../../controllers/login_controller/login_controller.dart';
import '../../controllers/phone_otp_controller/phone_otp_controller.dart';
import '../create_account/signup.dart';
import '../../../../common/navigation_bar/appbar.dart';
import '../../../../common/styles/spacing_style.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../../../utils/validators/validation.dart';
import 'forget_password.dart';

class EmailLoginScreen extends StatelessWidget {
  const EmailLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final controller = Get.put(LoginController());
    final oTPController = Get.put(OTPController());
    final userController = Get.put(AuthenticationController());

    final dark = HelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: const AppAppBar(title: "Login", showBackArrow: true),
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
                    Text(AppTexts.loginTitle, style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: AppSizes.sm),
                    Text(AppTexts.loginSubTitle, style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center)
                  ],
                ),
                const SizedBox(height: AppSizes.spaceBtwSection),
                //Form Field
                Form(
                  key: controller.loginFormKey,
                    child: Column(
                        children: [
                          //Email
                          TextFormField(
                            controller: controller.email,
                            validator: (value) => Validator.validateEmail(value),
                            decoration: InputDecoration(
                              prefixIcon: Icon(Iconsax.direct_right),
                              labelText: AppTexts.email,
                              // Default border (used when not focused)
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(AppSizes.inputFieldRadius)),
                                borderSide: BorderSide(color: Theme.of(context).colorScheme.outline, width: AppSizes.inputFieldBorderWidth),
                              ),

                              // Border when focused
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(AppSizes.inputFieldRadius)),
                                borderSide: BorderSide(color: Theme.of(context).colorScheme.outline, width: AppSizes.inputFieldBorderWidth),
                              ),
                            )
                          ),
                          //Password
                          const SizedBox(height: AppSizes.inputFieldSpace),
                          Obx(
                                () => TextFormField(
                                  controller: controller.password,
                                  validator: (value) => Validator.validateEmptyText(fieldName: 'Password',value: value),
                                  obscureText: controller.hidePassword.value,
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(Iconsax.password_check),
                                    labelText: AppTexts.password,
                                    suffixIcon: IconButton(
                                      onPressed: () => controller.hidePassword.value = !controller.hidePassword.value,
                                      icon: controller.hidePassword.value ? const Icon(Iconsax.eye_slash) : const Icon(Iconsax.eye),
                                    ),
                                    // Default border (used when not focused)
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(AppSizes.inputFieldRadius)),
                                      borderSide: BorderSide(color: Theme.of(context).colorScheme.outline, width: AppSizes.inputFieldBorderWidth),
                                    ),

                                    // Border when focused
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(AppSizes.inputFieldRadius)),
                                      borderSide: BorderSide(color: Theme.of(context).colorScheme.outline, width: AppSizes.inputFieldBorderWidth),
                                    ),
                                  )
                              )),
                          const SizedBox(height: AppSizes.inputFieldSpace / 2),
                          // Forget password and remember me
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Obx(() => Checkbox(
                                          value: controller.rememberMe.value,
                                          onChanged: (value) => controller.rememberMe.value = !controller.rememberMe.value,
                                      ),
                                    ),
                                    const Text(AppTexts.rememberMe),
                                  ],
                                ),
                                TextButton(
                                    onPressed: (){
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => ForgetPasswordScreen(email: controller.email.text.trim(),))
                                      );},
                                    child: Text(AppTexts.forgotPassword, style: Theme.of(context).textTheme.labelLarge!.copyWith(color: AppColors.linkColorDark))
                                )
                              ]
                          ),

                          // Login button
                          const SizedBox(height: AppSizes.spaceBtwSection),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              child: const Text(AppTexts.login),
                              onPressed: () => controller.mongoLogin(),
                            ),
                          ),
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
                        child: Text(AppTexts.orSignInWith.capitalize!, style: Theme.of(context).textTheme.labelMedium),
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
                        userController.login(user: user);
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
                        Text('Login with Google')
                      ],
                    )
                ),
              ],
            ),
        ),
      ),
    );
  }
}

