import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/dialog_box_massages/dialog_massage.dart';
import '../../../../common/layout_model/grid_layout.dart';
import '../../../../common/navigation_bar/appbar.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../authentication/controllers/authentication_controller/authentication_controller.dart';
import '../../controllers/new_chat/new_chat_controller.dart';
import '../../controllers/search/search_contact_delegate.dart';
import '../chats/widgets/chat_simmer.dart';
import '../messages/messages.dart';
import 'widgets/new_chat_tile.dart';

class NewChat extends StatelessWidget {
  const NewChat({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NewChatController());

    return Scaffold(
      appBar: AppAppBar(title: 'Select Contact', titleStyle: TextStyle(fontSize: 14),
        widgetInActions: Row(
          children: [
            IconButton(
              onPressed: () => showSearch(context: context, delegate: AppSearchContactDelegate()),
              icon: Icon(Icons.search),
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
        onRefresh: () => controller.refreshContacts(),
        child: ListView(
          children: [
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
              }else{
                return GridLayout(
                    itemCount: controller.contacts.length,
                    crossAxisCount: 1,
                    mainAxisExtent: AppSizes.chatTileHeight,
                    mainAxisSpacing: 0,
                    crossAxisSpacing: 0,
                    itemBuilder: (context, index) {
                      return NewChatTile(
                          contact: controller.contacts[index],
                          onTap: () {
                            if (controller.contacts[index].phoneNumbers.length > 1) {
                              DialogHelper.showPhoneNumberSelectorDialog(
                                context: context,
                                title: 'Choose phone number',
                                phoneNumbers: controller.contacts[index].phoneNumbers,
                                onNumberSelected: (selectedNumber) {
                                  Get.to(() => Messages(sessionId: selectedNumber));
                                },
                              );
                            } else {
                              Get.to(() => Messages(sessionId: controller.contacts[index].phoneNumbers.first));
                            }
                          }
                      );
                    }
                );
              }
            }),
          ],
        ),
      )
    );
  }
}