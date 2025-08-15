import 'package:flutter/material.dart';

import '../../../../../common/styles/spacing_style.dart';
import '../../../../../utils/constants/colors.dart';

class ChatInputBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const ChatInputBar({
    super.key,
    required this.controller,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    bool isEmojiVisible = false;
    final FocusNode focusNode = FocusNode();

    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color textCaptionColor = isDark ? AppColors.messageSendInputCaptionDark : AppColors.messageSendInputCaptionLight;
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: isDark ? AppColors.messageSendInputBackgroundDark : AppColors.messageSendInputBackgroundLight,
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                controller: controller,
                style: TextStyle(fontSize: 18), // 👈 set text size here
                cursorColor: AppColors.whatsAppColor, // 👈 set your desired cursor color
                decoration: InputDecoration(
                  hintText: "Message",
                  hintStyle: TextStyle(color: textCaptionColor, fontSize: 18), // 👈 match hint size
                  border: InputBorder.none,
                  isCollapsed: true, // makes TextField tighter
                  contentPadding: const EdgeInsets.symmetric(vertical: 12), // adjust as needed
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(2),
                    child: IconButton(
                      onPressed: () {
                        if (isEmojiVisible) {
                          // Hide emoji picker and show keyboard
                          focusNode.requestFocus();
                        } else {
                          // Hide keyboard and show emoji picker
                          focusNode.unfocus();
                        }
                        isEmojiVisible = !isEmojiVisible;
                      },
                      icon: Icon(
                        Icons.emoji_emotions_outlined,
                        color: textCaptionColor,
                      ),
                    ),
                  ),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.all(2),
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.attach_file, color: textCaptionColor)),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: isDark ? AppColors.whatsappButtonDark : AppColors.whatsappButtonLight,
            child: IconButton(
              icon: Icon(Icons.send, color: Theme.of(context).colorScheme.onInverseSurface),
              onPressed: onSend,
            ),
          ),
        ],
      ),
    );
  }
}
