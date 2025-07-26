import 'package:flutter/material.dart';
import 'package:n8nTalk/common/widgets/custom_shape/image/circular_image.dart';

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

    return ListTile(
      onTap: onTap,
      leading: RoundedImage(
          height: chatImageHeight,
          width: chatImageHeight,
          radius: chatTileRadius,
          isNetworkImage: true,
          image: ''
      ),
      title: Text(chat.sessionId),
      subtitle: Text('Text'),
      trailing: Icon(Icons.arrow_forward_ios, size: 20,),
    );
  }


}