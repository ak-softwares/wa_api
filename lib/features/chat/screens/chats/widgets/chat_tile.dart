import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:n8nTalk/common/widgets/custom_shape/containers/rounded_container.dart';
import 'package:n8nTalk/common/widgets/custom_shape/image/circular_image.dart';
import 'package:n8nTalk/utils/constants/colors.dart';

import '../../../../../common/styles/spacing_style.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../models/chats_model.dart';

class ChatTile extends StatelessWidget {
  const ChatTile({super.key, required this.chat, this.onTap});

  final ChatModel chat;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    const double chatTileHeight = AppSizes.chatTileHeight;
    const double chatImageHeight = AppSizes.chatImageHeight;
    const double chatTileRadius = AppSizes.chatTileRadius;

    return InkWell(
      onTap : onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // RoundedImage(
          //   height: chatImageHeight,
          //   width: chatImageHeight,
          //   radius: chatTileRadius,
          //   image: 'assets/images/default_images/default_profile_pic.jpg',
          // ),
          RoundedContainer(
            height: chatImageHeight,
            width: chatImageHeight,
            radius: chatTileRadius,
            backgroundColor: Theme.of(context).colorScheme.surface.darken(2),
            child: Icon(Icons.person, size: 27,),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(chat.sessionId, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                    Text('11.53 am', style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8))),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (chat.messages?.last.type == 'ai')
                      Row(
                        children: [
                          Icon(Icons.keyboard_double_arrow_right_sharp, size: 16, color: Colors.blue),
                          const SizedBox(width: 3),
                        ],
                      ),
                    Expanded(
                      child: Text(chat.messages?.last.data.content ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                          )
                      ),
                    ),
                    const SizedBox(width: 10),
                    Badge(
                      padding: EdgeInsets.all(3),
                      backgroundColor: AppColors.whatsAppColor,
                      label: Text('1'),
                      largeSize: 10,
                      textColor: Colors.white,
                      textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              ],
            ),
          ),
          // const Spacer(),
          // const Icon(Icons.arrow_forward_ios, size: 20,),
        ],
      ),
    );
  }


}