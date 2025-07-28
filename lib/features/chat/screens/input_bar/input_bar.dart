import 'package:flutter/material.dart';

import '../../../../common/styles/spacing_style.dart';
import '../../../../utils/constants/colors.dart';

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
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 25),
                child: TextFormField(
                  controller: controller,
                  style: TextStyle(fontSize: 18), // 👈 set text size here
                  cursorColor: AppColors.whatsAppColor, // 👈 set your desired cursor color
                  decoration: InputDecoration(
                    hintText: "Message",
                    hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 18), // 👈 match hint size
                    border: InputBorder.none,
                    isCollapsed: true, // makes TextField tighter
                    contentPadding: const EdgeInsets.symmetric(vertical: 12), // adjust as needed
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(2),
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.attach_file, color: Colors.black)),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: const Color(0xFF25D366), // WhatsApp green
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white),
              onPressed: onSend,
            ),
          ),
        ],
      ),
    );
  }
}
