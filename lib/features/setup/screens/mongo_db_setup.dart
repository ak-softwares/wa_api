import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../common/navigation_bar/appbar.dart';
import '../../../common/styles/spacing_style.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/validators/validation.dart';
import '../controllers/mongo_db_setup.dart';

class MongoDBSetup extends StatelessWidget {
  const MongoDBSetup({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MongoDbSetupController());
    return Scaffold(
      appBar: AppAppBar(title: 'MongoDB Setup'),
      body: Padding(
        padding: AppSpacingStyle.defaultPagePadding,
        child: Form(
          key: controller.formKey,
          child: Column(
            spacing: AppSizes.defaultSpace,
            children: [
              // Connection String
              TextFormField(
                  controller: controller.connectionString,
                  validator: (value) => Validator.validateEmptyText(fieldName: 'Connection String', value: value),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Iconsax.direct_right),
                    labelText: 'Connection String*',
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

              // Database Name
              TextFormField(
                  controller: controller.dataBaseName,
                  validator: (value) => Validator.validateEmptyText(fieldName: 'Database Name', value: value),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Iconsax.direct_right),
                    labelText: 'Database Name*',
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

              // Collection Name
              TextFormField(
                  controller: controller.collectionName,
                  validator: (value) => Validator
                      .validateEmptyText(fieldName: 'Collection Name', value: value),
                  decoration: InputDecoration(
                    prefixIcon: Icon(Iconsax.direct_right),
                    labelText: 'Collection Name*',
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

              // Signup button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  child: const Text('Save'),
                  onPressed: () => controller.uploadMongoDBData(),
                ),
              ),
            ]
          ),
        ),
      )
    );
  }
}
