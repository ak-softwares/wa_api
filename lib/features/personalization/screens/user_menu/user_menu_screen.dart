import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/navigation_bar/appbar.dart';
import '../../../../common/text/section_heading.dart';
import '../../../../common/widgets/custom_shape/containers/rounded_container.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../authentication/controllers/authentication_controller/authentication_controller.dart';
import '../../../settings/app_settings.dart';
import '../user_profile_info/user_profile_info.dart';
import 'widgets/contact_widget.dart';
import 'widgets/menu.dart';

class UserMenuScreen extends StatelessWidget {
  const UserMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
  final auth = Get.put(AuthenticationController());
    return Scaffold(
        appBar: const AppAppBar(title: 'Profile Setting', seeLogoutButton: true, seeSettingButton: true,),
        body: RefreshIndicator(
          onRefresh: () async => await auth.refreshUser(),
          color: AppColors.refreshIndicator,
          child: ListView(
            children: [
              const CustomerProfileCard(),

              // Menu
              Heading(title: 'Menu', paddingLeft: AppSizes.defaultSpace),
              const Menu(),

              // Contacts
              SupportWidget(),

              // Version
              Center(
                child: Column(
                  children: [
                    Text(AppSettings.appName, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),),
                    Text('v${AppSettings.appVersion}', style: TextStyle(fontSize: 12),)
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.md),
            ],
          ),
        ),
    );
  }
}

class CustomerProfileCard extends StatelessWidget {
  const CustomerProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.put(AuthenticationController());

    return Obx(() => ListTile(
        onTap: () => Get.to(() => const UserProfileInfo()),
        // leading: RoundedImage(
        //   padding: 0,
        //   height: 40,
        //   width: 40,
        //   borderRadius: 100,
        //   isNetworkImage: userController.admin.value.avatarUrl != null ? true : false,
        //   image: userController.admin.value.avatarUrl ?? Images.tProfileImage
        // ),
        leading: RoundedContainer(
          height: 50,
          width: 50,
          radius: 50,
          backgroundColor: Theme.of(context).colorScheme.surface.darken(2),
          child: Icon(Icons.person, size: 27,),
        ),
        title: Text(auth.user.value.name ?? 'User'),
        subtitle: Text(auth.user.value.email ?? 'Email',),
        trailing: Icon(Icons.arrow_forward_ios, size: 20),
      ),
    );
  }
}






