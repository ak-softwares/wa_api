import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../common/navigation_bar/appbar.dart';
import '../../../../common/styles/spacing_style.dart';
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
                          decoration: const InputDecoration(prefixIcon: Icon(Iconsax.user), labelText: 'Name'),
                        ),

                        // Email
                        TextFormField(
                            controller: controller.email,
                            validator: (value) => Validator.validateEmail(value),
                            decoration: const InputDecoration(
                                prefixIcon: Icon(Iconsax.direct_right),
                                labelText: AppTexts.email
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
                                  )
                              )
                        )),

                        // Phone
                        TextFormField(
                            controller: controller.phone,
                            validator: (value) => Validator.validatePhoneNumber(value),
                            decoration: const InputDecoration(
                                prefixIcon: Icon(Iconsax.call),
                                labelText: AppTexts.phone
                            )
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
