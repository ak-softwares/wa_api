import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/navigation_bar/appbar.dart';
import '../../../../common/text/section_heading.dart';
import '../../../../common/widgets/shimmers/user_shimmer.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../authentication/screens/check_login_screen/check_login_screen.dart';
import '../../../authentication/controllers/authentication_controller/authentication_controller.dart';
import '../../../settings/app_settings.dart';
import '../user_profile_info/user_profile_info.dart';
import 'widgets/contact_widget.dart';
import 'widgets/menu.dart';

class UserMenuScreen extends StatelessWidget {
  const UserMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: const AppAppBar(title: 'Profile Setting', seeLogoutButton: true, seeSettingButton: true,),
        body: ListView(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Menu
            Heading(title: 'Menu', paddingLeft: AppSizes.defaultSpace),
            const Menu(),

            // Contacts
            SupportWidget(),

            // Version
            Center(
              child: Column(
                children: [
                  Text('n8nTalk', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),),
                  Text('v${AppSettings.appVersion}', style: TextStyle(fontSize: 12),)
                ],
              ),
            ),
            const SizedBox(height: AppSizes.md),
          ],
        ),
    );
  }
}

class CustomerProfileCard extends StatelessWidget {
  const CustomerProfileCard({
    super.key,
    required this.userController, this.showHeading = false,
  });

  final bool showHeading;
  final AuthenticationController userController;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if(userController.isLoading.value) {
        return const UserTileShimmer();
      } else {
         return ListTile(
           onTap: () => Get.to(() => const UserProfileInfo()),
            // leading: RoundedImage(
            //   padding: 0,
            //   height: 40,
            //   width: 40,
            //   borderRadius: 100,
            //   isNetworkImage: userController.admin.value.avatarUrl != null ? true : false,
            //   image: userController.admin.value.avatarUrl ?? Images.tProfileImage
            // ),
            title: Text((userController.user.value.name?.isNotEmpty ?? false) ? userController.user.value.name! : "User",),
            subtitle: Text(userController.user.value.email?.isNotEmpty ?? false ? userController.user.value.email! : 'Email',),
            trailing: Icon(Icons.arrow_forward_ios, size: 20,),
         );
      }
    });
  }

}






