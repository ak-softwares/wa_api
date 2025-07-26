import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/navigation_bar/appbar.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../authentication/controllers/authentication_controller/authentication_controller.dart';
import '../change_profile/change_user_profile.dart';


class UserProfileInfo extends StatelessWidget {
  const UserProfileInfo({super.key});

  @override
  Widget build(BuildContext context) {

    final controller = Get.put(AuthenticationController());

    return Scaffold(
      appBar: AppAppBar(
        title: 'Profile Info',
        widgetInActions: TextButton(
            onPressed: () => Get.to(() => ChangeUserProfile()),
            child: const Row(
              spacing: AppSizes.sm,
              children: [
                Text('Edit', style: TextStyle(color: AppColors.linkColor),),
                Icon(Icons.edit, size: 18, color: AppColors.linkColor,)
              ],
            ),
        ),
      ),
      body: RefreshIndicator(
        color: AppColors.refreshIndicator,
        onRefresh: () async => controller.refreshUser(),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.defaultSpace),
            child: Column(
              spacing: AppSizes.spaceBtwSection,
              children: [

                // Profile Info
                Column(
                  children: [
                    TProfileMenu(
                      title: 'Name',
                      value: controller.user.value.name ?? 'Name',
                    ),
                    Divider(color: Colors.grey[200]),
                    TProfileMenu(
                      title: 'Email',
                      value: controller.user.value.email ?? "Email",
                    ),
                    Divider(color: Colors.grey[200]),
                    TProfileMenu(
                      title: 'Phone',
                      value: controller.user.value.phone ?? 'Phone',
                    ),
                    Divider(color: Colors.grey[200]),
                  ],
                ),

                // Delete
                Center(
                    child: TextButton(
                        child: const Text('Delete Account', style: TextStyle(color: Colors.red),),
                        onPressed: () => controller.showDialogDeleteAccount(context: context)
                    )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TProfileMenu extends StatelessWidget {
  const TProfileMenu({super.key, required this.title, required this.value,});
  final String title, value;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.spaceBtwItems),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(title, style: Theme.of(context).textTheme.bodySmall, overflow: TextOverflow.ellipsis)),
          Expanded(flex: 5, child: Text(value, style: Theme.of(context).textTheme.bodyMedium, overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }
}
