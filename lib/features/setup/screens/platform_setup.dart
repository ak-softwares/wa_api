import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/navigation_bar/appbar.dart';
import '../../../common/text/section_heading.dart';
import '../../../common/widgets/custom_shape/image/circular_image.dart';
import '../../../utils/constants/sizes.dart';
import '../../authentication/controllers/authentication_controller/authentication_controller.dart';
import '../controllers/mongo_db_setup.dart';
import 'whatsapp_cloud_api.dart';
import 'mongo_db_setup.dart';
import 'n8n_setup.dart';

class PlatformSelectionScreen extends StatelessWidget {

  const PlatformSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.put(AuthenticationController());

    return Scaffold(
      appBar: AppAppBar(title: 'Setup'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            SizedBox(height: AppSizes.md),
            PlatformCard(
              name: 'Whatsapp Cloud API',
              image: 'assets/images/setup_logos/facebook_logo.png',
              onTap: () => Get.to(() => WhatsappCloudApi()),
              isSetup: auth.user.value.fBApiCredentials?.accessToken != null,
            ),
            SizedBox(height: AppSizes.md),
            PlatformCard(
              name: 'n8n Setup',
              image: 'assets/images/setup_logos/n8n.png',
              onTap: () => Get.to(() => N8NSetup()),
              isConnected: true,
            ),
            SizedBox(height: AppSizes.md),
          ],
        ),
      ),
    );
  }
}

class PlatformCard extends StatelessWidget {
  final String name;
  final String image;
  final bool isConnected;
  final bool isSetup;
  final VoidCallback onTap;

  const PlatformCard({
    super.key,
    required this.name,
    required this.image,
    required this.onTap,
    this.isConnected = false,
    this.isSetup = false,
  });

  @override
  Widget build(BuildContext context) {
    final mongoDbSetupController = Get.put(MongoDbSetupController());

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          SizedBox(
            height: 150,
            width: double.infinity,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: onTap,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RoundedImage(
                    width: 200,
                    image: image,
                  ),
                  SizedBox(height: 16),
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if(isConnected)
            Positioned(
              top: 10,
              right: 10,
              child: Obx(() => Switch(
                value: mongoDbSetupController.isN8NSwitched.value,
                onChanged: (value) {
                  mongoDbSetupController.isN8NSwitched.value = value;
                  mongoDbSetupController.updateN8NSwitch();
                },
              ))
            ),
          if(isSetup)
            Positioned(
                top: 10,
                right: 10,
                child: Icon(Icons.check, color: Colors.green,)
            )
        ],
      ),
    );
  }
}