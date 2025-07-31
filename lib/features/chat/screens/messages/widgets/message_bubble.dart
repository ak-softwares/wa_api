import 'package:flutter/material.dart';

import '../../../../../utils/constants/colors.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final String time;
  final bool isMe;

  const MessageBubble({
    super.key,
    required this.message,
    required this.time,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
            decoration: BoxDecoration(
              color: isMe
                  ? isDark ? AppColors.messageBubbleIsMeSurfaceDark : AppColors.messageBubbleIsMeSurfaceLight
                  : isDark ? AppColors.messageBubbleIsYouSurfaceDark : AppColors.messageBubbleIsYouSurfaceLight,
              borderRadius: BorderRadius.only(
                topLeft: isMe ? const Radius.circular(12) : Radius.zero,
                bottomLeft: const Radius.circular(12),
                bottomRight: const Radius.circular(12),
                topRight: isMe ? Radius.zero : const Radius.circular(12)
              ),
            ),
            child: Stack(
              children: [
                RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onSurface),
                    children: [
                      TextSpan(text: message),
                      WidgetSpan(child: SizedBox(width: 70)),
                    ],
                  ),
                ),
                Positioned(
                  bottom: -3,
                  right: 0,
                  child: Row(
                    spacing: 4,
                    children: [
                      Text(time, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                      // if (isMe)
                      //   Icon(Icons.done_all, size: 16, color: Colors.grey[600]),
                    ],
                  )
                ),
              ],
            ),
          ),
          if(isMe)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                height: 8,
                width: 8,
                decoration: BoxDecoration(
                  color: isMe
                      ? isDark ? AppColors.messageBubbleIsMeSurfaceDark : AppColors.messageBubbleIsMeSurfaceLight
                      : isDark ? AppColors.messageBubbleIsYouSurfaceDark : AppColors.messageBubbleIsYouSurfaceLight,                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(50),
                    topRight: Radius.zero
                  ),
                ),              )
          )
          else
            Positioned(
                top: 0,
                left: 0,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  height: 8,
                  width: 8,
                  decoration: BoxDecoration(
                    color: isMe
                        ? isDark ? AppColors.messageBubbleIsMeSurfaceDark : AppColors.messageBubbleIsMeSurfaceLight
                        : isDark ? AppColors.messageBubbleIsYouSurfaceDark : AppColors.messageBubbleIsYouSurfaceLight,                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                        topRight: Radius.zero
                    ),
                  ),
                )
            )
        ],
      ),
    );
  }
}
