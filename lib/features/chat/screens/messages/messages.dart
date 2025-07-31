import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/navigation_bar/appbar.dart';
import '../../../../common/styles/spacing_style.dart';
import '../../../../common/widgets/custom_shape/containers/rounded_container.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../controllers/messages/messages_controller.dart';
import '../../models/message_model.dart';
import 'widgets/input_bar.dart';
import 'widgets/message_bubble.dart';

class Messages extends StatelessWidget {
  const Messages({super.key, required this.sessionId, this.messages});

  final String sessionId;
  final List<MessageModel>? messages;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MessagesController(sessionId));
    final ScrollController scrollController = ScrollController();

    controller.messages.addAll(messages != null ? messages! : []);
    const double chatTileHeight = AppSizes.chatTileHeight;
    const double chatImageHeight = AppSizes.chatImageHeight;
    const double chatTileRadius = AppSizes.chatTileRadius;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    scrollController.addListener(() async {
      if (controller.messages.length < 10) return; // Exit early if not enough messages
      if (scrollController.position.extentAfter < 0.2 * scrollController.position.maxScrollExtent) {
        if (!controller.isLoadingMore.value && controller.hasMoreMessages.value) {
          controller.isLoadingMore(true);
          controller.currentPage++;
          await controller.getMessages();
          controller.isLoadingMore(false);
        }
      }
    });

    return Scaffold(
      backgroundColor: isDark ? AppColors.messageBackgroundDark : AppColors.messageBackgroundLight,
      appBar: AppAppBar(
        tileWidget: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // RoundedImage(
            //   height: chatImageHeight,
            //   width: chatImageHeight,
            //   radius: chatTileRadius,
            //   image: 'assets/images/default_images/default_profile_pic.jpg',
            // ),
            Row(
              children: [
                RoundedContainer(
                  height: chatImageHeight * 0.75,
                  width: chatImageHeight * 0.75,
                  radius: chatTileRadius,
                  backgroundColor: Theme.of(context).colorScheme.surface.darken(2),
                  child: Icon(Icons.person, size: 27 * 0.75,),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 3),
                    Text(sessionId, style: const TextStyle(fontSize: 16)),
                    Text('Text',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                        )
                    ),
                  ],
                ),
              ],
            ),
            IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () {},
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          // Background
          Opacity(
            opacity: 0.1,
            child: Positioned.fill(
              child: ColorFiltered(
                colorFilter: !isDark
                    ? const ColorFilter.matrix(<double>
                          [
                            -1, 0, 0, 0, 255, // Red
                            0, -1, 0, 0, 255, // Green
                            0, 0, -1, 0, 255, // Blue
                            0, 0, 0, 1, 0,   // Alpha
                          ])
                    : const ColorFilter.mode(
                        Colors.transparent,
                        BlendMode.dst, // No change
                      ),
                child: Image.asset('assets/images/whatsapp/whatsapp_doodle_pattern.png', fit: BoxFit.cover),
              ),
            ),
          ),

          // Foreground layout
          Column(
            children: [

              // Messages list fills remaining space
              Expanded(
                child: Padding(
                  padding: AppSpacingStyle.defaultPageHorizontal,
                  child: Obx(() {
                    if(controller.messages.isEmpty){
                      return Column(
                        children: [
                          const SizedBox(height: 10),
                          Center(child: Text('No messages Found')),
                        ],
                      );
                    }else{
                      final reversedMessages = controller.messages.reversed.toList();

                      return ListView.builder(
                        reverse: true, // 👈 scroll starts from bottom
                        controller: scrollController,
                        padding: const EdgeInsets.only(top: 20), // use top padding when reversed
                        itemCount: controller.isLoadingMore.value
                            ? reversedMessages.length + 1
                            : reversedMessages.length,
                        itemBuilder: (context, index) {
                          if (index < reversedMessages.length) {
                            final message = reversedMessages[index];
                            return MessageBubble(
                              message: message.data.content,
                              time: '11.23 PM',
                              isMe: message.type == 'ai',
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
                        },
                      );

                    }
                  }),
                ),
              ),


              // Input bar fixed at bottom
              Padding(
                padding: AppSpacingStyle.defaultPageHorizontal,
                child: ChatInputBar(
                  controller: TextEditingController(),
                  onSend: () {
                    // send message
                  },
                ),
              ),
            ],
          ),
        ],
      )
    );
  }
}