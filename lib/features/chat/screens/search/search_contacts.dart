import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/dialog_box_massages/dialog_massage.dart';
import '../../../../common/layout_model/grid_layout.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../controllers/new_chat/new_chat_controller.dart';
import '../chats/widgets/chat_simmer.dart';
import '../messages/messages.dart';
import '../new_chat/widgets/new_chat_tile.dart';

class SearchContacts extends StatelessWidget {
  const SearchContacts({
    super.key,
    required this.title,
    required this.searchQuery,
  });

  final String title;
  final String searchQuery;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NewChatController());
    // Schedule the search refresh to occur after the current frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!controller.isLoading.value) {
        controller.refreshSearch(query: searchQuery);
      }
    });

    return Scaffold(
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
                      itemCount: controller.filteredContacts.length,
                      crossAxisCount: 1,
                      mainAxisExtent: AppSizes.chatTileHeight,
                      mainAxisSpacing: 0,
                      crossAxisSpacing: 0,
                      itemBuilder: (context, index) {
                        final contact = controller.filteredContacts[index];
                        return NewChatTile(
                          contact: contact,
                          onTap: () {
                            if (contact.phoneNumbers.length > 1) {
                              DialogHelper.showPhoneNumberSelectorDialog(
                                context: context,
                                title: 'Choose phone number',
                                phoneNumbers: contact.phoneNumbers,
                                onNumberSelected: (selectedNumber) {
                                  Get.to(() => Messages(sessionId: selectedNumber));
                                },
                              );
                            } else {
                              Get.to(() => Messages(sessionId: contact.phoneNumbers.first));
                            }
                          },
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
