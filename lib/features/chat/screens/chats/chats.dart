import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/layout_model/grid_layout.dart';
import '../../../../common/navigation_bar/appbar.dart';
import '../../../../common/styles/spacing_style.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../controllers/chats/chats_controller.dart';
import '../messages/messages.dart';
import '../search/widgets/search_bar.dart';
import 'widgets/chat_simmer.dart';
import 'widgets/chat_tile.dart';

class Chats extends StatelessWidget {
  const Chats({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChatsController());

    return Scaffold(
      appBar: AppAppBar(title: 'WhatsApp API', titleStyle: TextStyle(color: AppColors.whatsAppColor, fontSize: 20),
        widgetInActions: Row(
          children: [
            IconButton(
              icon: Icon(Icons.qr_code_scanner_outlined),
              onPressed: () { },
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.camera_alt_outlined),
            ),
            IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () {},
            ),
          ],
        )
      ),
      body: RefreshIndicator(
        color: AppColors.refreshIndicator,
        onRefresh: () async => controller.refreshChats(),
        child: ListView(
          padding: AppSpacingStyle.defaultPageHorizontal,
          children: [
            SearchField(),
            const SizedBox(height: 5),
            Obx(() {
              if(controller.isLoading.value){
                return GridLayout(
                    itemCount: 2,
                    crossAxisCount: 1,
                    mainAxisExtent: AppSizes.chatTileHeight,
                    mainAxisSpacing: 0,
                    crossAxisSpacing: 0,
                    itemBuilder: (context, index) {
                      return ChatSimmer();
                    }
                );
              } else if(controller.chats.isEmpty) {
                return Column(
                  children: [
                    const SizedBox(height: 10),
                    Center(child: Text('No Chats Found')),
                  ],
                );
              }
              else {
                return GridLayout(
                    itemCount: controller.chats.length,
                    crossAxisCount: 1,
                    mainAxisExtent: AppSizes.chatTileHeight,
                    mainAxisSpacing: 0,
                    crossAxisSpacing: 0,
                    itemBuilder: (context, index) {
                      return ChatTile(
                          chat: controller.chats[index],
                          onTap: () => Get.to(() => Messages(
                            sessionId: controller.chats[index].sessionId,
                            messages: controller.chats[index].messages,
                          ))
                      );
                    }
                );
              }
            }),
          ],
        ),
      ),
    );
  }
}
