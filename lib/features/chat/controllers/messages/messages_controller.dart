import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:get/get.dart';

import '../../../../common/dialog_box_massages/snack_bar_massages.dart';
import '../../../../data/repositories/user_mongodb/messages_repository/messages_repository.dart';
import '../../../../utils/constants/enums.dart';
import '../../models/message_model.dart';
import '../chats/chats_controller.dart';

class MessagesController extends GetxController {
  static MessagesController get instance => Get.find();

  final String sessionId;
  MessagesController(this.sessionId);

  // Variables
  RxInt currentPage = 1.obs;
  RxBool isLoading = false.obs;
  RxBool isLoadingMore = false.obs;
  final RxBool hasMoreMessages = true.obs;
  RxList<MessageModel> messages = <MessageModel>[].obs;
  final TextEditingController messageController = TextEditingController();

  final messagesRepository = Get.put(MessagesRepository());
  final chatsController = Get.put(ChatsController());

  Timer? _pollingTimer;

  @override
  void onInit() {
    super.onInit();
    refreshMessages();
    startPollingMessages();
  }


  @override
  void onClose() {
    stopPollingMessages();
    super.onClose();
  }

  void startPollingMessages() {
    _pollingTimer?.cancel(); // Clear existing timer if any

    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (_) async {
      try {

        // Ensure we have a valid last index
        if (messages.isEmpty || messages.last.messageIndex == null) return;

        final lastIndex = messages.last.messageIndex!;
        final newMessages = await messagesRepository.fetchNewUserMessages(
          sessionId: sessionId,
          lastIndex: lastIndex,
        );

        if (newMessages.isNotEmpty) {
          // Add messages and play sound
          messages.addAll(newMessages);
          FlutterRingtonePlayer().play(
            fromAsset: "assets/sounds/whatsapp/incoming-message-online-whatsapp.mp3",
            looping: false, // ensure it doesn't keep playing
            volume: 1.0,
          );
        }
      } catch (e, st) {
        debugPrint('Polling error: $e');
        debugPrint('Stacktrace: $st');
      }
    });
  }

  void stopPollingMessages() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  Future<void> sendMessage() async {
    try {
      final textMessage = messageController.text.trim();
      if (textMessage.isEmpty) return;

      messageController.text = '';

      // Send via API or webhook
      messagesRepository.sendMessage(
        phoneNumber: sessionId,
        message: textMessage,
      );

      final message = MessageModel(
        type: UserType.ai,
        data: MessageData(content: textMessage),
        timestamp: DateTime.now(),
      );

      messages.add(message);

      final chatIndex = chatsController.chats.indexWhere((c) => c.sessionId == sessionId);
      if (chatIndex != -1) {
        chatsController.chats[chatIndex].messages?.add(message);
        chatsController.chats.refresh();
      }

      messagesRepository.insertMessages(
        sessionId: sessionId,
        message: message,
      );

    } catch (e) {
      AppMassages.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  Future<void> getMessages() async {
    try {
      final List<MessageModel> newMessages = await messagesRepository.fetchAllMessages(
        sessionId: sessionId,
        page: currentPage.value,
      );
      if (newMessages.isEmpty || newMessages.length < 10) {
        hasMoreMessages(false);
      }
      final reversed = newMessages.reversed.toList();
      messages.insertAll(0, reversed);

    } catch (e) {
      AppMassages.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  Future<void> refreshMessages() async {
    try {
      currentPage(1);
      isLoading(true);
      hasMoreMessages(true);
      messages.clear();
      await getMessages();
      messages.refresh();
    } catch (e) {
      AppMassages.errorSnackBar(title: 'Error', message: e.toString());
    } finally {
      isLoading(false);
    }
  }
}
