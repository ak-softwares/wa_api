import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../common/navigation_bar/appbar.dart';
import '../../../common/styles/spacing_style.dart';
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
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Iconsax.direct_right),
                    labelText: 'Connection String*',
                  )
              ),

              // Database Name
              TextFormField(
                  controller: controller.dataBaseName,
                  validator: (value) => Validator.validateEmptyText(fieldName: 'Database Name', value: value),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Iconsax.direct_right),
                    labelText: 'Database Name*',
                  )
              ),

              // Collection Name
              TextFormField(
                  controller: controller.collectionName,
                  validator: (value) => Validator
                      .validateEmptyText(fieldName: 'Collection Name', value: value),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Iconsax.direct_right),
                    labelText: 'Collection Name*',
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
