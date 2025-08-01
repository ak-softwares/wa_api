import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../common/navigation_bar/appbar.dart';
import '../../../common/styles/spacing_style.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/validators/validation.dart';
import '../controllers/fb_api_setup.dart';
import '../controllers/mongo_db_setup.dart';

class FBApiSetup extends StatelessWidget {
  const FBApiSetup({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FBApiSetupController());
    return Scaffold(
      appBar: AppAppBar(title: 'Facebook API Setup'),
      body: Padding(
        padding: AppSpacingStyle.defaultPagePadding,
        child: Form(
          key: controller.formKey,
          child: Column(
            spacing: AppSizes.defaultSpace,
            children: [
              // Access Token
              TextFormField(
                  controller: controller.accessToken,
                  validator: (value) => Validator.validateEmptyText(fieldName: 'Access Token', value: value),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Iconsax.direct_right),
                    labelText: 'Access Token*',
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

              // Phone number ID
              TextFormField(
                  controller: controller.phoneNumberID,
                  validator: (value) => Validator
                      .validateEmptyText(fieldName: 'Phone number ID', value: value),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Iconsax.direct_right),
                    labelText: 'Phone number ID*',
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

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  child: const Text('Save'),
                  onPressed: () => controller.saveFBApiData(),
                ),
              ),
            ]
          ),
        ),
      )
    );
  }
}
