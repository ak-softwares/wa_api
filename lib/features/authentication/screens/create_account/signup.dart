import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../../../common/navigation_bar/appbar.dart';
import '../../../../common/styles/spacing_style.dart';
import '../../../../common/widgets/common/input_phone_field.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/validators/validation.dart';
import '../../controllers/create_account_controller/signup_controller.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final controller = Get.put(SignupController());

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: const AppAppBar(title: "Signup", showBackArrow: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: AppSpacingStyle.paddingWidthAppbarHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //SignUp , Title, Subtitle
              Text("Let's Create Your Account", style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: AppSizes.spaceBtwSection),
              //Form Field
              Form(
                  key: controller.signupFormKey,
                  child: Column(
                    spacing: AppSizes.inputFieldSpace,
                      children: [

                        // Name
                        TextFormField(
                          controller: controller.name,
                          validator: (value) => Validator.validateEmptyText(fieldName: 'Name', value: value),
                          decoration: InputDecoration(
                            prefixIcon: Icon(Iconsax.user),
                            labelText: 'Name',
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
                          ),
                        ),

                        // Email
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

                        // Password
                        Obx(
                            () => TextFormField(
                              controller: controller.password,
                              validator: (value) => Validator.validatePassword(value),
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

                        PhoneNumberField(
                          phoneController: controller.phoneNumber,
                          countryCodeController: controller.countryCode,
                          initialCountryCode: 'IN',
                          // validator: (value) => Validator.validatePhoneNumber(value?.number),
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Obx(() => Checkbox(
                              value: controller.rememberMe.value,
                              onChanged: (value) => controller.rememberMe.value = !controller.rememberMe.value,
                            ),
                            ),
                            const Text(AppTexts.rememberMe),
                          ],
                        ),

                        // Signup button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            child: const Text('Create Account'),
                            onPressed: () => controller.signupWithEmailPassword(),
                          ),
                        ),
                      ]
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
