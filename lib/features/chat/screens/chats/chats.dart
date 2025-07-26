import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/layout_model/grid_layout.dart';
import '../../../../common/navigation_bar/appbar.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../controllers/chats/chats_controller.dart';
import 'widget/chat.dart';

class Chats extends StatelessWidget {
  const Chats({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChatsController());

    return Scaffold(
      appBar: const AppAppBar(title: 'All Chats'),
      body: RefreshIndicator(
        color: AppColors.refreshIndicator,
        onRefresh: () async => controller.refreshChats(),
        child: ListView(
          children: [
            GridLayout(
              itemCount: controller.chats.length,
              crossAxisCount: 1,
              mainAxisExtent: AppSizes.chatTileHeight,
              itemBuilder: (context, index) {
                return ChatTile(
                  chat: controller.chats[index],
                  onTap: () {},
                );
              }
            ),
          ],
        ),
      ),
    );
  }
}
