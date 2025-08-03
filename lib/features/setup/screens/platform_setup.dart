import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/navigation_bar/appbar.dart';
import '../../../common/widgets/custom_shape/image/circular_image.dart';
import '../../../utils/constants/sizes.dart';
import '../../authentication/controllers/authentication_controller/authentication_controller.dart';
import 'fb_api_setup.dart';
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
            _PlatformCard(
                name: 'MongoDB',
                image: 'assets/images/setup_logos/mongo_db.png',
                onTap: () => Get.to(() => MongoDBSetup()),
                isSetup: auth.user.value.mongoDbCredentials?.collectionName != null,
            ),
            SizedBox(height: AppSizes.md),
            _PlatformCard(
                name: 'Facebook API Console',
                image: 'assets/images/setup_logos/facebook_logo.png',
                onTap: () => Get.to(() => FBApiSetup()),
                isSetup: auth.user.value.fBApiCredentials?.accessToken != null,
            ),
            SizedBox(height: AppSizes.md),
            _PlatformCard(
              name: 'n8n Setup',
              image: 'assets/images/setup_logos/n8n.png',
              onTap: () => Get.to(() => N8NSetup())
            ),
            SizedBox(height: AppSizes.md),
          ],
        ),
      ),
    );
  }
}

class _PlatformCard extends StatelessWidget {
  final String name;
  final String image;
  final bool isSetup;
  final VoidCallback onTap;

  const _PlatformCard({
    required this.name,
    required this.image,
    required this.onTap,
    this.isSetup = false,
  });

  @override
  Widget build(BuildContext context) {

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
          Positioned(
              top: 10,
              right: 10,
              child: Icon(Icons.check, color: isSetup ? Colors.green : Colors.transparent)
          )
        ],
      ),
    );
  }
}