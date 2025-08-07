import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../common/dialog_box_massages/snack_bar_massages.dart';
import '../../../../data/repositories/user_mongodb/chats_repository/chats_repository.dart';
import '../../../authentication/controllers/authentication_controller/authentication_controller.dart';
import '../../models/chat_model.dart';
import '../new_chat/new_chat_controller.dart';

class ChatsController extends GetxController {
  static ChatsController get instance => Get.find();

  // Variables
  RxInt currentPage = 1.obs;
  RxBool isLoading = false.obs;
  RxBool isLoadingMore = false.obs;
  RxBool hasMoreChats = true.obs;
  RxList<ChatModel> chats = <ChatModel>[].obs;

  final chatsRepository = Get.put(ChatsRepository());
  final newChatController = Get.put(NewChatController());
  final authenticationController = Get.put(AuthenticationController());
  final localStorage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    refreshChats();
  }

  // Update Last seen in chat
  Future<void> updateLastSeenBySessionId({required String sessionId, required int? lastSeenIndex}) async {
    try {
      final chatIndex = chats.indexWhere((chat) => chat.sessionId == sessionId);

      if (lastSeenIndex == null || (chats[chatIndex].lastSeenIndex == lastSeenIndex)) return;

      await chatsRepository.updateLastSeenBySessionId(
        sessionId: sessionId,
        lastSeenIndex: lastSeenIndex,
      );
      // ✅ Update locally
      if (chatIndex != -1) {
        chats[chatIndex].lastSeenIndex = lastSeenIndex;
        chats.refresh();
      }
    } catch (e) {
      rethrow;
    }
  }

  // Get all chats
  Future<void> getChats() async {
    try {
      final List<ChatModel> newChats = await chatsRepository.fetchAllChats(page: currentPage.value);
      if (newChats.isEmpty || newChats.length < 10) {
        hasMoreChats(false); // No more messages to load
      }
      // Assign name if sessionId matches with contact number
      for (var chat in newChats) {
        final matchingContact = newChatController.contacts.firstWhereOrNull((contact) {
          return contact.phoneNumbers.contains(chat.sessionId);
        });

        if (matchingContact != null) {
          chat.name = matchingContact.name;
        }
      }
      chats.addAll(newChats);
    } catch (e) {
      AppMassages.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  // Refresh chats
  Future<void> refreshChats() async {
    try {
      if(authenticationController.user.value.mongoDbCredentials?.collectionName == null) return;
      isLoading(true);
      hasMoreChats(true); // No more messages to load
      currentPage.value = 1; // Reset page number
      chats.clear(); // Clear existing orders
      await getChats();
    } catch (error) {
      AppMassages.warningSnackBar(title: 'Errors', message: error.toString());
    } finally {
      isLoading(false);
    }
  }
}
