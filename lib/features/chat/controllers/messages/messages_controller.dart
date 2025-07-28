import 'package:get/get.dart';

import '../../../../common/dialog_box_massages/snack_bar_massages.dart';
import '../../../../data/repositories/user_mongodb/messages_repository/messages_repository.dart';
import '../../models/message_model.dart';

class MessagesController extends GetxController {
  static MessagesController get instance => Get.find();

  final String sessionId;
  MessagesController(this.sessionId);

  // Variables
  RxInt currentPage = 1.obs;
  RxBool isLoadingMore = false.obs;
  final RxBool hasMoreMessages = true.obs;
  RxList<MessageModel> messages = <MessageModel>[].obs;

  final messagesRepository = Get.put(MessagesRepository());

  // Get all chats
  Future<void> getMessages() async {
    try {
      final List<MessageModel> newMessages = await messagesRepository.fetchAllMessages(sessionId: sessionId, page: currentPage.value);
      if (newMessages.isEmpty || newMessages.length < 10) {
        hasMoreMessages(false); // No more messages to load
      }
      messages.insertAll(0, newMessages.reversed.toList()); // 👈 reverse before insert
    } catch (e) {
      AppMassages.errorSnackBar(title: 'Error', message: e.toString());
    }
  }


}