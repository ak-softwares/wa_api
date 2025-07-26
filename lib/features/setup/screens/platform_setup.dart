import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/navigation_bar/appbar.dart';
import '../../../common/widgets/custom_shape/image/circular_image.dart';
import '../../../utils/constants/sizes.dart';
import '../../authentication/controllers/authentication_controller/authentication_controller.dart';
import 'mongo_db_setup.dart';
import 'n8n_setup.dart';

class PlatformSelectionScreen extends StatelessWidget {

  const PlatformSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {

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
              color: Colors.blue,
              onTap: () => Get.to(() => MongoDBSetup())
            ),
            SizedBox(height: AppSizes.md),
            _PlatformCard(
              name: 'n8n Setup',
              image: 'assets/images/setup_logos/n8n.png',
              color: Colors.green,
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
  final Color color;
  final VoidCallback onTap;

  const _PlatformCard({
    required this.name,
    required this.image,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final auth = Get.put(AuthenticationController());

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
        ],
      ),
    );
  }
}