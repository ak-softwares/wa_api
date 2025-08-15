import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';

import '../../../../common/navigation_bar/appbar.dart';
import '../../../../common/styles/spacing_style.dart';
import '../../../../common/widgets/common/input_phone_field.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/validators/validation.dart';
import '../../controllers/change_profile_controller.dart';


class ChangeUserProfile extends StatelessWidget {
  const ChangeUserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChangeProfileController());

    return Scaffold(
      appBar: const AppAppBar(title: "Update Profile", showBackArrow: true),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(AppSizes.defaultSpace),
        child: ElevatedButton(
          child: const Text('Update'),
          onPressed: () => controller.mongoChangeProfileDetails(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: AppSpacingStyle.defaultPagePadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Form(
                  key: controller.changeProfileFormKey,
                  child: Column(
                      spacing: AppSizes.inputFieldSpace,
                      children: [
                        // Name
                        TextFormField(
                          controller: controller.name,
                          validator: (value) => Validator.validateEmptyText(fieldName: 'Full Name',value: value),
                          decoration: InputDecoration(
                            prefixIcon: Icon(Iconsax.user),
                            labelText: 'Full Name*',
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

                        // email
                        TextFormField(
                            controller: controller.email,
                            validator: (value) => Validator.validateEmail(value),
                            decoration: InputDecoration(
                              prefixIcon: Icon(Iconsax.direct_right),
                              labelText: AppTexts.tEmail,
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
                        })
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
