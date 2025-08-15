import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/dialog_box_massages/animation_loader.dart';
import '../../../../common/layout_model/grid_layout.dart';
import '../../../../common/navigation_bar/appbar.dart';
import '../../../../common/styles/spacing_style.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../authentication/controllers/authentication_controller/authentication_controller.dart';
import '../../../settings/app_settings.dart';
import '../../../setup/screens/whatsapp_cloud_api.dart';
import '../../../setup/screens/mongo_db_setup.dart';
import '../../controllers/chats/chats_controller.dart';
import '../messages/messages.dart';
import '../new_chat/new_chat.dart';
import '../search/widgets/search_bar.dart';
import 'widgets/chat_simmer.dart';
import 'widgets/chat_tile.dart';

class Chats extends StatelessWidget {
  const Chats({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.put(AuthenticationController());
    final controller = Get.put(ChatsController());
    final ScrollController scrollController = ScrollController();

    scrollController.addListener(() async {
      if (controller.chats.length < 10) return; // Exit early if not enough messages
      if (scrollController.position.extentAfter < 0.2 * scrollController.position.maxScrollExtent) {
        if (!controller.isLoadingMore.value && controller.hasMoreChats.value) {
          controller.isLoadingMore(true);
          controller.currentPage++;
          await controller.getChats();
          controller.isLoadingMore(false);
        }
      }
    });

    return Scaffold(
      appBar: AppAppBar(title: AppSettings.appName, titleStyle: TextStyle(color: AppColors.whatsAppColor, fontSize: 20),
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
      floatingActionButton: FloatingActionButton(
        heroTag: 'chat',
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(17), // Fully circular
        ),
        backgroundColor: AppColors.whatsAppColor,
        onPressed: () => Get.to(() => NewChat()),
        tooltip: 'New Chat',
        child: const Icon(Icons.chat_outlined, size: 25, color: Colors.white),
      ),
      body: RefreshIndicator(
        color: AppColors.refreshIndicator,
        onRefresh: () async => controller.refreshChats(),
        child: ListView(
          controller: scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            Padding(
              padding: AppSpacingStyle.defaultPageHorizontal,
              child: SearchField(),
            ),
            const SizedBox(height: 5),
            Obx(() {
              if(auth.user.value.fBApiCredentials?.accessToken == null) {
                return AnimationLoaderWidgets(
                  text: 'Please Setup Whatsapp Cloud API',
                  animation: Images.pencilAnimation,
                  showAction: true,
                  actionText: 'Let\'s setup',
                  onActionPress: () => Get.to(() => WhatsappCloudApi()),
                );
              }
              else if(controller.isLoading.value){
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
                    itemCount: controller.isLoadingMore.value ? controller.chats.length + 1 : controller.chats.length,
                    crossAxisCount: 1,
                    mainAxisExtent: AppSizes.chatTileHeight,
                    mainAxisSpacing: 0,
                    crossAxisSpacing: 0,
                    itemBuilder: (context, index) {
                      if (index < controller.chats.length) {
                          return ChatTile(
                              chat: controller.chats[index],
                              onTap: () {
                                Get.to(() => Messages(sessionId: controller.chats[index].sessionId));
                                controller.updateLastSeenBySessionId(sessionId: controller.chats[index].sessionId, lastSeenIndex: controller.chats[index].messages?.last.messageIndex);
                              }
                          );
                      } else {
                        return Column(
                          children: [
                            Center(
                              child: SizedBox(
                                height: 50,
                                width: 50,
                                child: CircularProgressIndicator(color: Colors.grey.withOpacity(0.5), strokeWidth: 2),
                              ),
                            ),
                            SizedBox(height: 10,),
                          ],
                        );
                      }
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
