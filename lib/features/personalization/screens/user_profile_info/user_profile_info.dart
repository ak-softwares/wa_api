import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/navigation_bar/appbar.dart';
import '../../../../common/styles/spacing_style.dart';
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
                Text('Edit', style: TextStyle(color: AppColors.linkColorDark),),
                Icon(Icons.edit, size: 18, color: AppColors.linkColorDark,)
              ],
            ),
        ),
      ),
      body: RefreshIndicator(
        color: AppColors.refreshIndicator,
        onRefresh: () async => controller.refreshUser(),
        child: ListView(
          padding: AppSpacingStyle.defaultPagePadding,
          shrinkWrap: true,
          // physics: const NeverScrollableScrollPhysics(),
          children: [

            // Profile Info
            ProfileMenu(
              title: 'Name',
              value: controller.user.value.name ?? 'Name',
            ),
            Divider(color: Colors.grey[200]),
            ProfileMenu(
              title: 'Email',
              value: controller.user.value.email ?? "Email",
            ),
            Divider(color: Colors.grey[200]),
            ProfileMenu(
              title: 'Phone',
              value: controller.user.value.phone ?? 'Phone',
            ),
            Divider(color: Colors.grey[200]),

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
    );
  }
}

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({super.key, required this.title, required this.value,});
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
