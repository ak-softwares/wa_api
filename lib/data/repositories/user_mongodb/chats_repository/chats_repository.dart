import 'package:get/get.dart';

import '../../../../features/authentication/controllers/authentication_controller/authentication_controller.dart';
import '../../../../features/chat/models/chat_model.dart';
import '../../../../utils/constants/api_constants.dart';
import '../../../database/users_mongo_db/user_mongo_fetch.dart';
import '../../../database/users_mongo_db/user_mongo_update.dart';

class ChatsRepository extends GetxController {
  static ChatsRepository get instance => Get.find();

  final UserMongoFetch _userMongoFetch = UserMongoFetch();
  final UserMongoUpdate _userMongoUpdate = UserMongoUpdate();
  RxString collectionName = ''.obs;
  final int chatLoadPerPage = APIConstant.chatLoadPerPage;
  final int messagesLoadPerPage = APIConstant.messagesLoadPerPage;


  @override
  void onInit() {
    super.onInit();
    _initializeUserContext();
  }

  void _initializeUserContext() {
    final auth = Get.put(AuthenticationController());
    collectionName.value = auth.user.value.mongoDbCredentials?.collectionName ?? '';
  }

  // Fetch all chats
  Future<List<ChatModel>> fetchAllChats({int page = 1}) async {
    try {
      _initializeUserContext();
      // Fetch products from MongoDB with pagination
      final List<Map<String, dynamic>> chatsData = await _userMongoFetch.getChats(
          collectionName: collectionName.value,
          page: page,
          itemsPerPage: chatLoadPerPage,
          messageLimit: 1
      );
      // Convert data to a list of ProductModel
      final List<ChatModel> chats = chatsData.map((data) => ChatModel.fromJson(data)).toList();
      return chats;
    } catch (e) {
      rethrow;
    }
  }

  // Update Last seen in chat
  Future<void> updateLastSeenBySessionId({required String sessionId, required int lastSeenIndex}) async {
    try {
      await _userMongoUpdate.updateLastSeenBySessionId(
        collectionName: collectionName.value,
        sessionId: sessionId,
        lastSeenIndex: lastSeenIndex,
      );
    } catch (e) {
      rethrow;
    }
  }

}